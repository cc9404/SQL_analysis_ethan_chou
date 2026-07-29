# 📁 Sub-topic 3: Analyzing Channel Portfolios

This folder contains all SQL scripts and output datasets for analyzing channel portfolios, multi-channel marketing performance, paid search engine comparisons (e.g., gsearch vs. bsearch), organic traffic growth, and cross-channel marketing efficiency for Fuzzy Factory[cite: 2].

---

📊 Core Modules & SQL Scripts

| # | Module Link | SQL Script(s) | Data Output(s) | Description |
| :-: | :--- | :--- | :-: | :--- |
| **1** | [Analyzing Channel Portfolios](./01_analyzing_channel_portfolios) | [`analyzing_channel_portfolio.sql`](./01_analyzing_channel_portfolios/analyzing_channel_portfolio.sql) | [`CSV`](./01_analyzing_channel_portfolios/analyzing_channel_portfolio.csv) | Track weekly traffic volume across nonbrand search channels (`gsearch` vs. `bsearch`) from late August to late November 2012 to evaluate multi-channel performance and channel mix growth. |
| **2** | [Comparing Channel Characteristics](./02_comparing_channel_characteristics) | [`comparing_channel_characteristic.sql`](./02_comparing_channel_characteristics/comparing_channel_characteristic.sql) | [`CSV`](./02_comparing_channel_characteristics/comparing_channel_characteristic.csv) | Compare device mix (desktop vs. mobile percentage) between `gsearch` and `bsearch` nonbrand campaigns to evaluate channel user profile differences. |
| **3** | [Cross-Channel Bid Optimization](./03_cross_channel_bid_optimization) | [`multi_channel_bidding.sql`](./03_cross_channel_bid_optimization/multi_channel_bidding.sql) | [`CSV`](./03_cross_channel_bid_optimization/multi_channel_bidding.csv) | Analyze nonbrand session-to-order conversion rates across channels (`gsearch` vs. `bsearch`) segmented by device type to optimize cross-channel bidding strategies. |
| **4** | [Channel Portfolio Trends](./04_channel_portfolio_trends) | [`impact_of_bid_changes.sql`](./04_channel_portfolio_trends/impact_of_bid_changes.sql) | [`CSV`](./04_channel_portfolio_trends/impact_of_bid_changes.csv) | Track weekly session volume and `bsearch`-to-`gsearch` traffic ratios across desktop and mobile devices following the `bsearch` bid reduction on Dec 2, 2012. |
