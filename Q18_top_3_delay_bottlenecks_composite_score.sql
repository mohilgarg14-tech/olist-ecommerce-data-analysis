-- Q18: Top 3 Delay Bottlenecks
-- Business question: Which sellers combine high delay, slow corridors, and poor reviews?

WITH seller_delay AS (
  SELECT
    i.seller_id,
    COUNT(DISTINCT o.order_id) AS delayed_orders,
    ROUND(AVG(DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_estimated_delivery_date), DAY)), 2)
      AS avg_delay_days
  FROM `olist.olist_orders` AS o
  JOIN `olist.olist_order_items` AS i
    ON o.order_id = i.order_id
  WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
  GROUP BY i.seller_id
),
seller_reviews AS (
  SELECT
    i.seller_id,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
  FROM `olist.order_reviews` AS r
  JOIN `olist.olist_order_items` AS i
    ON r.order_id = i.order_id
  GROUP BY i.seller_id
),
seller_volume AS (
  SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
  FROM `olist.olist_order_items`
  GROUP BY seller_id
),
scored AS (
  SELECT
    d.seller_id,
    v.total_orders,
    d.delayed_orders,
    d.avg_delay_days,
    r.review_count,
    r.avg_review_score,
    ROUND(SAFE_DIVIDE(d.delayed_orders, v.total_orders) * 100, 2) AS delayed_order_pct,
    ROUND(
      (0.45 * d.avg_delay_days)
      + (0.35 * SAFE_DIVIDE(d.delayed_orders, v.total_orders) * 100)
      + (0.20 * (5 - COALESCE(r.avg_review_score, 5))),
      2
    ) AS bottleneck_score
  FROM seller_delay AS d
  JOIN seller_volume AS v
    ON d.seller_id = v.seller_id
  LEFT JOIN seller_reviews AS r
    ON d.seller_id = r.seller_id
  WHERE v.total_orders >= 5
)

SELECT *
FROM scored
ORDER BY bottleneck_score DESC
LIMIT 3;
