-- Xom Data · How much of a customer's life is the first month
-- Problem: https://xomdata.com/practice/hard-ltv-004
-- Solved: 2026-10-26

WITH first_month as(
    SELECT DISTINCT
        customer_id,
        TO_CHAR(MIN(order_date::DATE), 'YYYY-MM') as cohort_month   
        -- SUM(amount)
    FROM orders
    GROUP BY customer_id
),
cohort_revenue as(
    SELECT 
        cohort_month,
        SUM(amount) as first_month_revenue
    FROM first_month f JOIN orders o ON f.customer_id = o.customer_id 
                                    AND f.cohort_month = TO_CHAR(o.order_date::DATE, 'YYYY-MM')
    GROUP BY cohort_month
),
lifetime_revenues as(
    SELECT
        f.cohort_month, 
        first_month_revenue,
        SUM(amount) as lifetime_revenue
    FROM first_month f JOIN orders o ON f.customer_id = o.customer_id
                    JOIN cohort_revenue c ON f.cohort_month = c.cohort_month
    GROUP BY f.cohort_month, first_month_revenue
)
SELECT
    cohort_month, 
    first_month_revenue,
    lifetime_revenue,
    ROUND(first_month_revenue * 100. / lifetime_revenue, 2) as first_month_share_pct
FROM lifetime_revenues
ORDER BY cohort_month
