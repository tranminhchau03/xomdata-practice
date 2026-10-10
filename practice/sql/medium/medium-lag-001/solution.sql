-- Xom Data · Last month's revenue next to each month
-- Problem: https://xomdata.com/practice/medium-lag-001
-- Solved: 2026-10-10

-- Write your SQL here
SELECT
 month,
 revenue,
 LAG(revenue) OVER (ORDER BY month) as prev_revenue
FROM monthly_revenue
ORDER BY month
