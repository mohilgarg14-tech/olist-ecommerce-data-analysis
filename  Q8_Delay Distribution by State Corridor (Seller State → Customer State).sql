WITH delayed_delivery as
(SELECT o.order_delivered_customer_date, o.order_estimated_delivery_date, c.customer_state, s.seller_state,
(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN DATE_DIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date, DAY) END) as delay
FROM `olist.olist_orders` o
JOIN `olist.olist_order_items` i
ON o.order_id = i.order_id
JOIN `olist.olist_sellers` s
ON i.seller_id = s.seller_id
join `olist.olist_customers` c
ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL )

SELECT customer_state, seller_state, avg(delay) as avg_delay_days
FROM delayed_delivery
WHERE delay IS NOT NULL
GROUP BY seller_state , customer_state
order by avg_delay_days DESC;