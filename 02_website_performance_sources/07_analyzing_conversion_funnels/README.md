# 📄 Core Module 7: Analyzing Conversion Funnels

This module builds a full website conversion funnel for paid `gsearch nonbrand` traffic arriving at `/lander-1` between August 5, 2012 and September 5, 2012. It tracks user progression through each step—from entry to the order thank-you page—to identify click-through rates and key drop-off points.

---

## 📌 Business Problem & Context

Following the implementation of `/lander-1`, management wants to understand how effectively users navigate through the full purchasing funnel. By quantifying conversion rates at each step (landing page, products, cart, shipping, billing, thank you), we can identify friction points in the user journey and prioritize conversion rate optimization (CRO) efforts.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`analyzing_conversion_funnels.sql`](./analyzing_conversion_funnels.sql)

---

### 🔹 Step 1: Flag Pageview Steps per Session
Identify pageviews across all target funnel pages (`/products`, `/the-original-mr-fuzzy`, `/cart`, `/shipping`, `/billing`, `/thank-you-for-your-order`) for relevant sessions.

```sql
SELECT 
    website_sessions.website_session_id,
    website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
  AND website_sessions.utm_campaign = 'nonbrand'
  AND website_sessions.created_at > '2012-08-05'
  AND website_sessions.created_at < '2012-09-05'
ORDER BY
    website_sessions.website_session_id,
    website_pageviews.created_at;
```
