-- Xom Data · Top 10 most-engaged posts
-- Problem: https://xomdata.com/practice/medium-groupby-097
-- Solved: 2026-07-19

WITH interactions_info AS(
    SELECT
        u.id,
        u.full_name, 
        p.post_type, 
        p.post_date,
        COALESCE(p.like_count, 0) + COALESCE(p.share_count, 0) + COALESCE(p.comment_count, 0) 
            AS total_interactions
    FROM users u JOIN posts p ON u.id = p.user_id
    -- GROUP BY u.full_name, p.post_type, p.post_date, u.id
)
SELECT
    full_name, 
    post_type,
    post_date,
    total_interactions,
    RANK() OVER (ORDER BY total_interactions DESC) AS overall_rank,
    ROW_NUMBER() 
        OVER (PARTITION BY id ORDER BY total_interactions DESC, post_date ASC) AS rank_in_author,
    ROUND(total_interactions * 100.00 / MAX(total_interactions) OVER (), 2) AS pct_of_top
FROM interactions_info
ORDER BY overall_rank ASC, full_name ASC, rank_in_author ASC
LIMIT 10
