# 📄 Core Module 4: Calculating Bounce Rates

This module calculates the bounce rate for homepage traffic prior to June 14, 2012 (`created_at < '2012-06-14'`), identifying sessions that resulted in only a single pageview to evaluate early user engagement.

---

## 📌 Business Problem & Context

Since all initial website traffic lands exclusively on `/home`, understanding how effectively the homepage engages visitors is crucial. A high bounce rate indicates that users leave without taking further action, highlighting a major area for user experience optimization and potential A/B testing.

---

## 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`bounce_rate_analysis.sql`](./bounce_rate_analysis.sql)
* **Key SQL Techniques:** Multi-stage Temporary Tables (`CREATE TEMPORARY TABLE`), `MIN()`, `LEFT JOIN`, `GROUP BY ... HAVING COUNT(*) = 1`, and calculated ratios.

```sql
-- bounce rate analysis
-- STEP 1: finding the first website_pageview_id for relevant sessions
-- STEP 2: identifying the landing page of each session
-- STEP 3: counting pageviews for each session, to identify "bounces"
-- STEP 4: summarizing by counting total sessions and bounced sessions

USE mavenfuzzyfactory;

CREATE TEMPORARY TABLE first_pageviews
SELECT
    website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
    first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url = '/home';

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

-- final output for Assignment_Calculating_Bounce_Rates
SELECT
    COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id)/COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS bounce_rate
FROM sessions_w_home_landing_page
LEFT JOIN bounced_sessions
    ON sessions_w_home_landing_page.website_session_id = bounced_sessions.website_session_id;

```
