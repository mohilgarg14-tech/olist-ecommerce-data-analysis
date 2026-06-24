SELECT
  p.product_category_name,
  ROUND(
    AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_approved_at, DAY)),
    1) AS avg_delivery_time_days,
  APPROX_QUANTILES(
    DATE_DIFF(o.order_delivered_customer_date, o.order_approved_at, DAY),
    100)[OFFSET(50)] AS median_delivery_time_days,
  APPROX_QUANTILES(
    DATE_DIFF(o.order_delivered_customer_date, o.order_approved_at, DAY),
    100)[OFFSET(90)] AS p90_delivery_time_days,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM `olist.olist_orders` o
JOIN `olist.olist_order_items` i
  ON o.order_id = i.order_id
JOIN `olist.olist_products_dataset` p
  ON i.product_id = p.product_id
WHERE
  o.order_approved_at IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING total_orders >= 10
ORDER BY p90_delivery_time_days DESC, avg_delivery_time_days DESC;
