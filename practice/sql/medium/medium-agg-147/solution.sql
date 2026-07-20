-- Xom Data · Top 10 highest-profit dishes
-- Problem: https://xomdata.com/practice/medium-agg-147
-- Solved: 2026-07-20

WITH 
order_completed as(
    SELECT id 
    FROM orders 
    WHERE status = 'Completed'
),
calc_quantity_revenue as (
    SELECT 
        d.dish_name,
        c.category_name,
        SUM(oi.quantity) as total_sold,
        SUM(oi.quantity * unit_price) as revenue,
        SUM(oi.quantity * unit_price) - SUM(cost_price * quantity) as profit
    FROM order_completed oc JOIN order_items oi ON oc.id = oi.order_id
                            LEFT JOIN dishes d ON oi.dish_id = d.id
                            JOIN categories c ON c.id = d.category_id
    GROUP BY d.dish_name, c.category_name, cost_price
),
calc_margin_pct as(
    SELECT 
        dish_name,
        category_name,
        total_sold,
        revenue,
        profit,
        CAST(ROUND(((profit * 100.00) / revenue), 2) as NUMERIC) as margin_pct,
        RANK() OVER (ORDER BY profit DESC) as rank_by_profit
    FROM calc_quantity_revenue
) 
SELECT 
    dish_name, 
    category_name, 
    total_sold,
    revenue,
    profit,
    margin_pct, 
    rank_by_profit,
    RANK() OVER (ORDER BY margin_pct DESC) as rank_by_margin
FROM calc_margin_pct
ORDER BY profit desc, dish_name asc
