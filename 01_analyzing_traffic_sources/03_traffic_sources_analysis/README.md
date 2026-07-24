# 📊 Core Module 3: Traffic Sources Analysis

## 📌 Business Problem & Context

To evaluate ad performance at a more granular level, the marketing team needs to analyze traffic and conversion performance broken down by specific ad creatives (**`utm_content`**) for website sessions indexed between ID `1000` and `2000`.

* **Primary Objective:** Identify which specific ad copies (e.g., headings vs. body text across Google and Bing) drive the highest traffic volume and conversion efficiency.
* **Key Focus:** Evaluate if ad content placement impacts user purchase intent.

---

## 📐 Conversion Rate Formula

$$\text{Session-to-Order CVR} = \left( \frac{\text{Total Orders}}{\text{Total Sessions}} \right) \times 100\%$$

In SQL logic:
```sql
ROUND(COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id), 3)

USE mavenfuzzyfactory;

SELECT 
    website_sessions.utm_content,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    ROUND(COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id), 3) AS session_to_order_con_rt
FROM website_sessions
    LEFT JOIN orders
        ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.website_session_id BETWEEN 1000 AND 2000
GROUP BY 1
ORDER BY 2 DESC;
