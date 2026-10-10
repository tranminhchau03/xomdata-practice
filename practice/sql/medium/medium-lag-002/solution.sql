-- Xom Data · Change versus last month
-- Problem: https://xomdata.com/practice/medium-lag-002
-- Solved: 2026-10-10

-- Write your SQL here
SELECT 
 month, 
 revenue, 
 revenue - LAG(revenue) OVER(ORDER BY month) as mom_change
FROM monthly_revenue
ORDER BY month
