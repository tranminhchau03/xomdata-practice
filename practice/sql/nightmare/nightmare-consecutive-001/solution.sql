-- Xom Data · Numbers appearing 3 times in a row in the log
-- Problem: https://xomdata.com/practice/nightmare-consecutive-001
-- Solved: 2026-09-12

WITH prevs as(
    SELECT 
        id,
        CASE WHEN num = LAG(num) OVER (ORDER BY id asc) --as prev_num,
              AND num = LAG(num, 2) OVER (ORDER BY id asc) --as prev_2nd_num
             THEN num
        END as consecutive_num
    FROM Logs
)
SELECT distinct
     consecutive_num
FROM prevs
WHERE consecutive_num IS NOT NULL
ORDER BY consecutive_num asc
