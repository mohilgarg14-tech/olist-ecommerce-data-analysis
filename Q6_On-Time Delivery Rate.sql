WITH
  d AS (
    SELECT
      *,
      (
        CASE
          WHEN order_delivered_carrier_date <= order_estimated_delivery_date
            THEN 1
          ELSE 0
          END) AS delivery_on_time,
    FROM `olist.olist_orders`
  )
SELECT ROUND(d1.cnt / (d1.cnt + d2.cnt) * 100, 2) AS Delivered_on_time_pct
FROM
  (
    SELECT delivery_on_time, COUNT(delivery_on_time) AS cnt
    FROM d
    GROUP BY delivery_on_time
  ) AS d1
JOIN
  (
    SELECT delivery_on_time, COUNT(delivery_on_time) AS cnt
    FROM d
    GROUP BY delivery_on_time
  ) AS d2
  ON d1.delivery_on_time = d2.delivery_on_time + 1;
