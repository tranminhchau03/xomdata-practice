-- Xom Data · Còn sống sót tính từ tháng thứ hai trở đi
-- Problem: https://xomdata.com/practice/hard-retention-005
-- Solved: 2026-09-06

WITH months as (
    SELECT distinct 
        customer_id, 
        strftime('%Y-%m', order_date) as month
    FROM orders
),
cohort_months as (
    SELECT 
        customer_id, 
        MIN(month) as cohort_month
    FROM months
    GROUP BY customer_id
), 
cohort_sizes as (
    SELECT 
        cohort_month, 
        count(*) as cohort_size
    FROM cohort_months
    GROUP BY cohort_month
), 
find_survivors as (
    SELECT 
        cohort_month, 
        COUNT(DISTINCT m.customer_id) as survivors  
    FROM months m JOIN cohort_months c ON m.customer_id = c.customer_id
        AND m.month >= strftime('%Y-%m', DATE(cohort_month || '-01', '+2 months'))
    GROUP BY cohort_month
)
SELECT 
    cohort_month, 
    cohort_size, 
    COALESCE(survivors, 0) as survivors, 
    COALESCE(ROUND(NULLIF(survivors, 0) * 100.0 / cohort_size, 2), 0) as survival_pct
FROM find_survivors RIGHT JOIN cohort_sizes USING(cohort_month)
ORDER BY cohort_month asc



-- WITH months as(
--     SELECT distinct
--         customer_id, 
--         strftime('%Y-%m', order_date) as cohort_month, 
--         lag(order_date) OVER (PARTITION BY customer_id ORDER BY order_date asc) as prev_month
--     FROm orders 
-- ), 
-- calc_cohort_size as(
--     SELECT 
--         -- customer_id, 
--         cohort_month, 
--         COUNT(*) as cohort_size, 
--         prev_month
--     FROM months 
--     GROUP BY cohort_month 
-- ), 
-- count_survivors as(
--     SELECT 
--         cohort_month, 
--         cohort_size, 
--         COUNT(CASE WHEN cohort_month >= strftime('%Y-%m', DATE(prev_month, '+2 months')) THEN 1 END) as survivors
--     FROM calc_cohort_size
-- )
-- SELECT 
--     cohort_month, 
--     cohort_size, 
--     survivors,
--     COALESCE(ROUND(NULLIF(survivors, 0) * 100.0 / cohort_size, 2), 0) as survival_pct
-- FROM count_survivors 
-- GROUP BY cohort_month
-- ORDER BY cohort_month asc
