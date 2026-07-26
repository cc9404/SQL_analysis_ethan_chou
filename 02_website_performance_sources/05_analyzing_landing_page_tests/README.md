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
```

**Sample Output (`first_instance_of_lander1.csv`):**

| first_created_at | first_pageview_id |
| :---: | :---: |
| 2012-06-19 00:35:54 | 23504 |

---

### 🔹 Step 2 & 3: Filter Target Test Traffic & Landing Pages
Restrict analysis to `gsearch nonbrand` sessions after pageview ID 23504 and before July 28, 2012, mapping each session to its initial landing page (`/home` vs `/lander-1`).

* **Data Output Link:** 📄 [`first_pageviews.csv`](./first_pageviews_2.csv) 📄 [`nonbrand_test_sessions_w_landing_page.csv`](./nonbrand_test_sessions_w_landing_page.csv)

```sql
CREATE TEMPORARY TABLE first_pageviews
SELECT
    website_pageviews.website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
INNER JOIN website_sessions
    ON website_sessions.website_session_id = website_pageviews.website_session_id
    AND website_sessions.created_at < '2012-07-28'
    AND website_pageviews.website_pageview_id > 23504
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_page
SELECT 
    first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1');
```
**Sample Output (`first_pageviews.csv`):**

| website_session_id | min_pageview_id |
| :---: | :---: |
| 11684 | 23505 |
| 11685 | 23506 |
| 11686 | 23507 |

**Sample Output (`nonbrand_test_sessions_w_landing_page.csv`):**

| website_session_id | landing_page |
| :---: | :---: |
| 11684 | `/home` |
| 11685 | `/lander-1` |
| 11686 | `/lander-1` |

