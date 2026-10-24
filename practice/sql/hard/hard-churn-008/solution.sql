-- Xom Data · Customer base growth accounting ledger
-- Problem: https://xomdata.com/practice/hard-churn-008
-- Solved: 2026-10-24

WITH scope as(
    SELECT 
        MIN(DATE_TRUNC('month', order_date::DATE)) as start, 
        MAX(order_date::DATE) as ended
    FROM orders
),
gens as (
    SELECT 
        generate_series(
            start, 
            ended, 
            INTERVAL '1 month'
        )::DATE as gen_month
    FROM scope s 
),
new_orders as(
    SELECT 
        DISTINCT
        customer_id, 
        gen_month
    FROM gens CROSS JOIN orders
    ORDER BY customer_id
),
merged as(
    SELECT  
        n.customer_id, 
        n.gen_month, 
        o.order_date 
    FROM new_orders n 
        LEFT JOIN orders o ON n.customer_id = o.customer_id 
        AND DATE_TRUNC('month', n.gen_month) = DATE_TRUNC('month', o.order_date::DATE)
),
marked as(
    SELECT *,
        TO_CHAR(gen_month, 'YYYY-MM') as month,
        CASE WHEN order_date IS NOT NULL THEN 1 ELSE 0 END as active,
        LAG(CASE WHEN order_date IS NOT NULL THEN 1 ELSE 0 END) 
            OVER (PARTITION BY customer_id 
                  ORDER BY gen_month) as prev_active,
        MAX(CASE WHEN order_date IS NOT NULL THEN 1 ELSE 0 END)
            OVER (PARTITION BY customer_id 
                  ORDER BY gen_month
                  ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) as active_before
    FROM merged
),
count_cus_state as(
    SELECT 
        month, 
        COUNT(CASE WHEN active = 1 AND (active_before IS NULL OR active_before = 0) THEN 1 END) as new_customers,
        COUNT(CASE WHEN active = 1 AND active_before = 1 AND prev_active = 0 THEN 1 END) as resurrected,
        COUNT(CASE WHEN active = 0 AND active_before IS NOT NULL THEN 1 END) as churned
    FROM marked
    GROUP BY month
    ORDER BY month
)
SELECT 
    month,
    new_customers, 
    resurrected, 
    churned, 
    new_customers + resurrected - churned as net_change
FROM count_cus_state
ORDER BY month
