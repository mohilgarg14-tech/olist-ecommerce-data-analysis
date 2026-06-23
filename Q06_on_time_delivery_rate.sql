-- Q06: On-Time Delivery Rate
-- Business question: What percentage of orders arrive on time by month?

SELECT
  DATE_TRUNC(DATE(order_purchase_timestamp), MONTH) AS order_month,
  COUNT(DISTINCT order_id) AS delivered_orders,
  SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END)
    AS on_time_orders,
  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END),
      COUNT(DISTINCT order_id)
    ) * 100,
    2
  ) AS on_time_delivery_pct
FROM `olist.olist_orders`
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY order_month
ORDER BY order_month;
