-- Xom Data · The Silence Between Two Consecutive Purchases
-- Problem: https://xomdata.com/practice/medium-gap-001
-- Solved: 2026-10-19

WITH prev_orders as(
    SELECT 
        customer_id, 
        order_date, 
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date asc) as prev_order_date
    FROM orders
)
SELECT 
    customer_id, 
    order_date,
    order_date::DATE - prev_order_date::DATE as days_since_prev
FROM prev_orders
WHERE prev_order_date IS NOT NULL
