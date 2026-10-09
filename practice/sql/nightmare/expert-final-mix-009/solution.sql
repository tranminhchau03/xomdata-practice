-- Xom Data · Three-level sales totals: detail, by region, company-wide
-- Problem: https://xomdata.com/practice/expert-final-mix-009
-- Solved: 2026-10-09

SELECT 
    region, 
    room,
    SUM(revenue) as total_sales
FROM sales
GROUP BY GROUPING SETS(
    (region, room), 
    (region),
    ()
)
ORDER BY region, room

-- SELECT DISTINCT
--     region, 
--     room, 
--     SUM(revenue) as total_sales
-- FROM sales
-- GROUP BY ROLLUP (region, room)
-- ORDER BY region NULLs last, room NULLS LAST

-- SELECT 
--     region, 
--     room, 
--     SUM(revenue) as total_sales
-- FROM sales
-- GROUP BY region, room 
-- UNION ALL 
-- SELECT
--     region,
--     null,
--     SUM(revenue)
-- FROM sales
-- GROUP BY region
-- UNION ALL 
-- SELECT 
--     null, 
--     null, 
--     SUM(revenue)
-- FROM sales
-- ORDER BY region, room
