-- Xom Data · Merge overlapping bookings into continuous ranges
-- Problem: https://xomdata.com/practice/nightmare-interval-merge-001
-- Solved: 2026-09-15

WITH prev_end_at as(
    SELECT 
        room_id, 
        start_at,
        end_at,
        -- LAG(end_at) OVER (PARTITION BY room_id ORDER BY end_at) as prev_end,
        MAX(end_at) OVER (PARTITION BY room_id
                          ORDER BY start_at
                          ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) 
            as prev_max_end        
    FROM bookings
),
mark_booked as(
    SELECT
        room_id, 
        start_at, 
        end_at, 
        CASE WHEN prev_max_end is null THEN 1
             WHEN start_at <= prev_max_end THEN 0
             ELSE 1 
        END as booked
    FROM prev_end_at
),
book_list as(
    SELECT 
        room_id, 
        start_at,
        end_at,
        booked,
        SUM(booked) 
            OVER (  PARTITION BY room_id
                    ORDER BY start_at
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as booked_id
    FROM mark_booked
)
SELECT DISTINCT
    room_id,
    Min(start_at) as merged_start,
    MAX(end_at) as merged_end,
    COUNT(*) as n_bookings,
    ROUND((JULIANDAY(MAX(end_at)) - JULIANDAY(Min(start_at))) * 24 * 60) as duration_min
FROM book_list 
GROUP BY room_id, booked_id
ORDER BY room_id, merged_start
