-- Xom Data · 5 cheapest products
-- Problem: https://xomdata.com/practice/easy-limit-001
-- Solved: 2026-07-16

SELECT name, price
FROM products
ORDER BY price ASC
LIMIT 5
