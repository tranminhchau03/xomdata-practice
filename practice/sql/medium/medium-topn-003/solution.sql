-- Xom Data · Shift bonus for every top performer
-- Problem: https://xomdata.com/practice/medium-topn-003
-- Solved: 2026-10-08

-- Write your SQL here
WITH ranked as(
    SELECT 
        store, 
        staff_name,
        orders_served,
        DENSE_RANK() OVER (PARTITION BY store ORDER BY orders_served desc) as rk
    FROM shift_stats
)
SELECT 
    store, 
    staff_name, 
    orders_served
FROM ranked
WHERE rk = 1
ORDER BY store, staff_name
