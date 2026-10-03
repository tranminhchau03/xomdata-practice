-- Xom Data · Next session with a higher price
-- Problem: https://xomdata.com/practice/nightmare-nextgreater-001
-- Solved: 2026-10-03

SELECT 
    p1.day, 
    p1.price, 
    MIN(p2.day) as next_higher_day, 
    MIN(p2.day) - p1.day as days_until
FROM prices p1 LEFT JOIN prices p2 ON p1.day < p2.day AND p1.price < p2.price
GROUP BY p1.day, p1.price
ORDER BY p1.day
