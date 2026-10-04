-- Xom Data · Advertiser status by month (4 states)
-- Problem: https://xomdata.com/practice/nightmare-statemachine-001
-- Solved: 2026-10-04

WITH RECURSIVE 
grp_active as(
    SELECT DISTINCT
        advertiser_id, 
        month
    FROM advertiser_activity
), 
scope as(
    SELECT 
        MIN(month) as started, 
        MAX(month) as ended
    FROM grp_active 
), 
generate_months as(
    SELECT 
        started as list_month
    FROM scope

    UNION ALL 
    
    SELECt 
        strftime('%Y-%m', DATE(list_month || '-01', '+1 month'))
    FROM generate_months CROSS JOIN scope
    WHERE list_month < ended
), 
new_ad as(
    SELECT DISTINCT
        a.advertiser_id, 
        g.list_month
    FROM advertiser_activity a CROSS JOIN generate_months g
), 
flag as(
    SELECT 
        n.advertiser_id, 
        n.list_month, 

        -- CURRENT ACTIVE
        CASE WHEN a.month IS NOT NULL THEN 1 ELSE 0 END as current_active,

        -- prev active 
        LAG(
            CASE WHEN a.month IS NOT NULL THEN 1 ELSE 0 END 
        ) OVER (PARTITION BY n.advertiser_id 
                ORDER BY     n.list_month) 
        as prev_active,
        
        -- before active
        MAX(
            CASE WHEN a.month IS NOT NULL THEN 1 ELSE 0 END
        ) OVER (PARTITION BY n.advertiser_id
                ORDER BY     n.list_month
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)
        as had_actived_before

    FROM new_ad n 
        LEFT JOIN advertiser_activity a ON n.advertiser_id = a.advertiser_id
        AND n.list_month = a.month
), 
assign_state as(
    SELECT 
        advertiser_id, 
        list_month, 
        CASE WHEN current_active = 1 AND (had_actived_before = 0 or had_actived_before IS NULL)  THEN 'NEW'
             WHEN current_active = 1 AND prev_active = 1        THEN 'EXISTING'
             WHEN current_active = 0 AND prev_active = 1        THEN 'CHURN'
             WHEN current_active = 1 AND prev_active = 0
                                     AND had_actived_before = 1 THEN 'RESURRECT'
        END as state
    FROM flag
)
SELECT 
    advertiser_id,
    list_month as month,
    state
FROM assign_state
WHERE state IS NOT NULL
ORDER BY advertiser_id, month
