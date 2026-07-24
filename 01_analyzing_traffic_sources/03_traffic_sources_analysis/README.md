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
```

---

## 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`traffic_sources_analysis.csv`](./traffic_sources_analysis.csv)

| utm_content | sessions | orders | session_to_order_con_rt |
| :--- | :---: | :---: | :---: |
| **`g_ad_1`** | **975** | **35** | **0.036** |
| *NULL* | 18 | 0 | **0.000** |
| **`g_ad_2`** | 6 | 0 | **0.000** |
| **`b_ad_2`** | 2 | 0 | **0.000** |

---

## 💡 Key Business Insights

1. **`g_ad_1` is the Core Acquisition Driver:**
   * **`g_ad_1`** accounts for the vast majority of traffic with **975 sessions** and **35 orders**, achieving a **3.6%** CVR (`0.036`). It generated **100% of all converted orders** in this sample window.
2. **Underperforming Ad Variations:**
   * Other ad variations (`g_ad_2` and `b_ad_2`) as well as sessions missing content parameters (*NULL*) contributed negligible session volume (under 20 sessions each) and **0 conversions**.
3. **Next Actionable Step:**
   * **Budget Consolidation:** Focus primary search ad spending on **`g_ad_1`** and consider deprecating or pausing non-converting ad creative variations (`g_ad_2`, `b_ad_2`).
