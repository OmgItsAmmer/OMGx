# Payment Method Constraint Fix

## 🚨 Original Error

The system was experiencing this error:
```
FunctionException(status: 500, details: {success: false, error: Order creation failed: new row for relation "orders" violates check constraint "chk_payment_method_valid", errorCode: INTERNAL_ERROR, message: Checkout failed}
```

**Root Cause**: The database has a check constraint that only allows specific payment method values, but the application was sending different values.

## 🔍 Database Constraint

The `orders` table has this check constraint:
```sql
constraint chk_payment_method_valid check (
  (
    (payment_method)::text = any (
      array[
        ('cod'::character varying)::text,
        ('credit_card'::character varying)::text,
        ('bank_transfer'::character varying)::text,
        ('pickup'::character varying)::text,
        ('jazzcash'::character varying)::text
      ]
    )
  )
)
```

**Allowed Payment Methods**:
- `cod` (Cash on Delivery)
- `credit_card` (Credit Card)
- `bank_transfer` (Bank Transfer)
- `pickup` (Pickup)
- `jazzcash` (JazzCash)

## 🔧 Problem Analysis

### Flutter Side Issue
The `SaleType` enum in Flutter only has two values:
```dart
enum SaleType { cash, installment }
```

But the code was sending these raw enum values (`cash`, `installment`) to the database, which don't match the allowed constraint values.

### Edge Function Issue
The edge functions had incorrect `PaymentMethod` type definitions that didn't match the database constraint.

## ✅ Solution Applied

### 1. **Added Payment Method Mapping in Flutter**

Created a helper method in `SalesController` to map `SaleType` to valid database payment methods:

```dart
String _mapSaleTypeToPaymentMethod(SaleType saleType) {
  switch (saleType) {
    case SaleType.cash:
      return 'cod'; // Cash on delivery
    case SaleType.installment:
      return 'credit_card'; // Installment payments typically use credit card
    default:
      return 'cod'; // Default to cash on delivery
  }
}
```

### 2. **Updated All Payment Method References**

**Files Modified**:
- `lib/controllers/sales/sales_controller.dart`

**Changes Made**:
- Updated `checkOut()` method to use `_mapSaleTypeToPaymentMethod()`
- Updated `editCheckout()` method to use `_mapSaleTypeToPaymentMethod()`
- Updated `OrderModel` creation to use mapped payment methods

### 3. **Fixed Edge Function Type Definitions**

**Files Modified**:
- `supabase/functions/admin-secure-checkout/index.ts`
- `supabase/functions/admin-update-order/index.ts`

**Changes Made**:
```typescript
// Before
type PaymentMethod = 'cash' | 'card' | 'installment' | 'credit' | 'pickup';

// After
type PaymentMethod = 'cod' | 'credit_card' | 'bank_transfer' | 'pickup' | 'jazzcash';
```

## 📋 Payment Method Mapping

| Flutter SaleType | Database Payment Method | Description |
|------------------|------------------------|-------------|
| `SaleType.cash` | `cod` | Cash on Delivery |
| `SaleType.installment` | `credit_card` | Credit Card (for installments) |

## 🔄 Migration Steps

### 1. **Deploy Updated Edge Functions**
```bash
supabase functions deploy admin-secure-checkout
supabase functions deploy admin-update-order
```

### 2. **Update Flutter App**
- The Flutter changes are already applied
- No additional deployment needed

### 3. **Verify Payment Methods**
```sql
-- Check current payment methods in orders table
SELECT DISTINCT payment_method FROM orders ORDER BY payment_method;

-- Check constraint definition
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conname = 'chk_payment_method_valid';
```

## ✅ Verification Checklist

- [ ] `SaleType.cash` maps to `cod` in database
- [ ] `SaleType.installment` maps to `credit_card` in database
- [ ] Edge functions accept correct payment method types
- [ ] Database constraint validation passes
- [ ] Checkout process completes successfully
- [ ] Order updates work correctly

## 🚨 Breaking Changes

### For Existing Data:
- Existing orders with `cash` or `installment` payment methods may need to be updated
- New orders will use the correct payment method values

### For Client Code:
- Payment method mapping is now handled automatically
- No changes needed in UI components
- SaleType enum remains unchanged for backward compatibility

## 📞 Troubleshooting

### Common Issues After Fix:

1. **"Invalid payment method" Error**
   - Ensure edge functions are deployed with updated type definitions
   - Verify payment method mapping is working correctly

2. **Existing Orders with Wrong Payment Methods**
   - Update existing orders if needed:
   ```sql
   UPDATE orders SET payment_method = 'cod' WHERE payment_method = 'cash';
   UPDATE orders SET payment_method = 'credit_card' WHERE payment_method = 'installment';
   ```

3. **UI Still Shows Old Payment Method Names**
   - The UI can continue to show "Cash" and "Installment" 
   - The mapping happens transparently in the backend

## 🎯 Result

After this fix:
- ✅ Checkout process will use valid database payment methods
- ✅ Database constraint validation will pass
- ✅ Orders will be created successfully
- ✅ Payment method mapping is transparent to users
- ✅ Backward compatibility is maintained

The payment method constraint issue is now resolved and the checkout system should work correctly. 