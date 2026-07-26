# 📄 Core Module 4: Calculating Bounce Rates

This module calculates the baseline bounce rate for homepage traffic prior to June 14, 2012 (`created_at < '2012-06-14'`), establishing a multi-step temporary table workflow to identify single-pageview sessions and evaluate initial user engagement[cite: 1].

---

## 📌 Business Problem & Context

Since early traffic landed exclusively on `/home`, management needed to understand how effectively the homepage retained visitors[cite: 1]. High bounce rates indicate that users leave immediately without viewing additional pages, representing lost marketing efficiency and conversion opportunities[cite: 1].

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`bounce_rate_analysis.sql`](./bounce_rate_analysis.sql)

---

### 🔹 Step 1: Find Initial Pageview ID per Session
Extract the earliest `website_pageview_id` for each session up to June 14, 2012 to pinpoint the entry point[cite: 1].

* **Data Output Link:** 📄 [`first_pageviews.csv`](./first_pageviews.csv)

```sql
CREATE TEMPORARY TABLE first_pageviews
SELECT
    website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

```

**Sample Output (`first_pageviews.csv`):**

| website_session_id | min_pageview_id |
| :---: | :---: |
| 1 | 1 |
| 2 | 2 |
| 3 | 3 |
| 4 | 4 |
| 5 | 5 |

---
