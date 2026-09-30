-- Xom Data · Orders with customer names
-- Problem: https://xomdata.com/practice/easy-join-001
-- Solved: 2026-09-30

-- Write your SQL here
SELECT 
    order_code, 
    customer_name, 
    amount
FROM customers c JOIN orders o ON c.id = o.customer_id
