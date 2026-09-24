-- Xom Data · Tỷ lệ thất thoát khách theo từng tháng
-- Problem: https://xomdata.com/practice/hard-churn-003
-- Solved: 2026-09-24

WITH pair as(
    SELECT DISTINCT
        customer_id, 
        strftime('%Y-%m', order_date) as month, 
        CAST(strftime('%Y', order_date) as INTEGER) * 12 + 
        CAST(strftime('%m', order_date) as INTEGER) as midx
    FROM orders
), 
prev_months as(
    SELECT *, 
        LEAD(midx) OVER (PARTITION BY customer_id ORDER BY midx asc) as next
    FROM pair
    -- WHERE month < (SELECT MAX(strftime('%Y-%m', order_date)) FROM orders)
),
count_customers as(
    SELECT
        month, 
        COUNT(DISTINCT customer_id) as active_customers, 
        COUNT(DISTINCT CASE WHEN next - midx > 1 THEN customer_id 
                            WHEN next - midx IS NULL THEN customer_id 
                        END) as churned_customers
    FROM prev_months
    WHERE month < (SELECT MAX(strftime('%Y-%m', order_date)) FROM orders)
    GROUP BY month
)
SELECT 
    month, 
    active_customers, 
    churned_customers, 
    ROUND(churned_customers * 100. / active_customers, 2) as churn_rate_pct
FROM count_customers
ORDER BY month asc
