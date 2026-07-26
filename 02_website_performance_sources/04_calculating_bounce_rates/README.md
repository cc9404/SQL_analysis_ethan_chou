### 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`bounce_rate_analysis.sql`](./bounce_rate_analysis.sql)

---

### 🔹 Step 1: Find Initial Pageview ID per Session
Extract the earliest `website_pageview_id` for each session up to June 14, 2012 to pinpoint the entry point.

* **Data Output Link:** 📄 [`first_pageviews.csv`](./first_pageviews.csv)

```sql
CREATE TEMPORARY TABLE first_pageviews
SELECT
    website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;
