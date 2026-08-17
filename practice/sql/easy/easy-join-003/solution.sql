-- Xom Data · Line totals from the price list
-- Problem: https://xomdata.com/practice/easy-join-003
-- Solved: 2026-08-17

-- Viết SQL của bạn ở đây
SELECT 
    product_name, 
    quantity,
    price * quantity as line_total
FROM products p JOIN sale_items s ON p.id = s.product_id
