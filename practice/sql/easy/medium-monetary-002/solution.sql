-- Xom Data · Average spend per visit, per customer
-- Problem: https://xomdata.com/practice/medium-monetary-002
-- Solved: 2026-08-26

SELECT 
    customer_id,
    ROUND(AVG(amount), 2) as avg_order_value
FROM orders
GROUP BY customer_id
