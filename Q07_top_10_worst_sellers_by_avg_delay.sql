-- Q07: Top 10 Worst Sellers by Average Delay
-- Business question: Which sellers fail customers most?

SELECT
  i.seller_id,
  COUNT(DISTINCT o.order_id) AS delayed_orders,
  ROUND(
    AVG(DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_estimated_delivery_date), DAY)),
    2
  ) AS avg_delay_days,
  MAX(DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_estimated_delivery_date), DAY))
    AS max_delay_days
FROM `olist.olist_orders` AS o
JOIN `olist.olist_order_items` AS i
  ON o.order_id = i.order_id
WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY i.seller_id
HAVING delayed_orders >= 5
ORDER BY avg_delay_days DESC
LIMIT 10;
