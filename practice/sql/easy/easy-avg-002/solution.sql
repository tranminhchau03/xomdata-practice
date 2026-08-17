-- Xom Data · The cafe's average rating
-- Problem: https://xomdata.com/practice/easy-avg-002
-- Solved: 2026-08-17

-- Viết SQL của bạn ở đây
SELECT ROUND(AVG(rating), 2) as avg_rating 
FROM reviews
