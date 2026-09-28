-- Xom Data · Revenue by product category
-- Problem: https://xomdata.com/practice/easy-groupby-002
-- Solved: 2026-09-28

-- Write your SQL here
SELECT 
 category, 
 SUM(amount) as total_revenue
FROM sales
GROUP BY category
