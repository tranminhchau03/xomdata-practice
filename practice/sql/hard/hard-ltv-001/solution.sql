-- Xom Data · Average lifetime value by cohort
-- Problem: https://xomdata.com/practice/hard-ltv-001
-- Solved: 2026-10-11

WITH months as (
    SELECT 
         strftime('%Y-%m', order_date) as month,
         amount,
         customer_id
    FROM orders
),
calc_total as(
    SELECT 
        month as cohort_month, 
        SUM(amount) as total_amount
    FROM months
    GROUP BY customer_id 
) 
SELECT 
    cohort_month,
    COUNT(*) as cohort_size,
    ROUND(AVG(total_amount), 2) as avg_LTV
FROM calc_total
GROUP BY cohort_month
ORDER BY cohort_month
