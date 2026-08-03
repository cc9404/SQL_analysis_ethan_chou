# 📂 Sub-topic 6: User-Level Analysis

This folder contains all SQL scripts and output datasets for analyzing user-level session behavior, repeat visitor patterns, time-to-repeat dynamics, channel-specific repeat traffic, and customer lifetime loyalty metrics for Fuzzy Factory.

---

## 📊 Core Modules & SQL Scripts

| # | Module Link | SQL Script(s) | Data Output(s) | Description |
| :-: | :--- | :--- | :-: | :--- |
| **1** | [Identifying Repeat Visitors](./01_identifying_repeat_visitors) | [`identifying_repeat_visitors.sql`](./01_identifying_repeat_visitors/identifying_repeat_visitors.sql) | [`CSV`](./01_identifying_repeat_visitors/final_output.csv) | Analyze user-level session frequency to determine how many unique visitors returned for repeat sessions between Jan 2014 and Nov 2014. |
| **2** | [Analyzing Time to Repeat](./02_analyzing_time_to_repeat) | [`analyzing_time_to_repeat.sql`](./02_analyzing_time_to_repeat/analyzing_time_to_repeat.sql) | [`CSV`](./02_analyzing_time_to_repeat/final_output.csv) | Evaluate minimum, maximum, and average time (in days) between the first and second session for returning visitors. |
