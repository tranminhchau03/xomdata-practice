-- Xom Data · Scoring when the money is still sitting in the cart
-- Problem: https://xomdata.com/practice/hard-rfm-011
-- Solved: 2026-10-27

WITH cus_state as(
    SELECT
        customer_id,
        COUNT(DISTINCT order_date) as order_count,
        SUM(CASE WHEN quantity IS NOT NULL THEN quantity * unit_price ELSE 0 END) as total_spent
    FROM orders o LEFT JOIN order_items i USING(order_id)
    WHERE order_date <= '2024-06-30'
    GROUP BY customer_id
)
SELECT 
    customer_id, 
    order_count, 
    total_spent, 
    6 - NTILE(5) OVER (ORDER BY total_spent desc, customer_id asc) as m_score
FROM cus_state
