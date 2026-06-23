-- Q16: Running Total Revenue by Month
-- Business question: What is cumulative GMV growth?

WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS order_month,
    ROUND(SUM(p.payment_value), 2) AS monthly_revenue
  FROM `olist.olist_orders` AS o
  JOIN `olist.olist_order_payments` AS p
    ON o.order_id = p.order_id
  WHERE o.order_status NOT IN ('canceled', 'unavailable')
  GROUP BY order_month
)

SELECT
  order_month,
  monthly_revenue,
  ROUND(SUM(monthly_revenue) OVER (ORDER BY order_month), 2) AS cumulative_revenue
FROM monthly_revenue
ORDER BY order_month;
