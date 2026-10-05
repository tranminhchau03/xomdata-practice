-- Xom Data · Employee levels in the org chart
-- Problem: https://xomdata.com/practice/sql-nightmare-005
-- Solved: 2026-10-05

WITH RECURSIVE find_subs as(
    SELECT 
        id, 
        name,
        1 as level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL 

    SELECT  
        e.id,
        e.name, 
        level + 1 
    FROM find_subs s JOIN employees e ON s.id = e.manager_id
)
SELECT 
    id, 
    name, 
    level as depth
FROM find_subs
ORDER BY id asc
