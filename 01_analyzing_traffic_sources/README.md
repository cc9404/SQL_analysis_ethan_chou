# Sub-topic 1: Analyzing Traffic Sources

This folder contains all SQL scripts and output datasets for analyzing traffic acquisition, source conversion rates, trending, and bid optimization for Maven Fuzzy Factory.

---

## 📊 Core Modules & SQL Scripts

| # | Core Module Link | SQL Script | Data Output | Description |
| :-: | :--- | :--- | :-: | :--- |
| **1** | [Finding Top Traffic Sources](./01_finding_top_traffic_sources/) | [`finding_top_traffic_sources.sql`](./01_finding_top_traffic_sources/finding_top_traffic_sources.sql) | [`CSV`](./01_finding_top_traffic_sources/finding_top_traffic_sources.csv) | Identify primary channels driving high-volume website sessions. |
| **2** | [Traffic Source Conversion Rates](./02_traffic_source_conversion_rates/) | [`traffic_source_conversion_rates.sql`](./02_traffic_source_conversion_rates/traffic_source_conversion_rates.sql) | [`CSV`](./02_traffic_source_conversion_rates/traffic_source_conversion_rates.csv) | Calculate CVR across sources by joining sessions with orders data. |
| **3** | [Bid Optimization & Trend Analysis](./03_bid_optimization_and_trend_analysis/) | [`bid_optimization_and_trend_analysis.sql`](./03_bid_optimization_and_trend_analysis/bid_optimization_and_trend_analysis.sql) | [`CSV`](./03_bid_optimization_and_trend_analysis/bid_optimization_and_trend_analysis.csv) | Analyze weekly volume trends to adjust paid search ad bids. |
| **4** | [Segment Trending & Granular Analysis](./04_traffic_source_segment_trending/) | [`traffic_source_trending.sql`](./04_traffic_source_segment_trending/traffic_source_trending.sql) | [`CSV`](./04_traffic_source_segment_trending/traffic_source_trending.csv) | Segment traffic by device types (Desktop vs. Mobile) for granular bid optimization. |
