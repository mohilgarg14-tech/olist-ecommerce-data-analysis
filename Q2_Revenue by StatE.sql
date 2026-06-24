WITH
  state_revenue AS (
    SELECT
      customer_state AS state,
      ROUND(SUM(p.payment_value), 1) AS revenue
    FROM `olist.olist_order_payments` p
    JOIN `olist.olist_orders` o
      ON p.order_id = o.order_id
    JOIN `olist.olist_customers` c
      ON o.customer_id = c.customer_id
    WHERE
      o.order_delivered_customer_date IS NOT NULL
      AND o.order_status = 'delivered'
    GROUP BY state
  )
SELECT *
FROM state_revenue
ORDER BY state_revenue.revenue DESC;
