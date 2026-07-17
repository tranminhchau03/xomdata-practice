-- Xom Data · Top 3 highest-value orders
-- Problem: https://xomdata.com/practice/easy-limit-002
-- Solved: 2026-07-16

SELECT order_code, customers, total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 3
