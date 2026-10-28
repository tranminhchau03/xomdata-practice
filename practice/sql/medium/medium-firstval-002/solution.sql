-- Xom Data · First purchase date next to every order
-- Problem: https://xomdata.com/practice/medium-firstval-002
-- Solved: 2026-10-28

-- Write your SQL here
SELECT
    customer_name,
    order_date,
    amount,
    MIN(order_date) OVER (PARTITION BY customer_name ORDER BY order_date, customer_name) as first_order_date
FROM orders
