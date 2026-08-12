-- Xom Data · Grand final leaderboard
-- Problem: https://xomdata.com/practice/medium-rank-001
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    rank() OVER (order by points desc) as final_rank, 
    player_name, 
    points
FROM players
ORDER BY final_rank asc, player_name asc
