# 📄 Core Module 1: Product Sales Performance & Trends Analysis

This module evaluates monthly sales volume (`number_of_sales`), total revenue (`total_revenue`), and total profit margin (`total_margin`) generated across 2012 and early 2013. It provides baseline financial performance metrics to analyze core product growth before multi-product line expansions.

---

## 📌 Business Problem & Context

Understanding product sales velocity, revenue trends, and gross margin evolution over time is critical for inventory forecasting, pricing strategy, and profitability management. Management requested a monthly financial breakdown to evaluate Fuzzy Factory's flagship product performance trajectory.

---

## 🛠️ Step-by-Step SQL Analysis & Output Datasets

* **Main SQL Script:** 🔗 [`product_level_sales_analysis.sql`](./product_level_sales_analysis.sql)

---

### 🔹 Monthly Product Sales, Revenue, and Margin Breakdown
Aggregate order volume, sum gross revenue (`price_usd`), and sum net margin (`price_usd - cogs_usd`) grouped by year and month.

```sql
SELECT DISTINCT
    YEAR(created_at) AS yr,
    MONTH(created_at) AS mo,
    COUNT(DISTINCT order_id) AS number_of_sales,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS total_margin
FROM orders
WHERE created_at < '2013-01-04'
GROUP BY 1, 2;
```

---

* **Data Output Link:** 📄 [`product_level_sales_analysis.csv`](./product_level_sales_analysis.csv)

**Output Data (`product_level_sales_analysis.csv`):**

| yr | mo | number_of_sales | total_revenue | total_margin |
| :---: | :---: | :---: | :---: | :---: |
| 2012 | 3 | 60 | $2,999.40 | $1,830.00 |
| 2012 | 4 | 99 | $4,949.01 | $3,019.50 |
| 2012 | 5 | 108 | $5,398.92 | $3,294.00 |
| 2012 | 6 | 140 | $6,998.60 | $4,270.00 |
| 2012 | 7 | 169 | $8,448.31 | $5,154.50 |
| 2012 | 8 | 228 | $11,397.72 | $6,954.00 |
| 2012 | 9 | 287 | $14,347.13 | $8,753.50 |
| 2012 | 10 | 371 | $18,546.29 | $11,315.50 |
| 2012 | 11 | 618 | $30,893.82 | $18,849.00 |
| 2012 | 12 | 506 | $25,294.94 | $15,433.00 |
| 2013 | 1 | 42 | $2,099.58 | $1,281.00 |

---

## 💡 Key Business Insights

1. **Strong Growth Trajectory:**
   * Monthly sales expanded over **10x** from 60 orders ($2,999 revenue) in March 2012 to a peak of 618 orders ($30,893 revenue) in November 2012.

2. **High Gross Profit Margins:**
   * Gross profit margin remained exceptionally stable at **~61%** of total revenue throughout the entire period (e.g., $18,849 margin on $30,893 revenue in Nov 2012).

3. **Strategic Recommendations:**
   * Maintain focus on flagship product marketing efficiency while leveraging high profit margins to fund future multi-product launch R&D and portfolio expansion.
