INSERT INTO customers (customer_id, signup_date, region)
SELECT
    customer_id,
    DATE '2024-01-01' + ((customer_id * 7) % 365),
    CASE customer_id % 4
        WHEN 0 THEN 'Midwest'
        WHEN 1 THEN 'Northeast'
        WHEN 2 THEN 'South'
        ELSE 'West'
    END
FROM generate_series(1, 120) AS s(customer_id);

INSERT INTO products (product_id, product_name, category, unit_price)
VALUES
    (1, 'Wireless Headphones', 'Electronics', 129.00),
    (2, 'Smart Speaker', 'Electronics', 99.00),
    (3, 'Fitness Tracker', 'Electronics', 149.00),
    (4, 'Desk Lamp', 'Home', 45.00),
    (5, 'Throw Blanket', 'Home', 55.00),
    (6, 'Storage Set', 'Home', 39.00),
    (7, 'Running Shoes', 'Apparel', 89.00),
    (8, 'Everyday Hoodie', 'Apparel', 64.00),
    (9, 'Performance Tee', 'Apparel', 34.00),
    (10, 'Travel Mug', 'Lifestyle', 28.00),
    (11, 'Notebook Set', 'Lifestyle', 18.00),
    (12, 'Backpack', 'Lifestyle', 72.00);

INSERT INTO orders (order_id, customer_id, order_date, status, channel)
SELECT
    order_id,
    ((order_id * 17) % 120) + 1,
    DATE '2025-01-01' + ((order_id * 13) % 365),
    CASE
        WHEN order_id % 17 = 0 THEN 'Returned'
        WHEN order_id % 11 = 0 THEN 'Cancelled'
        ELSE 'Completed'
    END,
    CASE order_id % 3
        WHEN 0 THEN 'Web'
        WHEN 1 THEN 'Mobile'
        ELSE 'Store'
    END
FROM generate_series(1, 900) AS s(order_id);

INSERT INTO order_items (
    order_id,
    line_number,
    product_id,
    quantity,
    discount_pct
)
SELECT
    o.order_id,
    line_number,
    ((o.order_id * 5 + line_number * 3) % 12) + 1,
    1 + ((o.order_id + line_number) % 3),
    CASE
        WHEN (o.order_id + line_number) % 10 = 0 THEN 20
        WHEN (o.order_id + line_number) % 6 = 0 THEN 10
        WHEN (o.order_id + line_number) % 4 = 0 THEN 5
        ELSE 0
    END
FROM orders AS o
CROSS JOIN LATERAL generate_series(
    1,
    1 + (o.order_id % 3)
) AS g(line_number);
