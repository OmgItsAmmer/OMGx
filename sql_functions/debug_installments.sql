-- Debug function to check installment payments table structure and data
CREATE OR REPLACE FUNCTION debug_installment_payments()
RETURNS SETOF json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT json_build_object(
    'installment_plan_id', inst.installment_plan_id,
    'sequence_no', inst.sequence_no,
    'due_date', inst.due_date,
    'amount_due', inst.amount_due,
    'is_paid', inst.is_paid,
    'status', inst.status,
    'paid_date', inst.paid_date,
    'paid_amount', inst.paid_amount
  )
  FROM installment_payments inst
  ORDER BY inst.due_date DESC
  LIMIT 10;
END;
$$;

-- Debug function to check installment plans
CREATE OR REPLACE FUNCTION debug_installment_plans()
RETURNS SETOF json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT json_build_object(
    'installment_plans_id', ip.installment_plans_id,
    'order_id', ip.order_id,
    'total_amount', ip.total_amount,
    'down_payment', ip.down_payment,
    'number_of_installments', ip.number_of_installments
  )
  FROM installment_plans ip
  ORDER BY ip.installment_plans_id DESC
  LIMIT 10;
END;
$$;

-- Simplified upcoming installments (no complex filtering)
CREATE OR REPLACE FUNCTION simple_upcoming_installments()
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
    'due_date', COALESCE(inst.due_date, ''),
    'amount_due', COALESCE(inst.amount_due, '0.00'),
    'sequence_no', COALESCE(inst.sequence_no, 0),
    'is_paid', COALESCE(inst.is_paid, false),
    'status', COALESCE(inst.status, 'unknown')
  )
  FROM installment_payments inst
  LEFT JOIN installment_plans ip ON inst.installment_plan_id = ip.installment_plans_id
  LEFT JOIN orders o ON ip.order_id = o.order_id
  LEFT JOIN customers c ON o.customer_id = c.customer_id
  WHERE inst.due_date IS NOT NULL
  ORDER BY inst.due_date ASC
  LIMIT 20;
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION debug_installment_payments() TO authenticated;
GRANT EXECUTE ON FUNCTION debug_installment_payments() TO service_role;
GRANT EXECUTE ON FUNCTION debug_installment_payments() TO anon;

GRANT EXECUTE ON FUNCTION debug_installment_plans() TO authenticated;
GRANT EXECUTE ON FUNCTION debug_installment_plans() TO service_role;
GRANT EXECUTE ON FUNCTION debug_installment_plans() TO anon;

GRANT EXECUTE ON FUNCTION simple_upcoming_installments() TO authenticated;
GRANT EXECUTE ON FUNCTION simple_upcoming_installments() TO service_role;
GRANT EXECUTE ON FUNCTION simple_upcoming_installments() TO anon; 