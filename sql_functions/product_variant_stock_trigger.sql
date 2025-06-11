CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER AS $$
BEGIN
  -- Handle INSERT
  IF (TG_OP = 'INSERT') THEN
    IF (NEW.is_sold = false) THEN
      UPDATE products SET stock_quantity = stock_quantity + 1
      WHERE product_id = NEW.product_id;
    END IF;

  -- Handle DELETE
  ELSIF (TG_OP = 'DELETE') THEN
    IF (OLD.is_sold = false) THEN
      UPDATE products SET stock_quantity = stock_quantity - 1
      WHERE product_id = OLD.product_id;
    END IF;

  -- Handle UPDATE
  ELSIF (TG_OP = 'UPDATE') THEN
    -- Case: product_id changed
    IF (NEW.product_id IS DISTINCT FROM OLD.product_id) THEN
      -- Revert effect from old product
      IF (OLD.is_sold = false) THEN
        UPDATE products SET stock_quantity = stock_quantity - 1
        WHERE product_id = OLD.product_id;
      END IF;

      -- Apply effect on new product
      IF (NEW.is_sold = false) THEN
        UPDATE products SET stock_quantity = stock_quantity + 1
        WHERE product_id = NEW.product_id;
      END IF;

    -- Case: only is_sold changed
    ELSIF (NEW.is_sold IS DISTINCT FROM OLD.is_sold) THEN
      IF (OLD.is_sold = true AND NEW.is_sold = false) THEN
        UPDATE products SET stock_quantity = stock_quantity + 1
        WHERE product_id = NEW.product_id;
      ELSIF (OLD.is_sold = false AND NEW.is_sold = true) THEN
        UPDATE products SET stock_quantity = stock_quantity - 1
        WHERE product_id = NEW.product_id;
      END IF;
    END IF;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;


------------------------------------------------
CREATE TRIGGER trigger_update_product_stock
AFTER INSERT OR UPDATE OR DELETE ON product_variants
FOR EACH ROW
EXECUTE FUNCTION update_product_stock();
