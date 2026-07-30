# 📄 Core Module 1: Analyzing Seasonality Trends

This module evaluates monthly and weekly website session volume and total order counts across 2012. It identifies macro seasonal trends, Q4 holiday traffic surges (e.g., Black Friday / Cyber Monday), and overall business growth patterns to help leadership prepare budget and inventory forecasts for 2013.

---

## 📌 Business Problem & Context

As Fuzzy Factory prepares for 2013, management needs to understand the baseline traffic and revenue seasonality experienced throughout 2012. Identifying peak demand periods—especially during late-year holidays—ensures adequate marketing budget allocation, inventory planning, and infrastructure capacity.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`analyzing_seasonality.sql`](./analyzing_seasonality.sql)

---

### 🔹 Step 1: Monthly Traffic & Order Breakdown
Aggregate total website sessions and resulting order counts on a monthly basis across 2012.

```sql
SELECT
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) AS orders
FROM website_sessions
    LEFT JOIN orders
        ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2013-01-01'
GROUP BY 1, 2;
```

* **Data Output Link:** 📄 [`monthly_breakdown.csv`](./monthly_breakdown.csv)

**Output Data (`monthly_breakdown.csv`):**

| yr | mo | sessions | orders |
| :---: | :---: | :---: | :---: |
| 2012 | 3 | 1879 | 60 |
| 2012 | 4 | 3734 | 99 |
| 2012 | 5 | 3736 | 108 |
| 2012 | 6 | 3963 | 140 |
| 2012 | 7 | 4249 | 169 |
| 2012 | 8 | 6097 | 228 |
| 2012 | 9 | 6546 | 287 |
| 2012 | 10 | 8183 | 371 |
| 2012 | 11 | 14011 | 618 |
| 2012 | 12 | 10072 | 506 |

---

### 🔹 Step 2: Weekly Traffic & Order Breakdown
Aggregate total website sessions and resulting order counts on a weekly basis to pinpoint exact traffic surges, holiday seasonality spikes (e.g., Black Friday and Cyber Monday), and short-term performance shifts across 2012[cite: 3].

```sql
SELECT
    YEAR(website_sessions.created_at) AS yr,
    WEEK(website_sessions.created_at) AS wk,
    MIN(DATE(website_sessions.created_at)) AS week_start,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) AS orders
FROM website_sessions
    LEFT JOIN orders
        ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2013-01-01'
GROUP BY 1, 2;
```

---

* **Data Output Link:** 📄 [`weekly_breakdown.csv`](./weekly_breakdown.csv)

**Output Data (`weekly_breakdown.csv`):**

| yr | wk | week_start | sessions | orders |
| :---: | :---: | :---: | :---: | :---: |
| 2012 | 12 | 2012-03-19 | 896 | 25 |
| 2012 | 13 | 2012-03-25 | 983 | 35 |
| 2012 | 14 | 2012-04-01 | 1193 | 29 |
| 2012 | 15 | 2012-04-08 | 1029 | 28 |
| 2012 | 16 | 2012-04-15 | 679 | 22 |
| 2012 | 17 | 2012-04-22 | 655 | 18 |
| 2012 | 18 | 2012-04-29 | 770 | 19 |
| 2012 | 19 | 2012-05-06 | 798 | 17 |
| 2012 | 20 | 2012-05-13 | 706 | 23 |
| 2012 | 21 | 2012-05-20 | 965 | 28 |
| 2012 | 22 | 2012-05-27 | 875 | 31 |
| 2012 | 23 | 2012-06-03 | 920 | 34 |
| 2012 | 24 | 2012-06-10 | 994 | 29 |
| 2012 | 25 | 2012-06-17 | 966 | 37 |
| 2012 | 26 | 2012-06-24 | 883 | 32 |
| 2012 | 27 | 2012-07-01 | 892 | 30 |
| 2012 | 28 | 2012-07-08 | 925 | 36 |
| 2012 | 29 | 2012-07-15 | 987 | 47 |
| 2012 | 30 | 2012-07-22 | 954 | 41 |
| 2012 | 31 | 2012-07-29 | 1172 | 55 |
| 2012 | 32 | 2012-08-05 | 1235 | 48 |
| 2012 | 33 | 2012-08-12 | 1181 | 39 |
| 2012 | 34 | 2012-08-19 | 1522 | 55 |
| 2012 | 35 | 2012-08-26 | 1593 | 52 |
| 2012 | 36 | 2012-09-02 | 1418 | 56 |
| 2012 | 37 | 2012-09-09 | 1488 | 72 |
| 2012 | 38 | 2012-09-16 | 1776 | 76 |
| 2012 | 39 | 2012-09-23 | 1624 | 70 |
| 2012 | 40 | 2012-09-30 | 1553 | 67 |
| 2012 | 41 | 2012-10-07 | 1632 | 73 |
| 2012 | 42 | 2012-10-14 | 1955 | 93 |
| 2012 | 43 | 2012-10-21 | 2042 | 95 |
| 2012 | 44 | 2012-10-28 | 1923 | 82 |
| 2012 | 45 | 2012-11-04 | 2086 | 91 |
| 2012 | 46 | 2012-11-11 | 1973 | 101 |
| 2012 | 47 | 2012-11-18 | 5130 | 223 |
| 2012 | 48 | 2012-11-25 | 4172 | 179 |
| 2012 | 49 | 2012-12-02 | 2727 | 145 |
| 2012 | 50 | 2012-12-09 | 2489 | 123 |
| 2012 | 51 | 2012-12-16 | 2718 | 135 |
| 2012 | 52 | 2012-12-23 | 1682 | 74 |
| 2012 | 53 | 2012-12-30 | 309 | 21 |

---

## 💡 Key Business Insights

1. **Consistent Month-over-Month Steady Growth:**
   * Business traffic grew continuously throughout 2012, expanding from **1,879 sessions** (60 orders) in March to **8,183 sessions** (371 orders) in October prior to the holiday rush.

2. **Massive Q4 Holiday Seasonality Spike:**
   * November experienced a massive surge reaching **14,011 sessions** and **618 orders**, driven primarily by the week of **November 18 (Week 47)** which peaked at **5,130 sessions** and **223 orders** (Black Friday / Cyber Monday week).
   * Traffic in Week 47 was more than **2.5x higher** than the average weekly traffic in early November (~2,000 sessions).

3. **Post-Holiday Drop-off:**
   * Demand remained elevated through mid-December before sharply dropping during the week of Christmas (Week 52, **1,682 sessions**).

4. **Strategic Recommendations:**
   * **Inventory & Budget Planning:** Prepare for a massive inventory and marketing spend scaling starting in mid-November for 2013 to maximize holiday demand.
   * **Server Capacity:** Ensure web server elasticity during Week 47 and Week 48 to handle traffic volumes exceeding 2.5x standard baseline levels.
