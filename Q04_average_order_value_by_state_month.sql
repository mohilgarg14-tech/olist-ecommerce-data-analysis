-- Q04: Average Order Value by State and Month
-- Business question: Where are high-value customers?

WITH order_values AS (
  SELECT
    o.order_id,
    DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS order_month,
    c.customer_state,
    SUM(p.payment_value) AS order_value
  FROM `olist.olist_orders` AS o
  JOIN `olist.olist_customers` AS c
    ON o.customer_id = c.customer_id
  JOIN `olist.olist_order_payments` AS p
    ON o.order_id = p.order_id
  WHERE o.order_status NOT IN ('canceled', 'unavailable')
  GROUP BY o.order_id, order_month, c.customer_state
)

SELECT
  order_month,
  customer_state,
  COUNT(order_id) AS total_orders,
  ROUND(AVG(order_value), 2) AS average_order_value,
  ROUND(SUM(order_value), 2) AS total_revenue
FROM order_values
GROUP BY order_month, customer_state
ORDER BY order_month, average_order_value DESC;
