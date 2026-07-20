-- Xom Data · Showtime count and average ticket price per film
-- Problem: https://xomdata.com/practice/medium-join-076
-- Solved: 2026-07-20

WITH showtimes_info AS(
    SELECT 
        m.movie_name, 
        m.genres, 
        COUNT(s.id) AS showtime_count,
        AVG(ticket_price) AS avg_ticket_price
    FROM movies m JOIN showtimes s ON m.id = s.movie_id
    GROUP BY m.movie_name, m.genres
), 
ranking AS(
    SELECT 
        movie_name, 
        genres, 
        showtime_count, 
        avg_ticket_price,
        DENSE_RANK() OVER (PARTITION BY genres ORDER BY avg_ticket_price DESC) AS rank_in_genre
        
    FROM showtimes_info
)
SELECT 
    movie_name, 
    genres, 
    showtime_count, 
    avg_ticket_price,
    rank_in_genre,
    FIRST_VALUE(movie_name) OVER (PARTITION BY genres ORDER BY rank_in_genre ASC) as top_movie_in_genre
FROM ranking
ORDER BY genres ASC, rank_in_genre ASC, movie_name ASC
