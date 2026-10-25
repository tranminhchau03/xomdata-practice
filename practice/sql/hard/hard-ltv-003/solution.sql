-- Xom Data · How much is the first 90 days of life worth
-- Problem: https://xomdata.com/practice/hard-ltv-003
-- Solved: 2026-10-25

WITH first_month as(
    SELECT DISTINCT
        customer_id,
        MIN(order_date::DATE) as first_order
    FROM orders
    GROUP BY customer_id
),
filter_90d as(
    SELECT DISTINCT
        f.customer_id,
        TO_CHAR(first_order, 'YYYY-MM') as cohort_month, 
        SUM(amount) OVER(PARTITION BY f.customer_id) total_amount
    FROM first_month f 
        JOIN orders o ON f.customer_id = o.customer_id 
        AND first_order + INTERVAL '90 days' >= order_date::DATE 
)
SELECT 
    cohort_month, 
    COUNT(customer_id) as cohort_size,
    AVG(total_amount) as avg_ltv_90d
FROM filter_90d
GROUP BY cohort_month
ORDER BY cohort_month
