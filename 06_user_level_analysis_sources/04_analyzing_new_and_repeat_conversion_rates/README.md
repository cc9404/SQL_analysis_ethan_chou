# 📄 Core Module 4: Analyzing New and Repeat Conversion Rates

This module compares key performance metrics—session volume, conversion rate, and revenue per session (RPS)—between new and repeat visitors for Fuzzy Factory between **January 1, 2014 and November 8, 2014**.

---

## 📌 Business Problem & Context

Understanding the revenue performance and conversion behavior of returning visitors compared to first-time visitors is critical for evaluating long-term customer value (LTV). Management requested a comparison to quantify whether repeat visitors convert at a higher rate and generate more revenue per session than first-time visitors.

---

## 🛠️ SQL Script & Data Pipeline

* **Main SQL Script:** 🔗 [`analyzing_new_and_repeat_conversion_rates.sql`](./analyzing_new_and_repeat_conversion_rates.sql)
* **Final Output Link:** 📄 [`final_output.csv`](./final_output.csv)

---

### 🔹 Step 1: Compare Conversion Rate & RPS Across Sessions
Left join `website_sessions` with `orders` to aggregate total sessions, conversion rate (`orders / sessions`), and revenue per session (`SUM(price_usd) / sessions`), grouped by `is_repeat_session`.

```sql
-- STEP 1: Aggregate session count, conversion rate, and revenue per session for new vs. repeat visitors
SELECT
    is_repeat_session,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS rev_per_session
FROM website_sessions
    LEFT JOIN orders
        ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2014-11-08'
  AND website_sessions.created_at >= '2014-01-01'
GROUP BY 1;
```

---

## 📊 Summary Performance Comparison

* **Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

**Output Data Summary (`final_output.csv`):**

| is_repeat_session | User Type | sessions | conv_rate | rev_per_session |
| :---: | :--- | :---: | :---: | :---: |
| **0** | **New Session** | 149,787 | **6.80%** | **$4.34** |
| **1** | **Repeat Session** | 33,577 | **8.11%** | **$5.17** |

---

## 💡 Key Business Insights

1. **Higher Conversion Efficiency for Returning Users (+19.3% Higher Conv. Rate):**
   * Repeat sessions achieve an **8.11% conversion rate** compared to **6.80% for new sessions**, representing a relative conversion rate lift of **+19.3%**.

2. **Superior Revenue Monetization (+19.1% Higher RPS):**
   * Repeat visitors generate **$5.17 Revenue Per Session (RPS)** compared to **$4.34** for first-time visitors, demonstrating greater purchasing intent and higher overall monetizable value per visit.

3. **Strategic Recommendations:**
   * **Incentivize Initial Purchase:** First-time visitors have lower immediate conversion rates (6.80%), so top-of-funnel strategies should focus on driving first orders or capturing email leads to transition users into the higher-value repeat cohort.
   * **Maximize Repeat Retention:** Because returning visitors yield nearly $1.00 more per session with zero paid acquisition costs (from organic/direct sources), investments in customer retention and re-engagement directly expand profitability.
