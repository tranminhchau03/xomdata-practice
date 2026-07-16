-- Xom Data · Classify products by sales velocity
-- Problem: https://xomdata.com/practice/medium-case-110
-- Solved: 2026-07-16

WITH quantity_orders AS(
    SELECT  p1.id, 
            p1.name, 
            p1.categories, 
            SUM(t1.quantity) AS total_sold
    FROM products p1 
        JOIN transactions t1 ON p1.id = t1.product_id
    WHERE t1.quantity IS NOT NULL
    GROUP BY p1.id, p1.name, p1.categories
)
SELECT name, categories, total_sold,
    CASE
        WHEN total_sold >= 100 THEN 'Best Seller'
        WHEN total_sold >=50 THen 'Average'
        ELSE 'Slow Mover'
    END AS classification,
    DENSE_RANK() OVER (PARTITION BY categories ORDER BY total_sold DESC) AS rank_in_cat,
    ROUND(total_sold * 100.0/ SUM(total_sold) OVER (PARTITION BY categories), 2) AS pct_of_cat_total
FROM quantity_orders 
ORDER BY categories ASC, rank_in_cat ASC, name ASC
