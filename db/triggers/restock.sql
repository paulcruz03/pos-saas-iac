CREATE OR REPLACE FUNCTION apply_product_stock_on_approval()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    UPDATE products
    SET stock = stock + NEW.quantity
    WHERE id = NEW.product_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_apply_product_stock_on_approval
AFTER UPDATE ON product_stock
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION apply_product_stock_on_approval();
