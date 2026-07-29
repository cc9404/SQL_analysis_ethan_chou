# 📄 Core Module 2: Comparing Channel Characteristics

This module evaluates the user profile and device characteristics of nonbrand search campaigns across different acquisition channels (`gsearch` vs. `bsearch`) between August 22, 2012 and November 30, 2012. It specifically compares the percentage of mobile traffic on each search platform to identify channel-specific behavior differences.

---

## 📌 Business Problem & Context

To optimize bidding strategies for the newly launched `bsearch` nonbrand campaign, marketing leadership needs to understand how user behavior and traffic composition on Bing (`bsearch`) compare to Google (`gsearch`). Specifically, determining the mobile traffic distribution across channels helps tailor device-level bidding strategies for maximum efficiency.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`comparing_channel_characteristic.sql`](./comparing_channel_characteristic.sql)

---

### 🔹 Step 1: Channel-Level Device Distribution Aggregation
Aggregate total nonbrand sessions, mobile session counts, and calculate the proportion of mobile traffic (`pct_mobile`) grouped by traffic source (`utm_source`).

```sql
SELECT
    utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT website_sessions.website_session_id) AS pct_mobile
FROM website_sessions
WHERE created_at > '2012-08-22'
  AND created_at < '2012-11-30'
  AND utm_campaign = 'nonbrand'
GROUP BY utm_source;
```

---

* **Data Output Link:** 📄 [`comparing_channel_characteristic.csv`](./comparing_channel_characteristic.csv)

**Output Data (`comparing_channel_characteristic.csv`):**

| utm_source | sessions | mobile_sessions | pct_mobile |
| :---: | :---: | :---: | :---: |
| bsearch | 6522 | 562 | 8.62% |
| gsearch | 20073 | 4921 | 24.52% |

---

## 💡 Key Business Insights

1. **Distinct Device Mix Between Channels:**
   * **`gsearch` Mobile Share:** Mobile traffic accounts for **24.52%** (~1 in 4 users) of total nonbrand traffic on `gsearch`.
   * **`bsearch` Mobile Share:** Mobile traffic represents only **8.62%** (<1 in 10 users) of total nonbrand traffic on `bsearch`, showing a heavily desktop-skewed user base.

2. **Strategic Bidding Recommendations:**
   * **Custom Device Bidding:** Since `bsearch` traffic is overwhelmingly desktop-based (91.38%), device-specific bid adjustments should be applied independently for each channel rather than copying `gsearch` desktop/mobile bid ratios directly to `bsearch`.
   * **Channel Allocation Strategy:** Higher desktop bids on `bsearch` can be justified if desktop traffic exhibits higher conversion rates and higher average order value (AOV).
