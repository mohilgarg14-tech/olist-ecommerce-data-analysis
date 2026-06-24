SELECT payment_type, ROUND(sum(payment_value), 1) as sum_payments, ROUND(avg(payment_installments), 1) as avg_payment_istallments
FROM `olist.olist_order_payments`
WHERE payment_type != 'not_defined'
GROUP BY payment_type
ORDER BY sum_payments DESC;