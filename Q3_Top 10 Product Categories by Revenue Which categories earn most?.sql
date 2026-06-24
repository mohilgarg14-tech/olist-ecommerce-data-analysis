WITH product_category_revenue AS (
  SELECT opr.product_category_name as product_category,
    ROUND(SUM(op.payment_value), 1) as revenue
  FROM `olist.olist_order_payments` op
  JOIN `olist.olist_order_items` oi
  ON op.order_id = oi.order_id
  JOIN `olist.olist_products_dataset`  opr
  ON oi.product_id = opr.product_id
  GROUP BY product_category
  )

  SELECT * FROM product_category_revenue
  ORDER BY revenue DESC
  LIMIT 10;