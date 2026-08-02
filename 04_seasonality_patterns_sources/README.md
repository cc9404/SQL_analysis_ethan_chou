# 📁 Sub-topic 4: Business Patterns & Seasonality

This folder contains all SQL scripts and output datasets for analyzing temporal trends, seasonality patterns, holiday traffic surges, and hour-of-day/day-of-week traffic distribution to optimize marketing budgets, server load capacity, and live support staffing for Fuzzy Factory.

---

📊 Core Modules & SQL Scripts

| # | Module Link | SQL Script(s) | Data Output(s) | Description |
| :-: | :--- | :--- | :-: | :--- |
| **1** | [Analyzing Seasonality Trends](./01_analyzing_seasonality_trends) | [`analyzing_seasonality.sql`](./01_analyzing_seasonality_trends/analyzing_seasonality.sql) | [`CSV`](./01_analyzing_seasonality_trends/monthly_breakdown.csv) | Track weekly session volume and order totals across 2012 to identify macro seasonality trends, Q4 holiday surges, and revenue growth patterns.|
| **2** | [Analyzing Business Patterns](./02_analyzing_business_patterns) | [`data_for_cusotmer_service.sql`](./02_analyzing_business_patterns/data_for_cusotmer_service.sql) | [`CSV`](./02_analyzing_business_patterns/final_output.csv) | Evaluate average hourly website session volume segmented by day of the week to identify peak user activity windows for customer support staffing and server optimization.|
