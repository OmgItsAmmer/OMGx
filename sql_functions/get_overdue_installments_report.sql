-- Create a function to generate overdue installments report
CREATE OR REPLACE FUNCTION get_overdue_installments_report()
RETURNS SETOF json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT json_build_object(
    'installment_plan_id', COALESCE(ip.installment_plans_id, 0),
    'order_id', COALESCE(ip.order_id, 0),
    'customer_name', COALESCE(CONCAT(c.first_name, ' ', c.last_name), ''),
    'customer_contact', COALESCE(c.phone_number, ''),
    'due_date', COALESCE(inst.due_date, CURRENT_DATE::text),
    'amount_due', COALESCE(inst.amount_due, '0.00'),
    'sequence_no', COALESCE(inst.sequence_no, 0),
    'total_amount', COALESCE(ip.total_amount, '0.00'),
    'salesman_name', COALESCE(CONCAT(s.first_name, ' ', s.last_name), ''),
    'days_overdue', COALESCE(
      EXTRACT(DAY FROM (CURRENT_DATE::date - inst.due_date::date))::integer, 
      0
    ),
    'status', COALESCE(inst.status, 'Unpaid')
  )
  FROM installment_payments inst
  LEFT JOIN installment_plans ip ON inst.installment_plan_id = ip.installment_plans_id
  LEFT JOIN orders o ON ip.order_id = o.order_id
  LEFT JOIN customers c ON o.customer_id = c.customer_id
  LEFT JOIN salesman s ON o.salesman_id = s.salesman_id
  WHERE inst.due_date IS NOT NULL
    AND inst.due_date::date < CURRENT_DATE
    AND (inst.is_paid IS NULL OR inst.is_paid = false)
    AND (inst.status IS NULL OR inst.status != 'paid')
  ORDER BY inst.due_date ASC, c.first_name ASC;
END;
$$;

-- Alternative version with no filtering for testing
CREATE OR REPLACE FUNCTION get_overdue_installments_report_all()
RETURNS SETOF json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT json_build_object(
    'installment_plan_id', COALESCE(ip.installment_plans_id, 0),
    'order_id', COALESCE(ip.order_id, 0),
    'customer_name', COALESCE(CONCAT(c.first_name, ' ', c.last_name), ''),
    'customer_contact', COALESCE(c.phone_number, ''),
    'due_date', COALESCE(inst.due_date, CURRENT_DATE::text),
    'amount_due', COALESCE(inst.amount_due, '0.00'),
    'sequence_no', COALESCE(inst.sequence_no, 0),
    'total_amount', COALESCE(ip.total_amount, '0.00'),
    'salesman_name', COALESCE(CONCAT(s.first_name, ' ', s.last_name), ''),
    'days_overdue', 0,
    'status', COALESCE(inst.status, 'Unpaid')
  )
  FROM installment_payments inst
  LEFT JOIN installment_plans ip ON inst.installment_plan_id = ip.installment_plans_id
  LEFT JOIN orders o ON ip.order_id = o.order_id
  LEFT JOIN customers c ON o.customer_id = c.customer_id
  LEFT JOIN salesman s ON o.salesman_id = s.salesman_id
  WHERE inst.due_date IS NOT NULL
  ORDER BY inst.due_date ASC
  LIMIT 50;
END;
$$;

-- Grant appropriate permissions
GRANT EXECUTE ON FUNCTION get_overdue_installments_report() TO authenticated;
GRANT EXECUTE ON FUNCTION get_overdue_installments_report() TO service_role;
GRANT EXECUTE ON FUNCTION get_overdue_installments_report() TO anon;

GRANT EXECUTE ON FUNCTION get_overdue_installments_report_all() TO authenticated;
GRANT EXECUTE ON FUNCTION get_overdue_installments_report_all() TO service_role;
GRANT EXECUTE ON FUNCTION get_overdue_installments_report_all() TO anon; 