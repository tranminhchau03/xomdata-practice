-- Xom Data · Cumulative revenue and cumulative % of the period total
-- Problem: https://xomdata.com/practice/expert-final-win-008
-- Solved: 2026-10-15

WITH sum_period as(
    SELECT
        period,
        SUM(revenue) as period_revenue
    FROM sales
    GROUP BY period
    ORDER BY period
), 
sum_wf as(
    SELECT 
        period, 
        period_revenue,
        SUM(period_revenue) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total, 
        SUM(period_revenue) OVER () as grand_total
    FROM sum_period
)
SELECT 
    period, 
    period_revenue,
    running_total,
    grand_total,
    ROUND((running_total * 100.0 / grand_total), 1) as cumulative_pct
FROM sum_wf
ORDER BY period
