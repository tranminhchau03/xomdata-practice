-- Xom Data · Estimating lifetime value with three building blocks
-- Problem: https://xomdata.com/practice/hard-ltv-005
-- Solved: 2026-10-27

WITH 
calc_aov as(
    SELECT
        SUM(amount) * 1.0 / COUNT(order_date) as aov
    FROM orders
),
cus_month as(
    SELECT DISTINCT
        customer_id,
        TO_CHAR(order_date::DATE, 'YYYY-MM') as month
    FROM orders
),
count_order_grpmonth as(
    SELECT 
        customer_id,
        COUNT(month) as orders
    FROM cus_month
    GROUP BY customer_id
),
avg_age as(
    SELECT 
        aov,
        AVG(orders) as avg_active_months
    FROM count_order_grpmonth CROSS JOIN calc_aov
    GROUP BY aov
),
count_active_cus_month as(
    SELECT  
        COUNT(*) total_active
    FROM cus_MONTH c 
),
avg_active_months as(
    SELECT 
        aov, 
        COUNT(order_date) * 1.0 / total_active as orders_per_active_month,
        avg_active_months
    FROM count_active_cus_month CROSS JOIN orders
                                CROSS JOIN avg_age
    GROUP BY total_active, aov, avg_active_months
)
SELECT
    ROUND(aov, 2) as aov, 
    ROUND(orders_per_active_month, 2) as orders_per_active_month, 
    ROUND(avg_active_months, 2) as avg_active_months,
    ROUND(aov * orders_per_active_month * avg_active_months, 2) as estimated_ltv
FROM avg_active_months
