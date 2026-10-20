-- Xom Data · The blacklist of long-silent customers
-- Problem: https://xomdata.com/practice/medium-churn-004
-- Solved: 2026-10-20

WITH last_orders as(
    SELECT 
        customer_id, 
        MAX(order_date::DATE) as last_order_date,
        '2024-06-30'::DATE - MAX(order_date::DATE) as days_silent
    FROM orders
    GROUP BY customer_id
)
SELECT 
    customer_id, 
    last_order_date, 
    days_silent
FROM last_orders
WHERE days_silent > 90
ORDER BY days_silent desc, customer_id
