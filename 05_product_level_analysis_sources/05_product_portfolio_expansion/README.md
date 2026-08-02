# 📄 Core Module 5: Product Portfolio Expansion Analysis

This module evaluates the performance impact of expanding the Fuzzy Factory product portfolio (launching Product 3 on `2013-12-12`). It compares the 1-month pre-launch period (`2013-11-12` to `2013-12-12`) against the 1-month post-launch period (`2013-12-12` to `2014-01-12`) across overall session-to-order conversion rate, Average Order Value (AOV), products per order, and revenue per session.

---

## 📌 Business Problem & Context

On December 12, 2013, Fuzzy Factory expanded its product lineup by launching its 3rd product (Birthday Bear). Management requested a pre-vs-post analysis to evaluate whether adding a third core product to the portfolio successfully improved overall website conversion efficiency, basket size, Average Order Value (AOV), and overall revenue per session across the entire customer base.

---

## 🛠️ SQL Script & Output Dataset

* **Main SQL Script:** 🔗 [`product_portfolio_expansion.sql`](./product_portfolio_expansion.sql)
* **Data Output Link:** 📄 [`product_portfolio_expansion.csv`](./product_portfolio_expansion.csv)

### 🔹 SQL Query: Pre vs. Post Launch Aggregation

```sql
SELECT
    CASE
        WHEN website_sessions.created_at < '2013-12-12' THEN 'A. Pre_Cross_Sell'
        WHEN website_sessions.created_at >= '2013-12-12' THEN 'B. Post_Cross_Sell'
        ELSE 'check logic'
    END AS time_period,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd) AS total_revenue,
    SUM(orders.items_purchased) AS total_products_sold,
    SUM(orders.price_usd) / COUNT(DISTINCT orders.order_id) AS average_order_value,
    SUM(orders.items_purchased) / COUNT(DISTINCT orders.order_id) AS products_per_order,
    SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
    LEFT JOIN orders
        ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY 1;
```

## 📊 Summary Performance Comparison

| time_period | sessions | orders | conv_rate | total_revenue | total_products_sold | average_order_value | products_per_order | revenue_per_session |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A. Pre_Cross_Sell** | 17,343 | 1,055 | **6.08%** | $57,209.00 | 1,104 | **$54.23** | **1.0464** | **$3.30** |
| **B. Post_Cross_Sell** | 13,383 | 940 | **7.02%** | $53,515.40 | 1,056 | **$56.93** | **1.1234** | **$4.00** |

---

## 💡 Key Business Insights

1. **Significant Conversion Rate Lift:**
   * Overall website session-to-order conversion rate improved from **6.08%** pre-launch to **7.02%** post-launch, representing a **+0.94 percentage point lift** (+15.4% relative increase).

2. **Expanded Basket Size & Higher AOV:**
   * Products per order increased from **1.0464** to **1.1234** (+7.36%), driving Average Order Value (AOV) up from **$54.23** to **$56.93** (+5.00% / +$2.70 per order).

3. **Substantial Gain in Revenue per Session:**
   * Revenue per session increased significantly from **$3.30** to **$4.00** (+21.2% / +$0.70 per session), demonstrating that expanding the product portfolio created strong cross-product synergy.

4. **Strategic Recommendations:**
   * Expanding the product portfolio successfully unlocked additional customer demand and increased total basket value. Fuzzy Factory should continue exploring complementary product categories and optimizing cross-product navigation across the site.
