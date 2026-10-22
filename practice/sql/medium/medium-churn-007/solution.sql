-- Xom Data · Revenue walking out the door with old customers
-- Problem: https://xomdata.com/practice/medium-churn-007
-- Solved: 2026-10-22

WITH last_orders as(
    SELECT
        customer_id, 
        MAX(order_date) as last_order_date,
        '2024-06-30'::DATE - MAX(order_date::DATE) as silent_days
    FROM orders
    GROUP BY customer_id
)
SELECT DISTINCT
    l.customer_id, 
    last_order_date, 
    SUM(amount) OVER (PARTITION BY l.customer_id) as lost_revenue
FROM last_orders l JOIN orders o ON l.customer_id = o.customer_id
WHERE silent_days > 90
ORDER BY lost_revenue desc, l.customer_id asc
