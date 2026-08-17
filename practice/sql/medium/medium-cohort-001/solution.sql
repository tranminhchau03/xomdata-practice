-- Xom Data · The customer's joining month on every order
-- Problem: https://xomdata.com/practice/medium-cohort-001
-- Solved: 2026-08-17

-- Viết SQL của bạn ở đây
SELECT 
    customer_name, 
    order_date, 
    LEFT(MIN(order_date) OVER (PARTITION BY customer_name ORDER BY order_date asc), 7) as cohort_month
FROM orders
ORDER BY customer_name, order_date
