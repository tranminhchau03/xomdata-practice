-- Xom Data · Customer Shopping Tenure
-- Problem: https://xomdata.com/practice/medium-cohort-006
-- Solved: 2026-10-20

WITH get_first_last_month as(
    SELECT
        customer_id, 
        MIN(order_date::DATE) as first_month, 
        CAST(TO_CHAR(MIN(order_date::DATE), 'YYYY') as INTEGER) * 12 +
        CAST(TO_CHAR(MIN(order_date::DATE), 'MM') as INTEGER) as min_midx,
        MAX(order_date::DATE) as last_month, 
        CAST(TO_CHAR(MAX(order_date::DATE), 'YYYY') as INTEGER) * 12 +
        CAST(TO_CHAR(MAX(order_date::DATE), 'MM') as INTEGER) as max_midx
    FROM orders
    GROUP BY customer_id
)
SELECT 
    customer_id, 
    TO_CHAR(first_month, 'YYYY-MM') as first_month, 
    TO_CHAR(last_month, 'YYYY-MM') as last_month, 
    max_midx - min_midx as tenure_months
FROM get_first_last_month
ORDER BY tenure_months desc, customer_id
