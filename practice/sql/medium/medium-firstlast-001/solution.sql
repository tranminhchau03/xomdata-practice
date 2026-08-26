-- Xom Data · Lần đầu và lần gần nhất của mỗi khách
-- Problem: https://xomdata.com/practice/medium-firstlast-001
-- Solved: 2026-08-26

SELECT 
    customer_id, 
    min(order_date) as first_order_date, 
    max(order_date) as last_order_date
FROm orders 
GROUP by customer_id
order by customer_id
