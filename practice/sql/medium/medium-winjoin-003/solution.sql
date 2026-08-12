-- Xom Data · Each aisle's best seller
-- Problem: https://xomdata.com/practice/medium-winjoin-003
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
with rn_bestseller as(
    SELECT 
        c.category_name, 
        row_number() OVER (PARTITION BY c.id ORDER BY p.units_sold desc, p.product_name asc) as rn,
        p.product_name,
        p.units_sold
    FROM categories c JOIN products p ON c.id = p.category_id
)
SELECT 
    category_name, 
    product_name, 
    units_sold
FROm rn_bestseller
WHERE rn = 1
ORDER BY category_name asc
