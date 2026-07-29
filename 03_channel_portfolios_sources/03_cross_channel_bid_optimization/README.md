# 📄 Core Module 3: Cross-Channel Bid Optimization

This module analyzes nonbrand session-to-order conversion rates across paid search channels (`gsearch` vs. `bsearch`) segmented by device type (`desktop` vs. `mobile`) between August 22, 2012 and September 18, 2012. It aims to evaluate relative bidding efficiency and guide device-level bid adjustments for `bsearch` relative to `gsearch`.

---

## 📌 Business Problem & Context

After introducing `bsearch` nonbrand campaigns, marketing leadership needs to evaluate whether `bsearch` traffic converts at a similar rate to `gsearch` across desktop and mobile devices. Understanding these conversion differentials is crucial for bidding efficiently without overpaying for lower-converting traffic on Bing[cite: 3].

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`multi_channel_bidding.sql`](./multi_channel_bidding.sql)

---

### 🔹 Step 1: Session-to-Order Conversion Rate by Device & Channel
Aggregate nonbrand sessions, orders, and calculate conversion rates (`conv_rate`) grouped by `device_type` and `utm_source`.

```sql
SELECT
    website_sessions.device_type AS device_type,
    website_sessions.utm_source AS utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate
FROM website_sessions
LEFT JOIN orders
    ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-22' AND '2012-09-18'
  AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
    website_sessions.device_type,
    website_sessions.utm_source;
```

---

* **Data Output Link:** 📄 [`multi_channel_bidding.csv`](./multi_channel_bidding.csv)

**Output Data (`multi_channel_bidding.csv`):**

| device_type | utm_source | sessions | orders | conv_rate |
| :---: | :---: | :---: | :---: | :---: |
| desktop | bsearch | 1,118 | 43 | 3.85% |
| desktop | gsearch | 2,850 | 130 | 4.56% |
| mobile | bsearch | 125 | 1 | 0.80% |
| mobile | gsearch | 962 | 11 | 1.14% |

---

## 💡 Key Business Insights

1. **Desktop Performance Gap:**
   * Desktop conversion rate on `gsearch` is **4.56%**, whereas `bsearch` desktop converts at **3.85%**.
   * `bsearch` desktop conversion rate is roughly **84.4%** of `gsearch` desktop performance, suggesting `bsearch` bids should be lowered slightly relative to `gsearch` to maintain target ROI.

2. **Mobile Performance Limitation:**
   * Mobile conversion rates are significantly lower across both channels (**1.14%** on `gsearch` vs. **0.80%** on `bsearch`).
   * Mobile traffic on `bsearch` generated only 1 order out of 125 sessions during this period.

3. **Strategic Bidding Recommendations:**
   * **Bid Down on `bsearch`:** Adjust `bsearch` bids down slightly (around 15% lower than `gsearch`) to account for its lower overall conversion rate across both desktop and mobile segments.
