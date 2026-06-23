-- Q05: Payment Type Distribution
-- Business question: How do customers pay?

SELECT
  payment_type,
  COUNT(*) AS payment_records,
  ROUND(SUM(payment_value), 2) AS total_payment_value,
  ROUND(AVG(payment_value), 2) AS avg_payment_value,
  ROUND(AVG(payment_installments), 2) AS avg_installments
FROM `olist.olist_order_payments`
WHERE payment_type != 'not_defined'
GROUP BY payment_type
ORDER BY total_payment_value DESC;
