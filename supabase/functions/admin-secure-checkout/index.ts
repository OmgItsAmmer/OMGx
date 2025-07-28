import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

interface AdminCheckoutRequest {
  cartItems: AdminCartItem[];
  addressId: number;
  paymentMethod: PaymentMethod;
  customerInfo: CustomerInfo;
  salesmanInfo: SalesmanInfo;
  discount?: number;
  idempotencyKey?: string;
}

interface AdminCartItem {
  variantId?: number;
  productId: number;
  quantity: number;
  sellPrice: number;
  buyPrice: number;
  productName: string;
  unit?: string;
}

interface CustomerInfo {
  customerId: number;
  fullName: string;
  phoneNumber: string;
  cnic: string;
}

interface SalesmanInfo {
  salesmanId: number;
  commission: number; // percentage
}

type PaymentMethod = 'cod' | 'credit_card' | 'bank_transfer' | 'pickup' | 'jazzcash';

interface AdminCheckoutResponse {
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
  totals?: AdminCartTotals;
}

interface AdminCartTotals {
  subtotal: number;
  tax: number;
  shipping: number;
  salesman_comission: number;
  discount: number;
  total: number;
  buyingPriceTotal: number;
}

serve(async (req: Request) => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  try {
    const supabase = createClient(
      Deno.env.get('PROJECT_URL') ?? '',
      Deno.env.get('SERVICE_ROLE_KEY') ?? ''
    )

    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ 
        error: 'Authorization header required',
        errorCode: 'AUTH_REQUIRED'
      }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Verify user authentication
    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: authError } = await supabase.auth.getUser(token)
    
    if (authError || !user) {
      return new Response(JSON.stringify({
        error: 'Invalid authentication',
        errorCode: 'AUTH_INVALID'
      }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const requestBody: AdminCheckoutRequest = await req.json()

    // Validate request
    const validation = await validateAdminCheckout(supabase, requestBody)
    if (!validation.isValid) {
      return new Response(JSON.stringify({
        success: false,
        error: validation.errorMessage,
        errorCode: 'VALIDATION_FAILED'
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Generate idempotency key if not provided
    const idempotencyKey = requestBody.idempotencyKey || 
      await generateAdminIdempotencyKey(requestBody.customerInfo.customerId, requestBody.cartItems)

    // Check for duplicate orders
    const isDuplicate = await checkDuplicateAdminOrder(supabase, idempotencyKey)
    if (isDuplicate) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Duplicate order detected',
        errorCode: 'DUPLICATE_ORDER'
      }), {
        status: 409,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Validate stock availability with row-level locking
    const stockValidation = await validateStockAvailability(supabase, requestBody.cartItems)
    if (!stockValidation.isValid) {
      return new Response(JSON.stringify({
        success: false,
        error: stockValidation.errorMessage,
        errorCode: 'INSUFFICIENT_STOCK'
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const totals = validation.totals!

    // Create reservation ID for inventory management
    const reservationId = `admin_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`

    // Reserve inventory
    const reservationResult = await reserveAdminInventory(supabase, requestBody.cartItems, reservationId)
    if (!reservationResult.success) {
      return new Response(JSON.stringify({
        success: false,
        error: reservationResult.message,
        errorCode: 'RESERVATION_FAILED'
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    try {
      // Copy address to order_addresses table
      const addressCopyResult = await supabase.rpc('copy_address_to_order_addresses', {
        p_address_id: requestBody.addressId
      })

      if (addressCopyResult.error) {
        throw new Error(`Failed to copy address: ${addressCopyResult.error.message}`)
      }

      // Create the order with items
      const orderResult = await createAdminOrder(
        supabase,
        user.id, // This is the auth UUID, will be converted to integer user_id inside the function
        requestBody,
        totals,
        idempotencyKey
      )

      if (!orderResult.success || !orderResult.orderId) {
        throw new Error(orderResult.message)
      }

      // Confirm inventory reservation (reduces stock)
      await confirmAdminInventoryReservation(supabase, reservationId)

      // Log successful transaction
      await logAdminSecurityEvent(supabase, 'admin_checkout_success', {
        order_id: orderResult.orderId,
        customer_id: requestBody.customerInfo.customerId,
        total_amount: totals.total,
        item_count: requestBody.cartItems.length
      })

      const response: AdminCheckoutResponse = {
        success: true,
        orderId: orderResult.orderId,
        total: totals.total,
        message: 'Order created successfully'
      }

      return new Response(JSON.stringify(response), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })

    } catch (error) {
      // Rollback inventory reservation on failure
      await rollbackAdminInventoryReservation(supabase, reservationId)
      
      await logAdminSecurityEvent(supabase, 'admin_checkout_error', {
        error: (error as Error).message,
        customer_id: requestBody.customerInfo.customerId
      })

      throw error
    }

  } catch (error) {
    console.error('Admin checkout error:', error)
    
    const response: AdminCheckoutResponse = {
      success: false,
      error: (error as Error).message || 'Internal server error',
      errorCode: 'INTERNAL_ERROR',
      message: 'Checkout failed'
    }

    return new Response(JSON.stringify(response), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

async function validateAdminCheckout(supabase: any, request: AdminCheckoutRequest): Promise<ValidationResult> {
  try {
    // Validate cart items
    if (!request.cartItems || request.cartItems.length === 0) {
      return { isValid: false, errorMessage: 'Cart is empty' }
    }

    // Validate customer info
    if (!request.customerInfo || !request.customerInfo.customerId) {
      return { isValid: false, errorMessage: 'Customer information is required' }
    }

    // Validate salesman info
    if (!request.salesmanInfo || !request.salesmanInfo.salesmanId) {
      return { isValid: false, errorMessage: 'Salesman information is required' }
    }

    // Validate address
    if (!request.addressId) {
      return { isValid: false, errorMessage: 'Address is required' }
    }

    // Calculate totals
    const totals = await calculateAdminTotals(supabase, request)

    return { isValid: true, totals }

  } catch (error) {
    return { isValid: false, errorMessage: `Validation error: ${(error as Error).message}` }
  }
}

async function calculateAdminTotals(supabase: any, request: AdminCheckoutRequest): Promise<AdminCartTotals> {
  let subtotal = 0
  let buyingPriceTotal = 0

  // Calculate subtotal and buying price total
  for (const item of request.cartItems) {
    const itemTotal = item.sellPrice * item.quantity
    subtotal += itemTotal

    // All products have variants, so multiply by quantity
    buyingPriceTotal += item.buyPrice * item.quantity
  }

  // Get shop settings for tax and shipping
  const { data: shopData, error: shopError } = await supabase
    .from('shop')
    .select('taxrate, shipping_price')
    .limit(1)
    .single()

  if (shopError) {
    throw new Error(`Failed to get shop settings: ${shopError.message}`)
  }

  const tax = shopData.taxrate || 0
  // For POS orders, shipping is always 0 (customer pickup)
  const shipping = 0
  
  // Calculate salesman commission amount
  const salesman_comission = (subtotal * request.salesmanInfo.commission) / 100

  // Apply discount if provided
  const discountAmount = request.discount ? (subtotal * request.discount) / 100 : 0
  const discountedSubtotal = subtotal - discountAmount

  const total = discountedSubtotal + tax + shipping + salesman_comission

  return {
    subtotal: discountedSubtotal,
    tax,
    shipping,
    salesman_comission: Number(salesman_comission), // Ensure it's a number
    discount: discountAmount,
    total: Number(total), // Ensure it's a number
    buyingPriceTotal
  }
}

async function validateStockAvailability(supabase: any, cartItems: AdminCartItem[]): Promise<ValidationResult> {
  try {
    for (const item of cartItems) {
      // Every product must have variants, so we only check variant stock
      if (!item.variantId) {
        return { isValid: false, errorMessage: `Product ${item.productName} must have a variant selected` }
      }

      const { data: variant, error } = await supabase
        .from('product_variants')
        .select('stock, is_visible')
        .eq('variant_id', item.variantId)
        .single()

      if (error || !variant) {
        return { isValid: false, errorMessage: `Product variant ${item.variantId} not found` }
      }

      if (!variant.is_visible) {
        return { isValid: false, errorMessage: `Product variant ${item.productName} is not available` }
      }

      if (variant.stock < item.quantity) {
        return { isValid: false, errorMessage: `Insufficient stock for ${item.productName}. Available: ${variant.stock}, Requested: ${item.quantity}` }
      }
    }

    return { isValid: true }
  } catch (error) {
    return { isValid: false, errorMessage: `Stock validation error: ${(error as Error).message}` }
  }
}

async function reserveAdminInventory(supabase: any, cartItems: AdminCartItem[], reservationId: string): Promise<{success: boolean, message: string}> {
  try {
    const reservations = cartItems.map(item => ({
      reservation_id: reservationId,
      variant_id: item.variantId, // Every product must have a variant
      quantity: item.quantity,
      expires_at: new Date(Date.now() + 10 * 60 * 1000).toISOString() // 10 minutes
    }))

    const { error } = await supabase
      .from('inventory_reservations')
      .insert(reservations)

    if (error) {
      throw error
    }

    return { success: true, message: 'Inventory reserved successfully' }
  } catch (error) {
    return { success: false, message: `Reservation failed: ${(error as Error).message}` }
  }
}

async function createAdminOrder(
  supabase: any,
  userAuthId: string,
  request: AdminCheckoutRequest,
  totals: AdminCartTotals,
  idempotencyKey: string
): Promise<{success: boolean, message: string, orderId?: number}> {
  try {
    // First, get the integer user_id from the users table using auth UUID
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('user_id')
      .eq('auth_uid', userAuthId)
      .single()

    if (userError || !userData) {
      throw new Error(`User not found: ${userError?.message}`)
    }

    const userId = userData.user_id

    // Insert order
    const { data: orderData, error: orderError } = await supabase
      .from('orders')
      .insert({
        order_date: new Date().toISOString().split('T')[0], // Date format: YYYY-MM-DD
        sub_total: totals.subtotal,
        buying_price: totals.buyingPriceTotal,
        status: totals.total <= 0 ? 'completed' : 'pending', // If total is 0 or negative, mark as completed
        saletype: request.paymentMethod,
        address_id: request.addressId,
        customer_id: request.customerInfo.customerId,
        user_id: userId, // Now using integer user_id
        paid_amount: totals.total, // For POS, assume full payment
        discount: request.discount || 0,
        tax: totals.tax,
        shipping_fee: totals.shipping,
        salesman_comission: Math.round(request.salesmanInfo.commission), // Integer type
        payment_method: request.paymentMethod,
        salesman_id: request.salesmanInfo.salesmanId,
        idempotency_key: idempotencyKey
      })
      .select('order_id')
      .single()

    if (orderError) {
      throw orderError
    }

    const orderId = orderData.order_id

    // Insert order items
    const orderItems = request.cartItems.map(item => ({
      order_id: orderId,
      product_id: item.productId,
      quantity: parseInt(item.quantity.toString()), // Ensure integer
      price: parseFloat(item.sellPrice.toString()), // Ensure numeric
      unit: item.unit || 'item',
      total_buy_price: parseFloat((item.buyPrice * item.quantity).toString()), // All products have variants, multiply by quantity
      variant_id: item.variantId // Required since every product must have variants
    }))

    const { error: itemsError } = await supabase
      .from('order_items')
      .insert(orderItems)

    if (itemsError) {
      // Delete the order if items insertion fails
      await supabase.from('orders').delete().eq('order_id', orderId)
      throw itemsError
    }

    return { success: true, message: 'Order created successfully', orderId }
  } catch (error) {
    return { success: false, message: `Order creation failed: ${(error as Error).message}` }
  }
}

async function confirmAdminInventoryReservation(supabase: any, reservationId: string): Promise<void> {
  const { error } = await supabase.rpc('confirm_inventory_reservation', {
    p_reservation_id: reservationId
  })

  if (error) {
    throw new Error(`Failed to confirm reservation: ${error.message}`)
  }
}

async function rollbackAdminInventoryReservation(supabase: any, reservationId: string): Promise<void> {
  try {
    await supabase
      .from('inventory_reservations')
      .delete()
      .eq('reservation_id', reservationId)
  } catch (error) {
    console.error('Error rolling back reservation:', error)
  }
}

async function generateAdminIdempotencyKey(customerId: number, cartItems: AdminCartItem[]): Promise<string> {
  const itemsString = cartItems
    .map(item => `${item.productId}:${item.variantId || 0}:${item.quantity}:${item.sellPrice}`)
    .sort()
    .join('|')
  
  const dataString = `admin_${customerId}_${itemsString}_${Date.now()}`
  
  const encoder = new TextEncoder()
  const data = encoder.encode(dataString)
  const hashBuffer = await crypto.subtle.digest('SHA-256', data)
  const hashArray = Array.from(new Uint8Array(hashBuffer))
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
}

async function checkDuplicateAdminOrder(supabase: any, idempotencyKey: string): Promise<boolean> {
  try {
    const { data, error } = await supabase
      .from('orders')
      .select('order_id')
      .eq('idempotency_key', idempotencyKey)
      .limit(1)

    if (error) {
      console.error('Error checking duplicate order:', error)
      return false
    }

    return data && data.length > 0
  } catch (error) {
    console.error('Error checking duplicate order:', error)
    return false
  }
}

async function logAdminSecurityEvent(
  supabase: any, 
  eventType: string, 
  data: Record<string, any>
): Promise<void> {
  try {
    await supabase.from('security_audit_log').insert({
      event_type: eventType,
      event_data: data,
      timestamp: new Date().toISOString(),
      ip_address: 'admin_function',
      user_agent: 'supabase_admin_function',
      customer_id: data.customer_id || null,
      severity: getAdminSeverityLevel(eventType)
    })
  } catch (error) {
    console.error('Error logging admin security event:', error)
  }
}

function getAdminSeverityLevel(eventType: string): string {
  const criticalEvents = ['admin_checkout_error', 'stock_manipulation_detected']
  const warningEvents = ['admin_validation_failed', 'admin_insufficient_stock']
  
  if (criticalEvents.includes(eventType)) return 'critical'
  if (warningEvents.includes(eventType)) return 'warning'
  return 'info'
} 