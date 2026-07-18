-- Xom Data · High-priced products
-- Problem: https://xomdata.com/practice/easy-where-002
-- Solved: 2026-07-18

SELECT name, price
FROM products
WHERE price > 500000
ORDER BY price DESC
