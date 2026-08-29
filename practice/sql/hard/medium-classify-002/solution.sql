-- Xom Data · Thứ bậc chi tiêu trong nội bộ mỗi kênh
-- Problem: https://xomdata.com/practice/medium-classify-002
-- Solved: 2026-08-29

WITH calc_total_spent as(
    SELECT 
        channel,
        customer_id,
        SUM(amount) as total_spent
    FROM customers c JOIN orders o USING(customer_id)
    GROUP BY customer_id
)
SELECT 
    channel, 
    customer_id, 
    total_spent, 
    DENSE_RANK() OVER(PARTITION BY channel ORDER BY total_spent desc) as rank_in_channel
FROM calc_total_spent
ORDER BY channel asc, rank_in_channel asc, customer_id asc
