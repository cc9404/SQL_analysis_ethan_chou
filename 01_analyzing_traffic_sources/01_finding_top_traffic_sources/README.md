# 🔍 Core Module 1: Finding Top Traffic Sources

## 📌 Business Problem & Context
The Marketing Director wants to understand **where the bulk of website traffic is coming from** up until April 12, 2012. 

To evaluate overall marketing reach and identify primary acquisition drivers, we need to analyze the breakdown of total website sessions across three key dimensions:
* **`utm_source`**: The traffic provider (e.g., Google, Bing).
* **`utm_campaign`**: The marketing initiative (e.g., nonbrand, brand).
* **`http_referer`**: The referring domain URL.

---

## 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`finding_top_traffic_sources.sql`](./finding_top_traffic_sources.sql)
* **Key SQL Techniques:** `COUNT(DISTINCT)`, `GROUP BY`, `ORDER BY DESC`, `WHERE` (Date filtering).

```sql
USE mavenfuzzyfactory;

SELECT
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS number_of_sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY 
    1, 2, 3
ORDER BY 
    number_of_sessions DESC;
```

---

## 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`finding_top_traffic_sources.csv`](./finding_top_traffic_sources.csv)

| utm_source | utm_campaign | http_referer | number_of_sessions |
| :--- | :--- | :--- | :---: |
| **gsearch** | nonbrand | `https://www.gsearch.com` | **3,613** |
| *NULL* | *NULL* | *NULL* | 28 |
| *NULL* | *NULL* | `https://www.gsearch.com` | 27 |
| **gsearch** | brand | `https://www.gsearch.com` | 26 |
| *NULL* | *NULL* | `https://www.bsearch.com` | 7 |
| **bsearch** | brand | `https://www.bsearch.com` | 7 |

---

## 💡 Key Business Insights

1. **Primary Growth Engine**:
   * **`gsearch / nonbrand`** is driving the vast majority of traffic with **3,613 sessions** (~97% of paid traffic), making it the single most critical acquisition channel.
2. **Direct & Organic Traffic**:
   * Organic and direct search traffic (NULL referers/campaigns) remain very low in volume (under 30 sessions each), confirming that the business relies heavily on paid search at this early stage.
3. **Next Actionable Step**:
   * Focus deep-dive analysis specifically on **`gsearch / nonbrand`** to measure its **Conversion Rate (CVR)** and evaluate cost efficiency.
