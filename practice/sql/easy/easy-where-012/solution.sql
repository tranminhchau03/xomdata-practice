-- Xom Data · Books priced above a threshold
-- Problem: https://xomdata.com/practice/easy-where-012
-- Solved: 2026-07-21

SELECT title, price
from books
where price > 100000
order by price desc
