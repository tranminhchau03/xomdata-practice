-- Xom Data · Tháng chào sân của từng khách
-- Problem: https://xomdata.com/practice/medium-cohort-003
-- Solved: 2026-08-25

SELECT 
    customer_id, 
    strftime('%Y-%m', min(order_date)) as cohort_month
FROM orders
GROUP BY customer_id
ORDER BY cohort_month asc, customer_id asc
