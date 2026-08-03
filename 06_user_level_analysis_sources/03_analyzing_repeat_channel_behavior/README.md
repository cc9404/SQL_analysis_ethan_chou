# 📄 Core Module 3: Analyzing Repeat Channel Behavior

This module compares website session traffic sources between new and repeat visitors for Fuzzy Factory between **January 1, 2014 and November 5, 2014**.

---

## 📌 Business Problem & Context

Understanding which marketing channels drive new customer acquisition versus repeat traffic is essential for optimizing ad spend and retention strategy. Management requested a breakdown comparing organic search, paid non-brand, paid brand, direct type-in, and paid social channels to determine how returning users re-engage with the website.

---

## 🛠️ SQL Script & Data Pipeline

* **Main SQL Script:** 🔗 [`analyzing_repeat_channel_behavior.sql`](./analyzing_repeat_channel_behavior.sql)[cite: 3]
* **Step 1 Output Link:** 📄 [`step_1.csv`](./step_1.csv)
* **Final Output Link:** 📄 [`final_output.csv`](./final_output.csv)

---

### 🔹 Step 1: Breakdown Traffic by Source Parameters
Aggregate session counts for new vs. repeat visitors grouped by raw UTM parameters (`utm_source`, `utm_campaign`, `http_referer`).

```sql
-- STEP 1: Aggregate new vs repeat sessions by raw traffic parameters
SELECT
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
    COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM website_sessions
WHERE created_at < '2014-11-05'
  AND created_at >= '2014-01-01'
GROUP BY 1, 2, 3
ORDER BY 5 DESC;
```

---

* **Data Output Link:** 📄 [`step_1.csv`](./step_1.csv)

**Output Data Sample (`step_1.csv`):**

| utm_source | utm_campaign | http_referer | new_sessions | repeat_sessions |
| :---: | :---: | :---: | :---: | :---: |
| - | - | - | 0 | **8,108** |
| - | - | https://www.gsearch.com | 0 | **7,600** |
| gsearch | nonbrand | https://www.gsearch.com | 94,809 | **0** |
| gsearch | brand | https://www.gsearch.com | 5,233 | **4,825** |
| - | - | https://www.bsearch.com | 0 | **1,529** |

---

### 🔹 Step 2: Categorize Channel Groups & Aggregate Final Output
Map UTM source, campaign, and referer combinations into distinct high-level channel categories (`organic_search`, `paid_nonbrand`, `paid_brand`, `direct_type_in`, `paid_social`) to compare new acquisition traffic against returning traffic contribution across each channel.

```sql
-- STEP 2: Group traffic into high-level channel categories and aggregate
SELECT
	CASE
		WHEN utm_source IS NULL AND http_referer IN('[https://www.gsearch.com](https://www.gsearch.com)','[https://www.bsearch.com](https://www.bsearch.com)') THEN 'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
		WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
		WHEN utm_source = 'socialbook' THEN 'paid_social'
	END AS channel_group,
    COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
	COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM website_sessions
WHERE created_at < '2014-11-05'
  AND created_at >= '2014-01-01'
GROUP BY 1
ORDER BY 3 DESC;
```

---

## 📊 Summary Performance Comparison (`final_output.csv`)

* **Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

**Output Data Summary (`final_output.csv`):**

| channel_group | new_sessions | repeat_sessions |
| :--- | :---: | :---: |
| **organic_search** | 0 | **9,129** |
| **direct_type_in** | 0 | **8,108** |
| **paid_brand** | 6,509 | **6,051** |
| **paid_social** | 8,926 | **0** |
| **paid_nonbrand** | 127,703 | **0** |

---

## 💡 Key Business Insights

1. **Organic & Direct Channel Dominance for Repeat Traffic:**
   * **Organic Search (9,129 sessions)** and **Direct Type-In (8,108 sessions)** account for the vast majority of repeat visits[. This indicates strong brand recall and intent, as returning visitors re-engage without needing paid retargeting ads.

2. **Paid Brand Captures Strong Returning Intent:**
   * **Paid Brand** generated **6,051 repeat sessions** alongside 6,509 new sessions, demonstrating that a significant portion of returning users still click on paid search ads when looking for the brand name.

3. **Paid Non-Brand & Paid Social Drive Acquisition Only:**
   * **Paid Non-Brand (127,703 sessions)** and **Paid Social (8,926 sessions)** yielded **0 repeat visits**, confirming their role exclusively as top-of-funnel (TOFU) discovery channels rather than retention drivers.

4. **Strategic Recommendations:**
   * **Optimize Retargeting & Email Automation:** Rely on zero-CAC channels (email, direct, and organic SEO) to nurture post-purchase engagement rather than paying for re-acquisition.
   * **Refine Brand Search Bidding:** Monitor Paid Brand campaigns to ensure budget isn't wasted on existing customers who would otherwise return organically via Direct or Organic search.
