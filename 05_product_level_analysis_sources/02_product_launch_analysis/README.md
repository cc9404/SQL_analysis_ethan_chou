# 📄 Core Module 2: Product Launch Impact Analysis

This module analyzes website session volume, overall conversion rate, Revenue Per Session (RPS), and order volume breakdown by product following the launch of Product 2 (Love Bear) in January 2013.

---

## 📌 Business Problem & Context

In January 2013, Fuzzy Factory introduced its second product (Product 2) to expand its catalog. Management needs to evaluate whether adding a second product improved overall store conversion rates and Revenue Per Session (RPS), or if it merely cannibalized existing sales of Product 1.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`analyzing_product_launches.sql`](./analyzing_product_launches.sql)

---

### 🔹 Monthly Product Launch Metrics & Order Breakdown
Calculate monthly sessions, total orders, overall conversion rate (`conv_rate`), revenue per session (`revenue_per_session`), and order counts segmented by primary product.

```sql
SELECT
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mon,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session,
    COUNT(CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END) AS product_one_orders,
    COUNT(CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END) AS product_two_orders
FROM website_sessions
    LEFT JOIN orders
        ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-04-01' AND '2013-04-01'
GROUP BY 1, 2;
```

---

* **Data Output Link:** 📄 [`analyzing_product_launches.csv`](./analyzing_product_launches.csv)

**Output Data (`analyzing_product_launches.csv`):**

| yr | mon | sessions | orders | conv_rate | revenue_per_session | product_one_orders | product_two_orders |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 2012 | 4 | 3,734 | 99 | 2.65% | $1.33 | 99 | 0 |
| 2012 | 5 | 3,736 | 108 | 2.89% | $1.45 | 108 | 0 |
| 2012 | 6 | 3,963 | 140 | 3.53% | $1.77 | 140 | 0 |
| 2012 | 7 | 4,249 | 169 | 3.98% | $1.99 | 169 | 0 |
| 2012 | 8 | 6,097 | 228 | 3.74% | $1.87 | 228 | 0 |
| 2012 | 9 | 6,546 | 287 | 4.38% | $2.19 | 287 | 0 |
| 2012 | 10 | 8,183 | 371 | 4.53% | $2.27 | 371 | 0 |
| 2012 | 11 | 14,011 | 618 | 4.41% | $2.20 | 618 | 0 |
| 2012 | 12 | 10,072 | 506 | 5.02% | $2.51 | 506 | 0 |
| 2013 | 1 | 6,401 | 391 | 6.11% | $3.13 | 344 | 47 |
| 2013 | 2 | 7,168 | 497 | 6.93% | $3.69 | 335 | 162 |
| 2013 | 3 | 6,264 | 385 | 6.15% | $3.18 | 320 | 65 |

---

## 💡 Key Business Insights

1. **Immediate Lift in Conversion Rate & RPS:**
   * Prior to the Product 2 launch, conversion rates averaged ~4.5% to 5.0% in late 2012. Following the launch in January 2013, conversion rate jumped to **6.11%** in Jan and peaked at **6.93%** in Feb 2013.
   * Revenue Per Session (RPS) increased significantly from **$2.51** (Dec 2012) to **$3.13** (Jan 2013) and **$3.69** (Feb 2013).

2. **Incremental Growth vs. Minimal Cannibalization:**
   * Product 2 generated **162 orders** in February 2013 (~32.6% of total orders), while Product 1 orders remained stable (~320–344 orders/month).
   * This indicates Product 2 attracted new buyer segments and expanded overall sales rather than cannibalizing existing demand.

3. **Strategic Recommendations:**
   * Multi-product offerings successfully elevate baseline store performance; continue evaluating portfolio expansion while monitoring cross-sell funnels.
