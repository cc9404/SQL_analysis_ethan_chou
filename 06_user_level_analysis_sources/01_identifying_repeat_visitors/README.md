# 📄 Core Module 1: Identifying Repeat Visitors

This module analyzes user-level session frequency to evaluate customer retention and repeat visitation rates for Fuzzy Factory between **January 1, 2014 and November 1, 2014**.

---

## 📌 Business Problem & Context

Understanding customer loyalty and repeat traffic is critical for evaluating brand equity, long-term customer value, and marketing retention efficiency. Management requested a breakdown of user behavior to determine how many unique first-time visitors return for subsequent visits (1, 2, or 3+ repeat sessions) vs. those who never return.

---

## 🛠️ SQL Script & Data Pipeline

* **Main SQL Script:** 🔗 [`identifying_repeat_visitors.sql`](./identifying_repeat_visitors.sql)[cite: 2]
* **Step 1 Output Link:** 📄 [`step_1.csv`](./step_1.csv)[cite: 2]
* **Final Summary Output Link:** 📄 [`final_output.csv`](./final_output.csv)[cite: 2]

---

### 🔹 Step 1: Map First-Time Sessions to Subsequent Repeat Visits
Identify all new user sessions in 2014 and left join any repeat sessions initiated by the same `user_id` within the target timeframe.

```sql
-- STEP 1: Identify new sessions and join subsequent repeat sessions
CREATE TEMPORARY TABLE sessions_w_repeats
SELECT 
    new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    website_sessions.website_session_id AS repeat_session_id
FROM    
(
    SELECT
        user_id,
        website_session_id
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

SELECT * FROM sessions_w_repeats;
```

---

* **Data Output Link:** 📄 [`step_1.csv`](./step_1.csv)

**Output Data Sample (`step_1.csv`):**

| user_id | new_session_id | repeat_session_id |
| :---: | :---: | :---: |
| 152826 | 175252 | - |
| 152827 | 175253 | - |
| 152828 | 175254 | - |
| 152829 | 175256 | - |
| 152830 | 175257 | - |

---

### 🔹 Step 2: Aggregate Repeat Session Distribution
Group the session data at the user level to count the total number of repeat visits per customer, then aggregate across all users to determine the overall distribution of repeat session frequency (e.g., 0, 1, 2, or 3+ repeat sessions).

```sql
-- STEP 2: Aggregate user distribution by repeat session counts
SELECT
    repeat_sessions,
    COUNT(DISTINCT user_id) AS users
FROM
(
    SELECT
        user_id,
        COUNT(DISTINCT new_session_id) AS new_sessions,
        COUNT(DISTINCT repeat_session_id) AS repeat_sessions
    FROM sessions_w_repeats
    GROUP BY 1
) AS user_level
GROUP BY 1
ORDER BY 1;
```

---

## 📊 Summary Performance Comparison (`final_output.csv`)

* **Data Output Link:** 📄 [`final_output.csv`](./final_output.csv)

**Output Data Summary (`final_output.csv`):**

| repeat_sessions | users | % of Total Users |
| :---: | :---: | :---: |
| **0** | 126,813 | **86.92%** |
| **1** | 14,086 | **9.65%** |
| **2** | 315 | **0.22%** |
| **3** | 4,686 | **3.21%** |
| **Total Users** | **145,900** | **100.00%** |

---

## 💡 Key Business Insights

1. **High Single-Visit Retention Challenge (86.92% Single Session):**
   * Out of 145,900 unique visitors in 2014, **126,813 users (86.92%)** never returned for a second visit during the target window, indicating strong initial traffic acquisition but significant drop-off post-first visit.

2. **Core Loyalty Cohort (13.08% Repeat Rate):**
   * **19,087 users (13.08%)** completed 1 or more repeat visits. 
   * **9.65%** returned once (`1 repeat session`), while **3.21%** engaged in high-frequency repeat visits (`3 repeat sessions`), forming a highly valuable core customer segment.

3. **Strategic Recommendations:**
   * **Implement Targeted Remarketing:** Establish personalized email automation and retargeting campaigns aimed at first-time visitors to drive initial repeat engagement within 30 days.
   * **Analyze Multi-Repeat Drivers:** Deep-dive into the behavioral patterns and acquisition sources of the 3.21% high-frequency cohort to replicate their customer journey across the broader user base.
