-- Xom Data · Each device's next service date
-- Problem: https://xomdata.com/practice/medium-lead-001
-- Solved: 2026-10-31

-- Write your SQL here
SELECT
    device_code,
    service_date,
    LEAD(service_date) OVER (PARTITION BY device_code ORDER BY service_date) as next_service
FROM service_log
ORDER BY device_code, service_date
