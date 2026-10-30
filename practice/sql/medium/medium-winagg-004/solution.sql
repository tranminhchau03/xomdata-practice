-- Xom Data · How far from the server's top
-- Problem: https://xomdata.com/practice/medium-winagg-004
-- Solved: 2026-10-30

-- Write your SQL here
SELECT
    server,
    player_name,
    points,
    MAX(points) OVER (PARTITION BY server) - points AS gap_to_top
FROM players
ORDER BY server asc, points desc, player_name asc
