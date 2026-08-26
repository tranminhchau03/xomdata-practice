-- Xom Data · Bảng xếp hạng độ tươi của khách
-- Problem: https://xomdata.com/practice/medium-recency-003
-- Solved: 2026-08-26

WITH last_order as (
    SELECT distinct
        customer_id, 
        MAX(order_date) as last_order_date
    FROM orders
    GROUP BY customer_id --, order_date
    ORDER BY customer_id asc
) 
SELECT 
    customer_id, 
    last_order_date, 
    RANK() OVER(ORDER BY last_order_date desc) as freshness_rank
FROM last_order
ORDER BY freshness_rank, customer_id
