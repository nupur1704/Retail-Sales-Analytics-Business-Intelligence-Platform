-- =============================================================================
-- Retail Sales Analytics Platform
-- Script 02: ETL — Data Cleaning & Validation
-- Author: Atharva Korwar
-- Description: Validates raw data quality and applies cleaning rules before
--              loading into the analytics schema.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- STEP 1: Data Quality Checks (run before loading)
-- -----------------------------------------------------------------------------

-- 1a. Check for duplicate transaction IDs
SELECT transaction_id, COUNT(*) AS occurrences
FROM sales_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- 1b. Check for NULL values in critical columns
SELECT
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_txn_id,
    SUM(CASE WHEN date IS NULL          THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN revenue IS NULL       THEN 1 ELSE 0 END) AS null_revenue,
    SUM(CASE WHEN customer_id IS NULL   THEN 1 ELSE 0 END) AS null_customer,
    SUM(CASE WHEN product_id IS NULL    THEN 1 ELSE 0 END) AS null_product
FROM sales_transactions;

-- 1c. Check for negative or zero revenue (data integrity issue)
SELECT COUNT(*) AS invalid_revenue_rows
FROM sales_transactions
WHERE revenue <= 0 OR quantity <= 0;

-- 1d. Check for future-dated transactions
SELECT COUNT(*) AS future_dated_rows
FROM sales_transactions
WHERE date > CURRENT_DATE;

-- 1e. Orphaned transactions (no matching customer or product)
SELECT COUNT(*) AS orphaned_txns
FROM sales_transactions s
LEFT JOIN customers c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- -----------------------------------------------------------------------------
-- STEP 2: Cleaning Rules
-- -----------------------------------------------------------------------------

-- 2a. Recalculate net_unit_price and profit where inconsistent
UPDATE sales_transactions
SET
    net_unit_price = ROUND(unit_price * (1 - discount_pct), 2),
    profit         = ROUND(revenue - cogs, 2)
WHERE
    net_unit_price IS NULL
    OR profit IS NULL;

-- 2b. Standardise text casing for categorical columns
UPDATE sales_transactions SET channel = INITCAP(TRIM(channel));
UPDATE sales_transactions SET region  = INITCAP(TRIM(region));
UPDATE customers           SET segment = INITCAP(TRIM(segment));

-- 2c. Cap unrealistic discount values (> 60% assumed data error)
UPDATE sales_transactions
SET discount_pct = 0.60
WHERE discount_pct > 0.60;

-- -----------------------------------------------------------------------------
-- STEP 3: Summary — row counts after cleaning
-- -----------------------------------------------------------------------------
SELECT
    'sales_transactions' AS table_name, COUNT(*) AS row_count FROM sales_transactions
UNION ALL
SELECT 'products',        COUNT(*) FROM products
UNION ALL
SELECT 'customers',       COUNT(*) FROM customers
UNION ALL
SELECT 'monthly_targets', COUNT(*) FROM monthly_targets;
