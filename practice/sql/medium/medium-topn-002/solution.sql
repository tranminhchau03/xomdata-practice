-- Xom Data · Top three sellers per category
-- Problem: https://xomdata.com/practice/medium-topn-002
-- Solved: 2026-10-02

-- Write your SQL here
WITH rnum as(
    SELECT 
        category, 
        product_name, 
        units_sold,    
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY units_sold desc, product_name asc) as rn 
    FROM menu_sales
)
SELECT 
    category, 
    product_name, 
    units_sold
FROM rnum 
WHERE rn <= 3
