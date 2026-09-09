-- Xom Data · Còn quay lại trong tuần kế tiếp không
-- Problem: https://xomdata.com/practice/hard-retention-003
-- Solved: 2026-09-09

WITH rn as(
    SELECT DISTINCT
        customer_id, 
        CAST((JULIANDAY(order_date) - JULIANDAY('2024-01-01')) / 7 as INTEGER) + 1 as num_W
    FROM orders
),
find_cohortW as(
    SELECT 
        customer_id, 
        MIN(num_W) as cohort_week
    FROM rn
    GROUP BY customer_id
),
count_cohort_size as (
    SELECT 
        cohort_week,
        COUNT(*) as cohort_size
    FROM find_cohortW
    GROUP BY cohort_week
),
find_retained as(
    SELECT 
        cohort_week,
        COUNT(DISTINCT w.customer_id) as retained
    FROM find_cohortW w JOIN rn r ON w.customer_id = r.customer_id AND r.num_W = w.cohort_week + 1
    GROUP BY cohort_week
)
SELECT 
    s.cohort_week,
    s.cohort_size, 
    COALESCE(r.retained, 0) as retained_next_week
FROM count_cohort_size s LEFT JOIN find_retained r USING(cohort_week)
ORDER BY s.cohort_week asc;
