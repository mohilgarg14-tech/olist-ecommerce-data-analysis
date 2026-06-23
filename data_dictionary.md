# Data Dictionary

## Core Tables

| Table | Purpose | Key Columns |
|---|---|---|
| `olist.olist_orders` | Order lifecycle and timestamps | `order_id`, `customer_id`, `order_status`, `order_purchase_timestamp`, `order_approved_at`, `order_delivered_carrier_date`, `order_delivered_customer_date`, `order_estimated_delivery_date` |
| `olist.olist_order_items` | Products and sellers per order | `order_id`, `order_item_id`, `product_id`, `seller_id`, `price`, `freight_value` |
| `olist.olist_order_payments` | Payment method and value | `order_id`, `payment_type`, `payment_installments`, `payment_value` |
| `olist.olist_customers` | Customer IDs and geography | `customer_id`, `customer_unique_id`, `customer_city`, `customer_state` |
| `olist.olist_sellers` | Seller IDs and geography | `seller_id`, `seller_city`, `seller_state` |
| `olist.olist_products_dataset` | Product attributes | `product_id`, `product_category_name` |
| `olist.product_category_name_translation` | Portuguese-to-English product category mapping | `string_field_0`, `string_field_1` |
| `olist.order_reviews` | Customer reviews | `review_id`, `order_id`, `review_score`, `review_comment_title`, `review_comment_message`, `review_creation_date`, `review_answer_timestamp` |

## Metrics

| Metric | Definition |
|---|---|
| GMV / Revenue | Sum of `payment_value` for valid orders |
| AOV | Average order value after aggregating payments to order level |
| On-time delivery rate | Delivered orders where actual delivery date is on or before estimated delivery date |
| Delay days | Actual customer delivery date minus estimated delivery date |
| Dispatch days | Carrier delivery handoff date minus order approval date |
| Repeat purchase rate | Customers with more than one completed order divided by total customers |
| Recency | Days between latest dataset order date and each customer's latest order |
| Frequency | Count of distinct orders per customer |
| Monetary value | Sum of customer payment value |
