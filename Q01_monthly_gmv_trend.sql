-- Q01: Monthly GMV Trend
-- Business question: What is the month-over-month GMV trend?

WITH monthly_gmv AS (
  SELECT
    DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS gmv
  FROM `olist.olist_orders` AS o
  JOIN `olist.olist_order_payments` AS p
    ON o.order_id = p.order_id
  WHERE o.order_status NOT IN ('canceled', 'unavailable')
  GROUP BY order_month
)

SELECT
  order_month,
  total_orders,
  gmv,
  LAG(gmv) OVER (ORDER BY order_month) AS previous_month_gmv,
  ROUND(
    SAFE_DIVIDE(
      gmv - LAG(gmv) OVER (ORDER BY order_month),
      LAG(gmv) OVER (ORDER BY order_month)
    ) * 100,
    2
  ) AS mom_gmv_growth_pct
FROM monthly_gmv
ORDER BY order_month;
