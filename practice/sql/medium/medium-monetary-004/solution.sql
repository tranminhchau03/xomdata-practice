-- Xom Data · Each Customer's Record-Setting Order
-- Problem: https://xomdata.com/practice/medium-monetary-004
-- Solved: 2026-08-28

WITH rn as(
    SELECT 
        customer_id, 
        order_id, 
        order_date, 
        amount, 
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY amount desc, order_date asc, order_id asc) as rn
    FROM orders
)
SELECT 
    customer_id, 
    order_id, 
    order_date, 
    amount
FROM rn 
WHERE rn = 1
ORDER BY customer_id asc
