-- ============================================================================
-- Account Book Table Creation Script for Supabase
-- ============================================================================
-- This script creates a comprehensive account book table to track incoming 
-- and outgoing payments for vendors, customers, and salesmen with proper 
-- constraints, indexes, and Row Level Security (RLS) policies.
-- ============================================================================

-- Drop existing table if it exists (for clean recreation)
DROP TABLE IF EXISTS public.account_book CASCADE;

-- Create the account_book table
CREATE TABLE public.account_book (
    -- Primary key
    account_book_id BIGSERIAL PRIMARY KEY,
    
    -- Entity information
    entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('customer', 'vendor', 'salesman')),
    entity_id BIGINT NOT NULL,
    entity_name VARCHAR(255) NOT NULL,
    
    -- Transaction information
    transaction_type VARCHAR(10) NOT NULL CHECK (transaction_type IN ('buy', 'sell')),
    amount DECIMAL(15, 2) NOT NULL CHECK (amount > 0),
    description TEXT NOT NULL,
    reference VARCHAR(100), -- Optional reference number
    
    -- Date information
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES for better query performance
-- ============================================================================

-- Index on entity type and id for fast filtering by entity
CREATE INDEX idx_account_book_entity ON public.account_book(entity_type, entity_id);

-- Index on transaction type for filtering incoming/outgoing payments
CREATE INDEX idx_account_book_transaction_type ON public.account_book(transaction_type);

-- Index on transaction date for date range queries
CREATE INDEX idx_account_book_transaction_date ON public.account_book(transaction_date DESC);

-- Composite index for common query patterns
CREATE INDEX idx_account_book_entity_date ON public.account_book(entity_type, transaction_date DESC);

-- Index on created_at for audit trails
CREATE INDEX idx_account_book_created_at ON public.account_book(created_at DESC);

-- Index for search functionality
CREATE INDEX idx_account_book_search ON public.account_book USING gin(
    to_tsvector('english', entity_name || ' ' || description || ' ' || COALESCE(reference, ''))
);

-- ============================================================================
-- TRIGGERS for automatic timestamp updates
-- ============================================================================

-- Create or replace function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at on row updates
CREATE TRIGGER update_account_book_updated_at 
    BEFORE UPDATE ON public.account_book 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on the table
ALTER TABLE public.account_book ENABLE ROW LEVEL SECURITY;

-- Policy to allow authenticated users to read all records
CREATE POLICY "Allow authenticated users to read account book entries" 
ON public.account_book 
FOR SELECT 
TO authenticated 
USING (true);

-- Policy to allow authenticated users to insert records
CREATE POLICY "Allow authenticated users to insert account book entries" 
ON public.account_book 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Policy to allow authenticated users to update records
CREATE POLICY "Allow authenticated users to update account book entries" 
ON public.account_book 
FOR UPDATE 
TO authenticated 
USING (true)
WITH CHECK (true);

-- Policy to allow authenticated users to delete records
CREATE POLICY "Allow authenticated users to delete account book entries" 
ON public.account_book 
FOR DELETE 
TO authenticated 
USING (true);

-- ============================================================================
-- HELPFUL VIEWS for common queries
-- ============================================================================

-- View for account summary by entity type
CREATE OR REPLACE VIEW account_book_summary AS
SELECT 
    entity_type,
    transaction_type,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount,
    AVG(amount) as average_amount,
    MIN(amount) as min_amount,
    MAX(amount) as max_amount,
    MIN(transaction_date) as earliest_transaction,
    MAX(transaction_date) as latest_transaction
FROM public.account_book
GROUP BY entity_type, transaction_type;

-- View for monthly transaction summary
CREATE OR REPLACE VIEW monthly_account_summary AS
SELECT 
    DATE_TRUNC('month', transaction_date) as month,
    entity_type,
    transaction_type,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount
FROM public.account_book
GROUP BY DATE_TRUNC('month', transaction_date), entity_type, transaction_type
ORDER BY month DESC, entity_type, transaction_type;

-- View for entity-wise balance
CREATE OR REPLACE VIEW entity_balance_summary AS
SELECT 
    entity_type,
    entity_id,
    entity_name,
    SUM(CASE WHEN transaction_type = 'buy' THEN amount ELSE 0 END) as total_incoming,
    SUM(CASE WHEN transaction_type = 'sell' THEN amount ELSE 0 END) as total_outgoing,
    SUM(CASE WHEN transaction_type = 'buy' THEN amount ELSE -amount END) as net_balance,
    COUNT(*) as total_transactions,
    MIN(transaction_date) as first_transaction,
    MAX(transaction_date) as last_transaction
FROM public.account_book
GROUP BY entity_type, entity_id, entity_name;

-- ============================================================================
-- SAMPLE DATA for testing (optional - remove in production)
-- ============================================================================

-- Uncomment the following INSERT statements to add sample data for testing

/*
INSERT INTO public.account_book (entity_type, entity_id, entity_name, transaction_type, amount, description, reference, transaction_date) VALUES
('customer', 1, 'John Doe', 'buy', 1500.00, 'Payment received for Order #1001', 'PAY-1001', '2024-01-15'),
('customer', 2, 'Jane Smith', 'buy', 2300.50, 'Payment for products purchased', 'INV-2001', '2024-01-16'),
('vendor', 1, 'ABC Suppliers', 'sell', 5000.00, 'Payment for inventory purchase', 'PO-3001', '2024-01-17'),
('salesman', 1, 'Mike Johnson', 'sell', 800.00, 'Commission payment for Q1', 'COM-4001', '2024-01-18'),
('customer', 1, 'John Doe', 'buy', 750.00, 'Partial payment for Order #1002', 'PAY-1002', '2024-01-19'),
('vendor', 2, 'XYZ Distributors', 'sell', 3200.00, 'Office supplies purchase', 'INV-5001', '2024-01-20');
*/

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Function to get total balance
CREATE OR REPLACE FUNCTION get_total_balance()
RETURNS TABLE(
    total_incoming DECIMAL(15,2),
    total_outgoing DECIMAL(15,2),
    net_balance DECIMAL(15,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(SUM(CASE WHEN transaction_type = 'buy' THEN amount ELSE 0 END), 0) as total_incoming,
        COALESCE(SUM(CASE WHEN transaction_type = 'sell' THEN amount ELSE 0 END), 0) as total_outgoing,
        COALESCE(SUM(CASE WHEN transaction_type = 'buy' THEN amount ELSE -amount END), 0) as net_balance
    FROM public.account_book;
END;
$$ LANGUAGE plpgsql;

-- Function to get entity balance
CREATE OR REPLACE FUNCTION get_entity_balance(
    p_entity_type VARCHAR(20),
    p_entity_id BIGINT
)
RETURNS TABLE(
    incoming DECIMAL(15,2),
    outgoing DECIMAL(15,2),
    balance DECIMAL(15,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(SUM(CASE WHEN transaction_type = 'buy' THEN amount ELSE 0 END), 0) as incoming,
        COALESCE(SUM(CASE WHEN transaction_type = 'sell' THEN amount ELSE 0 END), 0) as outgoing,
        COALESCE(SUM(CASE WHEN transaction_type = 'buy' THEN amount ELSE -amount END), 0) as balance
    FROM public.account_book
    WHERE entity_type = p_entity_type AND entity_id = p_entity_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- GRANTS for proper permissions
-- ============================================================================

-- Grant usage on the sequence to authenticated users
GRANT USAGE ON SEQUENCE public.account_book_account_book_id_seq TO authenticated;

-- Grant permissions on the table to authenticated users
GRANT SELECT, INSERT, UPDATE, DELETE ON public.account_book TO authenticated;

-- Grant permissions on views to authenticated users
GRANT SELECT ON account_book_summary TO authenticated;
GRANT SELECT ON monthly_account_summary TO authenticated;
GRANT SELECT ON entity_balance_summary TO authenticated;

-- ============================================================================
-- COMPLETION MESSAGE
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE 'Account Book table created successfully!';
    RAISE NOTICE 'Table: public.account_book';
    RAISE NOTICE 'Indexes: 6 indexes created for optimal performance';
    RAISE NOTICE 'Views: 3 summary views created';
    RAISE NOTICE 'Functions: 2 utility functions created';
    RAISE NOTICE 'RLS: Row Level Security enabled with policies';
    RAISE NOTICE 'Ready for use in Flutter Admin Dashboard!';
END $$; 