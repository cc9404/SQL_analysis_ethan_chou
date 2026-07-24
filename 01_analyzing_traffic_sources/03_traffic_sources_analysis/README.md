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
| **`g_ad_heading`** | **878** | **28** | **0.032** |
| **`b_ad_heading`** | **63** | **1** | **0.016** |
| **`g_ad_body`** | **18** | **0** | **0.000** |
| **`b_ad_body`** | **1** | **0** | **0.000** |

---

## 💡 Key Business Insights

1. **Heading Ads Drive Primary Traffic & Conversions:**
   * **`g_ad_heading`** (Google Search Heading Ads) is the top performer, generating **878 sessions** and **28 orders** with a **3.2%** CVR (`0.032`).

2. **Inverted Ad Copy Inefficiency:**
   * Ad body copy variations (`g_ad_body` and `b_ad_body`) show extremely low traffic and **0 converted orders**, indicating that body-focused ad creatives fail to drive purchase intent.

3. **Google vs. Bing Heading Efficiency:**
   * Google heading ads convert at **3.2%**, which is **2x higher** than Bing heading ads (`b_ad_heading` at **1.6%** / `0.016`).

4. **Next Actionable Step:**
   * **Creative Allocation:** Reallocate ad budgets away from body-level ad copy toward high-performing heading copy, while re-evaluating Bing ad targeting to improve overall CVR.
