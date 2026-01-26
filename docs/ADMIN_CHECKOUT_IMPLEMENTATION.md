# Admin-Side Checkout & Order Update Implementation

## Overview
This implementation moves your POS checkout and order update logic from client-side to server-side (Supabase edge functions) to properly handle concurrency, race conditions, and stock management for your dual e-commerce + POS system.

## 🎯 Problem Solved
- **Race Conditions**: Multiple users can't oversell products
- **Stock Management**: Proper inventory tracking with reservations
- **Concurrency**: Server-side validation prevents conflicts
- **Edge Cases**: Comprehensive error handling and rollback mechanisms

## 🔧 Components Implemented

### 1. Edge Functions

#### `admin-secure-checkout/index.ts`
- **Purpose**: Handles new order creation for admin/POS users
- **Features**:
  - Stock validation with row-level locking
  - Inventory reservations (10-minute expiration)
  - Idempotency protection against duplicate orders
  - Comprehensive error handling with rollback
  - Security audit logging

#### `admin-update-order/index.ts`
- **Purpose**: Handles order updates with proper stock diff calculations
- **Features**:
  - Calculates stock differences between original and updated orders
  - Validates stock availability before applying changes
  - Atomic operations with rollback on failure
  - Preserves order integrity

### 2. SQL Functions (`admin_checkout_functions.sql`)

#### `validate_admin_cart_stock()`
- Validates entire cart for stock availability
- Handles both regular products and serialized variants
- Returns detailed error information

#### `apply_admin_stock_changes()`
- Applies stock changes with proper locking
- Handles both product and variant stock updates
- Uses existing `reduce_variant_stock()` function for consistency

#### `calculate_admin_order_totals()`
- Server-side total calculations
- Includes tax, shipping, commission, and discounts
- Prevents client-side price manipulation

#### `reserve_admin_inventory()`
- Creates temporary inventory reservations
- Auto-expires after configurable time
- Prevents overselling during checkout process

#### `get_available_stock_for_admin()`
- Returns actual available stock considering reservations
- Cleans up expired reservations automatically

### 3. Updated Controllers

#### Modified `sales_controller.dart`
- `checkOut()` method now calls `admin-secure-checkout`
- `editCheckout()` method now calls `admin-update-order`
- Proper request formatting for new edge functions
- Maintains local state management for UI consistency

## 🗄️ Database Schema Requirements

### New Table: `inventory_reservations`
```sql
CREATE TABLE IF NOT EXISTS inventory_reservations (
    id SERIAL PRIMARY KEY,
    reservation_id TEXT NOT NULL,
    variant_id INTEGER NOT NULL REFERENCES product_variants(variant_id),
    quantity INTEGER NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_inventory_reservations_expiry ON inventory_reservations(expires_at);
CREATE INDEX idx_inventory_reservations_reservation_id ON inventory_reservations(reservation_id);
```

**Note**: This table only uses `variant_id` because in this system, every product must have at least one variant. Products and variants are connected via `product_id` in the `product_variants` table.

### Orders Table Addition
```sql
ALTER TABLE orders ADD COLUMN IF NOT EXISTS idempotency_key TEXT UNIQUE;
CREATE INDEX IF NOT EXISTS idx_orders_idempotency_key ON orders(idempotency_key);
```

## 🔄 Flow Diagrams

### New Order Flow
```
Client Request → Authentication → Validation → Stock Check → Reserve Inventory → Create Order → Confirm Reservation → Success
                                     ↓ (if fails)
                               Error Response ← Rollback Reservation ← Stock Insufficient
```

### Order Update Flow
```
Client Request → Authentication → Get Original Items → Calculate Differences → Validate Stock → Apply Changes → Update Order → Success
                                                          ↓ (if fails)
                                                   Error Response ← Rollback Changes ← Insufficient Stock
```

## 🛡️ Security Features

### 1. Authentication
- JWT token validation for all requests
- User context preservation for audit logs

### 2. Idempotency
- Prevents duplicate order creation
- SHA-256 hash-based keys including customer and cart data

### 3. Audit Logging
- All operations logged to `security_audit_log`
- Severity levels: info, warning, critical
- Includes error details and customer context

### 4. Race Condition Prevention
- Row-level locking with `FOR UPDATE`
- Atomic transactions with proper rollback
- Inventory reservations prevent overselling

## 📋 Deployment Checklist

### 1. Database Setup
- [ ] Create `inventory_reservations` table
- [ ] Add `idempotency_key` column to orders table
- [ ] Execute all functions in `admin_checkout_functions.sql`
- [ ] Set up proper RLS policies if needed

### 2. Edge Functions Deployment
```bash
# Deploy admin checkout function
supabase functions deploy admin-secure-checkout

# Deploy admin update function  
supabase functions deploy admin-update-order
```

### 3. Environment Variables
Ensure these are set in your Supabase project:
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

### 4. Testing
- [ ] Test new order creation with multiple concurrent users
- [ ] Test order updates with stock changes
- [ ] Test edge cases (insufficient stock, invalid data)
- [ ] Verify audit logs are being created

## 🧪 Testing Scenarios

### Concurrent Checkout Test
1. Two admin users attempt to buy the last item simultaneously
2. Only one should succeed, the other should get "insufficient stock" error

### Order Update Test
1. Create an order with Product A (qty: 2)
2. Update order to Product B (qty: 1) 
3. Verify Product A stock increased by 2, Product B decreased by 1

### Edge Cases
- Invalid authentication tokens
- Non-existent products/variants
- Negative quantities
- Order updates for non-existent orders

## 🔍 Monitoring & Debugging

### Log Queries
```sql
-- View recent admin operations
SELECT * FROM security_audit_log 
WHERE event_type LIKE 'admin_%' 
ORDER BY timestamp DESC LIMIT 50;

-- Check active reservations
SELECT * FROM inventory_reservations 
WHERE expires_at > NOW();

-- Monitor stock levels
SELECT p.name, p.stock_quantity,
       COALESCE(r.reserved_qty, 0) as reserved,
       (p.stock_quantity - COALESCE(r.reserved_qty, 0)) as available
FROM products p
LEFT JOIN (
    SELECT product_id, SUM(quantity) as reserved_qty
    FROM inventory_reservations 
    WHERE expires_at > NOW() AND variant_id IS NULL
    GROUP BY product_id
) r ON p.product_id = r.product_id;
```

### Error Codes
- `AUTH_REQUIRED`: Missing authorization header
- `AUTH_INVALID`: Invalid JWT token
- `VALIDATION_FAILED`: Request validation failed
- `INSUFFICIENT_STOCK`: Not enough stock available
- `ORDER_NOT_FOUND`: Order doesn't exist (for updates)
- `DUPLICATE_ORDER`: Idempotency key already used
- `INTERNAL_ERROR`: Server error, check logs

## 📈 Performance Considerations

### Inventory Reservations Cleanup
The system automatically cleans up expired reservations, but for high-traffic systems, consider setting up a periodic cleanup job:

```sql
-- Run every 5 minutes
SELECT cleanup_expired_reservations();
```

### Database Indexing
Ensure proper indexes exist for:
- `inventory_reservations.expires_at`
- `inventory_reservations.reservation_id`
- `orders.idempotency_key`

## 🔧 Configuration Options

### Reservation Expiry
Default: 10 minutes. Adjust in edge functions:
```typescript
const reservationId = `admin_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
const reservationResult = await reserveAdminInventory(supabase, requestBody.cartItems, reservationId)
```

### Retry Logic
Consider implementing client-side retry logic for network failures, but not for business logic errors (stock issues, validation failures).

## 🚀 Future Enhancements

1. **Real-time Stock Updates**: Use Supabase realtime to update admin UIs when stock changes
2. **Batch Operations**: Support bulk order operations
3. **Advanced Reservations**: Customer-specific reservations for complex workflows
4. **Analytics Integration**: Enhanced reporting on stock movements and order patterns

## 📞 Support

If you encounter issues:
1. Check the `security_audit_log` table for detailed error information
2. Verify edge function deployment status in Supabase dashboard
3. Ensure all database functions are properly created
4. Test with minimal data to isolate issues

This implementation provides a robust, scalable foundation for your dual e-commerce + POS system with proper concurrency control and stock management. 