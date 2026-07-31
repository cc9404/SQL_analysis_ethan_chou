# 📄 Core Module 3: Product-Level Website Pathing & Conversion Funnels

This module builds side-by-side conversion funnels for Fuzzy Factory's two main products (`/the-original-mr-fuzzy` vs. `/the-forever-love-bear`) from January 6, 2013 to April 10, 2013. The objective is to analyze user navigation flow and click-through rates across each step of the checkout process to evaluate product page effectiveness.

---

## 📌 Business Problem & Context

Following the launch of Product 2 (Love Bear) in early January 2013, management requested a comparative funnel analysis to determine whether visitors viewing the new product page converted at a different rate compared to the flagship product (`Mr. Fuzzy`). Evaluating step-by-step drop-offs helps isolate whether product page design or downstream checkout steps drive conversion performance.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`building_product_conversion_funnels.sql`](./building_product_conversion_funnels.sql)

---

### 🔹 Step 1 & 2: Identify Product Sessions & Funnel Steps
Identify all session IDs that viewed either product page during the window (`2013-01-06` to `2013-04-10`), then map out subsequent pageview URLs in the conversion path.

```sql
-- STEP 1: Select all pageviews for relevant product sessions
CREATE TEMPORARY TABLE sessions_seeing_product_pages
SELECT DISTINCT 
    website_session_id,
    website_pageview_id,
    pageview_url AS product_page_seen    
FROM website_pageviews
WHERE created_at < '2013-04-10'
    AND created_at > '2013-01-06'
    AND pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear');
```

---

* **Data Output Link:** 📄 [`step_1.csv`](./step_1.csv)

**Output Data Sample (`step_1.csv`):**

| website_session_id | website_pageview_id | product_page_seen |
| :---: | :---: | :--- |
| 63513 | 138944 | `/the-original-mr-fuzzy` |
| 63515 | 138952 | `/the-original-mr-fuzzy` |
| 63516 | 138956 | `/the-original-mr-fuzzy` |
| 63562 | 139079 | `/the-forever-love-bear` |
| 63580 | 139121 | `/the-forever-love-bear` |

---

* **Data Output Link:** 📄 [`step_2.csv`](./step_2.csv)

**Output Data (`step_2.csv`):**

| pageview_url |
| :--- |
| `/cart` |
| `/shipping` |
| `/billing-2` |
| `/thank-you-for-your-order` |

---


### 🔹 Step 3 & 4: Session-Level Funnel Flags
In these steps, pageview-level URL records are evaluated to flag whether each session progressed through each specific page of the checkout funnel (`/cart`, `/shipping`, `/billing-2`, `/thank-you-for-your-order`). The results are then aggregated at the session level using `MAX()` flags to create a clear, binary status for each session and map them to their respective entry product page (`mrfuzzy` vs. `lovebear`).

```sql
-- STEP 3 & 4: Flag funnel pages and aggregate to session level
CREATE TEMPORARY TABLE session_product_level_made_it_flags
SELECT
    website_session_id,
    CASE
        WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
        WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
        ELSE 'check logic'
    END AS product_seen,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM (
    SELECT
        sessions_seeing_product_pages.website_session_id,
        sessions_seeing_product_pages.product_page_seen,
        CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
        CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
        CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
        CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
    FROM sessions_seeing_product_pages
        LEFT JOIN website_pageviews
            ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
            AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id
    ORDER BY 
        sessions_seeing_product_pages.website_session_id,
        website_pageviews.created_at
) AS pageview_level
GROUP BY 
    website_session_id,
    CASE
        WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
        WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
        ELSE 'check logic'
    END;
```

---

* **Data Output Link:** 📄 [`step_3_4.csv`](./step_3_4.csv)

**Output Data Sample (`step_3_4.csv`):**

| website_session_id | product_seen | cart_made_it | shipping_made_it | billing_made_it | thankyou_made_it |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 63513 | mrfuzzy | 1 | 1 | 1 | 1 |
| 63515 | mrfuzzy | 1 | 0 | 0 | 0 |
| 63516 | mrfuzzy | 0 | 0 | 0 | 0 |
| 63517 | mrfuzzy | 0 | 0 | 0 | 0 |
| 63518 | mrfuzzy | 1 | 0 | 0 | 0 |

---

### 🔹 Step 5: Final Funnel Volume & Click-Through Rates

* **Data Output Links:**
  * Part 1 Volume Breakdown: 📄 [`final_output_part_1.csv`](./final_output_part_1.csv)
  * Part 2 CTR Breakdown: 📄 [`final_output_part_2.csv`](./final_output_part_2.csv)

**Part 1: Absolute Session Volume by Funnel Step (`final_output_part_1.csv`):**

| product_seen | sessions | to_cart | to_shipping | to_billing | to_thankyou |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **lovebear** | 1,599 | 877 | 603 | 488 | 301 |
| **mrfuzzy** | 6,985 | 3,038 | 2,084 | 1,710 | 1,088 |

---

**Part 2: Click-Through Rate (CTR) Breakdown (`final_output_part_2.csv`):**

| product_seen | sessions | product_page_click_rt | cart_click_rt | shipping_click_rt | billing_click_rt |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **lovebear** | 1,599 | **54.85%** | **68.76%** | **80.93%** | **61.68%** |
| **mrfuzzy** | 6,985 | **43.49%** | **68.60%** | **82.05%** | **63.63%** |

---

## 💡 Key Business Insights

1. **Superior Top-of-Funnel Conversion for Love Bear:**
   * Visitors landing on `/the-forever-love-bear` clicked through to the cart at a significantly higher rate (**54.85%**) compared to `/the-original-mr-fuzzy` (**43.49%**), representing an **11.36 percentage point lift in add-to-cart rate**.

2. **Consistent Mid-to-Bottom Funnel Retention:**
   * Once users added products to the cart, downstream step conversion rates (Cart → Shipping → Billing → Thank You) remained virtually identical across both products (~68.6% cart CTR, ~81–82% shipping CTR, ~62–63% billing CTR).

3. **Strategic Recommendations:**
   * The stronger product page conversion of Love Bear proves its strong purchase intent and product-market fit; consideration should be given to featuring Love Bear more prominently on marketing channels or homepage banners to maximize initial cart additions.
