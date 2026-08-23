-- Xom Data · Khách năng ghé trong nửa năm qua
-- Problem: https://xomdata.com/practice/medium-frequency-001
-- Solved: 2026-08-23

SELECT 
    customer_id, 
    COUNT(*) as order_count
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY customer_id
ORDER BY order_count desc, customer_id asc
