-- Xom Data · Top-scoring players
-- Problem: https://xomdata.com/practice/easy-where-027
-- Solved: 2026-07-21

select 
    full_name,
    goals_scored
FROM players
where goals_scored > 10
order by goals_scored desc
