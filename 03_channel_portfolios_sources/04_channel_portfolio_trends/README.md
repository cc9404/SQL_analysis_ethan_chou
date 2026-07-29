# 📄 Core Module 4: Channel Portfolio Trends (Impact of Bid Changes)

This module analyzes weekly nonbrand session volume for `gsearch` and `bsearch` broken down by device type (`desktop` vs. `mobile`) from November 4, 2012 to December 22, 2012. It evaluates the impact of reducing `bsearch` desktop bids on December 2, 2012.

---

## 📌 Business Problem & Context

Following the bid optimization strategy where `bsearch` bids were lowered due to lower relative conversion performance, leadership wants to analyze the impact on traffic volume. Tracking weekly session ratios between `bsearch` and `gsearch` across devices allows management to confirm whether the bid change effectively reduced lower-converting traffic as intended without disrupting core growth[cite: 3].

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`impact_of_bid_changes.sql`](./impact_of_bid_changes.sql)

---

### 🔹 Step 1: Weekly Device-Level Session Ratios
Aggregate weekly desktop and mobile sessions for `gsearch` and `bsearch`, and compute the relative proportion (`bsearch` as a percentage of `gsearch`) for each device type.

```sql
SELECT
    MIN(DATE(website_sessions.created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS g_dtop_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS b_dtop_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END)
    / COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS b_pct_of_g_dtop,
    
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS g_mob_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS b_mob_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)
    / COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS b_pct_of_g_mob
FROM website_sessions
WHERE website_sessions.created_at > '2012-11-04'
  AND website_sessions.created_at < '2012-12-22'
  AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(website_sessions.created_at);
```

---

* **Data Output Link:** 📄 [`impact_of_bid_changes.csv`](./impact_of_bid_changes.csv)

**Output Data (`impact_of_bid_changes.csv`):**

| week_start_date | g_dtop_sessions | b_dtop_sessions | b_pct_of_g_dtop | g_mob_sessions | b_mob_sessions | b_pct_of_g_mob |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 2012-11-04 | 1027 | 400 | 38.95% | 323 | 29 | 8.98% |
| 2012-11-11 | 956 | 401 | 41.95% | 290 | 37 | 12.76% |
| 2012-11-18 | 2655 | 1008 | 37.97% | 853 | 85 | 9.96% |
| 2012-11-25 | 2058 | 843 | 40.96% | 692 | 62 | 8.96% |
| 2012-12-02 | 1326 | 517 | 38.99% | 396 | 31 | 7.83% |
| 2012-12-09 | 1277 | 293 | 22.94% | 424 | 46 | 10.85% |
| 2012-12-16 | 1270 | 348 | 27.40% | 376 | 41 | 10.90% |

---

## 💡 Key Business Insights

1. **Clear Impact of Desktop Bid Reduction:**
   * Prior to December 2, `bsearch` desktop sessions consistently tracked at **~38%–42%** of `gsearch` desktop volume.
   * Following the bid reduction implemented on December 2, `b_pct_of_g_dtop` dropped significantly to **22.94%** (week of Dec 9) and **27.40%** (week of Dec 16).

2. **Stability in Mobile Ratios:**
   * Mobile ratios (`b_pct_of_g_mob`) remained relatively stable around **8%–11%** post-bid change, confirming that the desktop bid reduction specifically impacted desktop traffic acquisition efficiency as intended.

3. **Strategic Recommendations:**
   * Monitor long-term ROI to ensure the reduction in traffic volume is fully offset by lower ad spend and improved profit margins per order on Bing.

