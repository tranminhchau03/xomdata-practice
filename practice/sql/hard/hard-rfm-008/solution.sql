-- Xom Data · A single composite number per customer
-- Problem: https://xomdata.com/practice/hard-rfm-008
-- Solved: 2026-10-26

WITH cus_state as(
    SELECT
        customer_id, 
        MAX(order_date) as last_orders,
        COUNT(order_date) as total_orders,
        SUM(amount) as total_amount  
    FROM orders
    WHERE order_date <= '2024-06-30'
    GROUP BY customer_id
),
calc_rfm as(
    SELECT
        customer_id,
        6 - NTILE(5) OVER (ORDER BY last_orders desc, customer_id asc) as r_score,
        6 - NTILE(5) OVER (ORDER BY total_orders desc, customer_id asc) as f_score,
        6 - NTILE(5) OVER (ORDER BY total_amount desc, customer_id asc) as m_score
    FROM cus_state
)
SELECT 
    customer_id, 
    r_score, 
    f_score, 
    m_score,
    r_score * 100 + f_score * 10 + m_score as weighted_score
FROM calc_rfm
ORDER BY weighted_score desc, customer_id asc
