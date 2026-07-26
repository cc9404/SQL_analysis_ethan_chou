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

* **Data Output Link:** 📄 [`first_pageviews.csv`](./first_pageviews.csv) 📄 [`nonbrand_test_sessions_w_landing_page.csv`](./nonbrand_test_sessions_w_landing_page.csv)

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

---

### 🔹 Step 4: Identify Single-Page Bounced Sessions
Count total pageviews for each test session and isolate those with only 1 pageview to identify bounced sessions.

* **Data Output Link:** 📄 [`nonbrand_test_bounced_sessions.csv`](./nonbrand_test_bounced_sessions.csv)

```sql
CREATE TEMPORARY TABLE nonbrand_test_bounced_sessions
SELECT 
    nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewd
FROM nonbrand_test_sessions_w_landing_page
LEFT JOIN website_pageviews
    ON website_pageviews.website_session_id = nonbrand_test_sessions_w_landing_page.website_session_id
GROUP BY
    nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page
HAVING 
    COUNT(website_pageviews.website_pageview_id) = 1;
```

**Sample Output (`nonbrand_test_bounced_sessions.csv`):**

| website_session_id | landing_page | count_of_pages_viewd |
| :---: | :---: | :---: |
| 11684 | `/home` | 1 |
| 11685 | `/lander-1` | 1 |
| 11687 | `/home` | 1 |
| 11688 | `/home` | 1 |
| 11690 | `/home` | 1 |

---

### 🔹 Step 5: Final Performance Summary & Bounce Rate Comparison
Compare total sessions, bounced sessions, and bounce rates between `/home` and `/lander-1` to evaluate the A/B test performance.

* **Final Data Output Link:** 📄 [`identify_bounces_n_final_output.csv`](./identify_bounces_n_final_output.csv)

```sql
SELECT
    nonbrand_test_sessions_w_landing_page.landing_page,
    COUNT(DISTINCT nonbrand_test_sessions_w_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT nonbrand_test_bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT nonbrand_test_bounced_sessions.website_session_id) / 
    COUNT(DISTINCT nonbrand_test_sessions_w_landing_page.website_session_id) AS bounce_rate
FROM nonbrand_test_sessions_w_landing_page
LEFT JOIN nonbrand_test_bounced_sessions
    ON nonbrand_test_sessions_w_landing_page.website_session_id = nonbrand_test_bounced_sessions.website_session_id
GROUP BY
    nonbrand_test_sessions_w_landing_page.landing_page;
```

**Final Aggregated Output (`identify_bounces_n_final_output.csv`):**

| landing_page | sessions | bounced_sessions | bounce_rate |
| :---: | :---: | :---: | :---: |
| `/home` | **2,261** | **1,319** | **58.34%** |
| `/lander-1` | **2,315** | **1,232** | **53.22%** |

---

## 💡 Key Business Insights

1. **Successful Bounce Rate Reduction:**
   * `/lander-1` achieved a bounce rate of **53.22%**, compared to **58.34%** for `/home`.
   * This represents an absolute bounce rate reduction of **5.12%** (a **~8.8% relative improvement** in user retention).

2. **Traffic Engagement Improvement:**
   * For paid nonbrand search campaigns where customer acquisition cost (CAC) is high, retaining an extra ~5% of visitors significantly boosts marketing spend efficiency.

3. **Recommended Next Steps:**
   * **Full Rollout:** Direct 100% of paid nonbrand campaign traffic to `/lander-1`.
   * **Downstream Funnel Analysis:** Track whether these retained visitors convert into completed purchases at a higher overall rate.
