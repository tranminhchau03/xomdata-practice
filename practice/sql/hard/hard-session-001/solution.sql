-- Xom Data · Sessionize logins with a 30-minute gap
-- Problem: https://xomdata.com/practice/hard-session-001
-- Solved: 2026-10-12

WITH 
prev as(
    SELECT
        user_id, 
        event_at,
        LAG(event_at) OVER (PARTITION BY user_id ORDER BY datetime(event_at) asc) as prev
    FROM events
),
calc_minute_diff as(
    SELECT 
        user_id,
        event_at,
        prev,
        (JULIANDAY(datetime(event_at)) - JULIANDAY(datetime(prev))) * 86400 / 60 as min_diff
    FROM prev
),
flag as(
    SELECT 
        user_id, 
        event_at,
        min_diff,
        prev,
        CASE WHEN min_diff > 30 OR prev IS NULL THEN 1
            ELSE 0
        END as new_session
    FROM calc_minute_diff
), 
count_session as(
    SELECT 
        user_id, 
        event_at,
        min_diff,
        prev,
        SUM(new_session) OVER (PARTITION BY user_id ORDER BY event_at) as session_seq
    FROM flag
)
SELECT
    user_id, 
    session_seq,
    COUNT(*) as n_events,
    MIN(event_at) as session_start,
    MAX(event_at) as session_end,
    ROUND((JULIANDAY(datetime(MAX(event_at))) - JULIANDAY(datetime(MIN(event_at)))) * 86400 / 60, 1) as duration_min
FROM count_session
GROUP BY user_id, session_seq
ORDER BY user_id, session_seq
