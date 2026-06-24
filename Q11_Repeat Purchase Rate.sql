WITH
  counted_orders AS (
    SELECT c.customer_unique_id, COUNT(o.order_id) AS order_count
    FROM `olist.olist_orders` o
    JOIN `olist.olist_customers` c
      ON o.customer_id = c.customer_id
    GROUP BY(c.customer_unique_id)
    HAVING COUNT(o.order_id) > 1
    ORDER BY COUNT(o.order_id) DESC
  )
SELECT
  ROUND(
    (count_of_repeating_customers.repeating_customer_count)
      / (SELECT COUNT(customer_unique_id) FROM `olist.olist_customers`)
      * 100,
    2) AS percentage_of_repeating_cutomers
FROM
  (
    SELECT COUNT(customer_unique_id) AS repeating_customer_count
    FROM counted_orders
  ) AS count_of_repeating_customers;
