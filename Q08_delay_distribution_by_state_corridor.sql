-- Q08: Delay Distribution by State Corridor
-- Business question: Which seller-to-customer state corridors are slowest?

SELECT
  s.seller_state,
  c.customer_state,
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
JOIN `olist.olist_sellers` AS s
  ON i.seller_id = s.seller_id
JOIN `olist.olist_customers` AS c
  ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY s.seller_state, c.customer_state
HAVING delayed_orders >= 5
ORDER BY avg_delay_days DESC, delayed_orders DESC;
