-- Xom Data · Người mới và người quen mỗi tháng
-- Problem: https://xomdata.com/practice/hard-cohort-003
-- Solved: 2026-08-31

SELECT 
    month, 
    COUNT(
        case when prev is null AND rn = 1 THEN first_order END
    ) as new_customers,
    COUNT( 
        case when prev is not null and rn = 1 THEN customer_id END) as returning_customers
FROM
    (SELECT *, 
        strftime('%Y-%m', order_date) as month,
        LAG(strftime('%Y-%m', order_date)) 
            OVER (PARTITION BY customer_id ORDER BY order_date) as prev, 
        ROW_NUMBER() OVER (PARTITION BY customer_id, strftime('%Y-%m', order_date) ORDER BY order_date) as rn,
        FIRST_VALUE(order_date) 
            OVER(PARTITION BY customer_id, strftime('%Y-%m', order_date) ORDER BY order_date) as first_order
    FROM orders)
GROUP BY month
ORDER BY month asc

-- SELECT *, 
--         strftime('%Y-%m', order_date) as month,
--         LAG(strftime('%Y-%m', order_date)) 
--             OVER (PARTITION BY customer_id ORDER BY order_date) as prev, 
--         ROW_NUMBER() OVER (PARTITION BY customer_id, strftime('%Y-%m', order_date) ORDER BY order_date) as rn, 
--         FIRST_VALUE(order_date) OVER(PARTITION BY customer_id, strftime('%Y-%m', order_date) ORDER BY order_date) as first_order
--     FROM orders
