-- Xom Data · Mã ba chữ số nói lên tất cả
-- Problem: https://xomdata.com/practice/hard-rfm-004
-- Solved: 2026-09-04

WITH calc_rfm as(
    SELECT 
        customer_id, 
        MAX(order_date) as r_score, 
        COUNT(order_date) as f_score,
        SUM(amount) as m_score
    FROM orders 
    WHERE order_date <= '2024-06-30'
    GROUP BY customer_id
),
rk AS(
    SELECT 
        customer_id, 
        CAST((6 - NTILE(5) OVER (ORDER BY r_score desc, customer_id asc)) as CHAR) as rank_r_score, 
        CAST((6 - NTILE(5) OVER (ORDER BY f_score desc, customer_id asc)) as CHAR) as rank_f_score, 
        CAST((6 - NTILE(5) OVER (ORDER BY m_score desc, customer_id asc)) as CHAR) as rank_m_score
    FROM calc_rfm
) 
SELECT 
    customer_id, 
    rank_r_score || rank_f_score || rank_m_score as rfm_code
FROM rk
ORDER BY rfm_code desc, customer_id asc
