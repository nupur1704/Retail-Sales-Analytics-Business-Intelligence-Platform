# Power BI Dashboard — Build Guide
**Project:** Retail Sales Analytics & Business Intelligence Platform  
**File to create:** `Retail_Sales_Analytics.pbix`

---

## Data Sources to Connect

| Source | File | Load As |
|--------|------|---------|
| Sales Transactions | `../data/sales_transactions.csv` | Fact_Sales |
| Products | `../data/products.csv` | Dim_Products |
| Customers | `../data/customers.csv` | Dim_Customers |
| Monthly Targets | `../data/monthly_targets.csv` | Ref_Targets |

---

## Data Model (Star Schema)

```
          Dim_Customers
               |
Dim_Products --+-- Fact_Sales --- Ref_Targets
               |
          (date hierarchy)
```

**Relationships:**
- `Fact_Sales[product_id]` → `Dim_Products[product_id]` (Many-to-One)
- `Fact_Sales[customer_id]` → `Dim_Customers[customer_id]` (Many-to-One)
- `Fact_Sales[year_month]` → `Ref_Targets[year_month]` + `Fact_Sales[region]` → `Ref_Targets[region]`

---

## DAX Measures (create these in the model)

```dax
-- Core KPIs
Total Revenue = SUM(Fact_Sales[revenue])
Total Profit  = SUM(Fact_Sales[profit])
Total Orders  = DISTINCTCOUNT(Fact_Sales[transaction_id])
Unique Customers = DISTINCTCOUNT(Fact_Sales[customer_id])

-- Margin
Profit Margin % = DIVIDE([Total Profit], [Total Revenue]) * 100

-- Average Order Value
Avg Order Value = DIVIDE([Total Revenue], [Total Orders])

-- Target comparison
Revenue Target = SUM(Ref_Targets[revenue_target])
Revenue vs Target = [Total Revenue] - [Revenue Target]
Attainment % = DIVIDE([Total Revenue], [Revenue Target]) * 100

-- MoM Growth (requires Date table or period column)
Revenue MoM Growth % =
VAR CurrentRev = [Total Revenue]
VAR PrevRev    = CALCULATE([Total Revenue], DATEADD('Date'[Date], -1, MONTH))
RETURN DIVIDE(CurrentRev - PrevRev, PrevRev) * 100
```

---

## Dashboard Pages

### Page 1 — Executive Overview
**Visuals:**
- 4 KPI cards: Total Revenue · Total Profit · Profit Margin % · Total Orders
- Line chart: Monthly Revenue & Profit trend (Jan–Dec)
- Bar chart: Revenue by Category (sorted desc)
- Map visual: Revenue by Region (bubble map)
- Slicer: Month, Region, Category

### Page 2 — Product Performance
**Visuals:**
- Table: Top 10 Products (Revenue, Profit, Margin %, Units)
- Bar chart: Profit Margin % by Category
- Scatter chart: Revenue vs. Margin (each product as a dot)
- Bar chart: Discount Band vs. Avg Margin

### Page 3 — Regional KPIs
**Visuals:**
- Clustered bar: Actual Revenue vs. Target by Region
- Gauge chart: Overall Attainment % (target = 100%)
- Matrix: Region × Month heatmap (conditional formatting on revenue)
- Donut: Channel Mix by Region (slicer)

### Page 4 — Customer Insights
**Visuals:**
- Donut: Revenue by Customer Segment (Premium / Regular / Occasional)
- Bar: Avg Order Value by Age Group
- Bar: Orders by Channel
- Table: Top 20 customers by lifetime revenue

---

## Formatting Standards

- **Colour palette:** Blues for revenue (#2563EB), Greens for profit (#16A34A), Amber for targets (#D97706)
- **Fonts:** Segoe UI throughout
- **Number formats:** Revenue/Profit → `₹#,##0` | Percentages → `0.0%`
- **Report theme:** Apply a clean corporate theme (Accessible Default or Executive)
- **All pages:** Add a page title, company logo placeholder, and "Last Refreshed" date text box

---

## File Naming
Save as: `powerbi/Retail_Sales_Analytics.pbix`

> **Note:** The `.pbix` binary is not tracked in Git (added to `.gitignore`).  
> Screenshots of each dashboard page are saved in `screenshots/` instead.
