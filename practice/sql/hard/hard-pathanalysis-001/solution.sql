-- Xom Data · Most common 3-step user path
-- Problem: https://xomdata.com/practice/hard-pathanalysis-001
-- Solved: 2026-08-13

WITH concat_path AS(
    SELECT 
        user_id,
        page || ' > ' || lead(page) OVER (PARTITION BY user_id ORDER BY viewed_at asc)
             || ' > ' || lead(page, 2) OVER (PARTITION BY user_id ORDER BY viewed_at asc) as path
        -- STRING_AGG(page, ' > ' ORDER BY viewed_at) as path
    FROM page_views
    -- group by user_id
)
SELECT 
    path, 
    COUNT(*) as n_users
FROM concat_path 
WHERE path is not null
GROUP BY path
ORDER BY n_users desc, path asc
LIMIT 10
