-- Drop existing tables if they exist (to undo previous setup)
DROP TABLE IF EXISTS purchase_items CASCADE;
DROP TABLE IF EXISTS purchases CASCADE;

-- Drop any existing triggers and functions
DROP TRIGGER IF EXISTS update_purchases_updated_at ON purchases;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- Create purchases table with reference to public.users\
CREATE TABLE purchases (
    purchase_id BIGSERIAL PRIMARY KEY,
    purchase_date DATE NOT NULL DEFAULT CURRENT_DATE,
    sub_total DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'received', 'cancelled')),
    address_id BIGINT REFERENCES addresses(address_id),
    user_id INTEGER REFERENCES public.users(user_id), -- Changed to reference public.users
    paid_amount DECIMAL(15, 2) DEFAULT 0.00,
    vendor_id BIGINT REFERENCES vendors(vendor_id),
    discount DECIMAL(15, 2) DEFAULT 0.00,
    tax DECIMAL(15, 2) DEFAULT 0.00,
    shipping_fee DECIMAL(15, 2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create purchase_items table
CREATE TABLE purchase_items (
    purchase_item_id BIGSERIAL PRIMARY KEY,
    purchase_id BIGINT NOT NULL REFERENCES purchases(purchase_id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(product_id),
    variant_id BIGINT REFERENCES product_variants(variant_id),
    price DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_purchases_vendor_id ON purchases(vendor_id);
CREATE INDEX idx_purchases_user_id ON purchases(user_id);
CREATE INDEX idx_purchases_status ON purchases(status);
CREATE INDEX idx_purchases_date ON purchases(purchase_date);
CREATE INDEX idx_purchase_items_purchase_id ON purchase_items(purchase_id);
CREATE INDEX idx_purchase_items_product_id ON purchase_items(product_id);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_purchases_updated_at BEFORE UPDATE
    ON purchases FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create RLS (Row Level Security) policies
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_items ENABLE ROW LEVEL SECURITY;

-- RLS policies for purchases table
CREATE POLICY "Enable read access for all users" ON purchases FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users only" ON purchases FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users only" ON purchases FOR UPDATE USING (true);
CREATE POLICY "Enable delete for authenticated users only" ON purchases FOR DELETE USING (true);

-- RLS policies for purchase_items table
CREATE POLICY "Enable read access for all users" ON purchase_items FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users only" ON purchase_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users only" ON purchase_items FOR UPDATE USING (true);
CREATE POLICY "Enable delete for authenticated users only" ON purchase_items FOR DELETE USING (true);

-- Optional: Add some sample data for testing (remove in production)
-- INSERT INTO purchases (sub_total, status, vendor_id, user_id) 
-- VALUES (1000.00, 'pending', 1, 1); 