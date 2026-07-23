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

---

