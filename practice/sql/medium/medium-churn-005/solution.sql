-- Xom Data · The yellow warning zone before losing a customer
-- Problem: https://xomdata.com/practice/medium-churn-005
-- Solved: 2026-10-21

WITH calc_gap_days as(
    SELECT
        customer_id, 
        MAX(order_date) as last_order_date,
        '2024-06-30'::DATE - MAX(order_date::DATE) as days_silent
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    last_order_date, 
    days_silent
FROM calc_gap_days
WHERE days_silent BETWEEN 60 AND 89
ORDER BY days_silent desc, customer_id asc
