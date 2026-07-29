# 📄 Core Module 5: Analyzing Direct Traffic & Brand Growth

This module analyzes monthly session trends for Organic Search, Direct Type-in, and Paid Brand Search relative to Paid Nonbrand search sessions from March 2012 to December 2012. It measures the growth of brand awareness and unpaid traffic channels over time as paid marketing efforts scale.

---

## 📌 Business Problem & Context

As the business scales its paid nonbrand search marketing, leadership needs to confirm whether brand equity and customer recognition are growing organically. Tracking Direct Type-in, Organic Search, and Paid Brand Search—both in absolute session volume and as a percentage of Paid Nonbrand traffic—helps evaluate whether paid acquisition is successfully driving organic brand equity buildup.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`analyzing_direct_traffic.sql`](./analyzing_direct_traffic.sql)

---

### 🔹 Step 1: Channel Group Identification
Categorize traffic sources into distinct marketing channels (`organic_search`, `paid_nonbrand`, `paid_brand`, `direct_type_in`) based on UTM parameters and HTTP referrers.

```sql
SELECT DISTINCT
    CASE
        WHEN utm_source IS NULL AND http_referer IN ('[https://www.gsearch.com](https://www.gsearch.com)','[https://www.bsearch.com](https://www.bsearch.com)') THEN 'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
    END AS channel_group,
    utm_source,
    utm_campaign,
    http_referer
FROM website_sessions
WHERE created_at < '2012-12-23';
```
* **Data Output Link:** 📄 [`step_1.csv`](./step_1.csv)

**Output Data (`step_1.csv`):**

| channel_group | utm_source | utm_campaign | http_referer |
| :---: | :---: | :---: | :---: |
| organic_search | null | null | https://www.gsearch.com |
| paid_nonbrand | gsearch | nonbrand | https://www.gsearch.com |
| paid_brand | gsearch | brand | https://www.gsearch.com |
| direct_type_in | null | null | null |
| organic_search | null | null | https://www.bsearch.com |
| paid_nonbrand | bsearch | nonbrand | https://www.bsearch.com |
| paid_brand | bsearch | brand | https://www.bsearch.com |

---

### 🔹 Step 2: Mapping Sessions to Channel Groups
Map every individual `website_session_id` prior to December 23, 2012 to its assigned `channel_group` to prepare session-level data for monthly aggregation.

```sql
SELECT 
    website_session_id,
    created_at,
    CASE
        WHEN utm_source IS NULL AND http_referer IN ('[https://www.gsearch.com](https://www.gsearch.com)','[https://www.bsearch.com](https://www.bsearch.com)') THEN 'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
    END AS channel_group
FROM website_sessions
WHERE created_at < '2012-12-23';
```
* **Data Output Link:** 📄 [`step_2.csv`](./step_2.csv)

**Output Data Preview (`step_2.csv`):**

| website_session_id | created_at | channel_group |
| :---: | :---: | :---: |
| 1 | 2012-03-19 08:04:16 | paid_nonbrand |
| 2 | 2012-03-19 08:16:49 | paid_nonbrand |
| 3 | 2012-03-19 08:26:55 | paid_nonbrand |
| 4 | 2012-03-19 08:37:33 | paid_nonbrand |
| 5 | 2012-03-19 09:00:55 | paid_nonbrand |
| 6 | 2012-03-19 09:05:46 | paid_nonbrand |
| 7 | 2012-03-19 09:06:27 | paid_nonbrand |
| 8 | 2012-03-19 09:17:17 | paid_nonbrand |
| 9 | 2012-03-19 09:27:56 | paid_nonbrand |
| 10 | 2012-03-19 09:35:37 | paid_nonbrand |

---

### 🔹 Step 3: Final Aggregated Output (Monthly Brand Mix Growth)
Aggregate monthly session totals across all channel groups (`paid_nonbrand`, `paid_brand`, `direct_type_in`, `organic_search`) and compute brand, direct, and organic traffic as a percentage of paid nonbrand volume to track brand recognition over time.

```sql
SELECT
    YEAR(created_at) AS yr,
    MONTH(created_at) AS mo,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END) AS brand,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END)
        / COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS brand_pct_of_nonbrand,
    COUNT(DISTINCT CASE WHEN channel_group = 'direct_type_in' THEN website_session_id ELSE NULL END) AS direct,
    COUNT(DISTINCT CASE WHEN channel_group = 'direct_type_in' THEN website_session_id ELSE NULL END)
        / COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS direct_pct_of_nonbrand,
    COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END) AS organic,
    COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END) 
        / COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS organic_pct_of_nonbrand
FROM (
    SELECT 
        website_session_id,
        created_at,
        CASE
            WHEN utm_source IS NULL AND http_referer IN ('[https://www.gsearch.com](https://www.gsearch.com)','[https://www.bsearch.com](https://www.bsearch.com)') THEN 'organic_search'
            WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
            WHEN utm_campaign = 'brand' THEN 'paid_brand'
            WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
        END AS channel_group
    FROM website_sessions
    WHERE created_at < '2012-12-23'
) AS session_w_channel_group
GROUP BY
    YEAR(created_at),
    MONTH(created_at);
```

* **Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

**Output Data (`final_output.csv`):**

| yr | mo | nonbrand | brand | brand_pct_of_nonbrand | direct | direct_pct_of_nonbrand | organic | organic_pct_of_nonbrand |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 2012 | 3 | 1852 | 10 | 0.54% | 9 | 0.49% | 8 | 0.43% |
| 2012 | 4 | 3509 | 76 | 2.17% | 71 | 2.02% | 78 | 2.22% |
| 2012 | 5 | 3295 | 140 | 4.25% | 151 | 4.58% | 150 | 4.55% |
| 2012 | 6 | 3439 | 164 | 4.77% | 170 | 4.94% | 190 | 5.52% |
| 2012 | 7 | 3660 | 195 | 5.33% | 187 | 5.11% | 207 | 5.66% |
| 2012 | 8 | 5318 | 264 | 4.96% | 250 | 4.70% | 265 | 4.98% |
| 2012 | 9 | 5591 | 339 | 6.06% | 285 | 5.10% | 331 | 5.92% |
| 2012 | 10 | 6883 | 432 | 6.28% | 440 | 6.39% | 428 | 6.22% |
| 2012 | 11 | 12260 | 556 | 4.54% | 571 | 4.66% | 624 | 5.09% |
| 2012 | 12 | 6643 | 464 | 6.98% | 482 | 7.26% | 492 | 7.41% |

---

## 💡 Key Business Insights

1. **Sustained Brand Equity Growth:**
   * In March 2012, brand, direct, and organic channels each accounted for **less than 0.6%** of nonbrand volume.
   * By December 2012, brand search reached **6.98%**, direct traffic reached **7.26%**, and organic search reached **7.41%** of nonbrand volume.
   * Combined, unpaid and brand channels grew to represent over **21.6%** of paid nonbrand traffic by year-end, proving that initial nonbrand paid investment successfully built organic brand recognition.

2. **Scaling Beyond Paid Ads:**
   * Organic and direct channels expanded nearly **60x in volume** from March (~8–9 sessions/mo) to December (~480–492 sessions/mo), demonstrating compounding returns on brand awareness over time.

3. **Strategic Recommendations:**
   * Continue funding paid nonbrand acquisition as it serves as an effective feeder funnel for long-term organic retention and direct visits.
