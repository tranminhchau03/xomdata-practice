-- Xom Data · The size of each customer cohort
-- Problem: https://xomdata.com/practice/medium-cohort-004
-- Solved: 2026-10-16

WITH cus_month as(
    SELECT DISTINCT
        customer_id, 
        TO_DATE(MIN(order_date), 'YYYY-MM') as order_month
    FROM orders
    GROUP BY customer_id
)
SELECT
    TO_CHAR(order_month, 'YYYY-MM') as cohort_month,
    COUNT(order_month) as cohort_size
FROM cus_month 
GROUP BY cohort_month
ORDER BY cohort_month
