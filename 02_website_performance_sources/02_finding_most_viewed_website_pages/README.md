# 📄 Core Module 2: Finding Most Viewed Website Pages

This module ranks all website pages by total pageview volume prior to mid-June 2012 (`created_at < '2012-06-09'`) to evaluate overall traffic distribution across the conversion funnel.

---

## 📌 Business Problem & Context

To understand user navigation patterns and pinpoint high-impact pages, leadership requested a breakdown of total pageviews across the site. Identifying top-visited pages helps prioritize UI/UX optimization and identify potential drop-off points along the customer journey.

---

## 💻 SQL Query & Methodology

* **SQL Script:** 🔗 [`finding_most_viewed_website_pages.sql`](./finding_most_viewed_website_pages.sql)
* **Key SQL Techniques:** Aggregate function `COUNT(DISTINCT)`, Date filtering (`WHERE created_at < ...`), `GROUP BY`, and Sorting (`ORDER BY ... DESC`).

```sql
-- Finding most-viewed website pages, ranked by session volume
USE mavenfuzzyfactory;

SELECT
    pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pageviews
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY pageviews DESC;
```

---

### 📊 Query Results (Data Output)

* **Raw Data Output:** 📄 [`finding_most_viewed_website_pages.csv`](./finding_most_viewed_website_pages.csv)

| pageview_url | pageviews |
| :--- | :---: |
| `/home` | **10,403** |
| `/products` | **4,239** |
| `/the-original-mr-fuzzy` | **3,037** |
| `/cart` | **1,306** |
| `/shipping` | **869** |
| `/billing` | **716** |
| `/thank-you-for-your-order` | **306** |

---

### 💡 Key Business Insights

1. **Top-of-Funnel Dominance:**
   * `/home` is by far the most visited page (**10,403 pageviews**), representing the primary portal for user traffic.
   * Product browsing pages (`/products` and `/the-original-mr-fuzzy`) follow as the second highest group (**7,276 total pageviews combined**).

2. **Funnel Drop-off Pattern:**
   * A progressive drop-off is observed moving down the funnel: `/cart` (1,306) ➔ `/shipping` (869) ➔ `/billing` (716) ➔ `/thank-you-for-your-order` (306).
   * Only **~2.9% of initial home pageviews** currently translate into completed orders (`/thank-you-for-your-order`).

3. **Recommended Next Steps:**
   * **Entry Page Verification:** Confirm whether `/home` is also serving as the primary entry point across all traffic sources.
   * **Checkout Funnel Optimization:** Analyze conversion drop-offs between `/cart`, `/shipping`, and `/billing` to identify bottlenecks.



