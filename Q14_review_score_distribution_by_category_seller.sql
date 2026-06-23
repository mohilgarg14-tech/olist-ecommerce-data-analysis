-- Q14: Review Score Distribution by Category and Seller
-- Business question: Who gets bad reviews?

SELECT
  i.seller_id,
  COALESCE(t.string_field_1, p.product_category_name) AS product_category,
  COUNT(r.review_id) AS review_count,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) AS low_score_reviews,
  ROUND(SAFE_DIVIDE(SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END), COUNT(r.review_id)) * 100, 2)
    AS low_score_review_pct
FROM `olist.order_reviews` AS r
JOIN `olist.olist_order_items` AS i
  ON r.order_id = i.order_id
JOIN `olist.olist_products_dataset` AS p
  ON i.product_id = p.product_id
LEFT JOIN `olist.product_category_name_translation` AS t
  ON p.product_category_name = t.string_field_0
GROUP BY i.seller_id, product_category
HAVING review_count >= 5
ORDER BY low_score_review_pct DESC, review_count DESC;
