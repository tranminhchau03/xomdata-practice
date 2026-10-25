-- Xom Data · Each channel's poster child
-- Problem: https://xomdata.com/practice/hard-rfm-009
-- Solved: 2026-10-25

WITH calc_score as(
    SELECT 
        channel,
        c.customer_id,
        '2024-06-30'::DATE - MAX(order_date::DATE) as r,
        COUNT(o.order_date) as f,
        SUM(o.amount) as m
    FROM customers c JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_date <= '2024-06-30' 
    GROUP BY c.customer_id
),
rank_score as(
    SELECT 
        channel,
        customer_id,
        6 - NTILE(5) OVER(ORDER BY r asc, customer_id asc) as r,
        6 - NTILE(5) OVER(ORDER BY f desc, customer_id asc) as f,
        6 - NTILE(5) OVER(ORDER BY m desc, customer_id asc) as m
    FROM calc_score
), 
total_score as(
    SELECT 
        channel,
        customer_id,
        f + r + m as rfm_total
    FROM rank_score
),
rnum as(
    SELECT 
        channel, 
        customer_id,    
        rfm_total,
        ROW_NUMBER() OVER (PARTITION BY channel ORDER BY rfm_total desc, customer_id asc) as rn
    FROM total_score
)
SELECT
    channel, 
    customer_id, 
    rfm_total
FROM rnum
WHERE rn = 1
ORDER BY channel
