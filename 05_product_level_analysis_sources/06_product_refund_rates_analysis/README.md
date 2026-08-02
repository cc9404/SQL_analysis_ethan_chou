# 📄 Core Module 6: Product Refund Rates Analysis

This module tracks monthly order volume and product-level refund rates across all four products (Product 1 through Product 4) prior to October 15, 2014. It helps evaluate whether quality control adjustments effectively mitigated historic return/refund spikes.

---

## 📌 Business Problem & Context

Product quality issues and customer returns directly impact net revenue and unit economics. Management requested a monthly breakdown of refund rates by product to identify historical quality bottlenecks (e.g., Product 1 quality issues) and verify whether supplier/manufacturing fixes successfully lowered return rates back to baseline levels.

---

## 🛠️ SQL Script & Output Dataset

* **Main SQL Script:** 🔗 [`analyzing_product_refund_rates.sql`](./analyzing_product_refund_rates.sql)
* **Data Output Link:** 📄 [`analyzing_product_refund_rates.csv`](./analyzing_product_refund_rates.csv)

### 🔹 SQL Query: Monthly Product Refund Rates

```sql
SELECT
    YEAR(order_items.created_at) AS yr,
    MONTH(order_items.created_at) AS mo,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN order_items.order_id ELSE NULL END) AS p1_orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN order_item_refunds.order_item_id ELSE NULL END)
        / COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN order_items.order_item_id ELSE NULL END) AS p1_refund_rt,
    
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN order_items.order_id ELSE NULL END) AS p2_orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN order_item_refunds.order_item_id ELSE NULL END)
        / COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN order_items.order_item_id ELSE NULL END) AS p2_refund_rt,
    
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN order_items.order_id ELSE NULL END) AS p3_orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN order_item_refunds.order_item_id ELSE NULL END)
        / COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN order_items.order_item_id ELSE NULL END) AS p3_refund_rt,
    
    COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN order_items.order_id ELSE NULL END) AS p4_orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN order_item_refunds.order_item_id ELSE NULL END)
        / COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN order_items.order_item_id ELSE NULL END) AS p4_refund_rt

FROM order_items
    LEFT JOIN order_item_refunds
        ON order_item_refunds.order_item_id = order_items.order_item_id
WHERE order_items.created_at < '2014-10-15'
GROUP BY 1, 2;
```

---

* **Data Output Link:** 📄 [`analyzing_product_refund_rates.csv`](./analyzing_product_refund_rates.csv)

**Output Data Sample (`analyzing_product_refund_rates.csv`):**

| yr | mo | p1_orders | p1_refund_rt | p2_orders | p2_refund_rt | p3_orders | p3_refund_rt | p4_orders | p4_refund_rt |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **2014** | **5** | 1,030 | **2.91%** | 246 | **1.63%** | 299 | **5.69%** | 298 | **0.67%** |
| **2014** | **6** | 893 | **5.71%** | 245 | **3.67%** | 288 | **5.56%** | 249 | **2.41%** |
| **2014** | **7** | 961 | **4.37%** | 244 | **3.69%** | 276 | **3.99%** | 264 | **1.52%** |
| **2014** | **8** | 958 | **13.78%** | 237 | **1.69%** | 294 | **6.80%** | 303 | **0.66%** |
| **2014** | **9** | 1,056 | **13.26%** | 251 | **3.19%** | 317 | **6.62%** | 327 | **1.22%** |
| **2014** | **10** | 513 | **2.73%** | 135 | **0.74%** | 165 | **4.85%** | 155 | **3.23%** |

---

## 💡 Key Business Insights

1. **Product 1 Refund Surge & Quality Recovery:**
   * Product 1 experienced a severe quality degradation in August (**13.78%**) and September 2014 (**13.26%**).
   * Following targeted supplier interventions and quality control fixes, the refund rate dropped sharply to **2.73%** in October 2014, confirming that the manufacturing defect was successfully resolved.

2. **Benchmark Product Quality (Products 2 & 4):**
   * Products 2 and 4 consistently maintain low return rates, generally staying between **0.7% and 3.7%**, serving as strong quality benchmarks across the store.

3. **Ongoing Product 3 Optimization:**
   * Product 3 maintains a higher baseline refund rate (averaging **4.8% to 6.8%**) relative to Products 2 and 4. Continued supplier monitoring and customer feedback reviews are recommended to pull returns closer to the company's <3% benchmark.
