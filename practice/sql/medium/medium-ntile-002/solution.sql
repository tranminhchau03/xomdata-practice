-- Xom Data · Splitting deliveries into three shifts by order time
-- Problem: https://xomdata.com/practice/medium-ntile-002
-- Solved: 2026-10-31

-- Write your SQL here
SELECT
    order_code,
    order_time,
    NTILE(3) OVER (ORDER BY order_time) as delivery_shift
FROM morning_orders
ORDER BY order_time, order_code
