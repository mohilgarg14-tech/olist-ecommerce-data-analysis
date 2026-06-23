-- Q10: Delivery Time Percentiles by Category
-- Business question: Which product types take longest?

SELECT
  COALESCE(t.string_field_1, p.product_category_name) AS product_category,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(
    AVG(DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_approved_at), DAY)),
    2
  ) AS avg_delivery_time_days,
  APPROX_QUANTILES(
    DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_approved_at), DAY),
    100
  )[OFFSET(50)] AS median_delivery_time_days,
  APPROX_QUANTILES(
    DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_approved_at), DAY),
    100
  )[OFFSET(90)] AS p90_delivery_time_days
FROM `olist.olist_orders` AS o
JOIN `olist.olist_order_items` AS i
  ON o.order_id = i.order_id
JOIN `olist.olist_products_dataset` AS p
  ON i.product_id = p.product_id
LEFT JOIN `olist.product_category_name_translation` AS t
  ON p.product_category_name = t.string_field_0
WHERE o.order_approved_at IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND p.product_category_name IS NOT NULL
GROUP BY product_category
HAVING total_orders >= 10
ORDER BY p90_delivery_time_days DESC, avg_delivery_time_days DESC;
