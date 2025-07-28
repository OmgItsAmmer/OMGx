import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

interface AdminUpdateOrderRequest {
  orderId: number;
  updatedCartItems: AdminCartItem[];
  addressId: number;
  paymentMethod: PaymentMethod;
  customerInfo: CustomerInfo;
  salesmanInfo: SalesmanInfo;
  discount?: number;
  paidAmount: number;
  orderDate?: string;
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

interface AdminUpdateOrderResponse {
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

interface StockDifference {
  productChanges: Record<string, number>;
  variantChanges: Record<string, number>;
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
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
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

    const requestBody: AdminUpdateOrderRequest = await req.json()

    // Validate that order exists and get original items
    const originalOrderItems = await getOriginalOrderItems(supabase, requestBody.orderId)
    if (!originalOrderItems || originalOrderItems.length === 0) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Order not found or has no items',
        errorCode: 'ORDER_NOT_FOUND'
      }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Validate request
    const validation = await validateAdminOrderUpdate(supabase, requestBody)
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

    // Calculate stock differences
    const stockDifferences = calculateStockDifferences(originalOrderItems, requestBody.updatedCartItems)

    // Validate stock availability for the changes
    const stockValidation = await validateStockChanges(supabase, stockDifferences)
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

    try {
      // Apply stock changes first (this validates availability again with locks)
      const stockUpdateSuccess = await applyStockChanges(supabase, stockDifferences)
      if (!stockUpdateSuccess) {
        throw new Error('Failed to apply stock changes')
      }

      // Update the order
      const orderUpdateSuccess = await updateOrderInDatabase(
        supabase,
        requestBody,
        totals
      )

      if (!orderUpdateSuccess) {
        // Rollback stock changes if order update fails
        await rollbackStockChanges(supabase, stockDifferences)
        throw new Error('Failed to update order')
      }

      // Update order items
      const itemsUpdateSuccess = await updateOrderItems(
        supabase,
        requestBody.orderId,
        requestBody.updatedCartItems
      )

      if (!itemsUpdateSuccess) {
        // Rollback stock changes if items update fails
        await rollbackStockChanges(supabase, stockDifferences)
        throw new Error('Failed to update order items')
      }

      // Log successful update
      await logAdminSecurityEvent(supabase, 'admin_order_update_success', {
        order_id: requestBody.orderId,
        customer_id: requestBody.customerInfo.customerId,
        total_amount: totals.total,
        item_count: requestBody.updatedCartItems.length
      })

      const response: AdminUpdateOrderResponse = {
        success: true,
        orderId: requestBody.orderId,
        total: totals.total,
        message: 'Order updated successfully'
      }

      return new Response(JSON.stringify(response), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })

    } catch (error) {
      await logAdminSecurityEvent(supabase, 'admin_order_update_error', {
        error: (error as Error).message,
        order_id: requestBody.orderId,
        customer_id: requestBody.customerInfo.customerId
      })

      throw error
    }

  } catch (error) {
    console.error('Admin order update error:', error)
    
    const response: AdminUpdateOrderResponse = {
      success: false,
      error: (error as Error).message || 'Internal server error',
      errorCode: 'INTERNAL_ERROR',
      message: 'Order update failed'
    }

    return new Response(JSON.stringify(response), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

async function getOriginalOrderItems(supabase: any, orderId: number): Promise<AdminCartItem[]> {
  try {
    const { data: orderItems, error } = await supabase
      .from('order_items')
      .select(`
        product_id,
        quantity,
        price,
        unit,
        total_buy_price,
        variant_id,
        products!inner(name)
      `)
      .eq('order_id', orderId)

    if (error) {
      throw error
    }

    return orderItems.map((item: any) => ({
      productId: item.product_id,
      quantity: item.quantity,
      sellPrice: item.price,
      buyPrice: item.variant_id ? item.total_buy_price : item.total_buy_price / item.quantity,
      productName: item.products.name,
      unit: item.unit,
      variantId: item.variant_id
    }))
  } catch (error) {
    console.error('Error fetching original order items:', error)
    return []
  }
}

async function validateAdminOrderUpdate(supabase: any, request: AdminUpdateOrderRequest): Promise<ValidationResult> {
  try {
    // Validate cart items
    if (!request.updatedCartItems || request.updatedCartItems.length === 0) {
      return { isValid: false, errorMessage: 'Updated cart is empty' }
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

    // Validate order ID
    if (!request.orderId || request.orderId <= 0) {
      return { isValid: false, errorMessage: 'Valid order ID is required' }
    }

    // Calculate totals
    const totals = await calculateAdminTotals(supabase, request)

    return { isValid: true, totals }

  } catch (error) {
    return { isValid: false, errorMessage: `Validation error: ${(error as Error).message}` }
  }
}

async function calculateAdminTotals(supabase: any, request: AdminUpdateOrderRequest): Promise<AdminCartTotals> {
  let subtotal = 0
  let buyingPriceTotal = 0

  // Calculate subtotal and buying price total
  for (const item of request.updatedCartItems) {
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

function calculateStockDifferences(originalItems: AdminCartItem[], updatedItems: AdminCartItem[]): StockDifference {
  const variantChanges: Record<string, number> = {}

  // Create maps for easier lookup (only variants since every product must have variants)
  const originalMap = new Map<string, AdminCartItem>()
  const updatedMap = new Map<string, AdminCartItem>()

  // Build original items map
  for (const item of originalItems) {
    const key = `variant_${item.variantId}`
    originalMap.set(key, item)
  }

  // Build updated items map
  for (const item of updatedItems) {
    const key = `variant_${item.variantId}`
    updatedMap.set(key, item)
  }

  // Calculate differences
  // First, handle items that were removed or had quantity reduced
  for (const [key, originalItem] of originalMap) {
    const updatedItem = updatedMap.get(key)
    const quantityDiff = (updatedItem?.quantity || 0) - originalItem.quantity

    if (originalItem.variantId) {
      variantChanges[originalItem.variantId.toString()] = quantityDiff
    }
  }

  // Handle new items that weren't in original
  for (const [key, updatedItem] of updatedMap) {
    if (!originalMap.has(key)) {
      if (updatedItem.variantId) {
        variantChanges[updatedItem.variantId.toString()] = -updatedItem.quantity
      }
    }
  }

  return { productChanges: {}, variantChanges }
}

async function validateStockChanges(supabase: any, stockDifferences: StockDifference): Promise<ValidationResult> {
  try {
    // Check variant stock changes (only variants since every product must have variants)
    for (const [variantId, quantityChange] of Object.entries(stockDifferences.variantChanges)) {
      if (quantityChange < 0) { // Only check when we're adding more items (reducing stock)
        const { data: variant, error } = await supabase
          .from('product_variants')
          .select('stock, variant_name, is_visible')
          .eq('variant_id', parseInt(variantId))
          .single()

        if (error || !variant) {
          return { isValid: false, errorMessage: `Product variant ${variantId} not found` }
        }

        if (!variant.is_visible) {
          return { isValid: false, errorMessage: `Product variant ${variant.variant_name} is not available` }
        }

        if (variant.stock < Math.abs(quantityChange)) {
          return { 
            isValid: false, 
            errorMessage: `Insufficient stock for ${variant.variant_name}. Available: ${variant.stock}, Additional needed: ${Math.abs(quantityChange)}` 
          }
        }
      }
    }

    return { isValid: true }
  } catch (error) {
    return { isValid: false, errorMessage: `Stock validation error: ${(error as Error).message}` }
  }
}

async function applyStockChanges(supabase: any, stockDifferences: StockDifference): Promise<boolean> {
  try {
    // Apply variant stock changes using the existing function (only variants since every product must have variants)
    for (const [variantId, quantityChange] of Object.entries(stockDifferences.variantChanges)) {
      if (quantityChange < 0) { // Reducing stock (adding more items)
        const { error } = await supabase.rpc('reduce_variant_stock', {
          variant_id_param: parseInt(variantId),
          quantity_param: Math.abs(quantityChange)
        })

        if (error) {
          throw error
        }
      } else if (quantityChange > 0) { // Increasing stock (removing items)
        const { error } = await supabase
          .from('product_variants')
          .update({ 
            stock: supabase.sql`stock + ${quantityChange}`,
            updated_at: new Date().toISOString()
          })
          .eq('variant_id', parseInt(variantId))

        if (error) {
          throw error
        }
      }
    }

    return true
  } catch (error) {
    console.error('Error applying stock changes:', error)
    return false
  }
}

async function rollbackStockChanges(supabase: any, stockDifferences: StockDifference): Promise<void> {
  try {
    // Rollback variant stock changes (reverse the changes) - only variants since every product must have variants
    for (const [variantId, quantityChange] of Object.entries(stockDifferences.variantChanges)) {
      if (quantityChange !== 0) {
        await supabase
          .from('product_variants')
          .update({ 
            stock: supabase.sql`stock - ${quantityChange}`,
            updated_at: new Date().toISOString()
          })
          .eq('variant_id', parseInt(variantId))
      }
    }
  } catch (error) {
    console.error('Error rolling back stock changes:', error)
  }
}

async function updateOrderInDatabase(
  supabase: any,
  request: AdminUpdateOrderRequest,
  totals: AdminCartTotals
): Promise<boolean> {
  try {
    const updateData: any = {
      sub_total: totals.subtotal,
      buying_price: totals.buyingPriceTotal,
      saletype: request.paymentMethod,
      address_id: request.addressId,
      customer_id: request.customerInfo.customerId,
      paid_amount: request.paidAmount,
      discount: request.discount || 0,
      tax: totals.tax,
      shipping_fee: totals.shipping,
      salesman_comission: Math.round(request.salesmanInfo.commission), // Integer type
      payment_method: request.paymentMethod,
      salesman_id: request.salesmanInfo.salesmanId
    }

    // Add order date if provided (ensure proper date format)
    if (request.orderDate) {
      // Convert to date format if it's a timestamp
      updateData.order_date = request.orderDate.split('T')[0]
    }

    // Determine status based on payment
    const remainingAmount = totals.total - request.paidAmount
    updateData.status = remainingAmount <= 0.01 ? 'completed' : 'pending'

    const { error } = await supabase
      .from('orders')
      .update(updateData)
      .eq('order_id', request.orderId)

    if (error) {
      throw error
    }

    return true
  } catch (error) {
    console.error('Error updating order:', error)
    return false
  }
}

async function updateOrderItems(
  supabase: any,
  orderId: number,
  updatedCartItems: AdminCartItem[]
): Promise<boolean> {
  try {
    // Delete existing order items
    const { error: deleteError } = await supabase
      .from('order_items')
      .delete()
      .eq('order_id', orderId)

    if (deleteError) {
      throw deleteError
    }

    // Insert new order items
    const orderItems = updatedCartItems.map(item => ({
      order_id: orderId,
      product_id: item.productId,
      quantity: parseInt(item.quantity.toString()), // Ensure integer
      price: parseFloat(item.sellPrice.toString()), // Ensure numeric
      unit: item.unit || 'item',
      total_buy_price: parseFloat((item.buyPrice * item.quantity).toString()), // All products have variants, multiply by quantity
      variant_id: item.variantId // Required since every product must have variants
    }))

    const { error: insertError } = await supabase
      .from('order_items')
      .insert(orderItems)

    if (insertError) {
      throw insertError
    }

    return true
  } catch (error) {
    console.error('Error updating order items:', error)
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
      user_agent: 'supabase_admin_update_function',
      customer_id: data.customer_id || null,
      severity: getAdminSeverityLevel(eventType)
    })
  } catch (error) {
    console.error('Error logging admin security event:', error)
  }
}

function getAdminSeverityLevel(eventType: string): string {
  const criticalEvents = ['admin_order_update_error', 'stock_manipulation_detected']
  const warningEvents = ['admin_update_validation_failed', 'admin_insufficient_stock']
  
  if (criticalEvents.includes(eventType)) return 'critical'
  if (warningEvents.includes(eventType)) return 'warning'
  return 'info'
} 