-- Xom Data · TWAP per stock symbol
-- Problem: https://xomdata.com/practice/sql-nightmare-010
-- Solved: 2026-09-16

WITH next_t as(
    SELECT
        *,
        LEAD(tick_time) OVER (PARTITION BY symbol ORDER BY tick_time asc) as next_time
    FROM price_ticks
    ORDER BY tick_time asc
),
calc_diff_durations as (
    SELECT *, 
        (JULIANDAY(next_time) - JULIANDAY(tick_time)) * 24.0 * 60 as diff
    FROM next_t 
    WHERE next_time IS NOT NULL
)
SELECT 
    symbol,
    ROUND(SUM(price * diff) / SUM(diff), 4) as twap
FROM calc_diff_durations 
GROUP BY symbol
ORDER BY symbol asc
