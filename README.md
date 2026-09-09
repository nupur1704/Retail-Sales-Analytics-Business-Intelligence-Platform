# Retail Sales Analytics Dashboard

A complete data analytics project for transforming retail transaction data into meaningful business insights using SQL, Python, and Power BI.

# 📌 Project Overview

This project focuses on analyzing retail sales data to understand revenue performance, profitability, customer behavior, regional trends, and sales-channel performance.

The dataset contains 2,000 sales transactions covering 6 product categories, 5 regions, and 3 sales channels during 2023.

The project follows an end-to-end analytics workflow:

Raw Data → SQL Processing → Exploratory Analysis → KPI Analysis → Power BI Dashboard → Business Recommendations

The main objective is to turn transactional data into insights that can support decisions around pricing, discounts, regional performance, customer retention, and revenue growth.

Business Questions

The analysis investigates questions such as:

Which categories generate the most revenue and profit?
Which regions are performing strongly against their targets?
How are discounts affecting profitability?
Which customer segments contribute the greatest share of revenue?
Which sales channel produces the highest average order value?
How does sales performance change throughout the year?
Where are there opportunities to improve customer retention?
🗂️ Repository Structure
retail-sales-analytics/
│
├── data/
│   ├── sales_transactions.csv
│   ├── products.csv
│   ├── customers.csv
│   └── monthly_targets.csv
│
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_etl_cleaning.sql
│   └── 03_analytics_queries.sql
│
├── notebooks/
│   └── 01_EDA_retail_sales.ipynb
│
├── powerbi/
│   └── dashboard_guide.md
│
├── reports/
│   └── business_insights_report.md
│
├── screenshots/
│   ├── powerbi_overview.png
│   ├── powerbi_product_page.png
│   ├── powerbi_regional_page.png
│   ├── monthly_revenue_trend.png
│   ├── category_performance.png
│   ├── regional_analysis.png
│   ├── discount_impact.png
│   └── channel_analysis.png
│
├── requirements.txt
└── .gitignore
🛠️ Tools & Technologies
Area	Technology
Data Storage	CSV / MySQL / PostgreSQL
Data Cleaning & SQL Analysis	MySQL SQL
Data Analysis	Python
Data Manipulation	Pandas, NumPy
Visualization	Matplotlib, Seaborn
Business Intelligence	Microsoft Power BI
Development Environment	Jupyter Notebook
Version Control	Git & GitHub
# 📊 Dataset

The project works with four primary datasets:

Dataset	Records	Purpose
sales_transactions	2,000	Stores individual sales transactions
products	30	Contains product and category information
customers	500	Provides customer and segment attributes
monthly_targets	60	Contains monthly revenue and profit targets by region
Main Transaction Fields

The sales_transactions table contains important analytical fields including:

transaction_id
date
customer_id
product_id
category
region
channel
quantity
revenue
cogs
profit
discount_pct

These fields are used to calculate KPIs such as revenue, profit, profit margin, average order value, discount impact, and regional performance.


Create the database and execute the SQL files in the following sequence:

mysql -u root -p your_db < sql/01_create_schema.sql
mysql -u root -p your_db < sql/02_etl_cleaning.sql
mysql -u root -p your_db < sql/03_analytics_queries.sql

The scripts handle database setup, data preparation, validation, and analytical queries.

4. Explore the Data with Python

Open the Jupyter notebook:

cd notebooks
jupyter notebook 01_EDA_retail_sales.ipynb

The notebook contains exploratory analysis covering the major trends and relationships within the sales data.

5. Build the Power BI Dashboard
Launch Power BI Desktop.
Import the four CSV files from the data directory.
Create the required relationships between the tables.
Follow powerbi/dashboard_guide.md for the data model and DAX measures.
Recreate the dashboard pages using the provided layout and KPI definitions.
# 🔎 Key Insights

The analysis produced several notable findings:

Area	Observation
Revenue Leader	Electronics contributes approximately 22% of overall revenue
Strongest Margin	Sports records an average margin of around 42%
Regional Leader	North consistently performs above its target
Regional Concern	Central falls short of its target in 7 of 12 months
Best AOV Channel	Mobile App has the highest average order value
Discount Effect	Discounts above 21% are associated with roughly 6–8 percentage points lower margins
Customer Value	Premium customers represent about 20% of customers but generate around 45% of revenue
Repeat Opportunity	Approximately 35% of customers are one-time buyers

These results highlight opportunities to improve discount management, strengthen weaker regions, and focus retention efforts on valuable customer groups.

# 📈 Dashboard

The Power BI dashboard is designed to provide an interactive view of overall business performance


Product Performance
<img width="1420" height="580" alt="discount_impact" src="https://github.com/user-attachments/assets/6d6043e1-5edc-47d1-b599-1374fb24219c" />




Regional Performance
<img width="1658" height="580" alt="category_performance" src="https://github.com/user-attachments/assets/c7f2262d-5e4d-4fdb-80cd-119541ce7da2" />




Monthly Revenue Analysis
<img width="1044" height="638" alt="Screenshot (290)" src="https://github.com/user-attachments/assets/1a986fbc-4a2e-4771-ac61-cf70e5f90d75" />


Category Analysis
<img width="1046" height="365" alt="Screenshot 2026-09-09 185320" src="https://github.com/user-attachments/assets/7dd4af60-83cd-4ea8-bca9-c74d5cbccffb" />




The supporting screenshots also include regional analysis, discount impact, and sales-channel performance.

# 💡 Business Recommendations

Based on the analysis, the following actions can help improve business performance:

1. Improve Discount Control

High discounts can significantly reduce margins. Electronics discounts could be limited to 15%, with additional approval required for larger discounts.

2. Strengthen the Mobile Channel

Since the Mobile App generates the highest average order value, investing in personalized notifications and improving the mobile experience could help increase sales.

3. Address Central Region Performance

The Central region consistently underperforms against its targets. Targeted promotions and additional sales support could help close the performance gap.

4. Focus on Customer Retention

The relatively high percentage of one-time buyers represents a potential re-engagement opportunity. Loyalty programs and targeted win-back campaigns can be used to encourage repeat purchases.

5. Prepare for Q4 Demand

December sales are approximately 18% higher than the monthly average, making inventory planning particularly important before the year-end period.

# 🧮 SQL Analysis

The project also demonstrates the use of advanced SQL techniques for business analysis.

Revenue Share by Channel

A window function is used to calculate the contribution of each sales channel within a region:

SELECT
    region,
    channel,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(
        SUM(revenue) /
        SUM(SUM(revenue)) OVER (PARTITION BY region) * 100,
        2
    ) AS channel_share_pct
FROM sales_transactions
GROUP BY region, channel;
Quarter-over-Quarter Growth

LAG() is used to compare quarterly revenue with the previous quarter:

SELECT
    YEAR(date) AS year,
    QUARTER(date) AS quarter,
    ROUND(SUM(revenue), 2) AS quarterly_revenue,
    ROUND(
        (
            SUM(revenue) -
            LAG(SUM(revenue)) OVER (
                ORDER BY YEAR(date), QUARTER(date)
            )
        )
        / NULLIF(
            LAG(SUM(revenue)) OVER (
                ORDER BY YEAR(date), QUARTER(date)
            ),
            0
        ) * 100,
        2
    ) AS qoq_growth_pct
FROM sales_transactions
GROUP BY YEAR(date), QUARTER(date);
# 🎯 Project Objectives

This project demonstrates practical skills in:

Data cleaning and preparation
SQL database querying
Exploratory data analysis
KPI development
Business intelligence reporting
Power BI dashboard development
Data visualization
Customer and regional analysis
Translating analytical findings into business recommendations
# <img width="1044" height="638" alt="Screenshot (290)" src="https://github.com/user-attachments/assets/b84184dc-7e8e-4b99-98e2-9fa0531c83d8" />
👤 Author

Nupur Gupta

Aspiring Data Analyst
Skills: Python · SQL · Power BI

LinkedIn = www.linkedin.com/in/nupur-gupta-886090311

⭐ Feedback

If you find the project useful, feel free to explore the repository, raise an issue, or share feedback and suggestions.
