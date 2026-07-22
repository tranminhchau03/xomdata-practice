-- Xom Data · Detect anomalous days vs the average
-- Problem: https://xomdata.com/practice/hard-anomaly-001
-- Solved: 2026-07-22

WITH 
messure as(
    SELECT 
        date,
        value,
        AVG(value) OVER () as mean,
        STDDEV_POP(value) OVER() as stddev
    FROM daily_metrics
),
calc_z_score as(
    SELECT 
        date, value, 
        ROUND(mean, 2) as mean, 
        ROUND(stddev, 2) as stddev,
        ROUND(
            CASE 
                WHEN stddev = 0 THEN 0
                ELSE (value - mean) / stddev
            END, 2) as z_score
    FROM messure
)
SELECT 
    date, 
    value, 
    mean,
    stddev,
    z_score, 
    CASE 
        WHEN stddev = 0 THEN 'normal'
        WHEN z_score > 2 THEN 'high'
        WHEN z_score < -2 THEN 'low'
        ELSE 'normal'
    END as flag
FROM calc_z_score
ORDER BY date asc
