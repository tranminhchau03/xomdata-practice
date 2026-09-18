-- Xom Data · Products in a price range
-- Problem: https://xomdata.com/practice/easy-between-001
-- Solved: 2026-09-18

-- Write your SQL here
 SELECT product_name, price
 FROM products
 WHERE price BETWEEN 200 AND 500
