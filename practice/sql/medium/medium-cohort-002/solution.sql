-- Xom Data · Opening order or returning order
-- Problem: https://xomdata.com/practice/medium-cohort-002
-- Solved: 2026-08-17

-- Viết SQL của bạn ở đây
WITH rn as(
    SELECT 
        customer_name, 
        order_date, 
        amount,
        ROW_NUMBER() OVER (PARTITION BY customer_name ORDER BY order_date asc) as rn
    FROM orders 
) 
SELECT 
    customer_name, 
    order_date, 
    amount,
    CASE    
        WHEN rn = 1 THEN 'New'
        ELSE 'Returning'
    END AS order_type
FROM rn
ORDER BY customer_name asc, order_date asc
