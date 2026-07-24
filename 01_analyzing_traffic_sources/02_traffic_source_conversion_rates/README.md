# 📈 Core Module 2: Traffic Source Conversion Rates

## 📌 Business Problem & Context

To evaluate whether the paid `gsearch / nonbrand` search traffic is generating enough order volume to justify ad spend, we need to measure its **Session-to-Order Conversion Rate (CVR)** up until **April 14, 2012**.

* **Target Benchmark:** Management requires a minimum CVR of **$\ge 4.0\%$** for the search marketing numbers to work profitably.
* **Key Challenge:** Determine if current performance meets this threshold or if bid reductions are necessary to prevent wasted spend.

---

## 📐 Conversion Rate Formula

The session-to-order conversion rate is calculated using the following mathematical formula:

$$\text{Conversion Rate (CVR)} = \left( \frac{\text{Total Orders}}{\text{Total Sessions}} \right) \times 100\%$$

---

## 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`traffic_source_conversion_rates.sql`](./traffic_source_conversion_rates.sql)
* **Key SQL Techniques:** `COUNT(DISTINCT)`, `LEFT JOIN` (between sessions and orders), Division for Rate Calculation, `WHERE` (Multi-condition filtering on dates, source, and campaign).

```sql
USE mavenfuzzyfactory;

SELECT
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
FROM website_sessions
    LEFT JOIN orders
        ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-04-14'
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand';

---

## 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`traffic_source_conversion_rates.csv`](./traffic_source_conversion_rates.csv)

| sessions | orders | session_to_order_conv_rate |
| :---: | :---: | :---: |
| **3,887** | **112** | **0.0288** |
