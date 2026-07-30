# 📄 Core Module 2: Analyzing Business Patterns (Support Staffing Optimization)

This module analyzes average hourly website session volume segmented by day of the week (`Monday` through `Sunday`) during a representative baseline period (September 15, 2012 to November 15, 2012). The primary objective is to identify peak traffic hours and weekday vs. weekend usage patterns to optimize live customer support staffing and server capacity planning[cite: 4].

---

## 📌 Business Problem & Context

To maximize customer satisfaction and conversion rates, live support agents should be scheduled during hours with highest site traffic. Conversely, staffing during off-peak hours generates unnecessary operational costs. Leadership requested a granular breakdown of hourly traffic across days of the week to establish optimal shift scheduling for customer support teams[cite: 4].

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`data_for_cusotmer_service.sql`](./data_for_cusotmer_service.sql)

---

### 🔹 Step 1: Daily and Hourly Session Aggregation
Aggregate website sessions for every distinct date, day of week (`wkday`: 0 = Mon, 6 = Sun), and hour of day (`hr`: 0–23) between September 15 and November 15, 2012[cite: 4].

```sql
SELECT
    DATE(created_at) AS created_date,
    WEEKDAY(created_at) AS wkday,
    HOUR(created_at) AS hr,
    COUNT(DISTINCT website_session_id) AS website_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1, 2, 3;
```
* **Data Output Link:** 📄 [`step_1.csv`](./step_1.csv)

**Output Data Preview (`step_1.csv`):**

| created_date | wkday | hr | website_sessions |
| :---: | :---: | :---: | :---: |
| 2012-09-15 | 5 | 0 | 1 |
| 2012-09-15 | 5 | 1 | 8 |
| 2012-09-15 | 5 | 2 | 2 |
| 2012-09-15 | 5 | 3 | 4 |
| 2012-09-15 | 5 | 4 | 2 |
| 2012-09-15 | 5 | 5 | 3 |
| 2012-09-15 | 5 | 6 | 2 |
| 2012-09-15 | 5 | 7 | 7 |
| 2012-09-15 | 5 | 8 | 2 |
| 2012-09-15 | 5 | 9 | 6 |

---

### 🔹 Step 2: Average Hourly Sessions Across Days of the Week
Pivot the daily-hourly session counts from Step 1 to compute the average traffic volume for each hour of the day (`0` to `23`) across all 7 days of the week (`Monday` through `Sunday`). This provides a clean matrix identifying peak user activity windows for customer support staffing and server capacity planning.

```sql
SELECT
    hr,
    ROUND(AVG(website_sessions), 1) AS avg_sessions,
    ROUND(AVG(CASE WHEN wkday = 0 THEN website_sessions ELSE NULL END), 1) AS mon,
    ROUND(AVG(CASE WHEN wkday = 1 THEN website_sessions ELSE NULL END), 1) AS tues,
    ROUND(AVG(CASE WHEN wkday = 2 THEN website_sessions ELSE NULL END), 1) AS wed,
    ROUND(AVG(CASE WHEN wkday = 3 THEN website_sessions ELSE NULL END), 1) AS thurs,
    ROUND(AVG(CASE WHEN wkday = 4 THEN website_sessions ELSE NULL END), 1) AS fri,
    ROUND(AVG(CASE WHEN wkday = 5 THEN website_sessions ELSE NULL END), 1) AS sat,
    ROUND(AVG(CASE WHEN wkday = 6 THEN website_sessions ELSE NULL END), 1) AS sun
FROM (
    SELECT
        DATE(created_at) AS created_date,
        WEEKDAY(created_at) AS wkday,
        HOUR(created_at) AS hr,
        COUNT(DISTINCT website_session_id) AS website_sessions
    FROM website_sessions
    WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
    GROUP BY 1, 2, 3
) AS daily_houly_sessions
GROUP BY 1
ORDER BY 1;
```
* **Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

**Output Data (`final_output.csv`):**

| hr | avg_sessions | mon | tues | wed | thurs | fri | sat | sun |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 0 | 6.7 | 8.7 | 7.7 | 6.3 | 7.4 | 6.8 | 5.0 | 5.0 |
| 1 | 5.5 | 6.6 | 6.7 | 5.3 | 4.9 | 7.1 | 5.0 | 3.0 |
| 2 | 4.6 | 6.1 | 4.4 | 4.4 | 6.1 | 4.6 | 3.7 | 3.0 |
| 3 | 4.3 | 5.7 | 4.0 | 4.7 | 4.6 | 3.6 | 3.9 | 3.4 |
| 4 | 4.8 | 5.9 | 6.3 | 6.0 | 4.0 | 6.1 | 2.8 | 2.4 |
| 5 | 4.8 | 5.0 | 5.4 | 5.1 | 5.4 | 4.6 | 4.3 | 3.9 |
| 6 | 5.0 | 5.4 | 5.6 | 4.8 | 6.0 | 6.8 | 4.0 | 2.6 |
| 7 | 7.2 | 7.3 | 7.8 | 7.4 | 10.6 | 7.0 | 5.7 | 4.8 |
| 8 | 10.4 | 12.3 | 12.2 | 13.0 | 16.5 | 10.5 | 4.3 | 4.1 |
| 9 | 14.6 | 17.6 | 15.7 | 19.6 | 19.3 | 17.5 | 7.6 | 6.0 |
| 10 | 15.5 | 18.4 | 17.7 | 21.0 | 18.4 | 19.0 | 8.3 | 6.3 |
| 11 | 16.9 | 18.0 | 19.1 | 24.9 | 21.6 | 20.9 | 7.2 | 7.7 |
| 12 | 17.7 | 21.1 | 23.3 | 22.8 | 24.1 | 19.0 | 8.6 | 6.1 |
| 13 | 17.1 | 17.8 | 23.0 | 20.8 | 20.6 | 21.6 | 8.1 | 8.4 |
| 14 | 16.4 | 17.9 | 21.6 | 22.3 | 18.5 | 19.5 | 8.7 | 6.7 |
| 15 | 17.4 | 21.6 | 17.1 | 25.3 | 23.5 | 21.3 | 6.9 | 7.1 |
| 16 | 17.7 | 21.1 | 23.7 | 23.7 | 19.6 | 20.9 | 7.6 | 6.6 |
| 17 | 14.5 | 19.4 | 15.9 | 20.2 | 19.8 | 12.9 | 6.4 | 7.6 |
| 18 | 11.5 | 12.7 | 15.0 | 14.8 | 15.3 | 10.9 | 5.3 | 6.8 |
| 19 | 11.3 | 12.4 | 14.1 | 13.3 | 11.6 | 14.3 | 7.1 | 6.4 |
| 20 | 10.5 | 12.1 | 12.4 | 14.2 | 10.6 | 10.3 | 5.7 | 8.4 |
| 21 | 9.4 | 9.1 | 12.6 | 11.4 | 9.4 | 7.3 | 5.7 | 10.2 |
| 22 | 9.0 | 9.1 | 10.0 | 9.8 | 12.1 | 6.0 | 5.7 | 10.2 |
| 23 | 8.4 | 8.8 | 8.6 | 9.6 | 10.6 | 7.6 | 5.3 | 8.3 |

---

## 💡 Key Business Insights

1. **Weekday Heavy Traffic Profile:**
   * Website traffic is significantly heavier on weekdays (**Monday through Friday**) compared to weekends (**Saturday and Sunday**).
   * Peak traffic consistently occurs between **8:00 AM and 5:00 PM (08:00–17:00)** on weekdays.

2. **Off-Peak Night & Weekend Windows:**
   * Early morning hours (**12:00 AM – 6:00 AM**) experience minimal session activity (< 10–15 sessions/hr average).
   * Weekend traffic stays uniformly lower throughout the entire day, averaging roughly 50%–60% of weekday peak volumes.

3. **Strategic Recommendations for Live Support Staffing:**
   * **Core Shifts:** Concentrate live chat / customer service coverage during weekday business hours (**8:00 AM – 5:00 PM EST/PST**).
   * **Reduced Staffing:** Downsize support staffing during late nights and weekends to reduce labor costs without sacrificing customer experience.
