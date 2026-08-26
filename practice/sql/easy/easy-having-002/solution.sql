-- Xom Data · Customers reaching the loyalty milestone
-- Problem: https://xomdata.com/practice/easy-having-002
-- Solved: 2026-08-26

-- Viết SQL của bạn ở đây
WITH calc_spent as (
    SELECT 
        customer_name, 
        SUM(amount) as total_spent
    FROM purchases
    GROUP BY customer_name
    ORDER BY total_spent desc, customer_name asc
) 
SELECT  
    customer_name, 
    total_spent
FROM calc_spent
WHERE total_spent >= 5000000
