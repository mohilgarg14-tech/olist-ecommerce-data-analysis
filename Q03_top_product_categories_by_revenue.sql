-- Q03: Top 10 Product Categories by Revenue
-- Business question: Which categories earn the most?

SELECT
  COALESCE(t.string_field_1, p.product_category_name) AS product_category,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(pay.payment_value), 2) AS total_revenue
FROM `olist.olist_orders` AS o
JOIN `olist.olist_order_items` AS i
  ON o.order_id = i.order_id
JOIN `olist.olist_products_dataset` AS p
  ON i.product_id = p.product_id
LEFT JOIN `olist.product_category_name_translation` AS t
  ON p.product_category_name = t.string_field_0
JOIN `olist.olist_order_payments` AS pay
  ON o.order_id = pay.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY product_category
ORDER BY total_revenue DESC
LIMIT 10;
