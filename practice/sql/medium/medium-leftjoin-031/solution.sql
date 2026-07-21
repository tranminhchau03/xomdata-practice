-- Xom Data · Candidates not yet interviewed
-- Problem: https://xomdata.com/practice/medium-leftjoin-031
-- Solved: 2026-07-21

WITH queue_info as(
    SELECT 
        c.full_name,
        c.email,
        c.application_date,
        ROW_NUMBER() OVER (ORDER BY c.application_date ASC, c.full_name ASC) as queue_position
    FROM candidates c LEFT JOIN interviews i ON c.id = i.candidate_id
    WHERE i.id IS NULL
)
SELECT 
    full_name,
    email,
    application_date,
    queue_position,
    ROUND(PERCENT_RANK() OVER (ORDER BY queue_position ASC) * 100.00, 2) as older_than_pct
FROM queue_info
ORDER BY queue_position ASC, full_name ASC
