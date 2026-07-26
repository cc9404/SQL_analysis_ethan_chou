# 📄 Core Module 4: Calculating Bounce Rates

This module calculates the baseline bounce rate for homepage traffic prior to June 14, 2012 (`created_at < '2012-06-14'`), establishing a multi-step temporary table workflow to identify single-pageview sessions and evaluate initial user engagement.

---

## 📌 Business Problem & Context

Since early traffic landed exclusively on `/home`, management needed to understand how effectively the homepage retained visitors. High bounce rates indicate that users leave immediately without viewing additional pages, representing lost marketing efficiency and conversion opportunities.

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

### 🔹 Step 2: Restrict to Homepage Landing Sessions
Join `first_pageviews` back to `website_pageviews` to filter exclusively for sessions that entered via `/home`.

* **Data Output Link:** 📄 [`sessions_w_home_landing_page.csv`](./sessions_w_home_landing_page.csv)

```sql
CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
    first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url = '/home';
```

---

**Sample Output (`sessions_w_home_landing_page.csv`):**

| website_session_id | landing_page |
| :---: | :---: |
| 1 | `/home` |
| 2 | `/home` |
| 3 | `/home` |
| 4 | `/home` |
| 5 | `/home` |

---

### 🔹 Step 3: Identify Bounced Sessions (Single-Page Views)
Count the total pageviews for each homepage session and use `HAVING COUNT(...) = 1` to isolate bounced sessions.

* **Data Output Link:** 📄 [`bounced_sessions.csv`](./bounced_sessions.csv)

```sql
CREATE TEMPORARY TABLE bounced_sessions
SELECT
    sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewd
FROM sessions_w_home_landing_page
LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id = sessions_w_home_landing_page.website_session_id
GROUP BY
    sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.landing_page
HAVING
    COUNT(website_pageviews.website_pageview_id) = 1;
```

**Sample Output (`bounced_sessions.csv`):**

| website_session_id | landing_page | count_of_pages_viewd |
| :---: | :---: | :---: |
| 1 | `/home` | 1 |
| 2 | `/home` | 1 |
| 3 | `/home` | 1 |
| 4 | `/home` | 1 |
| 5 | `/home` | 1 |

---

### 🔹 Step 4: Calculate Final Bounce Rate
Summarize total homepage sessions against total bounced sessions to derive the baseline homepage bounce rate.

* **Final Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

```sql
SELECT
    COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) / 
    COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS bounce_rate
FROM sessions_w_home_landing_page
LEFT JOIN bounced_sessions
    ON sessions_w_home_landing_page.website_session_id = bounced_sessions.website_session_id;
```

**Final Aggregated Output (`final_output.csv`):**

| sessions | bounced_sessions | bounce_rate |
| :---: | :---: | :---: |
| **11,044** | **6,636** | **59.18%** |

---

## 💡 Key Business Insights

1. **High Baseline Churn:**
   * Out of **11,044 homepage sessions**, **6,636 sessions bounced** after viewing only the initial landing page[cite: 1].
   * The initial baseline bounce rate for `/home` stands at **59.18%**[cite: 1].

2. **Conversion Opportunity:**
   * Nearly 6 in 10 visitors left immediately without further interaction[cite: 1]. Improving homepage engagement represents a major opportunity to stop wasting traffic and retain qualified buyers[cite: 1].

3. **Recommended Next Steps:**
   * **A/B Split Test:** Launch a new custom landing page (e.g., `/land-1`) featuring clearer product value propositions and stronger call-to-actions (CTAs)[cite: 1].
   * **Performance Benchmarking:** Run a controlled A/B split test comparing the new landing page against `/home` to evaluate bounce rate reduction[cite: 1].




