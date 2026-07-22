-- Xom Data · Customers silent for 90 days
-- Problem: https://xomdata.com/practice/hard-anti-001
-- Solved: 2026-07-22

WITH get_last_order_date as (
    SELECT
        id, 
        MAX(order_date) OVER() as last_date_in_orders,
        MAX(order_date) OVER(PARTITION BY user_id) as last_order_date
    FROM orders
)
SELECT 
    o.user_id,
    g.last_order_date,
    -- g.last_date_in_orders,
    JULIANDAY(g.last_date_in_orders) - JULIANDAY(g.last_order_date) as days_since_last
FROM get_last_order_date g JOIN orders o ON o.id = g.id
WHERE days_since_last >= 90
GROUP BY o.user_id, g.last_order_date
ORDER BY days_since_last DESC, user_id ASC
