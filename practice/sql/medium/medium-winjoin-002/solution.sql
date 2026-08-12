-- Xom Data · The customer's total next to every order
-- Problem: https://xomdata.com/practice/medium-winjoin-002
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    c.customer_name, 
    o.order_date, 
    o.amount, 
    sum(o.amount) OVER (PARTITION BY c.id) as customer_total
FROM customers c JOIN orders o ON c.id = o.customer_id
ORDER BY c.customer_name asc, o.order_date asc
