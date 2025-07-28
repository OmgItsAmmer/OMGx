-- Schema fixes for admin checkout system
-- This script ensures all tables have the correct data types and columns

-- 1. Ensure orders table has the correct structure
DO $$
BEGIN
    -- Add idempotency_key if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'orders' AND column_name = 'idempotency_key'
    ) THEN
        ALTER TABLE orders ADD COLUMN idempotency_key VARCHAR UNIQUE;
        CREATE INDEX IF NOT EXISTS idx_orders_idempotency_key ON orders(idempotency_key);
    END IF;

    -- Ensure salesman_comission is INTEGER type
    BEGIN
        ALTER TABLE orders ALTER COLUMN salesman_comission TYPE INTEGER USING salesman_comission::INTEGER;
    EXCEPTION
        WHEN others THEN
            -- Column might already be correct type or doesn't exist
            NULL;
    END;

    -- Ensure order_date is DATE type (not timestamp)
    BEGIN
        ALTER TABLE orders ALTER COLUMN order_date TYPE DATE USING order_date::DATE;
    EXCEPTION
        WHEN others THEN
            -- Column might already be correct type
            NULL;
    END;
END $$;

-- 2. Ensure users table has auth_uid column for mapping
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'auth_uid'
    ) THEN
        ALTER TABLE users ADD COLUMN auth_uid UUID;
        CREATE INDEX IF NOT EXISTS idx_users_auth_uid ON users(auth_uid);
    END IF;
END $$;

-- 3. Ensure inventory_reservations table has correct structure
CREATE TABLE IF NOT EXISTS inventory_reservations (
    reservation_id VARCHAR NOT NULL,
    variant_id INTEGER NOT NULL REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for inventory_reservations if they don't exist
CREATE INDEX IF NOT EXISTS idx_inventory_reservations_expiry 
    ON inventory_reservations(expires_at);

CREATE INDEX IF NOT EXISTS idx_inventory_reservations_reservation_id 
    ON inventory_reservations(reservation_id);

CREATE INDEX IF NOT EXISTS idx_inventory_reservations_variant_id 
    ON inventory_reservations(variant_id);

-- 4. Clean up any old reservations (optional)
DELETE FROM inventory_reservations WHERE expires_at < NOW();

-- 5. Ensure order_items table has correct structure
DO $$
BEGIN
    -- Ensure variant_id exists and is nullable (since it should be required but might have legacy data)
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'order_items' AND column_name = 'variant_id'
    ) THEN
        ALTER TABLE order_items ADD COLUMN variant_id INTEGER REFERENCES product_variants(variant_id);
        CREATE INDEX IF NOT EXISTS idx_order_items_variant_id ON order_items(variant_id);
    END IF;
END $$;

-- 6. Add security audit log table if it doesn't exist
CREATE TABLE IF NOT EXISTS security_audit_log (
    log_id SERIAL PRIMARY KEY,
    event_type VARCHAR NOT NULL,
    event_data JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT,
    customer_id INTEGER REFERENCES customers(customer_id),
    severity VARCHAR DEFAULT 'info'
);

CREATE INDEX IF NOT EXISTS idx_security_audit_log_timestamp 
    ON security_audit_log(timestamp);

CREATE INDEX IF NOT EXISTS idx_security_audit_log_event_type 
    ON security_audit_log(event_type);

-- 7. Display current schema for verification
DO $$
BEGIN
    RAISE NOTICE 'Schema fixes completed. Current inventory_reservations columns:';
END $$;

SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'inventory_reservations' 
ORDER BY ordinal_position;

-- Verification: Check orders table structure
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'orders' 
    AND column_name IN ('user_id', 'salesman_comission', 'order_date', 'idempotency_key')
ORDER BY ordinal_position; 