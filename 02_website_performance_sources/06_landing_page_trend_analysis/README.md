# 📄 Core Module 6: Landing Page Trend Analysis

This module tracks weekly landing page volume and overall bounce rate trends for paid `gsearch nonbrand` traffic between June 1, 2012 and August 31, 2012, evaluating the operational impact of introducing `/lander-1`.

---

## 📌 Business Problem & Context

Following the A/B split test that proved `/lander-1` reduced bounce rates compared to `/home`, management wants to see weekly performance trends over time. This analysis evaluates how traffic shifted from `/home` to `/lander-1` and tracks the overall weekly bounce rate to quantify long-term engagement improvements.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`landing_page_trend_analysis.sql`](./landing_page_trend_analysis.sql)

---

### 🔹 Step 1: Extract Initial Pageview ID & Pageview Count per Session
Filter for paid `gsearch nonbrand` traffic within the timeframe and identify each session's min pageview ID along with total pageviews.

* **Data Output Link:** 📄 [`step_1.csv`](./step_1.csv)

```sql
CREATE TEMPORARY TABLE sessions_w_min_pv_id_and_view_count
SELECT
    website_sessions.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS first_pageview_id,
    COUNT(website_pageviews.website_pageview_id) AS count_pageviews
FROM website_sessions
LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at > '2012-06-01' 
  AND website_sessions.created_at < '2012-08-31'
  AND website_sessions.utm_source = 'gsearch'
  AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY website_sessions.website_session_id;
```

**Sample Output (`step_1.csv`):**

| website_session_id | first_pageview_id | count_pageviews |
| :---: | :---: | :---: |
| 9350 | 18598 | 3 |
| 9351 | 18600 | 3 |
| 9352 | 18601 | 4 |

---

### 🔹 Step 2: Identify Landing Page URL and Session Created Time
Join back to `website_pageviews` using `website_session_id` to get the landing page URL and the exact session timestamp for each session.

* **Data Output Link:** 📄 [`step_2.csv`](./step_2.csv)

```sql
CREATE TEMPORARY TABLE session_w_counts_lander_and_created_at
SELECT
    sessions_w_min_pv_id_and_view_count.website_session_id,
    sessions_w_min_pv_id_and_view_count.first_pageview_id,
    sessions_w_min_pv_id_and_view_count.count_pageviews,
    website_pageviews.pageview_url AS landing_page,
    website_pageviews.created_at AS session_created_at
FROM sessions_w_min_pv_id_and_view_count
LEFT JOIN website_pageviews
    ON sessions_w_min_pv_id_and_view_count.website_session_id = website_pageviews.website_session_id;
```

**Sample Output (`step_2.csv`):**

| website_session_id | first_pageview_id | count_pageviews | landing_page | session_created_at |
| :---: | :---: | :---: | :---: | :---: |
| 9350 | 18598 | 3 | `/home` | 2012-06-01 00:05:11 |
| 9350 | 18598 | 3 | `/products` | 2012-06-01 00:08:58 |
| 9350 | 18598 | 3 | `/the-original-mr-fuzzy` | 2012-06-01 00:10:46 |

---

### 🔹 Step 3 & 4: Weekly Trend Aggregation
Group by week (`YEARWEEK`) to calculate the overall weekly bounce rate and traffic distribution across `/home` and `/lander-1`.

* **Final Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

```sql
SELECT
    YEARWEEK(session_created_at) AS year_week,
    MIN(DATE(session_created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) * 1.0 / 
    COUNT(DISTINCT website_session_id) AS bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions
FROM session_w_counts_lander_and_created_at
GROUP BY YEARWEEK(session_created_at);
```
**Final Aggregated Output (`final_output.csv`):**

| year_week | week_start_date | bounce_rate | home_sessions | lander_sessions |
| :---: | :---: | :---: | :---: | :---: |
| 201222 | 2012-06-01 | 60.57% | 175 | 0 |
| 201223 | 2012-06-03 | 58.71% | 792 | 0 |
| 201224 | 2012-06-10 | 61.60% | 875 | 0 |
| 201225 | 2012-06-17 | 55.82% | 492 | 350 |
| 201226 | 2012-06-24 | 58.28% | 369 | 386 |
| 201227 | 2012-07-01 | 58.21% | 392 | 388 |
| 201228 | 2012-07-08 | 56.68% | 390 | 411 |
| 201229 | 2012-07-15 | 54.24% | 429 | 421 |
| 201230 | 2012-07-22 | 51.38% | 402 | 394 |
| 201231 | 2012-07-29 | 49.71% | 33 | 995 |
| 201232 | 2012-08-05 | 53.82% | 0 | 1087 |
| 201233 | 2012-08-12 | 51.40% | 0 | 998 |
| 201234 | 2012-08-19 | 50.05% | 0 | 1012 |
| 201235 | 2012-08-26 | 53.78% | 0 | 833 |

---

## 💡 Key Business Insights

1. **Pre-Test Baseline (Early June):**
   * Before `/lander-1` launched (weeks of June 1 to June 10), 100% of traffic landed on `/home`, resulting in high bounce rates ranging from **58.71% to 61.60%**.

2. **A/B Split Test Phase (Mid-June to Late July):**
   * Starting the week of June 17 (`201225`), traffic was split 50/50 between `/home` (~400 sessions/week) and `/lander-1` (~400 sessions/week).
   * The blended weekly bounce rate immediately dropped from ~60% down to **51.38%–58.28%**.

3. **Full Scale Rollout (August Onward):**
   * Starting the week of July 29 (`201231`), traffic fully transitioned to `/lander-1` (reaching 100% rollout by August).
   * Weekly bounce rates stabilized around **50%–53.8%**, sustaining a permanent ~8% drop in overall bounce rates across paid nonbrand search campaigns.

