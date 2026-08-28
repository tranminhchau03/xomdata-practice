-- Xom Data · Miếng bánh doanh thu của từng khách
-- Problem: https://xomdata.com/practice/medium-monetary-005
-- Solved: 2026-08-28

WITH calc_total_spent as(
    SELECT 
        customer_id, 
        SUM(amount) as total_spent, 
        (SELECT SUM(amount)
         FROM orders) as total_revenue
    FROM orders 
    GROUP BY customer_id
) 
SELECT 
    customer_id, 
    total_spent, 
    ROUND(total_spent * 100.0 / total_revenue, 2) as revenue_share_pct
FROM calc_total_spent
ORDER BY revenue_share_pct desc, customer_id asc
