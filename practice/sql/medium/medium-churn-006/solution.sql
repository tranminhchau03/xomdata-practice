-- Xom Data · A snapshot of the customer base at a point in time
-- Problem: https://xomdata.com/practice/medium-churn-006
-- Solved: 2026-10-22

WITH prev_orders as(
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as prev
    FROM orders
),
flag as(
    SELECT 
        customer_id,
        CASE 
            WHEN prev IS NULL AND TO_CHAR(order_date::DATE, 'YYYY-MM') = '2024-06' THEN 'new' 
            WHEN '2024-06-30'::DATE - MAX(order_date::DATE) OVER (PARTITION BY customer_id) > 90 THEN 'churned'
            ELSE 'active'
        END as segment
    FROM prev_orders
)
SELECT
    segment,
    COUNT(DISTINCT customer_id) as customer_count
FROM flag
GROUP BY segment
