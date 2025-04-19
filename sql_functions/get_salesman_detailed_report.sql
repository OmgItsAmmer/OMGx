-- Create a function to generate detailed salesman report
CREATE OR REPLACE FUNCTION get_salesman_detailed_report(
  start_date DATE,
  end_date DATE,
  salesman_id INTEGER
)
RETURNS SETOF json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT json_build_object(
    'order_id', COALESCE(o.order_id, 0),
    'salesman_name', COALESCE(CONCAT(s.first_name, ' ', s.last_name), ''),
    'customer_name', COALESCE(CONCAT(c.first_name, ' ', c.last_name), ''),
    'order_date', COALESCE(o.order_date, CURRENT_DATE),
    'sale_price', COALESCE(o.total_price, 0),
    'order_type', COALESCE(o.saletype, ''),
    'commission_percent', COALESCE(s.comission, 0),
    'commission_in_rs', COALESCE(o.total_price, 0) * COALESCE(s.comission, 0) / 100
  )
  FROM orders o
  LEFT JOIN salesman s ON o.salesman_id = s.salesman_id
  LEFT JOIN customers c ON o.customer_id = c.customer_id
  WHERE o.salesman_id = $3
    AND o.order_date BETWEEN $1 AND $2
  ORDER BY o.order_date DESC;
END;
$$;

-- Grant appropriate permissions
GRANT EXECUTE ON FUNCTION get_salesman_detailed_report(DATE, DATE, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION get_salesman_detailed_report(DATE, DATE, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION get_salesman_detailed_report(DATE, DATE, INTEGER) TO anon; 