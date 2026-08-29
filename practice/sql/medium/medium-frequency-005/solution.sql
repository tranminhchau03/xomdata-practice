-- Xom Data · Khách phủ sóng nhiều tháng nhất
-- Problem: https://xomdata.com/practice/medium-frequency-005
-- Solved: 2026-08-29

-- SELECT 
--     customer_id, 
--     COUNT(*) as active_months, 
--     -- (SELECT 
--     --     -- customer_id, 
--     --     COUNT(*) 
--     -- FROM orders
--     -- GROUP BY customer_id) as total_orders
--     COUNT(order_date) as total_orders
-- FROM
--     (SELECT 
--         customer_id,
--         strftime('%Y-%m', order_date) as order_month,
--         ROW_NUMBER() OVER(PARTITION BY customer_id,  strftime('%Y-%m', order_date) 
--                           ORDER BY strftime('%Y-%m', order_date) asc) as rn
--     FROM orders
--     GROUP BY order_month, customer_id)
-- GROUP BY customer_id
-- ORDER BY active_months desc, customer_id asc

WITH calc_orders as(
    SELECT 
        customer_id,
        count(order_date) as total_orders 
    FROM orders 
    GROUP BY customer_id
),
rn as(
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY customer_id,  strftime('%Y-%m', order_date) 
                           ORDER BY strftime('%Y-%m', order_date) asc) as rn
    FROM orders JOIN calc_orders USING(customer_id)
)
SELECT 
    customer_id, 
    COUNT(case when rn = 1 then 1 end) as active_months,
    total_orders
FROM rn
GROUP BY customer_id
ORDER By active_months desc, customer_id
