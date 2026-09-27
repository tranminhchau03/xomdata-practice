-- Xom Data · Dishes off this season's menu
-- Problem: https://xomdata.com/practice/easy-in-002
-- Solved: 2026-09-27

-- Write your SQL here
SELECT 
    dish_name, 
    category
FROM dishes
WHERE category NOT IN ('Grill', 'Hotpot')
