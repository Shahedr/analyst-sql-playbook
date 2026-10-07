-- 7. Product ranking within category
WITH product_revenue AS (
    SELECT
        p.category,
        p.product_name,
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ) AS revenue
    FROM orders AS o
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    JOIN products AS p
        ON p.product_id = oi.product_id
    WHERE o.status = 'Completed'
    GROUP BY p.category, p.product_name
)
SELECT
    category,
    product_name,
    ROUND(revenue, 2) AS revenue,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS category_rank
FROM product_revenue
ORDER BY category, category_rank, product_name;


-- 8. Customer spend quartiles
WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ) AS total_spend
    FROM orders AS o
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    JOIN products AS p
        ON p.product_id = oi.product_id
    WHERE o.status = 'Completed'
    GROUP BY o.customer_id
),
ranked AS (
    SELECT
        customer_id,
        total_spend,
        NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
    FROM customer_spend
)
SELECT
    spend_quartile,
    COUNT(*) AS customers,
    ROUND(AVG(total_spend), 2) AS average_customer_spend
FROM ranked
GROUP BY spend_quartile
ORDER BY spend_quartile;


-- 9. Month-over-month revenue growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS month,
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ) AS revenue
    FROM orders AS o
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    JOIN products AS p
        ON p.product_id = oi.product_id
    WHERE o.status = 'Completed'
    GROUP BY month
),
with_previous AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(revenue - previous_month_revenue, 2) AS dollar_change,
    ROUND(
        100.0 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS percent_change
FROM with_previous
ORDER BY month;


-- 10. Rolling three-month revenue
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS month,
        SUM(
            p.unit_price
            * oi.quantity
            * (1 - oi.discount_pct / 100.0)
        ) AS revenue
    FROM orders AS o
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    JOIN products AS p
        ON p.product_id = oi.product_id
    WHERE o.status = 'Completed'
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_3_month_revenue
FROM monthly_revenue
ORDER BY month;
