-- Xom Data · Category price range next to each item
-- Problem: https://xomdata.com/practice/medium-winagg-008
-- Solved: 2026-10-31

-- Write your SQL here
SELECT
    category,
    product_name,
    price,
    MIN(price) OVER (PARTITION BY category ORDER BY price asc) as cat_min,
    MAX(price) OVER (PARTITION BY category ORDER BY price desc) as cat_max
FROM products
ORDER BY category, price, product_name
