-- Xom Data · Rank hotels by room price within each destination
-- Problem: https://xomdata.com/practice/medium-join-155
-- Solved: 2026-07-21

WITH price_info as(
    SELECT 
        h.hotel_name,
        h.star_class,
        d.destination_name,
        d.id as destination_id,
        COUNT(r.id) as room_count,
        MIN(r.nightly_rate) as min_price,
        MAX(r.nightly_rate) as max_price,
        ROUND(AVG(r.nightly_rate), 0) as avg_price,
        MAX(r.nightly_rate) - MIN(r.nightly_rate) as price_spread
    FROM hotels h JOIN destinations d ON d.id = h.destination_id
                JOIN hotel_rooms r ON h.id = r.hotel_id
    GROUP BY h.hotel_name, h.star_class, d.destination_name, d.id
)
SELECT 
    hotel_name, 
    star_class,
    destination_name, 
    room_count, 
    min_price,
    max_price,
    avg_price,
    price_spread,
    RANK() OVER (PARTITION BY destination_id ORDER BY avg_price DESC) as rank_in_destination
FROM price_info
WHERE room_count >= 2
ORDER BY destination_name ASC, rank_in_destination ASC, hotel_name ASC
