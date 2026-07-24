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

## 📈 Traffic Source Trending

### 💻 SQL Query & Methodology
* **SQL Script:** 🔗 [`traffic_source_trending.sql`](./traffic_source_trending.sql)
* **Goal:** Monitor weekly session trends before and after the bid reduction on `2012-04-15`.

```sql
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
| 2012-03-18 | 26 |
| 2012-03-25 | 156 |
| 2012-04-01 | 202 |
| 2012-04-08 | 206 |
| **2012-04-15** | **316** |
| 2012-04-22 | 234 |
| 2012-04-29 | 291 |
| 2012-05-06 | 285 |

---

### Bid Optimization & Trend Analysis

```markdown
## 📊 Part 2: Bid Optimization & Trend Analysis

### 💻 SQL Query & Methodology
* **SQL Script:** 🔗 [`bid_optimization_and_trend_analysis.sql`](./bid_optimization_and_trend_analysis.sql)
* **Goal:** Aggregate session distribution and demonstrate data pivoting techniques.

```sql
SELECT
    YEAR(created_at) AS year,
    WEEK(created_at) AS week,
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 115000
GROUP BY 1, 2;
```
---

### 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`bid_optimization_and_trend_analysis.csv`](./bid_optimization_and_trend_analysis.csv)

| year | week | week_start | sessions |
| :---: | :---: | :---: | :---: |
| **2013** | **10** | 2013-03-10 | 1,882 |
| **2013** | **11** | 2013-03-17 | 1,780 |
| **2013** | **12** | 2013-03-24 | 1,712 |
| **2013** | **13** | 2013-03-31 | 1,780 |

---

### Trending with Granular Segments

```markdown
## 📱 Part 3: Trending with Granular Segments (Desktop vs. Mobile)

### 💻 SQL Query & Methodology
* **SQL Script:** 🔗 [`trending_with_granular_segments.sql`](./trending_with_granular_segments.sql)
* **Goal:** Breakdown `gsearch / nonbrand` traffic across device types to analyze device performance.

```sql
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

### 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`trending_with_granular_segments.csv`](./trending_with_granular_segments.csv)

| week_start_date | dtop_sessions | mob_sessions | total_sessions |
| :---: | :---: | :---: | :---: |
| **2012-04-15** | 221 | 95 | **316** |
| **2012-04-22** | 170 | 64 | **234** |
| **2012-04-29** | 227 | 64 | **291** |
| **2012-05-06** | 219 | 66 | **285** |
| **2012-05-13** | 212 | 61 | **273** |
| **2012-05-20** | 229 | 66 | **295** |
| **2012-05-27** | 218 | 63 | **281** |
| **2012-06-03** | 222 | 63 | **285** |


