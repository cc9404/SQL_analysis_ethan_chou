# 📈 Module 2: Traffic Source Conversion Rates

This folder contains the SQL analysis and output datasets for evaluating Session-to-Order Conversion Rates (CVR) across primary traffic channels for Maven Fuzzy Factory.

---

## 📌 Business Question & Target

* **Context:** Management needs to confirm if paid `gsearch / nonbrand` search traffic is generating sufficient order volume to justify current advertising spend.
* **Target Metric:** Achieve a **Session-to-Order CVR of $\ge 4\%$** to ensure search campaign profitability.
* **Timeframe:** Data evaluated prior to `2012-04-14`.

---

## 📐 Conversion Rate Formula

The session-to-order conversion rate is calculated using the following formula:

$$\text{Conversion Rate (CVR)} = \frac{\text{Total Orders}}{\text{Total Website Sessions}} \times 100\%$$

In SQL logic:
```sql
COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id)
