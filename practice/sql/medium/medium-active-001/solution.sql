-- Xom Data · Nhịp khách ghé cửa hàng theo tháng
-- Problem: https://xomdata.com/practice/medium-active-001
-- Solved: 2026-08-26

SELECT 
    distinct strftime('%Y-%m', order_date) as month,
    COUNT(distinct customer_id) as active_customers
FROM orders
GROUP BY month
