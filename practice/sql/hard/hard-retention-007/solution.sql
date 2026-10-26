-- Xom Data · Returning right on schedule at month n
-- Problem: https://xomdata.com/practice/hard-retention-007
-- Solved: 2026-10-26

WITH first_month as(
    SELECT DISTINCT
        customer_id,
        TO_CHAR(MIN(order_date::DATE), 'YYYY-MM') as cohort_month
    FROM orders
    GROUP BY customer_id
),
count_size as(
    SELECT
        cohort_month,
        COUNT(customer_id) as cohort_size
    FROM first_month
    GROUP BY cohort_month 
)
SELECT 
    cohort_month, 
    cohort_size,
    COUNT(DISTINCT CASE WHEN cohort_month = TO_CHAR(order_date::DATE - INTERVAL '1 month', 'YYYY-MM') THEN customer_id END) as m1,
    COUNT(DISTINCT CASE WHEN cohort_month = TO_CHAR(order_date::DATE - INTERVAL '2 month', 'YYYY-MM') THEN customer_id END) as m2,
    COUNT(DISTINCT CASE WHEN cohort_month = TO_CHAR(order_date::DATE - INTERVAL '3 month', 'YYYY-MM') THEN customer_id END) as m3
FROM count_size c CROSS JOIN orders
GROUP BY cohort_month, cohort_size
ORDER BY cohort_month
