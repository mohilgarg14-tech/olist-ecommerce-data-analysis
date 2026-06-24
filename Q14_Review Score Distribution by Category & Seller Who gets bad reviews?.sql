SELECT s.seller_id, t.string_field_1 as product_category_name_english, ROUND(AVG(r.review_score), 1) AS avg_score, COUNT(r.review_id) as count_of_reviews
 FROM `olist.order_reviews` r
 JOIN `olist.olist_order_items` i
 ON r.order_id = i.order_id
 JOIN `olist.olist_products_dataset` p
 ON p.product_id = i.product_id
 JOIN `olist.olist_sellers` s
 ON i.seller_id = s.seller_id
 JOIN `olist.product_category_name_translation` t
 ON p.product_category_name = t.string_field_0
 GROUP BY s.seller_id, t.string_field_1
 ORDER BY avg_score DESC;