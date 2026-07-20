-- Xom Data · Investor trade summary
-- Problem: https://xomdata.com/practice/medium-agg-137
-- Solved: 2026-07-20

-- Summarize buy/sell totals per investor
WITH 
profit_side as(
  SELECT
    i.full_name,
    count(t.side) as total_trades,
    i.segment,
    SUM(
      CASE
        WHEN side = 'buy' THEN amount
        ELSE 0
      END
    ) as total_bought,
    SUM(
      CASE
        WHEN side = 'sell' THEN amount
        ELSE 0
      END
    ) as total_sold
  FROM investors i JOIN trades t ON t.investor_id = i.id
  GROUP BY i.id
),
calc_net AS (
  SELECT 
    full_name, 
    total_trades,
    segment,
    total_bought,
    total_sold, 
    total_bought - total_sold as net_position,
    total_bought + total_sold as total_transaction
  FROM profit_side
)
SELECT 
  full_name, 
  segment,
  total_trades,
  total_bought,
  total_sold, 
  net_position,
  CASE 
    WHEN net_position > 0 THEN 'Bull'
    WHEN net_position < 0 THEN 'Bear'
    ELSE 'Neutral'
  END as stance,
  DENSE_RANK() OVER (PARTITION BY segment ORDER BY total_transaction DESC) as rank_in_segment
FROM calc_net
ORDER BY total_transaction DESC, full_name ASC
