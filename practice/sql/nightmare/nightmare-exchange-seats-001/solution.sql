-- Xom Data · Swap seats in pairs (1↔2, 3↔4, …)
-- Problem: https://xomdata.com/practice/nightmare-exchange-seats-001
-- Solved: 2026-10-05

SELECT 
    s1.id, 
    CASE WHEN s2.student IS NOT NULL THEN s2.student
         ELSE s1.student
    END as student
FROM Seats s1 LEFT JOIN Seats s2
    ON s2.id = CASE WHEN s1.id % 2 = 1 THEN s1.id + 1 
                    ELSE s1.id - 1
               END
ORDER BY id
