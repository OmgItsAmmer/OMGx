-- Create inventory_reservations table for admin checkout system
-- This table only uses variant_id because every product must have at least one variant
-- in this e-commerce/POS system

CREATE TABLE IF NOT EXISTS inventory_reservations (
    reservation_id VARCHAR NOT NULL,
    variant_id INTEGER NOT NULL REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_inventory_reservations_expiry 
    ON inventory_reservations(expires_at);

CREATE INDEX IF NOT EXISTS idx_inventory_reservations_reservation_id 
    ON inventory_reservations(reservation_id);

CREATE INDEX IF NOT EXISTS idx_inventory_reservations_variant_id 
    ON inventory_reservations(variant_id);

-- Add comments for clarity
COMMENT ON TABLE inventory_reservations IS 'Temporary inventory reservations for admin checkout system';
COMMENT ON COLUMN inventory_reservations.reservation_id IS 'Unique identifier for a reservation session';
COMMENT ON COLUMN inventory_reservations.variant_id IS 'Product variant being reserved (every product must have variants)';
COMMENT ON COLUMN inventory_reservations.quantity IS 'Number of items reserved';
COMMENT ON COLUMN inventory_reservations.expires_at IS 'When this reservation expires (default 10 minutes)';

-- Add constraint to ensure reservations don't exceed available stock
-- This will be enforced by the application logic and SQL functions

-- Grant necessary permissions (adjust as needed for your setup)
-- GRANT SELECT, INSERT, UPDATE, DELETE ON inventory_reservations TO authenticated; 