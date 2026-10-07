-- 1. Monthly revenue
WITH order_totals AS (
    SELECT
        o.order_id,
        o.order_date,
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ) AS order_revenue
    FROM orders AS o
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    JOIN products AS p
        ON p.product_id = oi.product_id
    WHERE o.status = 'Completed'
    GROUP BY o.order_id, o.order_date
)
SELECT
    DATE_TRUNC('month', order_date)::date AS month,
    COUNT(*) AS completed_orders,
    ROUND(SUM(order_revenue), 2) AS revenue,
    ROUND(AVG(order_revenue), 2) AS average_order_value
FROM order_totals
GROUP BY month
ORDER BY month;


-- 2. Category performance
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ),
        2
    ) AS revenue
FROM orders AS o
JOIN order_items AS oi
    ON oi.order_id = o.order_id
JOIN products AS p
    ON p.product_id = oi.product_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;


-- 3. Regional performance
WITH customer_order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.region,
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ) AS order_revenue
    FROM orders AS o
    JOIN customers AS c
        ON c.customer_id = o.customer_id
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    JOIN products AS p
        ON p.product_id = oi.product_id
    WHERE o.status = 'Completed'
    GROUP BY o.order_id, o.customer_id, c.region
)
SELECT
    region,
    COUNT(DISTINCT customer_id) AS active_customers,
    COUNT(*) AS completed_orders,
    ROUND(SUM(order_revenue), 2) AS revenue,
    ROUND(SUM(order_revenue) / COUNT(DISTINCT customer_id), 2)
        AS revenue_per_customer
FROM customer_order_totals
GROUP BY region
ORDER BY revenue DESC;


-- 4. Discount usage
SELECT
    CASE
        WHEN oi.discount_pct = 0 THEN 'No discount'
        ELSE 'Discounted'
    END AS discount_group,
    COUNT(*) AS line_items,
    SUM(oi.quantity) AS units,
    ROUND(
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ),
        2
    ) AS revenue
FROM orders AS o
JOIN order_items AS oi
    ON oi.order_id = o.order_id
JOIN products AS p
    ON p.product_id = oi.product_id
WHERE o.status = 'Completed'
GROUP BY discount_group
ORDER BY discount_group;


-- 5. Highest-value customers
WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.region,
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ) AS order_revenue
    FROM orders AS o
    JOIN customers AS c
        ON c.customer_id = o.customer_id
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    JOIN products AS p
        ON p.product_id = oi.product_id
    WHERE o.status = 'Completed'
    GROUP BY o.order_id, o.customer_id, c.region
)
SELECT
    customer_id,
    region,
    COUNT(*) AS completed_orders,
    ROUND(SUM(order_revenue), 2) AS total_revenue
FROM order_totals
GROUP BY customer_id, region
ORDER BY total_revenue DESC
LIMIT 10;


-- 6. Order outcome by channel
SELECT
    channel,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Completed') / COUNT(*),
        1
    ) AS completed_pct,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Returned') / COUNT(*),
        1
    ) AS returned_pct,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Cancelled') / COUNT(*),
        1
    ) AS cancelled_pct
FROM orders
GROUP BY channel
ORDER BY channel;
