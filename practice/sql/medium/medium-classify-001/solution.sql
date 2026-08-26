-- Xom Data · Kim cương, vàng hay thành viên thường
-- Problem: https://xomdata.com/practice/medium-classify-001
-- Solved: 2026-08-26

SELECT 
    customer_id, 
    sum(amount) as total_spent, 
    CASE    
        WHEN sum(amount) >= 10000000 THEN 'Diamond'
        WHEN sum(amount) >= 3000000 AND sum(amount) < 10000000 THEN 'Gold'
        ELSE 'Member'
    END as tier
FROM orders
GROUP BY customer_id
