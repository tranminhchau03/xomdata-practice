-- Xom Data · Chấm điểm công bằng khi nhiều khách ngang tài
-- Problem: https://xomdata.com/practice/hard-rfm-005
-- Solved: 2026-09-05

WITH calc_spent as(
    SELECT 
        customer_id, 
        sum(amount) as total_spent
    FROM orders 
    GROUP BY customer_id
), 
rk as(
    SELECT 
        customer_id,
        total_spent,
        COALESCE((RANK() OVER (ORDER BY total_spent desc) - 1) * 1.0 / NULLIF((COUNT(*) OVER() - 1), 0), 0) as relative_rank
    FROM calc_spent
)
SELECT 
    customer_id, 
    total_spent,
    CASE WHEN relative_rank < 0.2 THEN 5
         WHEN relative_rank >= 0.2 AND relative_rank < 0.4 THEN 4
         WHEN relative_rank >= 0.4 AND relative_rank < 0.6 THEN 3
         WHEN relative_rank >= 0.6 AND relative_rank < 0.8 THEN 2
         WHEN relative_rank >= 0.8 THEN 1
    END as m_score
FROM rk
