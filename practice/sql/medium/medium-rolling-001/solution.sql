-- Xom Data · Three-month rolling average revenue
-- Problem: https://xomdata.com/practice/medium-rolling-001
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT
    month, 
    revenue, 
    ROUND(avg(revenue) over (rows between 2 preceding and current row), 2) as avg_3m
FROM shop_revenue
order by month asc
