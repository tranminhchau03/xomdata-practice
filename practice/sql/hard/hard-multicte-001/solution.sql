-- Xom Data · Multi-level profit margin analysis
-- Problem: https://xomdata.com/practice/hard-multicte-001
-- Solved: 2026-08-12

WITH 
calc_ as(
    SELECT 
        p.category, 
        p.name, 
        sum(o.quantity * o.price) as revenue, 
        sum(o.quantity * p.unit_cost) as cost,
        sum(o.quantity * o.price) - sum(o.quantity * p.unit_cost) as profit
    FROM products p JOIN orders o ON p.id = o.product_id
    GROUP BY p.category, p.name
)
SELECT 
    category, 
    name as product_name, 
    revenue, 
    cost, 
    profit,
    ROUND(profit * 100.0 / revenue, 2) as margin_pct, 
    DENSE_RANK() OVER (PARTITION BY category ORDER BY profit desc) as rank_in_cat, 
    ROUND(
        profit * 100.0 / 
        NULLIF(FIRST_VALUE(profit) 
            OVER (PARTITION BY category ORDER BY profit desc)
        , 0)
    , 2) as pct_of_top_in_cat
FROM calc_
ORDER BY category, rank_in_cat, name
