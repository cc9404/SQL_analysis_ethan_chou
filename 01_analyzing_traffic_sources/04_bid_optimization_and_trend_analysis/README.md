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
| **2** | Trend Analysis & Data Pivoting | [`bid_optimization_and_trend_analysis.sql`](./bid_optimization_and_trend_analysis.sql) | [`CSV 2`](./bid_optimization_and_trend_analysis.csv) |
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


