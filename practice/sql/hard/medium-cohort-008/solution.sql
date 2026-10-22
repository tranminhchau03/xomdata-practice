-- Xom Data · Each cohort's size and first-month cash
-- Problem: https://xomdata.com/practice/medium-cohort-008
-- Solved: 2026-10-22

WITH first_month as(
    SELECT
        customer_id, 
        TO_CHAR(MIN(order_date::DATE), 'YYYY-MM') as cohort_month
    FROM orders
    GROUP BY customer_id
),
count_first_size as(
    SELECT  
        cohort_month,
        COUNT(customer_id) as cohort_size
    FROM first_month
    GROUP BY cohort_month
), 
total_revenues as(
    SELECT 
        TO_CHAR(order_date::DATE, 'YYYY-MM') as month,
        SUM(amount) as total_revenue
    FROM orders
    GROUP BY month
)
SELECT 
    cohort_month,
    cohort_size, 
    total_revenue as first_month_revenue
FROM count_first_size c JOIN total_revenues t ON c.cohort_month = t.month
ORDER BY cohort_month
