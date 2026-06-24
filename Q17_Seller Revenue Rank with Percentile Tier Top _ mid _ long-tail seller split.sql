WITH
  seller_revenue AS (
    SELECT
      s.seller_id,
      ROUND(SUM(p.payment_value), 2) AS total_payment,
      DENSE_RANK() OVER (ORDER BY ROUND(SUM(p.payment_value), 2)) AS  `rank`,
      ROW_NUMBER() OVER (ORDER BY ROUND(SUM(p.payment_value), 2)) AS r
    FROM `olist.olist_sellers` s
    JOIN `olist.olist_order_items` i
      ON s.seller_id = i.seller_id
    JOIN `olist.olist_order_payments` p
      ON i.order_id = p.order_id
    GROUP BY s.seller_id
  ),
  selt AS (
    SELECT
      seller_id,
      total_payment,
      ROUND(
        ((r - 1) + (duplicate_rank_count * 0.5))
          / (SELECT COUNT(*) FROM seller_revenue)
          * 100,
        2) AS percentile, `rank`
    FROM
      (
        SELECT
          *,
          COUNT(*)
            OVER (PARTITION BY CAST(total_payment AS STRING))
            AS duplicate_rank_count
        FROM seller_revenue
      ) AS sub
    ORDER BY total_payment DESC
  )
SELECT
  *,
  CASE
    WHEN percentile >= 66 THEN 'TIER TOP'
    WHEN percentile >= 33 THEN 'TIER MIDDLE'
    ELSE 'TIER BOTTOM'
    END AS tier
FROM selt;
