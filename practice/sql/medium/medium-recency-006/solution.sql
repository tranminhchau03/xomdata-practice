-- Xom Data · Hồ sơ ba chỉ số thô của từng khách
-- Problem: https://xomdata.com/practice/medium-recency-006
-- Solved: 2026-08-29

SELECT 
    customer_id,
    JULIANDAY('2024-06-30') - JULIANDAY(MAX(order_date)) as days_silent,
    COUNT(*) as order_count,
    SUM(amount) as total_spent
FROM orders 
GROUP BY customer_id
