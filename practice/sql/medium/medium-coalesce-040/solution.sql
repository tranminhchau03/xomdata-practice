-- Xom Data · Book count and average price by genre
-- Problem: https://xomdata.com/practice/medium-coalesce-040
-- Solved: 2026-07-21

WITH 
price_info as(
    SELECT 
        g.genre_name,
        g.id,
        COUNT(b.id) as book_count,
        AVG(b.price) as avg_price,
        MIN(b.price) as min_price,
        MAX(b.price) as max_price,
        MAX(b.price) - MIN(b.price) as price_range
    FROM genres g LEFT JOIN books b ON g.id = b.genre_id
    GROUP BY g.genre_name, g.id
)
SELECT 
    genre_name,
    COALESCE(book_count, 0) as book_count,
    COALESCE(ROUND(avg_price, 0), 0) as avg_price,
    COALESCE(min_price, 0) as min_price,
    COALESCE(max_price, 0) as max_price,
    COALESCE(price_range, 0) as price_range,
    RANK() OVER (ORDER BY book_count DESC) as coverage_rank,
    NTILE(3) OVER (ORDER BY book_count DESC) as library_focus
FROM price_info
ORDER BY coverage_rank ASC, genre_name ASC
