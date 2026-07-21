-- Xom Data · Goals and cards by team
-- Problem: https://xomdata.com/practice/medium-join-186
-- Solved: 2026-07-21

WITH 
calc_per_team as(
    SELECT 
        t.team_name,
        t.city,
        count(DISTINCT p.id) as player_count,
        COUNT(DISTINCT g.id) as total_goals_scored,
        COUNT(DISTINCT pnt.id) as penalty_count
    FROM teams t JOIN players p ON t.id = p.team_id
                 LEFT JOIN goals g ON p.id = g.player_id
                 LEFT JOIN penalties pnt ON p.id = pnt.player_id
    GROUP BY t.team_name, t.city
)
SELECT 
    team_name,
    city,
    player_count,
    total_goals_scored,
    penalty_count,
    CAST(total_goals_scored * 1.0 / player_count as REAL) as goals_per_player, 
    ROUND(penalty_count * 1.0 / player_count, 2) as cards_per_player,
    RANK() OVER (ORDER BY total_goals_scored DESC) as scoring_rank,
    SUM(total_goals_scored) OVER (ORDER BY total_goals_scored DESC) as cumulative_goals
FROM calc_per_team
ORDER BY scoring_rank ASC, team_name ASC
