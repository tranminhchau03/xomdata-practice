-- Xom Data · Customer spending per order
-- Problem: https://xomdata.com/practice/medium-join-001
-- Solved: 2026-07-19

WITH revenue_info AS (
    SELECT 
        c.full_name, --VOI MOI KHACH HANG
        COUNT(o.id) AS order_count,
        SUM(total_amount) AS total_spending, 
        AVG(total_amount) as avg_order_value
    FROM customers c JOIN orders o ON c.id = o.customer_id 
    GROUP BY c.full_name
)
SELECT 
    full_name, 
    order_count,
    total_spending, 
    avg_order_value, 
    ROW_NUMBER() OVER (ORDER BY total_spending DESC, full_name ASC) as spending_rank
FROM revenue_info 
ORDER BY spending_rank
