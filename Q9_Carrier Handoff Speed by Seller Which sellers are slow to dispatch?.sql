SELECT
  s.seller_id,
  DATE_DIFF(o.order_delivered_carrier_date, o.order_approved_at, DAY)
    AS dispatch_time,
  DENSE_RANK()
    OVER (
      ORDER BY
        DATE_DIFF(o.order_delivered_carrier_date, o.order_approved_at, DAY) DESC
    ) AS Ranking
FROM `olist.olist_orders` o
JOIN `olist.olist_order_items` i
  ON o.order_id = i.order_id
JOIN `olist.olist_sellers` s
  ON i.seller_id = s.seller_id
WHERE
  o.order_approved_at IS NOT NULL AND o.order_delivered_carrier_date IS NOT NULL
ORDER BY dispatch_time DESC;
