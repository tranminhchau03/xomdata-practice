-- Xom Data · Total sales by org branch
-- Problem: https://xomdata.com/practice/hard-hierarchical-001
-- Solved: 2026-07-27

WITH RECURSIVE tree as (
    SELECT 
        id as ancestor, 
        id as descendant
    FROM agents

    UNION ALL 
    SELECT 
        t.ancestor, 
        a.id as descendant
    FROM agents a JOIN tree t ON a.manager_id = t.descendant
)
SELECT 
    a.id as agent_id,
    a.name as agent_name,
    a.direct_sales,
    SUM(ag.direct_sales) as team_total
FROM tree t JOIN agents a ON t.ancestor = a.id
            JOIN agents ag ON ag.id = t.descendant
GROUP BY t.ancestor , a.id, a.name
ORDER BY team_total desc, agent_id asc
