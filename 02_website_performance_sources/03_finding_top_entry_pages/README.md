# 📄 Core Module 3: Finding Top Entry Pages

This module determines the primary entry points (landing pages) across all user sessions prior to June 12, 2012 (`created_at < '2012-06-12'`) by identifying the first pageview of each session and measuring homepage traffic exposure.

---

## 📌 Business Problem & Context

Following up on top viewed pages, leadership wants to confirm whether `/home` acts as the exclusive landing page for all incoming traffic. Identifying entry page distribution allows the team to evaluate whether the homepage provides the optimal initial user experience or if dedicated landing pages should be introduced.

---

## 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`finding_top_entry_pages.sql`](./finding_top_entry_pages.sql)
* **Key SQL Techniques:** Two-step aggregation using Temporary Tables (`CREATE TEMPORARY TABLE`), `MIN()` for initial pageview identification, `LEFT JOIN`, and `COUNT(DISTINCT)`.

```sql
-- finding top entry pages (landing pages)
-- STEP 1: find the first pageview for each session
-- STEP 2: find the url the customer saw on that first pageview

CREATE TEMPORARY TABLE first_pv_per_session
SELECT
    website_session_id,
    MIN(website_pageview_id) AS first_pv
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

SELECT
    website_pageviews.pageview_url AS landing_page_url,
    COUNT(DISTINCT first_pv_per_session.website_session_id) AS sessions_hitting_page
FROM first_pv_per_session
LEFT JOIN website_pageviews
    ON first_pv_per_session.first_pv = website_pageviews.website_pageview_id
GROUP BY website_pageviews.pageview_url;
```

---

### 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`finding_top_entry_pages.csv`](./finding_top_entry_pages.csv)

| landing_page_url | sessions_hitting_page |
| :---: | :---: |
| `/home` | **10,714** |

---

### 💡 Key Business Insights

1. **Complete Entry Dependency:**
   * Across all **10,714 analyzed sessions**, 100% of incoming users entered the website exclusively through the `/home` page.
   * No secondary or custom landing pages were receiving direct entry traffic during this period.

2. **Strategic Evaluation:**
   * While a single entrance simplifies user flow management, relying entirely on `/home` may miss opportunities to match specific user intent or ad campaigns with targeted landing experiences.

3. **Recommended Next Steps:**
   * **Homepage Performance Analysis:** Calculate the bounce rate specifically for `/home` to establish baseline landing page performance.
   * **Landing Page Strategy:** Test custom landing pages (e.g., product-focused landers) for paid campaigns to see if tailored entry points improve engagement and conversion rates.
