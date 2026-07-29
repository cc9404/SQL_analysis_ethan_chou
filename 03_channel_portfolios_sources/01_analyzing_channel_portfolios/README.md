# 📄 Core Module 1: Analyzing Channel Portfolios

This module tracks weekly session volume across nonbrand search channels (`gsearch` vs. `bsearch`) from August 22, 2012 to November 29, 2012. It evaluates multi-channel performance, total traffic growth, and the volume mix between search engines following the launch of Bing search campaigns.

---

## 📌 Business Problem & Context

With the expansion of paid search marketing onto Bing (`bsearch`), leadership needs to monitor how `bsearch` performs relative to established `gsearch` nonbrand campaigns. Tracking weekly traffic trends helps determine whether `bsearch` is driving incremental traffic growth and provides insight into overall multi-channel portfolio performance.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`analyzing_channel_portfolio.sql`](./analyzing_channel_portfolio.sql)

---

### 🔹 Step 1: Weekly Channel Session Aggregation
Extract weekly start dates (`MIN(DATE(created_at))`) and aggregate total nonbrand session volume alongside specific channel counts for `gsearch` and `bsearch`[cite: 1].

```sql
SELECT
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions
FROM website_sessions
WHERE created_at > '2012-08-22'
  AND created_at < '2012-11-29'
  AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at);
```

---

* **Data Output Link:** 📄 [`analyzing_channel_portfolio.csv`](./analyzing_channel_portfolio.csv)

**Output Data (`analyzing_channel_portfolio.csv`):**

| week_start_date | total_sessions | gsearch_sessions | bsearch_sessions |
| :---: | :---: | :---: | :---: |
| 2012-08-22 | 787 | 590 | 197 |
| 2012-08-26 | 1399 | 1056 | 343 |
| 2012-09-02 | 1215 | 925 | 290 |
| 2012-09-09 | 1280 | 951 | 329 |
| 2012-09-16 | 1516 | 1151 | 365 |
| 2012-09-23 | 1371 | 1050 | 321 |
| 2012-09-30 | 1315 | 999 | 316 |
| 2012-10-07 | 1332 | 1002 | 330 |
| 2012-10-14 | 1677 | 1257 | 420 |
| 2012-10-21 | 1733 | 1302 | 431 |
| 2012-10-28 | 1595 | 1211 | 384 |
| 2012-11-04 | 1779 | 1350 | 429 |
| 2012-11-11 | 1684 | 1246 | 438 |
| 2012-11-18 | 4601 | 3508 | 1093 |
| 2012-11-25 | 3060 | 2286 | 774 |

## 💡 Key Business Insights

1. **Incremental Channel Growth:**
   * `bsearch` consistently contributes around **23%–25%** of total nonbrand paid search volume throughout the analyzed period, successfully serving as a supplementary acquisition channel alongside `gsearch`[cite: 1].

2. **Holiday Traffic Surges (Black Friday / Cyber Monday):**
   * During the week of **2012-11-18**, total sessions surged to **4,601** (with `gsearch` reaching 3,508 and `bsearch` reaching 1,093), demonstrating massive seasonality spikes across both paid search channels[cite: 1].

3. **Strategic Recommendations:**
   * Continue monitoring cross-channel conversion rates and cost-per-acquisition (CPA) to optimize bid allocation between `gsearch` and `bsearch` during peak traffic periods[cite: 1].
