-- Analyst SQL Playbook
-- Section 1: Core analytics
--
-- Work through these using the tables in sql/00_schema.sql.
-- Unless a question says otherwise, exclude Cancelled and Returned orders
-- when calculating sales revenue.


-- 1. Monthly revenue
-- Return one row per month with:
--   month
--   completed_orders
--   revenue
--   average_order_value
--
-- Sort chronologically.


-- 2. Category performance
-- For each product category, calculate:
--   order_count
--   units_sold
--   revenue
--
-- Sort highest revenue first.


-- 3. Regional performance
-- Compare regions on:
--   active_customers
--   completed_orders
--   revenue
--   revenue_per_customer


-- 4. Discount usage
-- Put line items into two groups:
--   No discount
--   Discounted
--
-- Compare line-item count, units, and revenue between the two groups.


-- 5. Highest-value customers
-- Return the top 10 customers by completed-order revenue.
-- Include:
--   customer_id
--   region
--   completed_orders
--   total_revenue


-- 6. Order outcome by channel
-- For each sales channel, calculate the percentage of orders that were:
--   Completed
--   Returned
--   Cancelled
--
-- Hint: conditional aggregation is useful here.
