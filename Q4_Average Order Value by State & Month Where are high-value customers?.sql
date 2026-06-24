WITH state_revenue AS (
  SELECT 
  DATE_TRUNC(o.order_delivered_customer_date, MONTH) AS Month,
    customer_state as State, 
    ROUND(AVG(p.payment_value), 1) as Average_order_Value_by_State_n_Month
  FROM `olist.olist_order_payments` p
  JOIN `olist.olist_orders` o 
  ON p.order_id = o.order_id
  JOIN `olist.olist_customers` c
  ON o.customer_id = c.customer_id
  WHERE o.order_delivered_customer_date IS NOT NULL
  GROUP BY State, Month
)
SELECT *
from state_revenue
ORDER BY state_revenue.Average_order_Value_by_State_n_Month desc
LIMIT 100;