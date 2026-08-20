-- Xom Data · Total payroll by org branch
-- Problem: https://xomdata.com/practice/hard-recursive-001
-- Solved: 2026-08-20

WITH RECURSIVE find_subs AS(
    SELECT 
        id as ancestor, 
        id as descendant
    FROM employees

    UNION ALL 

    SELECT 
        f.ancestor, 
        e.id as descendant
    FROM employees e JOIn find_subs f ON e.manager_id = f.descendant
), 
count_direct_reports AS(
    SELECT 
        manager_id,
        COUNT(*) as direct_reports
    FROM employees
    GROUP BY manager_id
)
SELECT 
    ancestor as manager_id, 
    e.name as manager_name,
    direct_reports,
    COUNT(CASE WHEN ancestor = e.id THEN 1 END) as subtree_size, 
    SUM(subs.salary) as subtree_salary
FROM find_subs s JOIN count_direct_reports c ON c.manager_id = s.ancestor
                 JOIN employees e ON s.ancestor = e.id
                 JOIN employees subs ON s.descendant = subs.id
GROUP BY ancestor, e.name, direct_reports
ORDER BY subtree_salary desc, manager_id asc
