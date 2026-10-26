-- Xom Data · How long does it take to win a customer back
-- Problem: https://xomdata.com/practice/hard-winback-004
-- Solved: 2026-10-26

WITH prev_orders as(
    SELECT 
        channel, 
        c.customer_id,
        order_date::DATE,
        LAG(order_date::DATE) OVER (PARTITION BY channel, c.customer_id ORDER BY order_date, order_id) as prev
    FROM customers c JOIN orders o ON c.customer_id = o.customer_id
),
calc_gap_days as(
    SELECT  
        channel,
        customer_id,
        order_date,
        order_date - prev as gap_days
    FROM prev_orders
)
SELECT
    channel, 
    COUNT(CASE WHEN gap_days >= 60 THEN customer_id END) as winback_count,
    ROUND(AVG(CASE WHEN gap_days >= 60 THEN gap_days END), 2) as avg_absence_days
FROM calc_gap_days
GROUP BY channel
HAVING COUNT(CASE WHEN gap_days >= 60 THEN customer_id END) >= 1
ORDER BY avg_absence_days asc, channel asc
