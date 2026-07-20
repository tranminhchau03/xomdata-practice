-- Xom Data · Top 10 most-borrowed books
-- Problem: https://xomdata.com/practice/medium-subquery-198
-- Solved: 2026-07-20

WITH 
count_book_loans AS(
    SELECT book_id, COUNT(id) as borrow_count
    FROM book_loans
    GROUP BY book_id
),
count_book_reservations AS(
    SELECT   
        book_id,
        COUNT(*) as pending_reservation
    FROM reservations 
    WHERE status = 'ready_pickup'
    GROUP BY book_id
),
total_engagement AS (
    SELECT  
        b.title,
        a.full_name as authors,
        publisher_name,
        b.genre_id,
        g.genre_name,
        borrow_count,
        COALESCE(pending_reservation, 0) as pending_reservation,
        borrow_count + COALESCE(pending_reservation, 0)  AS engagement
    FROM count_book_loans l -- chi lay sach tung duoc muon nen loans table is a center
                JOIN books b ON l.book_id = b.id
                JOIN authors a ON b.author_id = a. id
                JOIN publishers p ON p.id = b.publisher_id
                JOIN genres g ON b.genre_id = g.id
                LEFT JOIN count_book_reservations r ON r.book_id = l.book_id
)
SELECT
    title,
    authors, 
    publisher_name, 
    genre_name, 
    borrow_count,
    pending_reservation,
    engagement,
    DENSE_RANK() OVER (ORDER BY engagement DESC) as overall_rank,
    RANK() OVER (PARTITION BY genre_id ORDER BY engagement DESC) as rank_in_genre
FROM total_engagement
ORDER BY overall_rank ASC, title ASC
LIMIT 10

-- SELECT 
--     b.title,
--     a.full_name as authors, 
--     p.publisher_name,
--     g.genre_name, 
--     COUNT(DISTINCT l.id) as borrow_count
-- FROM books b JOIN authors a ON b.author_id = a.id
--              JOIN publishers p ON b.publisher_id = b.id
--              JOIN genres g ON b.genre_id = g.id
--              -- chi lay sach da tun duoc muon
--              RIGHT JOIN book_loans l ON b.id = l.book_id
--              RIGHT JOIN reservations r ON b.id = r.book_id
-- WHERE r.status = 'ready_pickup'
-- GROUP BY b.title, a.full_name, p.publisher_name, g.genre_name
