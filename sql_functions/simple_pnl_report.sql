CREATE OR REPLACE FUNCTION get_simple_pnl_report(
    start_date DATE,
    end_date DATE
)
RETURNS TABLE (
    total_revenue NUMERIC,
    total_cogs NUMERIC,
    total_expenses NUMERIC,
    gross_profit NUMERIC,
    net_profit NUMERIC,
    profit_margin NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH 
    -- Get non-cancelled orders in date range
    valid_orders AS (
        SELECT 
            o.order_id, 
            o.sub_total,
            o.order_date
        FROM orders o
        WHERE o.order_date::DATE BETWEEN start_date AND end_date
        AND o.status != 'cancelled'
    ),
    
    -- Calculate total revenue from valid orders
    revenue_summary AS (
        SELECT 
            COALESCE(SUM(vo.sub_total), 0.0) as total_revenue
        FROM valid_orders vo
    ),
    
    -- Calculate total COGS from order items of valid orders
    cogs_summary AS (
        SELECT 
            COALESCE(SUM(oi.total_buy_price * oi.quantity), 0.0) as total_cogs
        FROM valid_orders vo
        INNER JOIN order_items oi ON vo.order_id = oi.order_id
        WHERE oi.total_buy_price IS NOT NULL
    ),
    
    -- Calculate total expenses in the date range
    expenses_summary AS (
        SELECT 
            COALESCE(SUM(e.amount), 0.0) as total_expenses
        FROM expenses e
        WHERE e.created_at::DATE BETWEEN start_date AND end_date
    ),
    
    -- Calculate profit metrics
    profit_calculation AS (
        SELECT 
            rs.total_revenue,
            cs.total_cogs,
            es.total_expenses,
            (rs.total_revenue - cs.total_cogs) as gross_profit,
            (rs.total_revenue - cs.total_cogs - es.total_expenses) as net_profit,
            CASE 
                WHEN rs.total_revenue > 0 THEN 
                    ROUND(((rs.total_revenue - cs.total_cogs - es.total_expenses) / rs.total_revenue * 100), 2)
                ELSE 0.0
            END as profit_margin
        FROM revenue_summary rs
        CROSS JOIN cogs_summary cs
        CROSS JOIN expenses_summary es
    )
    
    SELECT 
        COALESCE(pc.total_revenue, 0.0) as total_revenue,
        COALESCE(pc.total_cogs, 0.0) as total_cogs,
        COALESCE(pc.total_expenses, 0.0) as total_expenses,
        COALESCE(pc.gross_profit, 0.0) as gross_profit,
        COALESCE(pc.net_profit, 0.0) as net_profit,
        COALESCE(pc.profit_margin, 0.0) as profit_margin
    FROM profit_calculation pc;
END;
$$ LANGUAGE plpgsql;