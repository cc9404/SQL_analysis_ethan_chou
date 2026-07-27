# 📁 Sub-topic 2: Analyzing Website Performance

This folder contains all SQL scripts and output datasets for analyzing website performance, top viewed pages, entry page behavior, landing page engagement, and conversion funnel optimization for Maven Fuzzy Factory.

---

## 📊 Core Modules & SQL Scripts

| # | Module Link | SQL Script(s) | Data Output(s) | Description |
| :---: | :--- | :--- | :---: | :--- |
| **1** | [Finding Top Website Pages & Entry Pages](./01_finding_top_website_pages_and_entry_pages) | [`finding_top_website_pages_and_entry_pages.sql`](./01_finding_top_website_pages_and_entry_pages/finding_top_website_pages_and_entry_pages.sql) | [`CSV`](./01_finding_top_website_pages_and_entry_pages/finding_top_website_pages_and_entry_pages.csv) | Identify top landing pages by linking initial session pageviews (IDs < 1000) to measure entry distribution. |
| **2** | [Finding Most Viewed Website Pages](./02_finding_most_viewed_website_pages) | [`finding_most_viewed_website_pages.sql`](./02_finding_most_viewed_website_pages/finding_most_viewed_website_pages.sql) | [`CSV`](./02_finding_most_viewed_website_pages/finding_most_viewed_website_pages.csv) | Rank most-frequently visited website pages by total pageview volume prior to mid-June 2012. |
| **3** | [Finding Top Entry Pages](./03_finding_top_entry_pages) | [`finding_top_entry_pages.sql`](./03_finding_top_entry_pages/finding_top_entry_pages.sql) | [`CSV`](./03_finding_top_entry_pages/finding_top_entry_pages.csv) | Determine primary entry points across all sessions to evaluate homepage traffic exposure. |
| **4** | [Calculating Bounce Rates](./04_calculating_bounce_rates) | [`bounce_rate_analysis.sql`](./04_calculating_bounce_rates/bounce_rate_analysis.sql) | [`CSV`](./04_calculating_bounce_rates/final_output.csv) | Measure single-page session bounce rates for homepage traffic prior to mid-June 2012 to quantify initial user engagement. |
| **5** | [Analyzing Landing Page Tests](./05_analyzing_landing_page_tests) | [`analyzing_landing_page_tests.sql`](./05_analyzing_landing_page_tests/analyzing_landing_page_tests.sql) | [`CSV`](./05_analyzing_landing_page_tests/identify_bounces_n_final_output.csv) | Evaluate A/B test performance comparing `/home` vs `/lander-1` for paid nonbrand search traffic to assess bounce rate reduction. |
| **6** | [Landing Page Trend Analysis](./06_landing_page_trend_analysis) | [`landing_page_trend_analysis.sql`](./06_landing_page_trend_analysis/landing_page_trend_analysis.sql) | [`CSV`](./06_landing_page_trend_analysis/final_output.csv) | Track weekly landing page volume and overall bounce rate trends from June to August 2012 to evaluate the impact of introducing `/lander-1`. |
| **7** | [Analyzing Conversion Funnels](./07_analyzing_conversion_funnels) | [`analyzing_conversion_funnels.sql`](./07_analyzing_conversion_funnels/analyzing_conversion_funnels.sql) | [`CSV`](./07_analyzing_conversion_funnels/final_output_part_2.csv) | Build a full conversion funnel for `/lander-1` traffic through the thank-you page to analyze drop-off rates and click-through performance across each step. |
