-- Fix payment method constraint issues
-- This script updates existing data to use correct payment method values

-- 1. Update existing orders with incorrect payment methods
UPDATE orders 
SET payment_method = 'cod' 
WHERE payment_method = 'cash';

UPDATE orders 
SET payment_method = 'credit_card' 
WHERE payment_method = 'installment';

-- 2. Verify the constraint is working
DO $$
BEGIN
    -- Check if there are any orders with invalid payment methods
    IF EXISTS (
        SELECT 1 FROM orders 
        WHERE payment_method NOT IN ('cod', 'credit_card', 'bank_transfer', 'pickup', 'jazzcash')
    ) THEN
        RAISE NOTICE 'Warning: Found orders with invalid payment methods';
        
        -- Show invalid payment methods
        SELECT DISTINCT payment_method 
        FROM orders 
        WHERE payment_method NOT IN ('cod', 'credit_card', 'bank_transfer', 'pickup', 'jazzcash');
    ELSE
        RAISE NOTICE 'All orders have valid payment methods';
    END IF;
END $$;

-- 3. Display current payment method distribution
SELECT 
    payment_method,
    COUNT(*) as order_count
FROM orders 
GROUP BY payment_method 
ORDER BY order_count DESC;

-- 4. Verify constraint definition
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conname = 'chk_payment_method_valid';

-- 5. Test constraint with valid values
DO $$
BEGIN
    -- This should not raise an error
    INSERT INTO orders (
        order_date, 
        sub_total, 
        status, 
        payment_method,
        customer_id
    ) VALUES (
        CURRENT_DATE,
        100.00,
        'pending',
        'cod',
        1
    );
    
    -- Clean up test data
    DELETE FROM orders WHERE sub_total = 100.00 AND payment_method = 'cod';
    
    RAISE NOTICE 'Payment method constraint test passed';
EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Payment method constraint test failed: %', SQLERRM;
END $$; 