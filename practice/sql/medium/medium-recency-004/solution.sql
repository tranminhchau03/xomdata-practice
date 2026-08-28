-- Xom Data · Ba vòng tròn độ tươi của tệp khách
-- Problem: https://xomdata.com/practice/medium-recency-004
-- Solved: 2026-08-28

WITH calc_days AS(
    SELECT 
        customer_id,
        JULIANDAY('2024-06-30') - JULIANDAY(max(order_date)) as days_since
    FROM orders 
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN days_since BETWEEN 0 AND 30 THEN 'hot'
        WHEN days_since BETWEEN 31 AND 90 THEN 'warm'
        WHEN days_since > 90 THEN 'cold'
    END as freshness_bucket, 
    COUNT(customer_id) as customer_count
FROM calc_days
GROUP BY freshness_bucket
ORDER by days_since
