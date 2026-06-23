-- Q09: Carrier Handoff Speed by Seller
-- Business question: Which sellers are slow to dispatch?

SELECT
  i.seller_id,
  COUNT(DISTINCT o.order_id) AS shipped_orders,
  ROUND(
    AVG(DATE_DIFF(DATE(o.order_delivered_carrier_date), DATE(o.order_approved_at), DAY)),
    2
  ) AS avg_dispatch_days,
  DENSE_RANK() OVER (
    ORDER BY AVG(DATE_DIFF(DATE(o.order_delivered_carrier_date), DATE(o.order_approved_at), DAY)) DESC
  ) AS slow_dispatch_rank
FROM `olist.olist_orders` AS o
JOIN `olist.olist_order_items` AS i
  ON o.order_id = i.order_id
WHERE o.order_approved_at IS NOT NULL
  AND o.order_delivered_carrier_date IS NOT NULL
GROUP BY i.seller_id
HAVING shipped_orders >= 5
ORDER BY avg_dispatch_days DESC;
