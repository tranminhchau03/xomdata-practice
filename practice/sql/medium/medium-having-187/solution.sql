-- Xom Data · Players with 3 or more goals
-- Problem: https://xomdata.com/practice/medium-having-187
-- Solved: 2026-07-17

WITH count_info AS(
    SELECT 
        p.full_name,
        p.positions,
        t.team_name,
        COUNT(DISTINCT g.id) AS goal_count,
        COUNT(DISTINCT g.match_id) AS scoring_matches, 
        COUNT(DISTINCT pt.id) AS cards_received
    FROM teams t JOIN players p ON t.id = p.team_id
                JOIN goals g ON p.id = g.player_id
                LEFT JOIN penalties pt ON p.id = pt.player_id
    GROUP BY p.full_name, p.positions, t.team_name
),
goals_per_game AS(
    SELECT
        full_name,
        positions,
        team_name,
        goal_count,
        scoring_matches,
        cards_received,
        ROUND(goal_count * 1.0 / scoring_matches, 2) AS goals_per_match
    FROM count_info
)
SELECT 
    full_name,
    positions,
    team_name,
    goal_count,
    scoring_matches,
    cards_received,
    goals_per_match,
    -- trb moi tran ghi bao nhieu ban
    DENSE_RANK() OVER (ORDER BY goals_per_match DESC) AS efficiency_rank, -- sai o day
    -- tong so ban thang, ko quan tam bao nhieu tran
    RANK() OVER (ORDER BY goal_count DESC) AS volume_rank
FROM goals_per_game
WHERE goal_count >= 3 AND cards_received < 5
ORDER BY efficiency_rank ASC, full_name ASC
