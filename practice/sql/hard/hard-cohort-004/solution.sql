-- Xom Data · Thế hệ khách nhìn theo kênh dẫn về
-- Problem: https://xomdata.com/practice/hard-cohort-004
-- Solved: 2026-09-02

WITH prev as(
    SELECT * , 
        LAG(order_date) OVER (PARTITION BY customer_id, channel ORDER BY order_date) as prev
    FROM customers c JOIN orders o USING(customer_id)
), 
count_return as(
    SELECT 
        *,
        strftime('%Y-%m', MIN(order_date)) as cohort_month,
        count(
        case when strftime('%Y-%m', order_date) = strftime('%Y-%m', DATE(prev, '+1 month')) then 1 
        end) as mark_return
    FROM prev 
    GROUP BY customer_id, channel
)
SELECT 
    channel, 
    cohort_month,
    COUNT(*) as cohort_size, 
    COUNT(case when mark_return = 1 then 1 end) as retained_m1
FROM count_return
GROUP BY channel, cohort_month

-- months as(
--     SELECT 
--         channel, 
--         strftime('%Y-%m', MIN(order_date)) as cohort_month,
--         LAG(strftime('%Y-%m', MIN(order_date))) OVER (PARTITION BY customer_id ORDER BY strftime('%Y-%m', MIN(order_date))) as prev
--     FROM customers JOIN orders USING(customer_id)
--     GROUP BY channel, customer_id --, cohort_month
-- )
-- SELECT DISTINCT
--     channel, 
--     cohort_month, 
--     COUNT(*) OVER (PARTITION BY cohort_month, channel) as cohort_size
-- FROM months
