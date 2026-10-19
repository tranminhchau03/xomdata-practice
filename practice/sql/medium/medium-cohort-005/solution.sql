-- Xom Data · Each customer's starting quarter
-- Problem: https://xomdata.com/practice/medium-cohort-005
-- Solved: 2026-10-19

SELECT
    customer_id, 
    CONCAT(
        DATE_PART('year', MIN(order_date::DATE)), 
        '-Q', 
        DATE_PART('quarter', MIN(order_date::DATE))
    ) as first_quarter
FROM orders
GROUP BY customer_id
