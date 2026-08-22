-- Xom Data · Bảng theo dõi khách quay lại theo thế hệ
-- Problem: https://xomdata.com/practice/hard-cohort-002
-- Solved: 2026-08-22

WITH 
get_month as(
    SELECT distinct
        strftime('%Y-%m', order_date) as order_month,
        customer_id
    FROM orders
),
get_cohort_month as(
    SELECT distinct
        MIN(strftime('%Y-%m', order_date)) as cohort_month, 
        customer_id
    FROM orders 
    GROUP BY customer_id
)
SELECT 
    cohort_month, 
    COUNT(case WHEN order_month = cohort_month THEN 1 END) as m0,
    COUNT(CASE WHEN order_month = strftime('%Y-%m', date(cohort_month || '-01', '+1 month'))THEN 1 END) as m1, 
    COUNT(CASE WHEN order_month = strftime('%Y-%m', date(cohort_month || '-01', '+2 months')) THEN 1 END) as m2, 
    COUNT(CASE WHEN order_month = strftime('%Y-%m', date(cohort_month || '-01', '+3 months')) THEN 1 END) as m3
FROM get_month m JOIN get_cohort_month c ON m.customer_id = c.customer_id
GROUP BY c.cohort_month
ORDER BY c.cohort_month
