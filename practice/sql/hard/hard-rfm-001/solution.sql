-- Xom Data · Chấm điểm khách hàng trên ba thước đo
-- Problem: https://xomdata.com/practice/hard-rfm-001
-- Solved: 2026-08-25

WITH calc_state as(
    SELECT 
        customer_id, 
        MAX(order_date) as last_order, 
        COUNT(*) as total_order, 
        SUM(amount) as total_spent
    FROM orders
    WHERE order_date <= '2024-06-30'
    GROUP BY customer_id
), 
calc_rfm as(
    SELECT 
        customer_id, 
        6 - NTILE(5) OVER (ORDER BY last_order desc, customer_id asc) as r_score, 
        6 - NTILE(5) OVER (ORDER BY total_order desc, customer_id asc) as f_score, 
        6 - NTILE(5) OVER (ORDER BY total_spent desc, customer_id asc) as m_score
    FROm calc_state
)
SELECT 
    customer_id, 
    r_score, 
    f_score, 
    m_score,
    r_score + f_score + m_score as rfm_total
FROm calc_rfm
ORDER BY rfm_total desc, customer_id asc
