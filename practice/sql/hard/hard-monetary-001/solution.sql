-- Xom Data · Chia khách thành năm hạng chi tiêu
-- Problem: https://xomdata.com/practice/hard-monetary-001
-- Solved: 2026-08-24

WITH calc_amount as(
    SELECT 
        customer_id, 
        sum(amount) as total_spent
    FROM orders 
    GROUP BY customer_id
)
SELECT customer_id, total_spent, 
       NTILE(5) OVER(ORDER BY total_spent desc, customer_id asc) as spend_rank
FROM calc_amount
ORDER BY spend_rank asc, customer_id asc
