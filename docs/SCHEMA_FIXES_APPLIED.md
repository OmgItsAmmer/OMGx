# Database Schema Fixes for Admin Checkout System

This document details the schema mismatches that were identified and fixed in the admin checkout system.

## 🚨 Original Error

The system was experiencing this error:
```
FunctionException(status: 500, details: {success: false, error: Order creation failed: invalid input syntax for type integer: "af8a624e-9e8c-4849-b57f-2f725902aaae", errorCode: INTERNAL_ERROR, message: Checkout failed}
```

**Root Cause**: Attempting to insert a UUID (auth user ID) into an INTEGER column (`user_id` in orders table).

## 🔧 Schema Fixes Applied

### 1. **User ID Mapping Issue**

**Problem**: Edge functions were trying to insert Supabase Auth UUID directly into `orders.user_id` (INTEGER column).

**Solution**: 
- Updated edge functions to lookup the integer `user_id` from `users` table using `auth_uid`
- Added proper user resolution in `createAdminOrder` function

**Code Changes**:
```typescript
// Before
user_id: userId, // UUID being passed to INTEGER field

// After  
// First, get the integer user_id from the users table using auth UUID
const { data: userData, error: userError } = await supabase
  .from('users')
  .select('user_id')
  .eq('auth_uid', userAuthId)
  .single()

const userId = userData.user_id // Now using INTEGER
```

### 2. **Data Type Mismatches**

#### Orders Table Fixes:
- **`order_date`**: Fixed from TIMESTAMP to DATE format
- **`salesman_comission`**: Ensured INTEGER type (not NUMERIC)
- **`idempotency_key`**: Added VARCHAR column with UNIQUE constraint

#### Order Items Table Fixes:
- **`quantity`**: Ensured INTEGER parsing
- **`price`**: Ensured NUMERIC parsing  
- **`total_buy_price`**: Fixed calculation and NUMERIC parsing
- **`variant_id`**: Made required (not NULL) since every product must have variants

**Code Changes**:
```typescript
// Before
quantity: item.quantity,
price: item.sellPrice,

// After
quantity: parseInt(item.quantity.toString()), // Ensure integer
price: parseFloat(item.sellPrice.toString()), // Ensure numeric
```

### 3. **Date Format Issues**

**Problem**: Edge functions were sending full ISO timestamps to DATE columns.

**Solution**: Convert timestamps to date-only format.

**Code Changes**:
```typescript
// Before
order_date: new Date().toISOString(),

// After
order_date: new Date().toISOString().split('T')[0], // Date format: YYYY-MM-DD
```

### 4. **Column Name Consistency**

**Problem**: Inconsistent use of `salesman_commission` vs `salesman_comission`.

**Solution**: Updated all code to use `salesman_comission` (matching database schema).

**Files Updated**:
- `supabase/functions/admin-secure-checkout/index.ts`
- `supabase/functions/admin-update-order/index.ts`
- `sql_functions/admin_checkout_functions.sql`
- `lib/controllers/sales/sales_controller.dart`

### 5. **Variant Validation**

**Problem**: Code allowed NULL `variant_id` but the new system requires every product to have variants.

**Solution**: Added validation to ensure `variant_id` is always present.

**Code Changes**:
```dart
// Added validation
final variantId = sale.variantId;
if (variantId == null) {
  throw Exception('Every product must have a variant selected: ${sale.name}');
}
```

### 6. **SQL Function Parameter Types**

**Problem**: SQL functions had incorrect parameter types.

**Solution**: Updated SQL function signatures to match database schema.

**Changes**:
- `salesman_comission`: NUMERIC → INTEGER
- `order_date`: TIMESTAMP → DATE
- `variant_id`: Made required (not nullable)

## 📁 Files Modified

### Edge Functions:
- `supabase/functions/admin-secure-checkout/index.ts`
- `supabase/functions/admin-update-order/index.ts`

### SQL Functions:
- `sql_functions/admin_checkout_functions.sql`
- `sql_functions/fix_schema_mismatches.sql` (new)

### Flutter Controllers:
- `lib/controllers/sales/sales_controller.dart`

### Documentation:
- Updated `ADMIN_CHECKOUT_IMPLEMENTATION.md`
- Created `SCHEMA_FIXES_APPLIED.md` (this file)

## 🔄 Migration Steps

### 1. Execute Schema Fixes
```sql
-- Run the schema fix script
\i sql_functions/fix_schema_mismatches.sql
```

### 2. Update Functions
```sql
-- Update admin checkout functions
\i sql_functions/admin_checkout_functions.sql
```

### 3. Deploy Edge Functions
```bash
# Deploy updated edge functions
supabase functions deploy admin-secure-checkout
supabase functions deploy admin-update-order
```

### 4. Verify Schema
```sql
-- Check orders table structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'orders' 
    AND column_name IN ('user_id', 'salesman_comission', 'order_date', 'idempotency_key')
ORDER BY ordinal_position;

-- Check inventory_reservations structure  
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'inventory_reservations' 
ORDER BY ordinal_position;
```

## ✅ Verification Checklist

- [ ] `orders.user_id` accepts INTEGER values (not UUIDs)
- [ ] `orders.order_date` accepts DATE format (YYYY-MM-DD)
- [ ] `orders.salesman_comission` is INTEGER type
- [ ] `orders.idempotency_key` column exists with UNIQUE constraint
- [ ] `order_items.variant_id` is required and not NULL
- [ ] Edge functions resolve auth UUID to integer user_id
- [ ] All numeric fields use proper parsing
- [ ] Date fields use proper formatting
- [ ] Variant validation prevents NULL variant_id

## 🚨 Breaking Changes

### For Existing Data:
- Orders without `idempotency_key` will have NULL values (acceptable)
- Order items without `variant_id` may need variant assignment for new orders
- Users table needs `auth_uid` mapping for new edge function flow

### For Client Code:
- All product selections must include variant selection
- Checkout validation now enforces variant requirement
- Error handling updated for new validation rules

## 📞 Troubleshooting

### Common Issues After Fix:

1. **"User not found" Error**
   - Ensure `users.auth_uid` is populated with correct Supabase Auth UUIDs
   - Verify user session is valid

2. **"Variant required" Error**  
   - Ensure all products have at least one variant
   - Update product selection UI to require variant selection

3. **Date Format Errors**
   - Ensure dates are sent in YYYY-MM-DD format
   - Check timezone handling if needed

4. **Type Conversion Errors**
   - Verify all numeric fields are properly parsed
   - Check that integers are not passed as strings

All schema mismatches have been resolved and the checkout system should now work correctly with proper data type handling and validation. 