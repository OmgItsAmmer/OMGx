-- Function to validate admin checkout cart items
CREATE OR REPLACE FUNCTION public.validate_admin_cart_stock(
    p_cart_items JSONB
) RETURNS TABLE (
    is_valid BOOLEAN,
    error_message TEXT,
    variant_id INTEGER
) LANGUAGE plpgsql
AS $function$
DECLARE
    item JSONB;
    v_variant_stock INTEGER;
    v_quantity INTEGER;
BEGIN
    -- Loop through each cart item (all products must have variants)
    FOR item IN SELECT * FROM jsonb_array_elements(p_cart_items)
    LOOP
        v_quantity := (item->>'quantity')::INTEGER;
        
        -- Check variant stock (every product must have at least one variant)
        SELECT stock INTO v_variant_stock 
        FROM product_variants 
        WHERE variant_id = (item->>'variantId')::INTEGER 
        AND is_visible = true;
        
        IF v_variant_stock IS NULL THEN
            RETURN QUERY SELECT false, 'Product variant not found or not visible', 
                (item->>'variantId')::INTEGER;
            RETURN;
        END IF;
        
        IF v_variant_stock < v_quantity THEN
            RETURN QUERY SELECT false, 
                format('Insufficient stock for variant. Available: %s, Requested: %s', 
                       v_variant_stock, v_quantity),
                (item->>'variantId')::INTEGER;
            RETURN;
        END IF;
    END LOOP;
    
    -- If we get here, all validations passed
    RETURN QUERY SELECT true, 'Stock validation passed'::TEXT, NULL::INTEGER;
END;
$function$;

-- Function to apply stock changes for order updates (only variants)
CREATE OR REPLACE FUNCTION public.apply_admin_stock_changes(
    p_variant_changes JSONB
) RETURNS BOOLEAN LANGUAGE plpgsql
AS $function$
DECLARE
    variant_entry RECORD;
BEGIN
    -- Apply variant stock changes (since every product must have variants)
    FOR variant_entry IN 
        SELECT key::INTEGER as variant_id, value::INTEGER as quantity_change
        FROM jsonb_each_text(p_variant_changes)
        WHERE value::INTEGER != 0
    LOOP
        -- For variants reducing stock, use the existing function
        IF variant_entry.quantity_change < 0 THEN
            PERFORM reduce_variant_stock(
                variant_entry.variant_id, 
                ABS(variant_entry.quantity_change)
            );
        ELSE
            -- For increasing stock, update directly
            UPDATE product_variants 
            SET stock = stock + variant_entry.quantity_change,
                updated_at = NOW()
            WHERE variant_id = variant_entry.variant_id;
        END IF;
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$function$;

-- Function to calculate order totals server-side
CREATE OR REPLACE FUNCTION public.calculate_admin_order_totals(
    p_cart_items JSONB,
    p_salesman_comission INTEGER DEFAULT 0,
    p_discount_percent NUMERIC DEFAULT 0,
    p_payment_method TEXT DEFAULT 'cash'
) RETURNS TABLE (
    subtotal NUMERIC,
    tax NUMERIC,
    shipping NUMERIC,
    salesman_comission INTEGER,
    discount NUMERIC,
    total NUMERIC,
    buying_price_total NUMERIC
) LANGUAGE plpgsql
AS $function$
DECLARE
    item JSONB;
    v_subtotal NUMERIC := 0;
    v_buying_price_total NUMERIC := 0;
    v_tax NUMERIC := 0;
    v_shipping NUMERIC := 0;
    v_salesman_comission INTEGER := 0;
    v_discount NUMERIC := 0;
    v_total NUMERIC := 0;
    shop_settings RECORD;
BEGIN
    -- Calculate subtotal and buying price total
    FOR item IN SELECT * FROM jsonb_array_elements(p_cart_items)
    LOOP
        v_subtotal := v_subtotal + ((item->>'sellPrice')::NUMERIC * (item->>'quantity')::NUMERIC);
        
        -- Calculate buying price (all products have variants, so multiply by quantity)
        v_buying_price_total := v_buying_price_total + 
            ((item->>'buyPrice')::NUMERIC * (item->>'quantity')::NUMERIC);
    END LOOP;
    
    -- Get shop settings
    SELECT taxrate, shipping_price INTO shop_settings
    FROM shop
    LIMIT 1;
    
    v_tax := COALESCE(shop_settings.taxrate, 0);
    
    -- For POS orders, shipping is always 0 (customer pickup)
    v_shipping := 0;
    
    -- Calculate salesman commission
    v_salesman_comission := ROUND((v_subtotal * p_salesman_comission) / 100);
    
    -- Calculate discount
    v_discount := (v_subtotal * p_discount_percent) / 100;
    
    -- Apply discount to subtotal
    v_subtotal := v_subtotal - v_discount;
    
    -- Calculate total
    v_total := v_subtotal + v_tax + v_shipping + v_salesman_comission;
    
    RETURN QUERY SELECT v_subtotal, v_tax, v_shipping, v_salesman_comission, 
                        v_discount, v_total, v_buying_price_total;
END;
$function$;

-- Function to safely reserve inventory with expiration
CREATE OR REPLACE FUNCTION public.reserve_admin_inventory(
    p_reservation_id TEXT,
    p_cart_items JSONB,
    p_expiry_minutes INTEGER DEFAULT 10
) RETURNS BOOLEAN LANGUAGE plpgsql
AS $function$
DECLARE
    item JSONB;
    v_expiry_time TIMESTAMP;
BEGIN
    v_expiry_time := NOW() + INTERVAL '1 minute' * p_expiry_minutes;
    
    -- Clean up any expired reservations first
    DELETE FROM inventory_reservations 
    WHERE expires_at < NOW();
    
    -- Reserve each item in the cart (only variant_id since every product must have variants)
    FOR item IN SELECT * FROM jsonb_array_elements(p_cart_items)
    LOOP
        INSERT INTO inventory_reservations (
            reservation_id,
            variant_id,
            quantity,
            expires_at
        ) VALUES (
            p_reservation_id,
            (item->>'variantId')::INTEGER,
            (item->>'quantity')::INTEGER,
            v_expiry_time
        );
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        -- Clean up any partial reservations
        DELETE FROM inventory_reservations 
        WHERE reservation_id = p_reservation_id;
        RAISE;
END;
$function$;

-- Function to update order with comprehensive validation
CREATE OR REPLACE FUNCTION public.update_admin_order_comprehensive(
    p_order_id INTEGER,
    p_order_data JSONB,
    p_order_items JSONB
) RETURNS BOOLEAN LANGUAGE plpgsql
AS $function$
DECLARE
    v_order_exists BOOLEAN := FALSE;
BEGIN
    -- Check if order exists
    SELECT EXISTS(SELECT 1 FROM orders WHERE order_id = p_order_id) INTO v_order_exists;
    
    IF NOT v_order_exists THEN
        RAISE EXCEPTION 'Order with ID % does not exist', p_order_id;
    END IF;
    
    -- Update the order
    UPDATE orders SET
        order_date = COALESCE((p_order_data->>'order_date')::DATE, order_date), -- DATE type, not TIMESTAMP
        sub_total = COALESCE((p_order_data->>'sub_total')::NUMERIC, sub_total),
        buying_price = COALESCE((p_order_data->>'buying_price')::NUMERIC, buying_price),
        status = COALESCE(p_order_data->>'status', status),
        saletype = COALESCE(p_order_data->>'saletype', saletype),
        address_id = COALESCE((p_order_data->>'address_id')::INTEGER, address_id),
        customer_id = COALESCE((p_order_data->>'customer_id')::INTEGER, customer_id),
        paid_amount = COALESCE((p_order_data->>'paid_amount')::NUMERIC, paid_amount),
        discount = COALESCE((p_order_data->>'discount')::NUMERIC, discount),
        tax = COALESCE((p_order_data->>'tax')::NUMERIC, tax),
        shipping_fee = COALESCE((p_order_data->>'shipping_fee')::NUMERIC, shipping_fee),
        salesman_comission = COALESCE((p_order_data->>'salesman_comission')::INTEGER, salesman_comission), -- INTEGER type
        payment_method = COALESCE(p_order_data->>'payment_method', payment_method),
        salesman_id = COALESCE((p_order_data->>'salesman_id')::INTEGER, salesman_id)
    WHERE order_id = p_order_id;
    
    -- Delete existing order items
    DELETE FROM order_items WHERE order_id = p_order_id;
    
    -- Insert new order items
    INSERT INTO order_items (
        order_id,
        product_id,
        quantity,
        price,
        unit,
        total_buy_price,
        variant_id
    )
    SELECT 
        p_order_id,
        (item->>'product_id')::INTEGER,
        (item->>'quantity')::INTEGER,
        (item->>'price')::NUMERIC,
        item->>'unit',
        (item->>'total_buy_price')::NUMERIC,
        (item->>'variant_id')::INTEGER -- Required since every product must have variants
    FROM jsonb_array_elements(p_order_items) item;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$function$;

-- Function to get current available stock (considering reservations)
CREATE OR REPLACE FUNCTION public.get_available_stock_for_admin(
    p_variant_id INTEGER
) RETURNS INTEGER LANGUAGE plpgsql
AS $function$
DECLARE
    v_total_stock INTEGER;
    v_reserved_stock INTEGER := 0;
BEGIN
    -- Clean up expired reservations first
    DELETE FROM inventory_reservations WHERE expires_at < NOW();
    
    -- Get variant stock (since every product must have variants)
    SELECT stock INTO v_total_stock
    FROM product_variants
    WHERE variant_id = p_variant_id AND is_visible = true;
    
    -- Get reserved stock for this variant
    SELECT COALESCE(SUM(quantity), 0) INTO v_reserved_stock
    FROM inventory_reservations
    WHERE variant_id = p_variant_id AND expires_at > NOW();
    
    RETURN GREATEST(0, COALESCE(v_total_stock, 0) - v_reserved_stock);
END;
$function$; 