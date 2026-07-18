-- Xom Data · Products more expensive than the category average
-- Problem: https://xomdata.com/practice/medium-subquery-103
-- Solved: 2026-07-18

WITH avg_price_per_category AS(
    SELECT 
        product_name, 
        category,
        price,
        AVG(price) OVER (PARTITION BY category) AS avg_price_category
    FROM products
), 
diff_from_avg_category AS(
    SELECT 
        product_name,
        category,
        price, 
        price - avg_price_category AS diff_from_avg,
        ROUND((price * 100.00 / avg_price_category) - 100, 2) AS pct_above
    FROM avg_price_per_category
)
SELECT 
    product_name,
    category,
    price, 
    ROUND(diff_from_avg, 2) as diff_from_avg,
    pct_above
FROM diff_from_avg_category 
WHERE diff_from_avg > 0
ORDER BY pct_above DESC, product_name ASC
