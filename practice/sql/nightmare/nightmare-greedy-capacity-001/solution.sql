-- Xom Data · Maximize inventory under an area limit
-- Problem: https://xomdata.com/practice/nightmare-greedy-capacity-001
-- Solved: 2026-09-14

WITH prime_infos as(
    SELECT 
        'prime' as item_type, 
        COUNT(*) as items_taken,
        COALESCE(SUM(sqft), 0) as total_prime_sqft
    FROM items
    WHERE item_type = 'prime'
    -- GROUP BY item_type
),
non_prime_infos as (
    SELECT 
        'non_prime' as item_type, 
        sqft, 
        item_id
    FROM items 
    WHERE item_type = 'non_prime'
),
cumulative_non_prime as(
    SELECT 
        'non_prime' as item_type,
        item_id,
        sqft,
        total_prime_sqft,
        total_prime_sqft + COALESCE(sum(sqft) OVER (ORDER BY sqft asc, item_id asc), 0) as capacity
    FROM prime_infos LEFT JOIN non_prime_infos n ON TRUE
)
-- select * from cumulative_non_prime
select distinct 
    item_type, 
    count(case when capacity <= 500000 and item_id IS NOT NULL then 1 end) OVER() as items_taken, 
    COALESCE(sum(case when capacity <= 500000 then sqft else 0 end) OVER(), 0) as sqft_used
from cumulative_non_prime
    UNION ALL
SELECT * 
FROM prime_infos
ORDER BY item_type asc
