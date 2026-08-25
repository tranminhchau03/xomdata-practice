-- Xom Data · Gắn nhãn khách còn gắn bó hay đã rời đi
-- Problem: https://xomdata.com/practice/medium-churn-001
-- Solved: 2026-08-25

SELECT 
    customer_id, 
    max(order_date) as last_order_date, 
    CASE 
        WHEN JULIANDAY('2024-06-30') - JULIANDAY(MAX(order_date)) > 90 THEN 'churned'
        ELSE 'active'
    END as status
FROM orders 
GROUP BY customer_id
