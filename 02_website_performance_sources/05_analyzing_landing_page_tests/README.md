# 📄 Core Module 5: Analyzing Landing Page Tests

This module evaluates an A/B split test comparing the original `/home` landing page against a new custom landing page (`/lander-1`) for `gsearch` `nonbrand` search traffic between June 19, 2012 and July 28, 2012.

---

## 📌 Business Problem & Context

Following the initial bounce rate analysis showing a high ~59% bounce rate on `/home`, the marketing team launched a new landing page (`/lander-1`) to improve engagement[cite: 1, 2]. Management requested an A/B test evaluation to determine whether `/lander-1` successfully reduces bounce rates for paid nonbrand search visitors.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`analyzing_landing_page_tests.sql`](./analyzing_landing_page_tests.sql)

---

### 🔹 Step 1: Determine Landing Page Launch Date
Find the first pageview timestamp and ID for `/lander-1` to establish the analysis start timeframe.

* **Data Output Link:** 📄 [`first_instance_of_lander1.csv`](./first_instance_of_lander1.csv)

```sql
SELECT
    MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'
  AND created_at IS NOT NULL;
