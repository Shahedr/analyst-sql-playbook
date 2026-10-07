DO $$
BEGIN
    IF (SELECT COUNT(*) FROM customers) <> 120 THEN
        RAISE EXCEPTION 'Expected 120 customers';
    END IF;

    IF (SELECT COUNT(*) FROM products) <> 12 THEN
        RAISE EXCEPTION 'Expected 12 products';
    END IF;

    IF (SELECT COUNT(*) FROM orders) <> 900 THEN
        RAISE EXCEPTION 'Expected 900 orders';
    END IF;

    IF (SELECT COUNT(*) FROM order_items) <> 1800 THEN
        RAISE EXCEPTION 'Expected 1800 order items';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM orders
        WHERE order_date < DATE '2025-01-01'
           OR order_date > DATE '2025-12-31'
    ) THEN
        RAISE EXCEPTION 'Order dates fall outside 2025';
    END IF;
END
$$;
