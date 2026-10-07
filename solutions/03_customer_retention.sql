-- 11. New vs. returning purchasers by month
WITH completed_orders AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        MIN(order_date) OVER (
            PARTITION BY customer_id
        ) AS first_purchase_date
    FROM orders
    WHERE status = 'Completed'
)
SELECT
    DATE_TRUNC('month', order_date)::date AS month,
    COUNT(DISTINCT customer_id) FILTER (
        WHERE DATE_TRUNC('month', order_date)
            = DATE_TRUNC('month', first_purchase_date)
    ) AS new_customers,
    COUNT(DISTINCT customer_id) FILTER (
        WHERE order_date > first_purchase_date
    ) AS returning_customers
FROM completed_orders
GROUP BY month
ORDER BY month;


-- 12. Repeat-customer rate
WITH purchase_counts AS (
    SELECT
        customer_id,
        COUNT(*) AS completed_orders
    FROM orders
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS purchasing_customers,
    COUNT(*) FILTER (WHERE completed_orders >= 2) AS repeat_customers,
    ROUND(
        100.0
        * COUNT(*) FILTER (WHERE completed_orders >= 2)
        / COUNT(*),
        1
    ) AS repeat_customer_pct
FROM purchase_counts;


-- 13. Days to second purchase
WITH ranked_orders AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS purchase_number
    FROM orders
    WHERE status = 'Completed'
),
first_second AS (
    SELECT
        customer_id,
        MIN(order_date) FILTER (
            WHERE purchase_number = 1
        ) AS first_purchase_date,
        MIN(order_date) FILTER (
            WHERE purchase_number = 2
        ) AS second_purchase_date
    FROM ranked_orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    first_purchase_date,
    second_purchase_date,
    second_purchase_date - first_purchase_date AS days_to_second_purchase
FROM first_second
WHERE second_purchase_date IS NOT NULL
ORDER BY days_to_second_purchase, customer_id;

WITH ranked_orders AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS purchase_number
    FROM orders
    WHERE status = 'Completed'
),
first_second AS (
    SELECT
        customer_id,
        MIN(order_date) FILTER (
            WHERE purchase_number = 1
        ) AS first_purchase_date,
        MIN(order_date) FILTER (
            WHERE purchase_number = 2
        ) AS second_purchase_date
    FROM ranked_orders
    GROUP BY customer_id
),
repeat_intervals AS (
    SELECT
        second_purchase_date - first_purchase_date
            AS days_to_second_purchase
    FROM first_second
    WHERE second_purchase_date IS NOT NULL
)
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY days_to_second_purchase
    ) AS median_days_to_second_purchase
FROM repeat_intervals;


-- 14. Signup cohort activity
WITH cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', signup_date)::date AS signup_month
    FROM customers
),
purchasers AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE status = 'Completed'
)
SELECT
    c.signup_month,
    COUNT(*) AS customers_in_cohort,
    COUNT(p.customer_id) AS purchasing_customers,
    ROUND(
        100.0 * COUNT(p.customer_id) / COUNT(*),
        1
    ) AS activation_rate_pct
FROM cohorts AS c
LEFT JOIN purchasers AS p
    ON p.customer_id = c.customer_id
GROUP BY c.signup_month
ORDER BY c.signup_month;
