# Retail Sales Analytics — Business Insights Report
**Period:** January 2023 – December 2023  
**Analyst:** Atharva Korwar  
**Tools Used:** SQL · Python · Power BI · Excel

---

## Executive Summary

Analysis of 2,000 retail transactions across 6 product categories, 5 regions, and 3 sales channels reveals a healthy revenue base with significant opportunities to improve profitability through discount optimisation, channel investment, and customer retention.

---

## 1. Financial Performance at a Glance

| KPI | Value |
|-----|-------|
| Total Revenue | ~₹3.6L |
| Total Profit | ~₹1.4L |
| Overall Profit Margin | ~39% |
| Total Orders | 2,000 |
| Unique Customers | 500 |
| Average Order Value | ~₹180 |

---

## 2. Category Performance

### Key Findings

**Electronics** — Highest revenue contributor due to premium unit prices (avg ₹399+), but susceptibility to high discount rates (seen in 21%+ band) compresses margins. Close monitoring of discount approvals is recommended.

**Home & Kitchen** — Balanced performer with consistent margin around 40–42%. Strong repeat purchase pattern from loyal customers makes this a low-risk, steady revenue stream.

**Sports & Beauty** — Underperforming in total revenue but above-average margin. These categories have pricing power that is being under-utilised. Targeted campaigns could unlock volume growth without sacrificing margin.

**Books** — Lowest absolute revenue but highest discount frequency due to promotions. Consider reducing blanket discounts and shifting to loyalty-based offers.

### Recommendation
> Introduce category-level discount caps: Electronics ≤ 15%, Clothing ≤ 20%, Books ≤ 10%. Estimated margin improvement: **+2–3 percentage points** overall.

---

## 3. Regional Insights

| Region | Revenue Rank | Margin Rank | Insight |
|--------|:-----------:|:-----------:|---------|
| North | 1st | 3rd | High volume, moderate margin — review cost structure |
| South | 2nd | 1st | Best margin efficiency — replicate model elsewhere |
| East | 3rd | 4th | Below-average margin signals possible discount overuse |
| West | 4th | 2nd | Strong margin on lower volume — opportunity to scale |
| Central | 5th | 5th | Weakest performer on both dimensions — needs intervention |

### Revenue vs. Target
- North and South consistently **exceed** monthly revenue targets by 8–12%.
- Central region misses targets 7 out of 12 months — root cause analysis and sales team support required.

### Recommendation
> Reallocate Q4 marketing budget from Central to West region where margin return per marketing rupee is highest.

---

## 4. Channel Analysis

| Channel | Revenue Share | Avg Order Value | Profit Margin |
|---------|:------------:|:--------------:|:-------------:|
| Online | ~38% | Medium | ~39% |
| In-Store | ~33% | Lower | ~38% |
| Mobile App | ~29% | **Highest** | ~40% |

### Key Insight
Mobile App customers have the **highest average order value** and the best profit margin. This likely reflects a higher-intent, tech-savvy customer segment that responds well to personalised recommendations.

### Recommendation
> Invest in Mobile App UX improvements and personalised push notifications targeting lapsed app users. Even a 5% increase in Mobile App revenue share would add ~₹18K incremental revenue annually.

---

## 5. Discount Impact

| Discount Band | Avg Profit Margin | Transaction Share |
|--------------|:-----------------:|:-----------------:|
| No Discount | ~44% | ~25% |
| 1–10% | ~41% | ~30% |
| 11–20% | ~37% | ~30% |
| 21%+ | ~33% | ~15% |

### Key Insight
Each 10 percentage point increase in discount depth reduces profit margin by approximately **3.5–4 pp**. The 21%+ band generates the weakest margins with no evidence of compensating volume uplift.

### Recommendation
> Implement a discount approval workflow for any discount above 15%. Estimated annual profit protection: **₹12,000–₹18,000**.

---

## 6. Customer Behaviour

### Segment Revenue Contribution
- **Premium** customers (20% of base): ~45% of revenue
- **Regular** customers (50% of base): ~42% of revenue
- **Occasional** customers (30% of base): ~13% of revenue

### Purchase Frequency
- ~35% of customers are **one-time buyers** — significant churn risk
- ~18% are **Loyal (7+ orders)** — disproportionately high revenue contributors

### Recommendation
> Launch a two-pronged CRM strategy:
> 1. **Win-back campaign** for one-time buyers (email + 10% offer after 60-day silence)
> 2. **Loyalty programme** for Loyal segment to maintain and deepen engagement

---

## 7. Seasonal Trend

- Revenue shows a **steady upward trend** from January through April, a mid-year plateau in May–August, and a **Q4 spike** in October–December.
- December is consistently the highest revenue month (~18% above monthly average).

### Recommendation
> Begin inventory build and supplier negotiations for top-selling Electronics and Home & Kitchen SKUs by **September** to avoid stockouts during Q4 peak.

---

## 8. Summary of Recommendations

| # | Recommendation | Expected Impact | Priority |
|---|---------------|----------------|----------|
| 1 | Category-level discount caps | +2–3 pp margin | High |
| 2 | Reallocate budget: Central → West | +5–8% regional revenue | High |
| 3 | Mobile App investment | +5% revenue share | Medium |
| 4 | Discount approval workflow | ₹12K–18K profit protection | High |
| 5 | CRM win-back campaign | Recover 10–15% one-time buyers | Medium |
| 6 | Q4 inventory pre-planning | Prevent stockout revenue loss | Medium |

---

*Report generated from EDA notebook `notebooks/01_EDA_retail_sales.ipynb` and SQL analytics in `sql/03_analytics_queries.sql`*
