-- Xom Data · Group winners in the tournament
-- Problem: https://xomdata.com/practice/nightmare-tournament-001
-- Solved: 2026-10-15

WITH match_winner as(
    SELECT 
        first_player as player_id, 
        1 as win_point
    FROM matches
    WHERE first_score > second_score

    UNION ALL 
    SELECT
        second_player,
        1 
    FROM matches
    WHERE first_score < second_score
), 
sum_scores as(
    SELECT 
        p.group_id,
        p.player_id,
        SUM(COALESCE(win_point, 0)) as total_score
    FROM match_winner w RIGHT JOIN players p ON w.player_id = p.player_id
    GROUP BY p.group_id, p.player_id
),
ranked as(
    SELECT 
        group_id, 
        player_id, 
        ROW_NUMBER() OVER (PARTITION BY group_id ORDER BY total_score desc, player_id asc) as rk
    FROM sum_scores
)
SELECT 
    group_id, 
    player_id
FROM ranked
WHERE rk = 1
ORDER BY group_id
