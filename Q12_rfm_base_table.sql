-- Q12: RFM Base Table
-- Business question: Build recency, frequency, and monetary metrics per customer.

SELECT
  c.customer_unique_id,
  DATE_DIFF(
    DATE((SELECT MAX(order_purchase_timestamp) FROM `olist.olist_orders`)),
    DATE(MAX(o.order_purchase_timestamp)),
    DAY
  ) AS recency_days,
  COUNT(DISTINCT o.order_id) AS frequency,
  ROUND(SUM(p.payment_value), 2) AS monetary_value
FROM `olist.olist_customers` AS c
JOIN `olist.olist_orders` AS o
  ON c.customer_id = o.customer_id
JOIN `olist.olist_order_payments` AS p
  ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id
ORDER BY monetary_value DESC;
