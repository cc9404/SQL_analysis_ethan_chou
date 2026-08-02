# 📁 Sub-topic 5: Product-Level Analysis

This folder contains all SQL scripts and output datasets for evaluating product sales performance, new product launch impact, cross-selling funnels, product portfolio expansion, and refund rate analytics for Fuzzy Factory.

---

📊 Core Modules & SQL Scripts

| # | Module Link | SQL Script(s) | Data Output(s) | Description |
| :-: | :--- | :--- | :-: | :--- |
| **1** | [Product Sales Analysis](./01_product_sales_analysis) | [`product_level_sales_analysis.sql`](./01_product_sales_analysis/product_level_sales_analysis.sql) | [`CSV`](./01_product_sales_analysis/product_level_sales_analysis.csv) | Track monthly sales volume, total revenue, and total margin generated to analyze product sales performance trends. |
| **2** | [Product Launch Analysis](./02_product_launch_analysis) | [`analyzing_product_launches.sql`](./02_product_launch_analysis/analyzing_product_launches.sql) | [`CSV`](./02_product_launch_analysis/analyzing_product_launches.csv) | Evaluate monthly order volume, conversion rate lift, revenue per session, and product breakdown following the launch of Product 2. |
| **3** | [Product-Level Website Pathing](./03_product_level_website_pathing) | [`building_product_conversion_funnels.sql`](./03_product_level_website_pathing/building_product_conversion_funnels.sql) | [`CSV`](./03_product_level_website_pathing/final_output_part_1.csv) | Compare product-level conversion funnels and click-through rates from product pageview to checkout completion for Mr. Fuzzy vs. Love Bear. |
| **4** | [Cross-Sell Portfolio Analysis](./04_cross_sell_portfolio_analysis) | [`cross_sell_analysis.sql`](./04_cross_sell_portfolio_analysis/cross_sell_analysis.sql) | [`CSV`](./04_cross_sell_portfolio_analysis/final_output.csv) | Compare cart page click-through rates, items per order, average order value (AOV), and revenue per cart session before vs. after cross-sell implementation. |
| **5** | [Product Portfolio Expansion](./05_product_portfolio_expansion) | [`product_portfolio_expansion.sql`](./05_product_portfolio_expansion/product_portfolio_expansion.sql) | [`CSV`](./05_product_portfolio_expansion/product_portfolio_expansion.csv) | Evaluate session-to-order conversion rate, AOV, products per order, and revenue per session pre vs. post product portfolio expansion (3rd product launch). |
| **6** | [Product Refund Rates Analysis](./06_product_refund_rates_analysis) | [`analyzing_product_refund_rates.sql`](./06_product_refund_rates_analysis/analyzing_product_refund_rates.sql) | [`CSV`](./06_product_refund_rates_analysis/analyzing_product_refund_rates.csv) | Track monthly product-level order volume and refund rates across Products 1–4 to evaluate product quality improvements and return trends. |
