CREATE OR REPLACE FUNCTION apply_refund_effect_on_approval()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    -- Add refund effect logic here (e.g., revenue adjustment)
    RAISE NOTICE 'Refund % approved.', NEW.id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_apply_refund_on_approval
AFTER UPDATE ON refunds
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION apply_refund_effect_on_approval();
