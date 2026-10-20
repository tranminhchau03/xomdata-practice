-- Xom Data · The month that exploded with new customers
-- Problem: https://xomdata.com/practice/medium-active-003
-- Solved: 2026-10-20

WITH cus_month as(
    SELECT
        customer_id,
        TO_CHAR(MIN(order_date::DATE), 'YYYY-MM') as month
    FROM orders
    GROUP BY customer_id
),
rn_rank as(
    SELECT
        month, 
        COUNT(customer_id) as new_customers, 
        ROW_NUMBER() OVER (ORDER BY COUNT(customer_id) desc, month) as rn
    FROM cus_month
    GROUP BY month
)
SELECT 
    month, 
    new_customers
FROM rn_rank
WHERE rn = 1
