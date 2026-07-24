# 🎯 Core Module 4: Bid Optimization & Trend Analysis

This module conducts a multi-part analysis evaluating weekly traffic volume trends, measuring the elasticity and impact of paid search bid changes, and segmenting device-level performance (Desktop vs. Mobile) for Maven Fuzzy Factory.

---

## 📌 Business Problem & Context

Following the initial CVR analysis, management implemented bid adjustments for `gsearch / nonbrand` search campaigns. We need to:
1. **Monitor Volume Impact:** Determine if bid reductions caused session volume to drop significantly.
2. **Analyze Granular Trends:** Segment weekly traffic by device types (Desktop vs. Mobile) to uncover optimization opportunities.

---

## 📂 Analysis Breakdown & Structure

| Part | Analysis Focus | SQL Script | Data Output |
| :---: | :--- | :--- | :---: |
| **1** | Traffic Source Trending (Bid Reduction Impact) | [`traffic_source_trending.sql`](./traffic_source_trending.sql) | [`CSV 1`](./traffic_source_trending.csv) |
| **2** | Trend Analysis | [`bid_optimization_and_trend_analysis.sql`](./bid_optimization_and_trend_analysis.sql) | [`CSV 2`](./bid_optimization_and_trend_analysis.csv) |
| **3** | Granular Segment Trending (Desktop vs. Mobile) | [`trending_with_granular_segments.sql`](./trending_with_granular_segments.sql) | [`CSV 3`](./trending_with_granular_segments.csv) |

---

## 📈 Part 1: Traffic Source Trending

### 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`traffic_source_trending.sql`](./traffic_source_trending.sql)
* **Key SQL Techniques:** `MIN(DATE())` (to extract week start dates), `COUNT(DISTINCT)`, `YEAR()` & `WEEK()` (date grouping aggregation), `WHERE` (filtering on dates, source, and campaign).

```sql
/*
Traffic source trending
Based on previous conversion rate analysis, gsearch nonbrand has been bid down.
This time, we pull gsearch nonbrand session volume by week to see if the bid changes
have caused volume to drop at all.
*/

USE mavenfuzzyfactory;

SELECT
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-10' 
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand'
GROUP BY
    YEAR(created_at),
    WEEK(created_at);
```

---

### 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`traffic_source_trending.csv`](./traffic_source_trending.csv)

| week_start_date | sessions |
| :---: | :---: |
| 2012-03-19 | 896 |
| 2012-03-25 | 956 |
| 2012-04-01 | 1,152 |
| **2012-04-08** | **983** |
| **2012-04-15** | **621** |
| 2012-04-22 | 594 |
| 2012-04-29 | 681 |
| 2012-05-06 | 399 |

---

### 💡 Key Business Insights

1. **Significant Drop Post-Bid Reduction:**
   * Following the bid reduction on **2012-04-15**, weekly session volume for `gsearch / nonbrand` dropped sharply from **983 sessions** (week of April 8) to **621 sessions** (a **~36.8%** decline), indicating high volume sensitivity to ad bids.
2. **Traffic Trend Dynamics:**
   * Traffic remained lower in late April (averaging ~600–680 sessions/week) compared to its peak of **1,152 sessions** in early April.
3. **Next Actionable Steps:**
   * **Continuous Volume Monitoring:** Keep tracking weekly session volume levels to ensure traffic doesn't drop further.
   * **Efficiency Enhancement:** Explore optimization opportunities (e.g., ad creative improvements or landing page experience) to increase campaign efficiency and regain volume profitably.

---

## 📊 Part 2: Bid Optimization & Trend Analysis

### 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`bid_optimization_and_trend_analysis.sql`](./bid_optimization_and_trend_analysis.sql)
* **Key SQL Techniques:** `YEAR()`, `WEEK()`, `MIN(DATE())`, `COUNT(DISTINCT)`, Date & Time Grouping Aggregation.

```sql
/*
Bid optimization and trend analysis
Goal : Understanding the values of various segments of paid traffic, so that we can optimize the marketing budget
*/
USE mavenfuzzyfactory;

SELECT
    YEAR(created_at) AS year,
    WEEK(created_at) AS week,
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 115000 -- arbitrary range
GROUP BY 1, 2;
```

---

### 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`bid_optimization_and_trend_analysis.csv`](./bid_optimization_and_trend_analysis.csv)

| YEAR(created_at) | WEEK(created_at) | week_start | sessions |
| :---: | :---: | :---: | :---: |
| 2013 | 22 | 2013-06-05 | 883 |
| 2013 | 23 | 2013-06-09 | **1,920** |
| 2013 | 24 | 2013-06-16 | **2,066** |
| 2013 | 25 | 2013-06-23 | **2,027** |
| 2013 | 26 | 2013-06-30 | 1,919 |
| 2013 | 27 | 2013-07-07 | 1,938 |
| 2013 | 28 | 2013-07-14 | **2,007** |
| 2013 | 29 | 2013-07-21 | **2,052** |
| 2013 | 30 | 2013-07-28 | 189 |

---

### 💡 Key Business Insights

1. **Stable High-Volume Baseline:**
   * During mid-2013, full-week session volume maintained a strong and consistent range of **~1,900 to 2,066 sessions per week**, peaking at **2,066 sessions** in mid-June (week of June 16).
2. **Partial Week Edge Cases:**
   * The start week (2013-06-05, 883 sessions) and end week (2013-07-28, 189 sessions) show lower numbers due to session filtering (`session_id BETWEEN 100000 AND 115000`) truncating data mid-week.
3. **Budget Allocation Takeaway:**
   * Understanding baseline traffic patterns during full operational weeks ensures that budget allocation models reflect accurate full-week capacity.

---
   
## 📱 Part 3: Trending with Granular Segments (Desktop vs. Mobile)

### 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`trending_with_granular_segments.sql`](./trending_with_granular_segments.sql)
* **Key SQL Techniques:** `COUNT(CASE WHEN ... THEN ... ELSE NULL END)` (Conditional Aggregation / Data Pivoting), `MIN(DATE())`, `GROUP BY` with `YEAR()` & `WEEK()`.

```sql
/*
Trending with granular segments
analyze weekly trends for both desktop and mobile
*/

USE mavenfuzzyfactory;

SELECT
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions,
    COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mob_sessions,
    COUNT(DISTINCT website_session_id) AS total_sessions
FROM website_sessions
WHERE website_sessions.created_at BETWEEN '2012-04-15' AND '2012-06-09'
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand'
GROUP BY 
    YEAR(created_at),
    WEEK(created_at);
```

---

### 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`trending_with_granular_segments.csv`](./trending_with_granular_segments.csv)

| week_start_date | dtop_sessions | mob_sessions | total_sessions |
| :---: | :---: | :---: | :---: |
| **2012-04-15** | 383 | 238 | **621** |
| **2012-04-22** | 360 | 234 | **594** |
| **2012-04-29** | 425 | 256 | **681** |
| **2012-05-06** | 430 | 282 | **712** |
| **2012-05-13** | 403 | 214 | **617** |
| **2012-05-20** | **661** | 190 | **851** |
| **2012-05-27** | 585 | 183 | **768** |
| **2012-06-03** | 582 | 157 | **739** |

---

### 💡 Key Business Insights

1. **Desktop Rebound Drives Growth:**
   * Desktop traffic (`dtop_sessions`) saw a significant surge starting late May (rising from **403** to a peak of **661 sessions** in the week of 2012-05-20), driving total campaign volume back up to **851 sessions**.

2. **Divergent Device Trends:**
   * While Desktop traffic grew rapidly through late May and early June, Mobile traffic (`mob_sessions`) showed a downward trend (declining from a peak of **282 sessions** down to **157 sessions**).

3. **Next Actionable Steps:**
   * **Device-Level Bid Optimization:** Continue monitoring device-level volume and evaluate conversion performance separately for Desktop vs. Mobile to optimize bidding strategies and ad spend.
