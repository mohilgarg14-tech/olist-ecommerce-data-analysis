-- Q02: Revenue by State
-- Business question: Which customer states drive the most revenue?

SELECT
  c.customer_state,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(p.payment_value), 2) AS total_revenue,
  ROUND(AVG(p.payment_value), 2) AS avg_payment_value
FROM `olist.olist_orders` AS o
JOIN `olist.olist_customers` AS c
  ON o.customer_id = c.customer_id
JOIN `olist.olist_order_payments` AS p
  ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
