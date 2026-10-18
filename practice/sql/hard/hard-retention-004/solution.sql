-- Xom Data · First three-month return-rate matrix
-- Problem: https://xomdata.com/practice/hard-retention-004
-- Solved: 2026-10-18

WITH cus_month as(
    SELECT
        customer_id, 
        TO_CHAR(order_date::DATE, 'YYYY-MM') as order_date,
        CAST(TO_CHAR(order_date::DATE, 'YYYY') as INTEGER) * 12 + 
        CAST(TO_CHAR(order_date::DATE, 'MM') as INTEGER) as midx
    FROM orders
), 
new_cus as(
    SELECT DISTINCT
        customer_id,
        MIN(order_date) as cohort_month, 
        MIN(midx) as cohort_midx
    FROM cus_month
    GROUP BY customer_id
), 
cus_stat as(
    SELECT 
        c.customer_id, 
        cohort_month, 
        midx - cohort_midx as diff_m
    FROM new_cus n JOIN cus_month c ON n.customer_id = c.customer_id
), 
calc_cohort as(
    SELECT 
        cohort_month, 
        COUNT(DISTINCT customer_id) as cohort_size, 
        COUNT(DISTINCT CASE WHEN diff_m = 0 THEN customer_id END) as m0,
        COUNT(DISTINCT CASE WHEN diff_m = 1 THEN customer_id END) as m1,
        COUNT(DISTINCT CASE WHEN diff_m = 2 THEN customer_id END) as m2
    FROM cus_stat
    GROUP BY cohort_month
)
SELECT 
    cohort_month,
    cohort_size,
    ROUND(m0 * 100.0 / cohort_size, 2) as m0_pct, 
    ROUND(m1 * 100.0 / cohort_size, 2) as m1_pct,
    ROUND(m2 * 100.0 / cohort_size, 2) as m2_pct
FROM calc_cohort
