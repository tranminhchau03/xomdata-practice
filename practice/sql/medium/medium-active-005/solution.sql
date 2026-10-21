-- Xom Data · Month-over-month momentum in customer count
-- Problem: https://xomdata.com/practice/medium-active-005
-- Solved: 2026-10-21

WITH count_cus as(
    SELECT DISTINCT
        TO_CHAR(order_date::DATE, 'YYYY-MM') as month,
        COUNT(DISTINCT customer_id) as active_customers
    FROM orders
    GROUP BY month
)
SELECT 
    month, 
    active_customers, 
    active_customers - LAG(active_customers) OVER (ORDER BY month) as change_vs_prev
FROM count_cus  
ORDER BY month
