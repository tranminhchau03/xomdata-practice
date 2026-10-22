-- Xom Data · Head-to-head customer count across quarters
-- Problem: https://xomdata.com/practice/medium-active-006
-- Solved: 2026-10-22

WITH define_quarter as(
    SELECT
        CONCAT(TO_CHAR(order_date::DATE, 'YYYY'), '-Q', DATE_PART('quarter', order_date::DATE)) as quarter,
        COUNT(DISTINCT customer_id) as active_customers
    FROM orders
    GROUP BY quarter
    ORDER BY quarter
)
SELECT
    quarter, 
    active_customers,
    active_customers - LAG(active_customers) OVER (ORDER BY quarter) as change_vs_prev
FROM define_quarter
ORDER BY quarter
