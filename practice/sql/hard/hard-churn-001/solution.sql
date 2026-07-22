-- Xom Data · Churned and returning customers
-- Problem: https://xomdata.com/practice/hard-churn-001
-- Solved: 2026-07-22

WITH 
get_order_date AS(
    SELECT
        user_id,
        order_date as prev_order,
        LEAD(order_date) OVER(PARTITION BY user_id ORDER BY order_date) as next_order
    FROM orders
)
SELECT 
    user_id,
    prev_order,
    next_order,
    JULIANDAY(next_order) - JULIANDAY(prev_order) as gap_days
FROM get_order_date
WHERE next_order IS NOT NULL and gap_days >= 90
GROUP BY user_id, prev_order, next_order
ORDER BY gap_days DESC, user_id
