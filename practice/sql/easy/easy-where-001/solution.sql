-- Xom Data · Filter products by category
-- Problem: https://xomdata.com/practice/easy-where-001
-- Solved: 2026-07-17

SELECT name, price, categories
FROM products
WHERE categories = 'Electronics'
ORDER BY name ASC
