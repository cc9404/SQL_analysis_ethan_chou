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
* **Data Output Link:** 📄 [`step_1.csv`](./step_1.csv)

**Sample Output (`step_1_2.csv`):**

| website_session_id | pageview_url | products_page | mrfuzzy_page | cart_page | shipping_page | billing_page | thankyou_page |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 18243 | `/lander-1` | 0 | 0 | 0 | 0 | 0 | 0 |
| 18244 | `/lander-1` | 0 | 0 | 0 | 0 | 0 | 0 |
| 18244 | `/products` | 1 | 0 | 0 | 0 | 0 | 0 |
| 18244 | `/the-original-mr-fuzzy` | 0 | 1 | 0 | 0 | 0 | 0 |
| 18244 | `/cart` | 0 | 0 | 1 | 0 | 0 | 0 |
| 18244 | `/shipping` | 0 | 0 | 0 | 1 | 0 | 0 |
| 18244 | `/billing` | 0 | 0 | 0 | 0 | 1 | 0 |

---

### 🔹 Step 2: Aggregate Funnel Progression at Session Level
Group the pageview-level flags by `website_session_id` to aggregate maximum pageview flags (`MAX()`), summarizing whether each session successfully reached each funnel stage[cite: 2].

```sql
SELECT
    website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM (
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
        website_pageviews.created_at
) AS pageview_level
GROUP BY website_session_id;
```

* **Data Output Link:** 📄 [`step_2.csv`](./step_2.csv)

**Sample Output (`step_2.csv`):**

| website_session_id | product_made_it | mrfuzzy_made_it | cart_made_it | shipping_made_it | billing_made_it | thankyou_made_it |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 18243 | 0 | 0 | 0 | 0 | 0 | 0 |
| 18244 | 1 | 1 | 1 | 1 | 1 | 0 |
| 18245 | 0 | 0 | 0 | 0 | 0 | 0 |
| 18246 | 1 | 0 | 0 | 0 | 0 | 0 |
| 18247 | 1 | 1 | 0 | 0 | 0 | 0 |

---

### 🔹 Step 3: Create Temporary Table for Session-Level Funnel Progression
Create a temporary table `session_level_made_it_flags` to store the aggregated funnel flags for each session, serving as the foundation for calculating overall funnel conversion metrics.

```sql
CREATE TEMPORARY TABLE session_level_made_it_flags
SELECT
    website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM (
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
        website_pageviews.created_at
) AS pageview_level
GROUP BY website_session_id;

SELECT * FROM session_level_made_it_flags;
```

* **Data Output Link:** 📄 [`step_3.csv`](./step_3.csv)

**Sample Output (`step_3.csv`):**

| website_session_id | product_made_it | mrfuzzy_made_it | cart_made_it | shipping_made_it | billing_made_it | thankyou_made_it |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 18243 | 0 | 0 | 0 | 0 | 0 | 0 |
| 18244 | 1 | 1 | 1 | 1 | 1 | 0 |
| 18245 | 0 | 0 | 0 | 0 | 0 | 0 |
| 18246 | 1 | 0 | 0 | 0 | 0 | 0 |
| 18247 | 1 | 1 | 0 | 0 | 0 | 0 |

---

### 🔹 Final Output Part 1: Funnel Volume Summary
Aggregate session-level funnel flags to quantify the total session volume reaching each step of the conversion funnel.

```sql
SELECT
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flags;
```

* **Data Output Link:** 📄 [`final_output_part_1.csv`](./final_output_part_1.csv)

**Final Aggregated Output Part 1 (`final_output_part_1.csv`):**

| sessions | to_products | mrfuzzy | to_cart | to_shipping | to_billing | to_thankyou |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 4493 | 2115 | 1567 | 683 | 455 | 361 | 158 |

---

### 🔹 Final Output Part 2: Step-by-Step Click-Through Rates
Calculate the conversion click-through rate between each consecutive funnel stage.

```sql
SELECT
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT website_session_id) AS lander_click_rt,
    
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS product_click_rt,
    
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_click_rt,
    
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rt,
    
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_click_rt,
    
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rt
FROM session_level_made_it_flags;
```
* **Data Output Link:** 📄 [`final_output_part_2.csv`](./final_output_part_2.csv)

**Final Aggregated Output Part 2 (`final_output_part_2.csv`):**

| lander_click_rt | product_click_rt | mrfuzzy_click_rt | cart_click_rt | shipping_click_rt | billing_click_rt |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 47.07% | 74.09% | 43.59% | 66.62% | 79.34% | 43.77% |



