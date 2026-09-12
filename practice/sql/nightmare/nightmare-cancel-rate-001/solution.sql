-- Xom Data · Daily trip cancellation rate (unbanned users/drivers only)
-- Problem: https://xomdata.com/practice/nightmare-cancel-rate-001
-- Solved: 2026-09-12

WITH filters_banned AS(
    SELECT *
    FROM Trips t JOIN Users c ON t.client_id = c.users_id  
                JOIN Users d ON t.driver_id = d.users_id 
    WHERE c.banned NOT LIKE 'Yes' AND d.banned NOT LIKE 'Yes'
        AND request_at BETWEEN '2024-01-01' AND '2024-01-03'
)
SELECT 
    DATE(request_at) as Day,
    ROUND(
        COUNT(CASE WHEN status LIKE 'cancelled%' THEN 1 END) * 1.0 /
        COUNT(*)
    , 2) as Cancellation_Rate
FROM filters_banned
GROUP BY DATE(request_at)
ORDER BY day asc
