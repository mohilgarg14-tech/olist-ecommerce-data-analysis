WITH
  x AS (
    SELECT
      DATE_TRUNC(t1.order_purchase_timestamp, MONTH) AS purchase_month,
      ROUND(SUM(t2.price + t2.freight_value), 2) AS monthly_revenue,
    FROM
      `master-aegis-500209-u4`.`olist`.`olist_orders` AS t1
    INNER JOIN
      `master-aegis-500209-u4`.`olist`.`olist_order_items` AS t2
      ON
        t1.order_id = t2.order_id
    GROUP BY
      purchase_montH
    ORDER BY
      purchase_month
  )
SELECT
  *,
  ROUND(SUM(x.monthly_revenue) OVER (ORDER BY purchase_month), 2)
    AS cumulative_revenue
FROM x
ORDER BY x.monthly_revenue, cumulative_revenue DESC;
