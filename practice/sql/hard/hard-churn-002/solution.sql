-- Xom Data · How many of last month's customers are lost this month
-- Problem: https://xomdata.com/practice/hard-churn-002
-- Solved: 2026-10-08

WITH monthly_active as(
    SELECT 
        customer_id, 
        strftime('%Y-%m', order_date) as month, 
        DATE(order_date, 'start of month') as started
    FROM orders
),
max_month as (
    SELECT
        MAX(started) as max_m
    FROM monthly_active 
)
SELECT 
    cur.month, 
    COUNT(CASE WHEN nxt.customer_id IS NULL THEN 1 END) as churned_customers
FROM max_month CROSS JOIN monthly_active cur
               LEFT  JOIN monthly_active nxt ON cur.customer_id = nxt.customer_id
                                            AND cur.started = DATE(nxt.started, '-1 month')
WHERE cur.started < max_m
GROUP BY cur.month, cur.started
ORDER BY cur.started

-- WITH RECURSIVE 
-- scope as (
--     SELECT 
--         DATE(MIN(order_date), 'start of month') AS started,
--         DATE(MAX(order_date), 'start of month') AS ended
--     FROM orders
-- ), 
-- list_months as (
--     SELECT 
--         date(started, 'start of month') as list_m
--     FROM scope

--     UNION ALL 

--     SELECT 
--         DATE(list_m, '+1 month') 
--     FROM list_months CROSS JOIN scope
--     WHERE list_m < DATE(ended, 'start of month') 
-- ),
-- cus_list as (
--     SELECT DISTINCT customer_id
--     FROM orders
-- ), 
-- cus_month as (
--     SELECT 
--         customer_id,
--         list_m
--     FROM list_months CROSS JOIN cus_list 
-- ), 
-- new_orders as(
--     SELECT
--         c.customer_id, 
--         c.list_m, 
--         o.order_date,
--         o.amount
--     FROM cus_month c LEFT JOIN orders o 
--         ON strftime('%Y-%m', list_m) = strftime('%Y-%m', order_date) 
--         and c.customer_id = o.customer_id
-- ),
-- prevs as (
--     SELECT 
--         *, 
--         LAG(order_date) OVER (PARTITION BY customer_id ORDER BY list_m) as prev
--     FROM new_orders
-- ),
-- flag as(
--     SELECT *,
--         CASE WHEN prev IS NOT NULL AND order_date IS  NULL THEN prev END as churned
--     FROM prevs
-- )
-- select 
--     strftime('%Y-%m', churned) as month, 
--     COALESCE(COUNT(*), 0) as churned_customers
-- FROM flag cross join scope 
-- WHERE churned IS NOT NULL AND list_m <= DATE(ended, 'start of month')
-- GROUP BY month
-- ORDER BY month;
