# 📄 Core Module 1: Finding Top Website Pages & Entry Pages

This module identifies the primary landing pages (entry pages) for website visitors by extracting the initial pageview for early website sessions (`website_pageview_id < 1000`) and determining entry traffic distribution.

---

## 📌 Business Problem & Context

To optimize front-end user experience and campaign landing pages, management needs to understand where users first arrive on the Fuzzy Factory website. By isolating initial pageview hits, we measure the dominance of specific entry points across early platform history.

---

## 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`finding_top_website_pages_and_entry_pages.sql`](./finding_top_website_pages_and_entry_pages.sql)
* **Key SQL Techniques:** Temporary Tables (`CREATE TEMPORARY TABLE`), `MIN()` for initial pageview extraction, `LEFT JOIN`, and `COUNT(DISTINCT)`.

```sql
-- Finding top website pages and entry pages
USE mavenfuzzyfactory;

CREATE TEMPORARY TABLE first_pageview
SELECT
    website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
WHERE website_pageview_id < 1000
GROUP BY website_session_id;

SELECT
    website_pageviews.pageview_url AS landing_page, -- aka "entry page"
    COUNT(DISTINCT first_pageview.website_session_id) AS sessions_hitting_this_lander
FROM first_pageview
LEFT JOIN website_pageviews
    ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY 
    website_pageviews.pageview_url;
```

### 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`finding_top_website_pages_and_entry_pages.csv`](./finding_top_website_pages_and_entry_pages.csv)

| landing_page | sessions_hitting_this_lander |
| :---: | :---: |
| `/home` | **523** |

---

### 💡 Key Business Insights

1. **Single Entry Point Dominance:**
   * During the early period (`website_pageview_id < 1000`), **100% of analyzed sessions (523 sessions)** landed exclusively on the `/home` page.
2. **Strategic Implications:**
   * Since `/home` acts as the sole front door for all initial traffic, optimizing homepage messaging, load speeds, and call-to-action (CTA) placements is critical for driving downstream conversions.
3. **Recommended Next Steps:**
   * **Expand Scope:** Evaluate entry page volume across full dataset timeframes to see if secondary landing pages (e.g., custom campaign landers) are introduced later.
   * **Bounce Rate Analysis:** Measure bounce rates specifically for `/home` to determine user engagement levels upon entry.


