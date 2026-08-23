-- Xom Data · Sau một tháng, còn lại bao nhiêu phần
-- Problem: https://xomdata.com/practice/hard-retention-002
-- Solved: 2026-08-23

WITH get_cohort_month as(
    SELECT 
        customer_id,
        strftime('%Y-%m', MIN(order_date)) as cohort_month
    FROM orders
    GROUP BY customer_id
), 
get_retained AS(
    SELECT 
        cohort_month, 
        COUNT(distinct o.customer_id) as cohort_size, 
        COUNT(CASE WHEN strftime('%Y-%m', order_date) = strftime('%Y-%m', DATE(cohort_month || '-01', '+1 month')) THEN 1 END) as retained_m1
    FROM get_cohort_month c JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY cohort_month
)
SELECT 
    cohort_month, 
    cohort_size, 
    retained_m1, 
    ROUND(retained_m1 * 100.0 / NULLIF(cohort_size, 0), 2) as retention_pct
FROM get_retained
ORDER BY cohort_month asc
