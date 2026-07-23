# Sub-topic 1: Analyzing Traffic Sources

This folder contains all SQL scripts and output datasets for analyzing traffic acquisition, source conversion rates, trending, and bid optimization for Maven Fuzzy Factory.

---

## 📊 Core Modules & SQL Scripts

| # | Core Module Link | SQL Script(s) | Data Output(s) | Description |
| :-: | :--- | :--- | :-: | :--- |
| **1** | [🔍 Finding Top Traffic Sources](./01_finding_top_traffic_sources/) | [`finding_top_traffic_sources.sql`](./01_finding_top_traffic_sources/finding_top_traffic_sources.sql) | [`CSV`](./01_finding_top_traffic_sources/finding_top_traffic_sources.csv) | Identify primary channels driving high-volume website sessions. |
| **2** | [📈 Traffic Source CVR](./02_traffic_source_conversion_rates/) | [`traffic_source_conversion_rates.sql`](./02_traffic_source_conversion_rates/traffic_source_conversion_rates.sql) | [`CSV`](./02_traffic_source_conversion_rates/traffic_source_conversion_rates.csv) | Calculate CVR across sources by joining sessions with orders data. |
| **3** | [🎯 Bid Optimization & Trend Analysis](./03_bid_optimization_and_trend_analysis/) | 1. [`traffic_source_trending.sql`](./03_bid_optimization_and_trend_analysis/traffic_source_trending.sql)<br>2. [`bid_optimization_and_trend_analysis.sql`](./03_bid_optimization_and_trend_analysis/bid_optimization_and_trend_analysis.sql)<br>3. [`trending_with_granular_segments.sql`](./03_bid_optimization_and_trend_analysis/trending_with_granular_segments.sql) | [`CSV 1`](./03_bid_optimization_and_trend_analysis/traffic_source_trending.csv)<br>[`CSV 2`](./03_bid_optimization_and_trend_analysis/bid_optimization_and_trend_analysis.csv)<br>[`CSV 3`](./03_bid_optimization_and_trend_analysis/trending_with_granular_segments.csv) | Multi-part analysis evaluating weekly traffic trends, paid search bid changes, and device-level segmentation (Desktop vs. Mobile). |
