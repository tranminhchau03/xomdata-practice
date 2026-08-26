-- Xom Data · Ba mươi ngày vắng bóng
-- Problem: https://xomdata.com/practice/medium-recency-002
-- Solved: 2026-08-26

WITH order_state as(
    SELECT 
        customer_id, 
        max(order_date) as last_order_date, 
        JULIANDAY('2024-06-30') - JULIANDAY(max(order_date)) as days_since
    FROM orders 
    GROUP BY customer_id
)
SELECT 
    customer_id, 
    last_order_date
FROM order_state
WHERE days_since > 30
