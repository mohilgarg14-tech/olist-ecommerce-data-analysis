WITH
  retention AS (
    SELECT feb.customers_in_february, COUNT(jan.customers_in_januray) AS cnt
    FROM
      (
        SELECT DISTINCT c.customer_unique_id AS customers_in_januray
        FROM `olist.olist_orders` o
        JOIN `olist.olist_customers` AS c
          ON c.customer_id = o.customer_id
        WHERE DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) = '2017-01-01'
        ORDER BY c.customer_unique_id
      ) jan
    LEFT JOIN
      (
        SELECT DISTINCT c.customer_unique_id AS customers_in_february
        FROM `olist.olist_orders` o
        JOIN `olist.olist_customers` AS c
          ON c.customer_id = o.customer_id
        WHERE DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) = '2017-02-01'
        ORDER BY c.customer_unique_id
      ) AS feb
      ON jan.customers_in_januray = feb.customers_in_february
    GROUP BY feb.customers_in_february
  )
SELECT
  ROUND(
    (
      SELECT sum(cnt)
      FROM retention
      WHERE customers_in_february IS NOT NULL
    ) / (SELECT sum(cnt) FROM retention)
      * 100,
    2) AS retention_rate_feb;
