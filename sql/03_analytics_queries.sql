-- =============================================================================
-- Retail Sales Analytics Platform
-- Script 03: Core Analytics Queries
-- Author: Atharva Korwar
-- Description: Business KPI queries powering the Power BI dashboard.
--              Each section corresponds to a dashboard page.
-- =============================================================================

-- =============================================================================
-- SECTION A: Revenue Overview KPIs
-- =============================================================================

-- A1. Overall KPI Summary
SELECT
    COUNT(DISTINCT transaction_id)              AS total_transactions,
    COUNT(DISTINCT customer_id)                 AS unique_customers,
    ROUND(SUM(revenue), 2)                      AS total_revenue,
    ROUND(SUM(profit), 2)                       AS total_profit,
    ROUND(AVG(profit / NULLIF(revenue,0)) * 100, 2) AS avg_profit_margin_pct,
    ROUND(SUM(revenue) / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM sales_transactions;

-- A2. Monthly Revenue & Profit Trend
SELECT
    DATE_FORMAT(date, '%Y-%m')     AS year_month,
    ROUND(SUM(revenue), 2)          AS total_revenue,
    ROUND(SUM(profit), 2)           AS total_profit,
    ROUND(SUM(profit)/SUM(revenue)*100, 2) AS profit_margin_pct,
    COUNT(DISTINCT transaction_id)  AS total_orders
FROM sales_transactions
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY year_month;

-- A3. Revenue vs Target (Month × Region)
SELECT
    t.year_month,
    t.region,
    ROUND(SUM(s.revenue), 2)               AS actual_revenue,
    t.revenue_target,
    ROUND(SUM(s.revenue) - t.revenue_target, 2) AS variance,
    ROUND(SUM(s.revenue) / t.revenue_target * 100, 2) AS attainment_pct
FROM sales_transactions s
JOIN monthly_targets t
    ON DATE_FORMAT(s.date, '%Y-%m') = t.year_month
    AND s.region = t.region
GROUP BY t.year_month, t.region, t.revenue_target
ORDER BY t.year_month, t.region;


-- =============================================================================
-- SECTION B: Product Performance
-- =============================================================================

-- B1. Revenue & Profit by Category
SELECT
    category,
    COUNT(DISTINCT transaction_id)         AS total_orders,
    SUM(quantity)                          AS units_sold,
    ROUND(SUM(revenue), 2)                 AS total_revenue,
    ROUND(SUM(profit), 2)                  AS total_profit,
    ROUND(SUM(profit)/SUM(revenue)*100, 2) AS profit_margin_pct,
    ROUND(AVG(net_unit_price), 2)          AS avg_selling_price
FROM sales_transactions
GROUP BY category
ORDER BY total_revenue DESC;

-- B2. Top 10 Products by Revenue
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity)                          AS units_sold,
    ROUND(SUM(revenue), 2)                 AS total_revenue,
    ROUND(SUM(profit), 2)                  AS total_profit,
    ROUND(SUM(profit)/SUM(revenue)*100, 2) AS profit_margin_pct
FROM sales_transactions
GROUP BY product_id, product_name, category
ORDER BY total_revenue DESC
LIMIT 10;

-- B3. Discount Impact on Profit Margin
SELECT
    CASE
        WHEN discount_pct = 0          THEN 'No Discount'
        WHEN discount_pct <= 0.10      THEN '1-10%'
        WHEN discount_pct <= 0.20      THEN '11-20%'
        ELSE '21%+'
    END                                     AS discount_band,
    COUNT(*)                                AS transactions,
    ROUND(AVG(profit/NULLIF(revenue,0))*100,2) AS avg_margin_pct,
    ROUND(SUM(revenue), 2)                  AS total_revenue
FROM sales_transactions
GROUP BY discount_band
ORDER BY discount_band;


-- =============================================================================
-- SECTION C: Regional Performance
-- =============================================================================

-- C1. Revenue & Orders by Region
SELECT
    region,
    COUNT(DISTINCT transaction_id)         AS total_orders,
    COUNT(DISTINCT customer_id)            AS unique_customers,
    ROUND(SUM(revenue), 2)                 AS total_revenue,
    ROUND(SUM(profit), 2)                  AS total_profit,
    ROUND(SUM(profit)/SUM(revenue)*100, 2) AS profit_margin_pct,
    ROUND(SUM(revenue)/COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM sales_transactions
GROUP BY region
ORDER BY total_revenue DESC;

-- C2. Channel Mix by Region
SELECT
    region,
    channel,
    COUNT(DISTINCT transaction_id)   AS orders,
    ROUND(SUM(revenue), 2)           AS revenue,
    ROUND(SUM(revenue) / SUM(SUM(revenue)) OVER (PARTITION BY region) * 100, 2) AS channel_share_pct
FROM sales_transactions
GROUP BY region, channel
ORDER BY region, revenue DESC;


-- =============================================================================
-- SECTION D: Customer Behaviour
-- =============================================================================

-- D1. Customer Segment Analysis
SELECT
    c.segment,
    COUNT(DISTINCT s.customer_id)          AS total_customers,
    COUNT(DISTINCT s.transaction_id)       AS total_orders,
    ROUND(SUM(s.revenue), 2)               AS total_revenue,
    ROUND(SUM(s.revenue)/COUNT(DISTINCT s.customer_id), 2) AS avg_revenue_per_customer,
    ROUND(COUNT(DISTINCT s.transaction_id)*1.0/COUNT(DISTINCT s.customer_id), 1) AS avg_orders_per_customer
FROM sales_transactions s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_revenue DESC;

-- D2. Repeat vs One-time Buyers
SELECT
    purchase_frequency,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_customers
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(DISTINCT transaction_id) = 1 THEN 'One-time'
            WHEN COUNT(DISTINCT transaction_id) <= 3 THEN 'Occasional (2-3)'
            WHEN COUNT(DISTINCT transaction_id) <= 6 THEN 'Regular (4-6)'
            ELSE 'Loyal (7+)'
        END AS purchase_frequency
    FROM sales_transactions
    GROUP BY customer_id
) freq
GROUP BY purchase_frequency
ORDER BY customer_count DESC;

-- D3. Sales Channel Performance
SELECT
    channel,
    COUNT(DISTINCT transaction_id)         AS total_orders,
    ROUND(SUM(revenue), 2)                 AS total_revenue,
    ROUND(AVG(revenue), 2)                 AS avg_order_value,
    ROUND(SUM(profit)/SUM(revenue)*100, 2) AS profit_margin_pct
FROM sales_transactions
GROUP BY channel
ORDER BY total_revenue DESC;


-- =============================================================================
-- SECTION E: Time Intelligence
-- =============================================================================

-- E1. Quarter-over-Quarter Revenue Growth
SELECT
    YEAR(date)   AS year,
    QUARTER(date) AS quarter,
    ROUND(SUM(revenue), 2) AS quarterly_revenue,
    ROUND(
        (SUM(revenue) - LAG(SUM(revenue)) OVER (ORDER BY YEAR(date), QUARTER(date)))
        / NULLIF(LAG(SUM(revenue)) OVER (ORDER BY YEAR(date), QUARTER(date)), 0) * 100,
    2) AS qoq_growth_pct
FROM sales_transactions
GROUP BY YEAR(date), QUARTER(date)
ORDER BY year, quarter;

-- E2. Day-of-Week Revenue Pattern
SELECT
    DAYNAME(date)           AS day_of_week,
    DAYOFWEEK(date)         AS day_num,
    COUNT(*)                AS total_orders,
    ROUND(SUM(revenue), 2)  AS total_revenue,
    ROUND(AVG(revenue), 2)  AS avg_order_value
FROM sales_transactions
GROUP BY DAYNAME(date), DAYOFWEEK(date)
ORDER BY day_num;
