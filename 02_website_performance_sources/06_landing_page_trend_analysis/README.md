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


