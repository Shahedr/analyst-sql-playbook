-- Analyst SQL Playbook
-- Section 2: Window functions


-- 7. Product ranking within category
-- Calculate completed-order revenue by product and rank products
-- from highest to lowest revenue inside each category.
--
-- Use a window function rather than a correlated subquery.


-- 8. Customer spend quartiles
-- Calculate each customer's completed-order revenue, then assign
-- customers to four spend groups:
--   1 = highest-spending quartile
--   4 = lowest-spending quartile
--
-- Return quartile, customer count, and average customer spend.


-- 9. Month-over-month revenue growth
-- Calculate monthly completed-order revenue and:
--   previous_month_revenue
--   dollar_change
--   percent_change
--
-- Keep the first month in the result even though it has no prior month.


-- 10. Rolling three-month revenue
-- Starting from monthly completed-order revenue, calculate a rolling
-- three-month revenue total.
--
-- The first two months should still appear using the months available.
