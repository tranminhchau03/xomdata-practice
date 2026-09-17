-- Xom Data · Categories full enough for the homepage
-- Problem: https://xomdata.com/practice/easy-having-001
-- Solved: 2026-09-17

-- Write your SQL here
SELECT 
 category,
 COUNT(*) as num_products
FROM products
GROUP BY category
HAVING COUNT(*) >= 3
ORDER BY category asc;
