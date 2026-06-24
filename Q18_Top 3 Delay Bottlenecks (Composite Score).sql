WITH
  seller_rank AS (
    SELECT
      i.seller_id,
      ROUND(
        AVG(
          DATE_DIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date,
            DAY)),
        1) AS avg_delay_days,
      DENSE_RANK()
        OVER (
          ORDER BY
            AVG(
              DATE_DIFF(
                o.order_delivered_customer_date,
                o.order_estimated_delivery_date,
                DAY)) DESC
        ) AS seller_rnk
    FROM `olist.olist_orders` o
    JOIN `olist.olist_order_items` i
      ON o.order_id = i.order_id
    WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
    GROUP BY i.seller_id
  ),

  corridor_delay AS (
    SELECT
      s.seller_state,
      c.customer_state,
      ROUND(
        AVG(
          DATE_DIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date,
            DAY)),
        1) AS avg_corridor_delay,
      DENSE_RANK()
        OVER (
          ORDER BY
            AVG(
              DATE_DIFF(
                o.order_delivered_customer_date,
                o.order_estimated_delivery_date,
                DAY)) DESC
        ) AS volume_rnk
    FROM `olist.olist_orders` o
    JOIN `olist.olist_order_items` i
      ON o.order_id = i.order_id
    JOIN `olist.olist_sellers` s
      ON i.seller_id = s.seller_id
    JOIN `olist.olist_customers` c
      ON o.customer_id = c.customer_id
    WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
    GROUP BY s.seller_state, c.customer_state
  ),

  review_score AS (
    SELECT
      i.seller_id,
      ROUND(AVG(r.review_score), 2) AS avg_review_score,
      COUNT(r.review_id) AS count_of_reviews
    FROM `olist.order_reviews` r
    JOIN `olist.olist_order_items` i
      ON r.order_id = i.order_id
    GROUP BY i.seller_id
  )

SELECT
  s.seller_state,
  s.seller_id,
  sr.seller_rnk,
  cd.volume_rnk,
  rs.avg_review_score,
  ROUND(
    (
      (0.4 * sr.seller_rnk)
      + (0.3 * cd.volume_rnk)
      + (0.3 * rs.avg_review_score)),
    2) AS composite_score
FROM `olist.olist_sellers` s
JOIN seller_rank sr
  ON s.seller_id = sr.seller_id
JOIN review_score rs
  ON s.seller_id = rs.seller_id
JOIN
  (
    SELECT DISTINCT i.seller_id, s.seller_state, c.customer_state
    FROM `olist.olist_order_items` i
    JOIN `olist.olist_orders` o
      ON i.order_id = o.order_id
    JOIN `olist.olist_sellers` s
      ON i.seller_id = s.seller_id
    JOIN `olist.olist_customers` c
      ON o.customer_id = c.customer_id
  ) map
  ON s.seller_id = map.seller_id
JOIN corridor_delay cd
  ON
    map.seller_state = cd.seller_state
    AND map.customer_state = cd.customer_state
ORDER BY composite_score DESC
LIMIT 10;
