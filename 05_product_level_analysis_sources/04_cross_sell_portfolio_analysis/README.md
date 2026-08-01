# 📄 Core Module 4: Cart Cross-Sell Portfolio Analysis

This module evaluates the performance impact of introducing a product cross-sell feature on the `/cart` page (comparing the 1-month period before `2013-08-25` to `2013-09-25` vs. 1-month after `2013-09-25` to `2013-10-25`). Key metrics evaluated include cart click-through rate (`cart_ctr`), products per order (`products_per_order`), average order value (`aov`), and revenue per cart session (`rev_per_cart_session`).

---

## 📌 Business Problem & Context

On September 25, 2013, Fuzzy Factory launched a cross-selling feature on the `/cart` page allowing customers to add a secondary product before proceeding to checkout. Management requested a pre-vs-post impact analysis to determine whether cross-selling increased basket size and total revenue per session without hurting top-of-funnel cart click-through rates.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`cross_sell_analysis.sql`](./cross_sell_analysis.sql)

---

### 🔹 Step 1: Identify Cart Sessions Pre/Post Cross-Sell Launch
Identify all `/cart` pageviews during the pre/post cross-sell window (comparing the period before `2013-09-25` vs. after `2013-09-25`) to establish the baseline cart session cohort.

```sql
-- STEP 1: Identify relevant cart page views
CREATE TEMPORARY TABLE session_seeing_cart
SELECT
    CASE
        WHEN created_at < '2013-09-25' THEN 'A. Pre_Cross_Sell'
        WHEN created_at >= '2013-09-25' THEN 'B. Post_Cross_Sell'
        ELSE 'check logic'
    END AS time_period,
    website_session_id AS cart_session_id,
    website_pageview_id AS cart_pageview_id
FROM website_pageviews
WHERE created_at BETWEEN '2013-08-25' AND '2013-10-25'
    AND pageview_url = '/cart';

SELECT * FROM session_seeing_cart;
```
* **Data Output Link:** 📄 [`step_1.csv`](./step_1.csv)

**Output Data Sample (`step_1.csv`):**

| time_period | cart_session_id | cart_pageview_id |
| :--- | :---: | :---: |
| **A. Pre_Cross_Sell** | 122947 | 285248 |
| **A. Pre_Cross_Sell** | 122952 | 285261 |
| **A. Pre_Cross_Sell** | 122954 | 285269 |
| **A. Pre_Cross_Sell** | 122963 | 285290 |
| **A. Pre_Cross_Sell** | 122973 | 285308 |

---

### 🔹 Step 2: Identify sessions that viewed another page after the /cart page view to measure top-of-funnel cart click-through rates (CTR).

```
CREATE TEMPORARY TABLE cart_sessions_seeing_another_page
SELECT
    session_seeing_cart.time_period,
    session_seeing_cart.cart_session_id,
    MIN(website_pageviews.website_pageview_id) AS pv_id_after_cart
FROM session_seeing_cart
    LEFT JOIN website_pageviews
        ON website_pageviews.website_session_id = session_seeing_cart.cart_session_id
        AND website_pageviews.website_pageview_id > session_seeing_cart.cart_pageview_id
GROUP BY 
    session_seeing_cart.time_period,
    session_seeing_cart.cart_session_id
HAVING
    MIN(website_pageviews.website_pageview_id) IS NOT NULL;

SELECT * FROM cart_sessions_seeing_another_page;
```
* **Data Output Link:** 📄 [`step_2.csv`](./step_2.csv)

**Output Data Sample (`step_2.csv`):**

| time_period | cart_session_id | pv_id_after_cart |
| :--- | :---: | :---: |
| **A. Pre_Cross_Sell** | 122947 | 285250 |
| **A. Pre_Cross_Sell** | 122952 | 285262 |
| **A. Pre_Cross_Sell** | 122954 | 285270 |
| **A. Pre_Cross_Sell** | 122987 | 285342 |
| **A. Pre_Cross_Sell** | 123008 | 285380 |

---

### 🔹 Step 3: Identify Orders Associated with Cart Sessions
Join the `/cart` sessions cohort with the `orders` table to identify which sessions resulted in completed purchases, including the number of items purchased and total order revenue.

```sql
-- STEP 3: Identify orders associated with cart sessions
CREATE TEMPORARY TABLE pre_post_sessions_orders
SELECT
    time_period,
    cart_session_id,
    order_id,
    items_purchased,
    price_usd
FROM session_seeing_cart
    INNER JOIN orders
        ON session_seeing_cart.cart_session_id = orders.website_session_id;

SELECT * FROM pre_post_sessions_orders;
```
* **Data Output Link:** 📄 [`step_3.csv`](./step_3.csv)

**Output Data Sample (`step_3.csv`):**

| time_period | cart_session_id | order_id | items_purchased | price_usd |
| :--- | :---: | :---: | :---: | :---: |
| **A. Pre_Cross_Sell** | 122947 | 6645 | 1 | $49.99 |
| **A. Pre_Cross_Sell** | 122987 | 6646 | 1 | $49.99 |
| **A. Pre_Cross_Sell** | 123008 | 6647 | 1 | $49.99 |
| **A. Pre_Cross_Sell** | 123021 | 6648 | 1 | $59.99 |
| **A. Pre_Cross_Sell** | 123030 | 6649 | 1 | $49.99 |

---

### 🔹 Step 4: Create Full Session-Level Dataset
Combine the `/cart` sessions with the click-through flags from Step 2 and order details from Step 3 to build a complete session-level view. This dataset captures whether each cart session resulted in a click-through to a subsequent page, whether an order was placed, the total items purchased, and the total revenue generated.

```sql
-- STEP 4: Build session-level combined dataset
SELECT
    session_seeing_cart.time_period,
    session_seeing_cart.cart_session_id,
    CASE WHEN cart_sessions_seeing_another_page.cart_session_id IS NULL THEN 0 ELSE 1 END AS clicked_to_another_page,
    CASE WHEN pre_post_sessions_orders.order_id IS NULL THEN 0 ELSE 1 END AS placed_order,
    pre_post_sessions_orders.items_purchased,
    pre_post_sessions_orders.price_usd
FROM session_seeing_cart
    LEFT JOIN cart_sessions_seeing_another_page
        ON cart_sessions_seeing_another_page.cart_session_id = session_seeing_cart.cart_session_id
    LEFT JOIN pre_post_sessions_orders
        ON session_seeing_cart.cart_session_id = pre_post_sessions_orders.cart_session_id
ORDER BY
    cart_session_id;
```

* **Data Output Link:** 📄 [`step_4.csv`](./step_4.csv)

**Output Data Sample (`step_4.csv`):**

| time_period | cart_session_id | clicked_to_another_page | placed_order | items_purchased | price_usd |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **A. Pre_Cross_Sell** | 122947 | 1 | 1 | 1 | $49.99 |
| **A. Pre_Cross_Sell** | 122952 | 1 | 0 | - | - |
| **A. Pre_Cross_Sell** | 122954 | 1 | 0 | - | - |
| **A. Pre_Cross_Sell** | 122963 | 0 | 0 | - | - |
| **A. Pre_Cross_Sell** | 122973 | 0 | 0 | - | - |

---

### 🔹 Final Output: Aggregate Final Performance Metrics (Pre vs. Post Cross-Sell)
Aggregate the session-level dataset to compare key business metrics before and after the cross-sell feature launch. This summary measures changes in cart click-through rate (`cart_ctr`), products per order (`products_per_order`), average order value (`aov`), and total revenue per cart session (`rev_per_cart_session`).

```sql
-- FINAL OUTPUT: Pre vs. Post Cross-Sell Performance Summary
SELECT
    time_period,
    COUNT(DISTINCT cart_session_id) AS cart_sessions,
    SUM(clicked_to_another_page) AS clickthroughs,
    SUM(clicked_to_another_page) / COUNT(DISTINCT cart_session_id) AS cart_ctr,
    SUM(placed_order) AS order_placed,
    SUM(items_purchased) AS products_purchased,
    SUM(items_purchased) / SUM(placed_order) AS products_per_order,
    SUM(price_usd) AS revenue,
    SUM(price_usd) / SUM(placed_order) AS aov,
    SUM(price_usd) / COUNT(DISTINCT cart_session_id) AS rev_per_cart_session
FROM (
    SELECT
        session_seeing_cart.time_period,
        session_seeing_cart.cart_session_id,
        CASE WHEN cart_sessions_seeing_another_page.cart_session_id IS NULL THEN 0 ELSE 1 END AS clicked_to_another_page,
        CASE WHEN pre_post_sessions_orders.order_id IS NULL THEN 0 ELSE 1 END AS placed_order,
        pre_post_sessions_orders.items_purchased,
        pre_post_sessions_orders.price_usd
    FROM session_seeing_cart
        LEFT JOIN cart_sessions_seeing_another_page
            ON cart_sessions_seeing_another_page.cart_session_id = session_seeing_cart.cart_session_id
        LEFT JOIN pre_post_sessions_orders
            ON session_seeing_cart.cart_session_id = pre_post_sessions_orders.cart_session_id
) AS full_data
GROUP BY time_period;
```

* **Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

**Output Data (`final_output.csv`):**

| time_period | cart_sessions | clickthroughs | cart_ctr | order_placed | products_purchased | products_per_order | revenue | aov | rev_per_cart_session |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A. Pre_Cross_Sell** | 1,830 | 1,229 | **67.16%** | 652 | 652 | **1.0000** | $33,523.48 | **$51.42** | **$18.32** |
| **B. Post_Cross_Sell** | 1,975 | 1,351 | **68.41%** | 671 | 701 | **1.0447** | $36,402.99 | **$54.25** | **$18.43** |

---

## 💡 Key Business Insights

1. **Improved Cart Click-Through Rate:**
   * Cart page CTR increased slightly from **67.16%** to **68.41%** (+1.25 percentage points), confirming that introducing cross-sell recommendations did not add friction or cause drop-offs during checkout.

2. **Higher Basket Size & Average Order Value (AOV):**
   * Products per order increased from **1.0000** to **1.0447** (+4.47%), driving an increase in Average Order Value (AOV) from **$51.42** to **$54.25** (+5.50% / +$2.83 per order).

3. **Incremental Revenue Impact:**
   * Revenue per cart session rose from **$18.32** to **$18.43**, generating additional revenue without compromising core conversion efficiency.

4. **Strategic Recommendations:**
   * Continue running the cross-sell feature on the cart page and consider testing personalized product cross-sell recommendations based on user basket items to further increase multi-item order rates.
