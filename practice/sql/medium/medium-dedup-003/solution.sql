-- Xom Data · Latest readings and over-limit alerts
-- Problem: https://xomdata.com/practice/medium-dedup-003
-- Solved: 2026-08-17

-- Viết SQL của bạn ở đây
SELECT 
    sensor_name, 
    reading_date, 
    temp_c, 
    max_temp, 
    CASE 
        WHEN  temp_c <= max_temp THEN 'Normal'
        ELSE 'Alert'
    END AS status
FROM sensors s JOIN readings r ON s.id = r.sensor_id
WHERE reading_date in (SELECT MAX(reading_date)
                       FROM readings
                       GROUP BY sensor_id)
ORDER BY sensor_name asc
