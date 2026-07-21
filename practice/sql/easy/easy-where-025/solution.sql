-- Xom Data · Heavy shipments
-- Problem: https://xomdata.com/practice/easy-where-025
-- Solved: 2026-07-21

select
    waybill_code,
    weight_kg,
    shipping_fee
from shipments
where weight_kg > 3
order by weight_kg desc
