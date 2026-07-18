-- Xom Data · Delivered orders
-- Problem: https://xomdata.com/practice/easy-where-003
-- Solved: 2026-07-18

SELECT order_code, customers, total_amount
FROM orders
WHERE status = 'Delivered'
ORDER BY order_code ASC
