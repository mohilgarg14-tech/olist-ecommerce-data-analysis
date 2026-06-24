WITH delayed_delivery as
(SELECT o.order_delivered_customer_date, o.order_estimated_delivery_date, s.seller_id,
(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN (o.order_delivered_customer_date- o.order_estimated_delivery_date) END) as delay
FROM `olist.olist_orders` o
JOIN `olist.olist_order_items` i
ON o.order_id = i.order_id
JOIN `olist.olist_sellers` s
ON i.seller_id = s.seller_id
WHERE o.order_delivered_customer_date IS NOT NULL )

SELECT seller_id, delay
FROM delayed_delivery
WHERE delay IS NOT NULL
ORDER BY delay DESC
LIMIT 10;