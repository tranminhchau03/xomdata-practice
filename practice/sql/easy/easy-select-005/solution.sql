-- Xom Data · Store list by city
-- Problem: https://xomdata.com/practice/easy-select-005
-- Solved: 2026-07-18

SELECT name, city 
FROM stores
ORDER BY city ASC, name ASC
