-- Xom Data · Kênh nào đang giữ được hơi ấm
-- Problem: https://xomdata.com/practice/medium-recency-005
-- Solved: 2026-08-29

SELECT 
    channel,
    COUNT(*) as customers,
    ROUND(AVG(days_since), 2) as avg_days_silent
FROM
    (SELECT 
        customer_id, 
        channel,
        JULIANDAY('2024-06-30') - JULIANDAY(MAX(order_date)) as days_since
    FROM orders JOIN customers USING(customer_id)
    GROUP BY customer_id , channel)
GROUP BY channel


-- SELECT 
--     channel, 
--     COUNT(distinct customer_id) as customers, 
-- FROM customers c JOIN orders o USING(customer_id)
-- GROUP BY channel
