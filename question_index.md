# Question Index

| # | Topic | Business Question | SQL Pattern |
|---|---|---|---|
| Q01 | Monthly GMV Trend | What is the month-over-month GMV trend? | CTE, `LAG`, date truncation |
| Q02 | Revenue by State | Which customer states drive the most revenue? | multi-table join, aggregation |
| Q03 | Top Categories | Which categories earn the most? | join, translation table, `LIMIT` |
| Q04 | AOV by State and Month | Where are high-value customers? | order-level CTE, grouped average |
| Q05 | Payment Type Distribution | How do customers pay? | payment aggregation |
| Q06 | On-Time Delivery Rate | What percentage of orders arrive on time by month? | conditional aggregation |
| Q07 | Worst Sellers by Delay | Which sellers fail customers most? | seller aggregation, delay metric |
| Q08 | Delay by State Corridor | Which seller-to-customer state corridors are slowest? | seller/customer geography join |
| Q09 | Carrier Handoff Speed | Which sellers are slow to dispatch? | date difference, ranking |
| Q10 | Delivery Percentiles | Which product types take longest? | `APPROX_QUANTILES` |
| Q11 | Repeat Purchase Rate | What percentage of customers order more than once? | customer-level CTE |
| Q12 | RFM Base Table | Build recency, frequency, and monetary metrics per customer. | RFM aggregation |
| Q13 | Cohort Retention | Of January 2017 first-order customers, how many returned in February 2017? | cohort CTE |
| Q14 | Bad Review Analysis | Who gets bad reviews? | review/category/seller join |
| Q15 | Review Response Lag | Do slow review replies correlate with low scores? | date difference by score |
| Q16 | Running Total Revenue | What is cumulative GMV growth? | window running sum |
| Q17 | Seller Revenue Tier | Which sellers are top, middle, and long-tail contributors? | `PERCENT_RANK` |
| Q18 | Delay Bottlenecks | Which sellers combine high delay, slow corridors, and poor reviews? | composite score |
