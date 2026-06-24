SELECT ROUND(avg(DATE_DIFF(review_answer_timestamp, review_creation_date, DAY)), 1) as Review_Response_Lag, r.review_score
FROM `olist.order_reviews` r
GROUP BY r.review_score;