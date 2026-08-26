-- Xom Data · Ấn tượng đầu tiên trị giá bao nhiêu
-- Problem: https://xomdata.com/practice/medium-firstlast-003
-- Solved: 2026-08-26

WITH rn as (
    SELECT 
        customer_id, 
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date asc, order_id asc) as rn, 
        order_date,
        amount    
    FROM orders 
)
SELECT 
    customer_id, 
    order_date as first_order_date, 
    amount as first_amount 
FROM rn 
WHERE rn = 1 
ORDER BY customer_id asc
-- WITH first_order as(
--     SELECT 
--         customer_id, 
--         min(order_date) as first_order_date 
--     FROM orders 
--     GROUP BY customer_id
-- ) 
-- SELECT distinct
--     f.customer_id, 
--     f.first_order_date, 
--     amount as first_amount
-- FROM first_order f JOIN orders o ON f.customer_id = o.customer_id
-- WHERE o.order_id in (SELECT MIN(order_id) 
--                      FROM orders 
--                      GROUP BY customer_id)
-- ORDER BY customer_id asc
