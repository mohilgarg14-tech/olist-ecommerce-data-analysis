CREATE OR REPLACE TABLE `olist.RFM`
AS
SELECT
  c.customer_unique_id,
  ROUND(SUM(p.payment_value), 2) AS monetary_value,
  MAX(o.order_purchase_timestamp) AS recency,
  COUNT(o.order_id) AS frequency
FROM `olist.olist_customers` AS c
JOIN `olist.olist_orders` AS o
  ON c.customer_id = o.customer_id
JOIN `olist.olist_order_payments` AS p
  ON o.order_id = p.order_id
GROUP BY c.customer_unique_id;
