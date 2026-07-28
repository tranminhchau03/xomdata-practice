-- Xom Data · 7-day moving average of revenue
-- Problem: https://xomdata.com/practice/hard-frame-001
-- Solved: 2026-07-28

SELECT 
    date,
    amount as revenue,
    ROUND(AVG(amount) OVER (ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as ma7
FROM daily_revenue
ORDER BY date asc
