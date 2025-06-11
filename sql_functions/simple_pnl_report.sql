

----- working sql function
------
CREATE OR REPLACE FUNCTION get_simple_pnl_report(
  start_date timestamp with time zone,
  end_date timestamp with time zone
)
RETURNS TABLE (
  report_period text,
  total_sales numeric,
  total_cogs numeric,
  total_profit numeric,
  profit_margin_percent numeric,
  total_orders bigint,
  total_installments_paid numeric,
  total_installments_pending numeric
) 
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  WITH 
  -- Get non-cancelled orders in date range
  valid_orders AS (
    SELECT o.order_id, o.total_price, o.status
    FROM orders o
    WHERE o.order_date BETWEEN start_date AND end_date
    AND o.status != 'cancelled'
  ),
  
  -- Calculate COGS from order items
  order_cogs AS (
    SELECT 
      oi.order_id,
      SUM(oi.total_buy_price::numeric) as total_cost
    FROM order_items oi
    JOIN valid_orders vo ON oi.order_id = vo.order_id
    GROUP BY oi.order_id
  ),
  
  -- Calculate installment payments
  installment_payments AS (
    SELECT
      ip.installment_plan_id,
      SUM(CASE WHEN ip.is_paid THEN ip.paid_amount::numeric ELSE 0 END) as paid_total,
      SUM(CASE WHEN NOT ip.is_paid THEN ip.amount_due::numeric ELSE 0 END) as pending_total
    FROM installment_payments ip
    JOIN installment_plans ipl ON ip.installment_plan_id = ipl.installment_plans_id
    JOIN valid_orders vo ON ipl.order_id = vo.order_id
    WHERE ip.due_date BETWEEN start_date AND end_date
    GROUP BY ip.installment_plan_id
  )
  
  SELECT
    'From ' || TO_CHAR(start_date, 'YYYY-MM-DD') || ' to ' || TO_CHAR(end_date, 'YYYY-MM-DD') AS report_period,
    COALESCE(SUM(vo.total_price::numeric), 0) AS total_sales,
    COALESCE(SUM(oc.total_cost), 0) AS total_cogs,
    COALESCE(SUM(vo.total_price::numeric) - SUM(oc.total_cost), 0) AS total_profit,
    CASE 
      WHEN COALESCE(SUM(vo.total_price::numeric), 0) = 0 THEN 0
      ELSE ROUND((SUM(vo.total_price::numeric) - SUM(oc.total_cost)) / SUM(vo.total_price::numeric) * 100, 2)
    END AS profit_margin_percent,
    COUNT(DISTINCT vo.order_id) AS total_orders,
    COALESCE(SUM(ip.paid_total), 0) AS total_installments_paid,
    COALESCE(SUM(ip.pending_total), 0) AS total_installments_pending
  FROM 
    valid_orders vo
    LEFT JOIN order_cogs oc ON vo.order_id = oc.order_id
    LEFT JOIN installment_plans ipl ON vo.order_id = ipl.order_id
    LEFT JOIN installment_payments ip ON ipl.installment_plans_id = ip.installment_plan_id;
END;
$$;