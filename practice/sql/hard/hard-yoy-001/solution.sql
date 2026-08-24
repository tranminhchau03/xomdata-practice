-- Xom Data · YoY and QoQ sales growth
-- Problem: https://xomdata.com/practice/hard-yoy-001
-- Solved: 2026-08-24

WITH prev_revenue as(
    SELECT 
        year, 
        quarter, 
        revenue, 
        LAG(revenue) OVER(ORDER BY year, quarter) as prev_quarter_revenue,
        LAG(revenue, 4) OVER( ORDER By year, quarter) as prev_year_revenue
    FROM quarterly_sales
    GROUP BY year, quarter, revenue
    ORDER BY year asc, quarter asc
)
SELECT 
    *, 
    ROUND(
        (revenue - prev_quarter_revenue) * 100.0 
        / NULLIF(prev_quarter_revenue, 0),
    2) as qoq_pct, 
    ROUND(
        (revenue - prev_year_revenue) * 100.0 
        / NULLIF(prev_year_revenue, 0), 
    2) as yoy_pct
FROM prev_revenue
ORDER BY year asc, quarter asc

-- prev_year as(
--     SELECT 
--         year, 
--         revenue, 
--         LAG(revenue) OVER(ORDER BY year) as prev_year_revenue
--     FROM quarterly_sales
--     GROUP BY year, revenue
--     ORDER BY year asc --, quarter asc
-- -- )
