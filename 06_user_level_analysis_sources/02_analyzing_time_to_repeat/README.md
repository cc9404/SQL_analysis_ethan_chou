# 📄 Core Module 2: Analyzing Time to Repeat

This module analyzes the time gap (in days) between a user's first and second session for returning visitors to Fuzzy Factory between **January 1, 2014 and November 1, 2014**.

---

## 📌 Business Problem & Context

Understanding the behavior of returning visitors requires knowing how long it takes for a customer to come back. Management requested an analysis of the minimum, maximum, and average number of days between a user's initial visit and their second visit to help set expectations for retargeting windows and customer lifecycle marketing strategies.

---

## 🛠️ SQL Script & Data Pipeline

* **Main SQL Script:** 🔗 [`analyzing_time_to_repeat.sql`](./analyzing_time_to_repeat.sql)
* **Final Summary Output Link:** 📄 [`final_output.csv`](./final_output.csv)

---

### 🔹 Step 1: Identify New Sessions & Subsequent Repeat Visits
Filter for new sessions created between January 1, 2014 and November 1, 2014, and left join any repeat sessions for the same `user_id`.

```sql
-- STEP 1: Map initial session to repeat sessions
CREATE TEMPORARY TABLE sessions_w_repeats_for_time_diff
SELECT 
    new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    new_sessions.created_at AS new_sessions_created_at,
    website_sessions.website_session_id AS repeat_session_id,
    website_sessions.created_at AS repeat_session_created_at
FROM    
(
    SELECT
        user_id,
        website_session_id,
        created_at
    FROM website_sessions
    WHERE created_at < '2014-11-01' 
      AND created_at >= '2014-01-01'
      AND is_repeat_session = 0 -- new sessions only
) AS new_sessions
    LEFT JOIN website_sessions
        ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1
        AND website_sessions.website_session_id > new_sessions.website_session_id
        AND website_sessions.created_at < '2014-11-01'
        AND website_sessions.created_at >= '2014-01-01';
```

---

* **Step 1 Output Link:** 📄 [`step_1.csv`](./step_1.csv)

**Output Data Sample (`step_1.csv`):**

| user_id | new_session_id | new_sessions_created_at | repeat_session_id | repeat_session_created_at |
| :---: | :---: | :---: | :---: | :---: |
| 152826 | 175252 | 2014-01-01 00:30:00 | - | - |
| 152827 | 175253 | 2014-01-01 01:12:00 | - | - |
| 152828 | 175254 | 2014-01-01 02:25:00 | - | - |
| 152837 | 175268 | 2014-01-01 09:15:00 | 182410 | 2014-02-16 14:20:00 |
| 152847 | 175281 | 2014-01-01 13:40:00 | 179850 | 2014-01-29 10:05:00 |

---

### 🔹 Step 2: Calculate Days Between 1st and 2nd Session
For returning visitors, filter for their earliest repeat visit (`MIN(repeat_session_id)`) to isolate their second overall website session. Then, compute the difference in days between the first session creation date and the second session creation date using `DATEDIFF`.

```sql
-- STEP 2: Compute time difference in days for each returning user
CREATE TEMPORARY TABLE users_first_to_second
SELECT
    user_id,
    DATEDIFF(second_session_created_at, new_sessions_created_at) AS days_first_to_second_session
FROM
(
    SELECT
        user_id,
        new_session_id,
        new_sessions_created_at,
        MIN(repeat_session_id) AS second_session_id,
        MIN(repeat_session_created_at) AS second_session_created_at
    FROM sessions_w_repeats_for_time_diff
    WHERE repeat_session_id IS NOT NULL
    GROUP BY 1, 2, 3
) AS first_second;

SELECT * FROM users_first_to_second;
```

---

* **Step 2 Output Link:** 📄 [`step_2.csv`](./step_2.csv)

**Output Data Sample (`step_2.csv`):**

| user_id | days_first_to_second_session |
| :---: | :---: |
| 152837 | **46** |
| 152847 | **28** |
| 152848 | **56** |
| 152849 | **15** |
| 152851 | **23** |

---

### 🔹 Step 3: Aggregate Time-to-Repeat Metrics
Calculate overall summary statistics across all returning visitors by taking the `AVG`, `MIN`, and `MAX` of `days_first_to_second_session`. This summarizes the overall time distribution required for customers to make their second visit.

```sql
-- STEP 3: Generate summary statistics across all returning users
SELECT
    AVG(days_first_to_second_session) AS avg_days_first_to_second,
    MIN(days_first_to_second_session) AS min_days_first_to_second,
    MAX(days_first_to_second_session) AS max_days_first_to_second
FROM users_first_to_second;
```

---

## 📊 Summary Performance Comparison (`final_output.csv`)

* **Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

**Output Data Summary (`final_output.csv`):**

| avg_days_first_to_second | min_days_first_to_second | max_days_first_to_second |
| :---: | :---: | :---: |
| **33.25** | **1** | **69** |

---

## 💡 Key Business Insights

1. **Average Repeat Time Frame (~33 Days):**
   * On average, users who return for a second visit do so **33.25 days** (approximately 1 month) after their initial session.

2. **Re-engagement Window Range (1 to 69 Days):**
   * Returning behavior ranges from immediate next-day visits (**1 day**) up to **69 days** post-first visit.

3. **Strategic Recommendations:**
   * **Targeted Retargeting Window:** Align CRM email automation, retargeting ads, and special promotions to trigger around the **30-to-35-day mark**, reaching users right at their typical return decision window.
   * **Win-Back Push:** For users reaching the 60+ day threshold without returning, deploy stronger win-back incentives before they exceed the 69-day maximum observed return window.
