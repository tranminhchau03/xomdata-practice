-- Xom Data · Top 3 campaigns by month-over-month growth
-- Problem: https://xomdata.com/practice/nightmare-pipeline-001
-- Solved: 2026-09-23

WITH 
remove_dup as(
    SELECT DISTINCT
        campaign_id,
        spend_date,
        MAX(amount) as amount
        -- LAG(SUM(amount)) OVER (PARTITION BY campaign_id) as prev_total_spend
    FROM campaign_spend
    GROUP BY campaign_id, spend_date
), 
calc_total_spend as(
    SELECT 
        strftime('%Y-%m', spend_date) as month, 
        campaign_id, 
        SUM(amount) as total_spend, 
        LAG(SUM(amount)) OVER ( PARTITION BY campaign_id
                                ORDER BY strftime('%Y-%m', spend_date) asc) as prev_total_spend
    FROM remove_dup
    GROUP BY campaign_id, month
),
calc_pct as(
    SELECT 
        month,
        campaign_id,
        total_spend,
        (total_spend - prev_total_spend) * 100 / prev_total_spend as growth_pct
    FROM calc_total_spend
),
ranked as(
    SELECT 
        month, 
        campaign_id, 
        total_spend, 
        growth_pct, 
        DENSE_RANK() OVER (PARTITION BY month ORDER BY month asc, growth_pct desc, campaign_id asc) as rank_in_month
    FROM calc_pct
    WHERE growth_pct IS NOT NULL
)
SELECT 
    month, 
    campaign_id, 
    total_spend, 
    COALESCE(ROUND(growth_pct, 2), 0) as growth_pct, 
    rank_in_month
FROM ranked
WHERE rank_in_month <= 3
ORDER BY month asc, rank_in_month asc
