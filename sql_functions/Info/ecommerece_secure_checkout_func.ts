import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.4";

// Types for checkout request and response
interface CheckoutRequest {
  cartItems: CartItem[];
  addressId: number;
  paymentMethod: PaymentMethod;
  directCheckout?: {
    productId: number;
    variantId: number;
    quantity: number;
    price: number;
  };
  idempotencyKey?: string;
}

interface CartItem {
  variantId: number;
  quantity: number;
  sellPrice: number;
  buyPrice?: number;
}

type PaymentMethod = 'cod' | 'credit_card' | 'bank_transfer' | 'jazzcash' | 'pickup';

interface CheckoutResponse {
  success: boolean;
  orderId?: number;
  total?: number;
  message: string;
  error?: string;
  errorCode?: string;
}

interface ValidationResult {
  isValid: boolean;
  errorMessage?: string;
  totals?: CartTotals;
}

interface CartTotals {
  subtotal: number;
  tax: number;
  shipping: number;
  discount: number;
  total: number;
  cost: number;
}

serve(async (req: Request) => {
  try {
    // CORS headers for web clients
    if (req.method === 'OPTIONS') {
      return new Response('ok', {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST',
          'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
        },
      });
    }

    // Only allow POST requests
    if (req.method !== 'POST') {
      return new Response(
        JSON.stringify({ success: false, message: 'Method not allowed' }),
        { 
          status: 405, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

    // Get authorization header
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(
        JSON.stringify({ success: false, message: 'Authorization required' }),
        { 
          status: 401, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

    // Initialize Supabase client with service role for server operations
    const supabaseUrl = Deno.env.get('PROJECT_URL')!;
    const supabaseServiceKey = Deno.env.get('SERVICE_ROLE_KEY')!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Initialize user client for RLS checks
    const token = authHeader.replace('Bearer ', '');
    const userSupabase = createClient(supabaseUrl, Deno.env.get('PROJECT_ANON_KEY')!, {
      global: { headers: { Authorization: authHeader } }
    });

    // Verify JWT and get user
    const { data: { user }, error: authError } = await userSupabase.auth.getUser(token);
    if (authError || !user) {
      return new Response(
        JSON.stringify({ success: false, message: 'Invalid authentication' }),
        { 
          status: 401, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

    // Get customer ID from user
    const { data: customer, error: customerError } = await supabase
      .from('customers')
      .select('customer_id')
      .eq('auth_uid', user.id)
      .single();

    if (customerError || !customer) {
      return new Response(
        JSON.stringify({ success: false, message: 'Customer not found' }),
        { 
          status: 404, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

    const customerId = customer.customer_id;

    // Parse request body
    const checkoutData: CheckoutRequest = await req.json();

    // Generate idempotency key if not provided
    const idempotencyKey = checkoutData.idempotencyKey || 
      await generateIdempotencyKey(customerId, checkoutData.cartItems || []);

    console.log('🛒 Starting secure checkout for customer:', customerId);

    // Step 1: Check for duplicate orders
    const isDuplicate = await checkDuplicateOrder(supabase, idempotencyKey);
    if (isDuplicate) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          message: 'Order already processed. Please refresh and try again.',
          errorCode: 'DUPLICATE_ORDER'
        }),
        { 
          status: 409, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

    // Prepare cart items (for both cart and direct checkout)
    let cartItems: CartItem[] = [];
    
    if (checkoutData.directCheckout) {
      // Direct checkout - create temporary cart item
      cartItems = [{
        variantId: checkoutData.directCheckout.variantId,
        quantity: checkoutData.directCheckout.quantity,
        sellPrice: checkoutData.directCheckout.price,
        buyPrice: 0 // Will be fetched from database
      }];
    } else {
      cartItems = checkoutData.cartItems || [];
    }

    if (cartItems.length === 0) {
      return new Response(
        JSON.stringify({ success: false, message: 'Cart is empty' }),
        { 
          status: 400, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

    // Step 2: Validate cart security (server-side price validation)
    const validation = await validateCartSecurity(supabase, cartItems);
    if (!validation.isValid) {
      await logSecurityEvent(supabase, 'cart_validation_failed', {
        customer_id: customerId,
        error: validation.errorMessage,
        cart_items: cartItems.length
      });

      return new Response(
        JSON.stringify({ 
          success: false, 
          message: validation.errorMessage,
          errorCode: 'SECURITY_VIOLATION'
        }),
        { 
          status: 400, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

    // Step 3: Reserve inventory with optimistic locking
    const reservationResult = await reserveInventory(supabase, cartItems, idempotencyKey);
    if (!reservationResult.success) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          message: reservationResult.message,
          errorCode: 'INVENTORY_UNAVAILABLE'
        }),
        { 
          status: 400, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

    try {
      // Step 4: Process payment (extensible for different payment methods)
      const paymentResult = await processPayment(
        checkoutData.paymentMethod, 
        validation.totals!.total,
        customerId,
        idempotencyKey
      );
      
      if (!paymentResult.success) {
        await rollbackInventoryReservation(supabase, idempotencyKey);
        return new Response(
          JSON.stringify({ 
            success: false, 
            message: paymentResult.message,
            errorCode: 'PAYMENT_FAILED'
          }),
          { 
            status: 400, 
            headers: { 'Content-Type': 'application/json' } 
          }
        );
      }

      // Step 5: Create order with transaction-like behavior
      const orderResult = await createSecureOrder(
        supabase,
        customerId,
        cartItems,
        checkoutData.addressId,
        checkoutData.paymentMethod,
        validation.totals!,
        idempotencyKey
      );

      if (!orderResult.success) {
        await rollbackInventoryReservation(supabase, idempotencyKey);
        // TODO: Add payment refund logic here for JazzCash and other payment methods
        return new Response(
          JSON.stringify({ 
            success: false, 
            message: orderResult.message,
            errorCode: 'ORDER_CREATION_FAILED'
          }),
          { 
            status: 500, 
            headers: { 'Content-Type': 'application/json' } 
          }
        );
      }

      // Step 6: Confirm inventory reservation (reduce actual stock)
      await confirmInventoryReservation(supabase, idempotencyKey);

      // Step 7: Clear cart for regular checkout (not direct checkout)
      if (!checkoutData.directCheckout) {
        await clearCustomerCart(supabase, customerId);
      }

      // Log successful checkout
      await logSecurityEvent(supabase, 'checkout_success', {
        customer_id: customerId,
        order_id: orderResult.orderId,
        total: validation.totals!.total,
        payment_method: checkoutData.paymentMethod
      });

      console.log('✅ Checkout completed successfully:', orderResult.orderId);

      return new Response(
        JSON.stringify({
          success: true,
          orderId: orderResult.orderId,
          total: validation.totals!.total,
          message: 'Order placed successfully!'
        } as CheckoutResponse),
        { 
          status: 200, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );

         } catch (error) {
       console.error('❌ Checkout error:', error);
       await rollbackInventoryReservation(supabase, idempotencyKey);
       
       await logSecurityEvent(supabase, 'checkout_error', {
         customer_id: customerId,
         error: error instanceof Error ? error.message : 'Unknown error',
         idempotency_key: idempotencyKey
       });

      return new Response(
        JSON.stringify({ 
          success: false, 
          message: 'Checkout failed due to system error. Please try again.',
          errorCode: 'SYSTEM_ERROR'
        }),
        { 
          status: 500, 
          headers: { 'Content-Type': 'application/json' } 
        }
      );
    }

  } catch (error) {
    console.error('🔥 Unhandled error:', error);
    return new Response(
      JSON.stringify({ 
        success: false, 
        message: 'Internal server error',
        errorCode: 'INTERNAL_ERROR'
      }),
      { 
        status: 500, 
        headers: { 'Content-Type': 'application/json' } 
      }
    );
  }
});

// Helper Functions

async function generateIdempotencyKey(customerId: number, cartItems: CartItem[]): Promise<string> {
  const cartData = cartItems
    .map(item => `${item.variantId}:${item.quantity}:${item.sellPrice}`)
    .join('|');

  const input = `${customerId}:${cartData}:${Math.floor(Date.now() / 60000)}`; // 1-minute window
  const encoder = new TextEncoder();
  const data = encoder.encode(input);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
  
  return `checkout_${hashHex.substring(0, 16)}`;
}

async function checkDuplicateOrder(supabase: any, idempotencyKey: string): Promise<boolean> {
  try {
    const { data, error } = await supabase
      .from('orders')
      .select('order_id')
      .eq('idempotency_key', idempotencyKey)
      .limit(1);

    if (error) {
      console.error('Error checking duplicate order:', error);
      return false; // Allow order on error for better UX
    }

    return data && data.length > 0;
  } catch (error) {
    console.error('Exception checking duplicate order:', error);
    return false;
  }
}

async function validateCartSecurity(supabase: any, cartItems: CartItem[]): Promise<ValidationResult> {
  try {
    // Get all variant IDs
    const variantIds = cartItems.map(item => item.variantId);

    // Fetch current product data from database
    const { data: dbProducts, error } = await supabase
      .from('product_variants')
      .select(`
        variant_id,
        sell_price,
        is_visible,
        stock,
        products!inner(
          product_id,
          name,
          sale_price,
          isVisible
        )
      `)
      .in('variant_id', variantIds);

    if (error) {
      console.error('Error fetching products:', error);
      return { isValid: false, errorMessage: 'Product validation failed' };
    }

    // Create lookup map
    const dbProductMap = new Map();
    dbProducts.forEach((product: any) => {
      dbProductMap.set(product.variant_id, product);
    });

    // Validate each cart item
    for (const cartItem of cartItems) {
      const dbProduct = dbProductMap.get(cartItem.variantId);
      
      if (!dbProduct) {
        return { 
          isValid: false, 
          errorMessage: `Product no longer available (ID: ${cartItem.variantId})` 
        };
      }

      // Check visibility
      if (!dbProduct.is_visible || !dbProduct.products.isVisible) {
        return { 
          isValid: false, 
          errorMessage: `Product ${dbProduct.products.name} is no longer available` 
        };
      }

      // Validate price integrity (prevent tampering)
      const dbPrice = parseFloat(dbProduct.sell_price);
      const cartPrice = cartItem.sellPrice;

      if (Math.abs(dbPrice - cartPrice) > 0.01) { // 1 cent tolerance
        await logSecurityEvent(supabase, 'price_manipulation_detected', {
          variant_id: cartItem.variantId,
          cart_price: cartPrice,
          db_price: dbPrice,
          product_name: dbProduct.products.name
        });

        return { 
          isValid: false, 
          errorMessage: 'Price mismatch detected. Please refresh and try again.' 
        };
      }

      // Validate stock availability
      if (cartItem.quantity > dbProduct.stock) {
        return { 
          isValid: false, 
          errorMessage: `${dbProduct.products.name} - Only ${dbProduct.stock} available` 
        };
      }

      // Validate quantity constraints
      if (cartItem.quantity <= 0 || cartItem.quantity > 99) {
        return { 
          isValid: false, 
          errorMessage: 'Invalid quantity. Must be between 1 and 99.' 
        };
      }
    }

    // Calculate totals server-side
    const totals = await calculateSecureTotals(supabase, cartItems);

    // Validate business rules
    if (totals.total < 10.0) {
      return { 
        isValid: false, 
        errorMessage: 'Minimum order amount is $10.00' 
      };
    }

    if (totals.total > 10000.0) {
      return { 
        isValid: false, 
        errorMessage: 'Maximum order amount is $10,000.00' 
      };
    }

    return { isValid: true, totals };

  } catch (error) {
    console.error('Error in cart validation:', error);
    return { isValid: false, errorMessage: 'Security validation failed' };
  }
}

async function calculateSecureTotals(supabase: any, cartItems: CartItem[]): Promise<CartTotals> {
  console.log('🧮 Starting calculateSecureTotals with cart items:', cartItems.length);
  
  let subtotal = 0;
  let totalCost = 0;

  for (const item of cartItems) {
    const itemTotal = item.sellPrice * item.quantity;
    const itemCost = (item.buyPrice || 0) * item.quantity;
    subtotal += itemTotal;
    totalCost += itemCost;
    console.log('📦 Cart item:', { 
      variantId: item.variantId, 
      quantity: item.quantity, 
      sellPrice: item.sellPrice, 
      itemTotal,
      itemCost 
    });
  }
  
  console.log('📊 Subtotal calculation:', { subtotal, totalCost });

  // Fetch fixed tax amount from shop table
  let fixedTaxAmount = 0;
  try {
    console.log('🔍 Fetching fixed tax amount from shop table...');
    const { data: shopData, error: shopError } = await supabase
      .from('shop')
      .select('taxrate')
      .limit(1)
      .single();

    console.log('📊 Shop data response:', { shopData, shopError });

    if (shopError) {
      console.error('❌ Error fetching tax amount from shop table:', shopError);
      // Fallback to 0 tax amount if unable to fetch
      fixedTaxAmount = 0;
    } else if (shopData && shopData.taxrate !== null) {
      fixedTaxAmount = parseFloat(shopData.taxrate);
      console.log('✅ Fixed tax amount fetched successfully: $' + fixedTaxAmount);
    } else {
      console.log('⚠️ No tax amount found in shop table, using $0');
      fixedTaxAmount = 0;
    }
  } catch (error) {
    console.error('💥 Exception fetching tax amount:', error);
    fixedTaxAmount = 0; // Fallback to 0 tax amount
  }

  // Use fixed tax amount (not percentage)
  const tax = fixedTaxAmount;
  console.log('💰 Tax calculation:', { subtotal, fixedTaxAmount, calculatedTax: tax });

  // Calculate shipping based on total items
 // const totalItems = cartItems.reduce((sum, item) => sum + item.quantity, 0);
  let shipping = 0; // Standard shipping(not yet.)
  // if (totalItems > 10) shipping = 15.99;
  // else if (totalItems > 3) shipping = 9.99;

  // Calculate discount (no logic yet)
  const discount =  0;

  const total = subtotal + tax + shipping - discount;

  const finalTotals = {
    subtotal,
    tax,
    shipping,
    discount,
    total,
    cost: totalCost
  };
  
  console.log('🎯 Final totals calculated:', finalTotals);
  console.log('✅ calculateSecureTotals completed successfully');
  
  return finalTotals;
}

async function reserveInventory(supabase: any, cartItems: CartItem[], reservationId: string): Promise<{success: boolean, message: string}> {
  try {
    // Create inventory reservations
    const reservations = cartItems.map(item => ({
      reservation_id: reservationId,
      variant_id: item.variantId,
      quantity: item.quantity,
      expires_at: new Date(Date.now() + 5 * 60 * 1000).toISOString() // 5 minutes
    }));

    const { error } = await supabase
      .from('inventory_reservations')
      .insert(reservations);

    if (error) {
      console.error('Error creating reservations:', error);
      return { success: false, message: 'Unable to reserve inventory' };
    }

    return { success: true, message: 'Inventory reserved successfully' };

  } catch (error) {
    console.error('Exception in inventory reservation:', error);
    return { success: false, message: 'Inventory reservation failed' };
  }
}

// 🔄 PAYMENT PROCESSING - EXTENSIBLE FOR JAZZCASH
async function processPayment(
  paymentMethod: PaymentMethod, 
  amount: number, 
  customerId: number,
  idempotencyKey: string
): Promise<{success: boolean, message: string, transactionId?: string}> {
  
  console.log(`💳 Processing payment via ${paymentMethod} for amount: $${amount}`);

  switch (paymentMethod) {
    case 'cod':
      // Cash on Delivery - no payment processing needed
      return { 
        success: true, 
        message: 'Cash on Delivery order confirmed',
        transactionId: `cod_${idempotencyKey}`
      };

    case 'pickup':
      // Pickup order - no payment processing needed, customer pays at pickup
      return { 
        success: true, 
        message: 'Pickup order confirmed - payment at pickup',
        transactionId: `pickup_${idempotencyKey}`
      };

    case 'credit_card':
      // TODO: Integrate with Stripe, Square, or other credit card processor
      // For now, simulate success
      return { 
        success: true, 
        message: 'Credit card payment processed',
        transactionId: `cc_${idempotencyKey}`
      };

    case 'bank_transfer':
      // TODO: Integrate with bank transfer API
      return { 
        success: true, 
        message: 'Bank transfer initiated',
        transactionId: `bt_${idempotencyKey}`
      };

    case 'jazzcash':
      // 🚀 JAZZCASH INTEGRATION POINT
      // TODO: Implement JazzCash payment processing
      // This is where you'll integrate with JazzCash API
      /*
       * JazzCash Integration Steps:
       * 1. Call JazzCash checkout API with order details
       * 2. Handle JazzCash response and transaction status
       * 3. Store JazzCash transaction ID
       * 4. Handle callbacks for payment confirmation
       * 
       * Example implementation structure:
       * 
       * const jazzCashResult = await processJazzCashPayment({
       *   amount: amount,
       *   customerId: customerId,
       *   orderId: idempotencyKey,
       *   returnUrl: 'your-app://payment-return',
       *   webhookUrl: 'https://your-edge-function/jazzcash-webhook'
       * });
       * 
       * return {
       *   success: jazzCashResult.success,
       *   message: jazzCashResult.message,
       *   transactionId: jazzCashResult.transactionId
       * };
       */
      
      // For now, simulate JazzCash payment (replace with actual integration)
      console.log('🔄 JazzCash payment simulation - Replace with actual API call');
      return { 
        success: true, 
        message: 'JazzCash payment processed',
        transactionId: `jc_${idempotencyKey}`
      };

    default:
      return { 
        success: false, 
        message: `Payment method ${paymentMethod} not supported` 
      };
  }
}

async function createSecureOrder(
  supabase: any,
  customerId: number,
  cartItems: CartItem[],
  addressId: number,
  paymentMethod: PaymentMethod,
  totals: CartTotals,
  idempotencyKey: string
): Promise<{success: boolean, message: string, orderId?: number}> {
  try {
    // Handle pickup orders (addressId === -1) and invalid addresses (addressId === 0)
    if (addressId > 0) {
      // Copy address to order_addresses (for order history)
      console.log('Copying address to order_addresses, addressId:', addressId);
      
      const { data: addressResult, error: addressError } = await supabase.rpc('copy_address_to_order_address', {
        p_address_id: addressId
      });

      console.log('Address copy result:', addressResult, 'Error:', addressError);

      if (addressError) {
        console.error('Error copying address:', addressError);
        
        // Check if address exists first
        const { data: addressExists, error: checkError } = await supabase
          .from('addresses')
          .select('address_id')
          .eq('address_id', addressId)
          .single();
        
        if (checkError || !addressExists) {
          console.error('Address does not exist:', addressId);
          return { success: false, message: 'Selected address not found. Please select a valid address.' };
        }
        
        return { success: false, message: 'Address processing failed' };
      }
      
      // Check if the function returned false (address not found)
      if (addressResult === false) {
        console.error('Address copy function returned false for addressId:', addressId);
        return { success: false, message: 'Address not found. Please select a valid address.' };
      }
    } else {
      console.log('Skipping address copy - pickup order or invalid addressId:', addressId);
    }

    // Fetch product_id for each variant_id in cartItems
    const variantIds = cartItems.map(item => item.variantId);
    const { data: variantRows, error: variantError } = await supabase
      .from('product_variants')
      .select('variant_id, product_id')
      .in('variant_id', variantIds);

    if (variantError || !variantRows || variantRows.length !== cartItems.length) {
      console.error('Error fetching product_ids for variants:', variantError);
      return { success: false, message: 'Failed to fetch product information for order items' };
    }

    // Build a map from variant_id to product_id
    const variantToProductMap = new Map<number, number>();
    for (const row of variantRows) {
      variantToProductMap.set(row.variant_id, row.product_id);
    }

    // Create order
    const orderData = {
      customer_id: customerId,
      status: 'pending',
      sub_total: totals.subtotal,
      tax: totals.tax,
      shipping_fee: totals.shipping,
      discount: totals.discount,
      paid_amount: totals.total,
      buying_price: totals.cost,
      address_id: (addressId <= 0) ? null : addressId,
      order_date: new Date().toISOString(),
      payment_method: paymentMethod,
      idempotency_key: idempotencyKey
    };

    const { data: orderResult, error: orderError } = await supabase
      .from('orders')
      .insert(orderData)
      .select('order_id')
      .single();

    if (orderError) {
      console.error('Error creating order:', orderError);
      return { success: false, message: 'Order creation failed' };
    }

    const orderId = orderResult.order_id;

    // Create order items with correct product_id
    const orderItems = cartItems.map(item => ({
      order_id: orderId,
      product_id: variantToProductMap.get(item.variantId),
      variant_id: item.variantId,
      quantity: item.quantity,
      price: item.sellPrice,
      total_buy_price: (item.buyPrice || 0) * item.quantity
    }));

    const { error: itemsError } = await supabase
      .from('order_items')
      .insert(orderItems);

    if (itemsError) {
      console.error('Error creating order items:', itemsError);
      // Rollback order
      await supabase.from('orders').delete().eq('order_id', orderId);
      return { success: false, message: 'Order items creation failed' };
    }

    return { success: true, message: 'Order created successfully', orderId };
  } catch (error) {
    console.error('Exception in order creation:', error);
    return { success: false, message: 'Order creation failed' };
  }
}

async function confirmInventoryReservation(supabase: any, reservationId: string): Promise<void> {
  try {
    // Call the database function to reduce stock and remove reservations
    await supabase.rpc('confirm_inventory_reservation', {
      p_reservation_id: reservationId
    });
  } catch (error) {
    console.error('Error confirming inventory reservation:', error);
  }
}

async function rollbackInventoryReservation(supabase: any, reservationId: string): Promise<void> {
  try {
    // Remove the reservations to free up inventory
    await supabase
      .from('inventory_reservations')
      .delete()
      .eq('reservation_id', reservationId);
  } catch (error) {
    console.error('Error rolling back inventory reservation:', error);
  }
}

async function clearCustomerCart(supabase: any, customerId: number): Promise<void> {
  try {
    await supabase
      .from('cart')
      .delete()
      .eq('customer_id', customerId);
  } catch (error) {
    console.error('Error clearing cart:', error);
  }
}

async function logSecurityEvent(
  supabase: any, 
  eventType: string, 
  data: Record<string, any>
): Promise<void> {
  try {
    await supabase.from('security_audit_log').insert({
      event_type: eventType,
      event_data: data,
      timestamp: new Date().toISOString(),
      ip_address: 'edge_function',
      user_agent: 'supabase_function',
      customer_id: data.customer_id || null,
      severity: getSeverityLevel(eventType)
    });
  } catch (error) {
    console.error('Error logging security event:', error);
  }
}

function getSeverityLevel(eventType: string): string {
  const criticalEvents = ['price_manipulation_detected', 'checkout_error'];
  const warningEvents = ['cart_validation_failed', 'inventory_unavailable'];
  
  if (criticalEvents.includes(eventType)) return 'critical';
  if (warningEvents.includes(eventType)) return 'warning';
  return 'info';
} 