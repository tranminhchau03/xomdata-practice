-- Xom Data · Countdown before losing a customer
-- Problem: https://xomdata.com/practice/medium-churn-003
-- Solved: 2026-10-20

WITH count_days_silent as(
    SELECT
        customer_id, 
        '2024-06-30'::DATE - order_date::DATE as days_silent
    FROM orders
)
SELECT 
    customer_id, 
    days_silent, 
    90 - days_silent as days_left
FROM count_days_silent 
WHERE days_silent <= 90
ORDER BY days_left, customer_id
