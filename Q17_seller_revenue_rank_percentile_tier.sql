-- Q17: Seller Revenue Rank with Percentile Tier
-- Business question: Which sellers are top, middle, and long-tail contributors?

WITH seller_revenue AS (
  SELECT
    i.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS seller_revenue
  FROM `olist.olist_order_items` AS i
  JOIN `olist.olist_orders` AS o
    ON i.order_id = o.order_id
  JOIN `olist.olist_order_payments` AS p
    ON i.order_id = p.order_id
  WHERE o.order_status NOT IN ('canceled', 'unavailable')
  GROUP BY i.seller_id
),
ranked AS (
  SELECT
    *,
    DENSE_RANK() OVER (ORDER BY seller_revenue DESC) AS revenue_rank,
    PERCENT_RANK() OVER (ORDER BY seller_revenue) AS percentile_rank
  FROM seller_revenue
)

SELECT
  seller_id,
  total_orders,
  seller_revenue,
  revenue_rank,
  ROUND(percentile_rank * 100, 2) AS percentile,
  CASE
    WHEN percentile_rank >= 0.66 THEN 'Top tier'
    WHEN percentile_rank >= 0.33 THEN 'Mid tier'
    ELSE 'Long tail'
  END AS seller_tier
FROM ranked
ORDER BY seller_revenue DESC;
