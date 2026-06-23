-- Q11: Repeat Purchase Rate
-- Business question: What percentage of customers order more than once?

WITH customer_orders AS (
  SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
  FROM `olist.olist_customers` AS c
  JOIN `olist.olist_orders` AS o
    ON c.customer_id = o.customer_id
  WHERE o.order_status NOT IN ('canceled', 'unavailable')
  GROUP BY c.customer_unique_id
)

SELECT
  COUNT(*) AS total_customers,
  SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
  ROUND(
    SAFE_DIVIDE(SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END), COUNT(*)) * 100,
    2
  ) AS repeat_purchase_rate_pct
FROM customer_orders;
