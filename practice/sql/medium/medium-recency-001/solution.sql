-- Xom Data · Bao lâu rồi khách chưa quay lại
-- Problem: https://xomdata.com/practice/medium-recency-001
-- Solved: 2026-08-25

SELECT 
    customer_id, 
    max(order_date) as last_order_date, 
    COALESCE(JULIANDAY('2024-06-30') - JULIANDAY(order_date), 0) as days_since
FROM orders 
GROUP BY customer_id
order by days_since asc, customer_id asc
