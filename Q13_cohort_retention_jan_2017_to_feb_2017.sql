-- Q13: Cohort Retention
-- Business question: Of customers who first ordered in January 2017, how many returned in February 2017?

WITH first_orders AS (
  SELECT
    c.customer_unique_id,
    MIN(DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH)) AS first_order_month
  FROM `olist.olist_customers` AS c
  JOIN `olist.olist_orders` AS o
    ON c.customer_id = o.customer_id
  WHERE o.order_status NOT IN ('canceled', 'unavailable')
  GROUP BY c.customer_unique_id
),
january_cohort AS (
  SELECT customer_unique_id
  FROM first_orders
  WHERE first_order_month = DATE '2017-01-01'
),
february_returners AS (
  SELECT DISTINCT c.customer_unique_id
  FROM `olist.olist_customers` AS c
  JOIN `olist.olist_orders` AS o
    ON c.customer_id = o.customer_id
  WHERE DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) = DATE '2017-02-01'
    AND o.order_status NOT IN ('canceled', 'unavailable')
)

SELECT
  COUNT(j.customer_unique_id) AS january_2017_new_customers,
  COUNT(f.customer_unique_id) AS returned_in_february_2017,
  ROUND(SAFE_DIVIDE(COUNT(f.customer_unique_id), COUNT(j.customer_unique_id)) * 100, 2)
    AS retention_rate_pct
FROM january_cohort AS j
LEFT JOIN february_returners AS f
  ON j.customer_unique_id = f.customer_unique_id;
