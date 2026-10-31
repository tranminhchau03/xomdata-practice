-- Xom Data · Trend labels for the monthly report
-- Problem: https://xomdata.com/practice/medium-lag-004
-- Solved: 2026-10-31

-- Write your SQL here
WITH prevs as(
    SELECT
        month, 
        revenue, 
        LAG(revenue) OVER (ORDER BY month) as prev_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue, 
    CASE 
        WHEN revenue > prev_revenue THEN 'Up'
        WHEN revenue < prev_revenue THEN 'Down'
        WHEN revenue = prev_revenue THEN 'Flat'
        ELSE 'First'
    END as trend
FROM prevs 
ORDER BY month
