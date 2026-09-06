-- Xom Data · Quãng im lặng dài nhất của mỗi khách
-- Problem: https://xomdata.com/practice/hard-gap-002
-- Solved: 2026-09-06

-- -- WITH count_orders as(
-- --     SELECT 
-- --         customer_id,
    
-- --     FROM orders
-- --     GROUP BY customer_id
-- -- )
-- WITH calc_gap_days AS(
--     SELECT 
--         customer_id,  
--         lag(order_date) OVER (PARTITION BY customer_id ORDER BY order_date asc) as gap_start,
--         last_value(order_date) OVER (PARTITION BY customer_id) as gap_end,
--         JULIANDAY(last_value(order_date) OVER (PARTITION BY customer_id)) - 
--         JULIANDAY(lag(order_date) OVER (PARTITION BY customer_id ORDER BY order_date asc)) as gap_days
--     FROM orders
--     WHERE customer_id in (
--         SELECT customer_id
--         FROM orders 
--         GROUP BY customer_id
--         HAVING count(*) >= 2
--     )
-- ), 
-- rnum as(
--     SELECT *, 
--         ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY gap_start desc) as rn
--     FROM calc_gap_days
-- )
-- -- SELECT * from calc_gap_days
-- SELECT 
--     customer_id, 
--     gap_start, 
--     gap_end,
--     gap_days
-- FROM rnum 
-- WHERE rn = 1
-- ORDER BY gap_days desc
WITH status_date as (
    SELECT 
        customer_id,
        lag(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as gap_start,
        order_date as gap_end
    FROM orders
), 
calc_gap_days as (
    SELECT 
        customer_id, 
        gap_start, 
        gap_end,
        JULIANDAY(gap_end) - JULIANDAY(gap_start) as gap_days
    FROM status_date
    WHERE gap_start is not null and customer_id in (select customer_id
                                                    FROM orders 
                                                    GROUP BY customer_id
                                                    HAVING count(order_date) >= 2)
),
arrange_list as (
    SELECT 
        customer_id, 
        gap_start, 
        gap_end, 
        gap_days,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY gap_days desc, gap_start asc) as rn
    FROM calc_gap_days
)
SELECT 
    customer_id, 
    gap_start, 
    gap_end, 
    gap_days
FROM arrange_list
WHERE rn = 1
ORDER BY gap_days desc, customer_id asc
