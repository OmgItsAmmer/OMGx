-- Update existing orders table to reference public.users instead of auth.users
-- This script safely updates the foreign key constraint

-- Step 1: Drop the existing foreign key constraint (if it exists)
DO $$
BEGIN
    -- Check if the constraint exists and drop it
    IF EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'orders_user_id_fkey' 
        AND table_name = 'orders'
    ) THEN
        ALTER TABLE orders DROP CONSTRAINT orders_user_id_fkey;
    END IF;
END $$;

-- Step 2: Ensure user_id column is INTEGER type (should already be correct)
-- This will fail if there's data that can't be converted, so use with caution
-- ALTER TABLE orders ALTER COLUMN user_id TYPE INTEGER USING user_id::INTEGER;

-- Step 3: Add new foreign key constraint to reference public.users
ALTER TABLE orders 
ADD CONSTRAINT orders_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES public.users(user_id);

-- Step 4: Create index for better performance (if not exists)
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);

-- Verification query - run this to check the constraint
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu 
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu 
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = 'orders'
    AND kcu.column_name = 'user_id'; 