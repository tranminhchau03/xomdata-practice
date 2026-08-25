-- Xom Data · Khách một lần ghé và khách quay lại
-- Problem: https://xomdata.com/practice/medium-repeat-001
-- Solved: 2026-08-25

WITH order_state as(
    SELECT
        customer_id,
        count(*) as order_count
    FROM orders 
    GROUP BY customer_id
)
SELECT 
    case 
        when order_count = 1 then 'one-time'
        when order_count >= 2 then 'repeat'
    END as customer_type, 
    count(order_count) as customer_count
FROm order_state
GROUP BY customer_type
