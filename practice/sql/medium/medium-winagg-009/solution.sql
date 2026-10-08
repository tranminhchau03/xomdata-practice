-- Xom Data · Each category's slice of revenue
-- Problem: https://xomdata.com/practice/medium-winagg-009
-- Solved: 2026-10-08

-- Write your SQL here
WITH calc_category_revenue as(
    SELECT 
        category, 
        SUM(amount) as total_revenue
    FROM sales
    GROUP BY category 
)
SELECT 
    category,
    total_revenue,
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER(), 2) as pct_share
FROM calc_category_revenue
ORDER BY total_revenue desc, category
