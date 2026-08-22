-- Xom Data · Xếp khách vào nhóm chăm sóc phù hợp
-- Problem: https://xomdata.com/practice/hard-rfm-002
-- Solved: 2026-08-22

WITH 
status_order AS(
    SELECT 
        order_id,
        customer_id, 
        MAX(order_date) as lastest_order_date, 
        count(order_id) as order_count
    FROM orders
    GROUP BY customer_id
)
SELECT 
    customer_id, 
    JULIANDAY('2024-06-30') - JULIANDAY(lastest_order_date) as days_since,
    order_count, 
    CASE 
        WHEN JULIANDAY('2024-06-30') - JULIANDAY(lastest_order_date) <= 60 AND order_count >= 3 THEN 'Champions'
        WHEN JULIANDAY('2024-06-30') - JULIANDAY(lastest_order_date) > 60 AND order_count >= 3 THEN 'At Risk'
        WHEN JULIANDAY('2024-06-30') - JULIANDAY(lastest_order_date) <= 60 AND order_count < 3 THEN 'Promising'
        ELSE 'Hibernating'
    END as segment
FROM status_order
