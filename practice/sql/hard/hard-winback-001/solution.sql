-- Xom Data · Những người quay về sau hai tháng im ắng
-- Problem: https://xomdata.com/practice/hard-winback-001
-- Solved: 2026-09-24

SELECT *
FROM
    (SELECT 
        customer_id, 
        order_date, 
        JULIANDAY(order_date) -  JULIANDAY(LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) as gap_days
    FROM orders)
WHERE gap_days IS NOT NULL AND gap_days >= 60
