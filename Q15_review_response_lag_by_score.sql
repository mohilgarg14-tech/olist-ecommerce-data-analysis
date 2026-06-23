-- Q15: Review Response Lag
-- Business question: Do slow review replies correlate with low scores?

SELECT
  review_score,
  COUNT(review_id) AS review_count,
  ROUND(AVG(DATE_DIFF(DATE(review_answer_timestamp), DATE(review_creation_date), DAY)), 2)
    AS avg_response_lag_days,
  APPROX_QUANTILES(
    DATE_DIFF(DATE(review_answer_timestamp), DATE(review_creation_date), DAY),
    100
  )[OFFSET(50)] AS median_response_lag_days
FROM `olist.order_reviews`
WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
GROUP BY review_score
ORDER BY review_score;
