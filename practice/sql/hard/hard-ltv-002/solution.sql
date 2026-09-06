-- Xom Data · Dòng tiền tích luỹ theo tuổi thế hệ
-- Problem: https://xomdata.com/practice/hard-ltv-002
-- Solved: 2026-09-06

WITH months as(
    SELECT DISTINCT
        customer_id,
        min(strftime('%Y-%m', order_date)) OVER (PARTITION BY customer_id) as cohort_month, 
        CAST(strftime('%Y', order_date) AS INTEGER) * 12 + 
        CAST(strftime('%m', order_date) AS INTEGER) as midx,
        amount
    FROM orders 
), 
calc_age as(
    SELECT 
        distinct cohort_month,
        amount,
        midx - first_value(midx) OVER (PARTITION BY customer_id ORDER BY midx) as month_age
    FROm months
)
SELECT 
    cohort_month, 
    month_age, 
    SUM(amount) as revenue, 
    sum(SUM(amount)) OVER (PARTITION BY Cohort_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM calc_age
GROUP BY cohort_month, month_age
ORDER BY cohort_month asc, month_age asc
