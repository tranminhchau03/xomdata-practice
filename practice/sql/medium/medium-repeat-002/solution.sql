-- Xom Data · Cửa hàng giữ được bao nhiêu phần khách
-- Problem: https://xomdata.com/practice/medium-repeat-002
-- Solved: 2026-08-26

WITH count_order as(
    SELECT 
        customer_id, 
        COUNT(order_date) as total_order
    FROm orders
    GROUP by customer_id
), 
get_more_2_order as (
    SELECT 
        sum(case when total_order > 1 THEN 1 else 0 end) as more_2_orders
    FROM count_order
),
count_customer as(
    SELECT 
        count(distinct customer_id) as total_customer
    FROM orders
)
SELECT ROUND(more_2_orders * 100.00 / total_customer, 2) as repeat_rate_pct
FROM get_more_2_order o cross JOIN count_customer c
