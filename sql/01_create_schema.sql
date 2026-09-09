-- =============================================================================
-- Retail Sales Analytics Platform
-- Script 01: Schema Creation
-- Author: Atharva Korwar
-- Description: Creates the core schema for sales analytics data warehouse
-- =============================================================================

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS sales_transactions;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS monthly_targets;

-- -----------------------------------------------------------------------------
-- DIMENSION: Products
-- -----------------------------------------------------------------------------
CREATE TABLE products (
    product_id    VARCHAR(10)    PRIMARY KEY,
    product_name  VARCHAR(100)   NOT NULL,
    category      VARCHAR(50)    NOT NULL,
    base_price    DECIMAL(10,2)  NOT NULL,
    supplier      VARCHAR(50),
    launch_date   DATE,
    is_active     CHAR(3)        DEFAULT 'Yes',
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------------------------------
-- DIMENSION: Customers
-- -----------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id   VARCHAR(10)    PRIMARY KEY,
    first_name    VARCHAR(50)    NOT NULL,
    last_name     VARCHAR(50)    NOT NULL,
    email         VARCHAR(100)   UNIQUE,
    region        VARCHAR(20),
    segment       VARCHAR(20),           -- Premium / Regular / Occasional
    signup_date   DATE,
    age_group     VARCHAR(10),
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------------------------------
-- FACT: Sales Transactions
-- -----------------------------------------------------------------------------
CREATE TABLE sales_transactions (
    transaction_id   VARCHAR(12)   PRIMARY KEY,
    date             DATE          NOT NULL,
    customer_id      VARCHAR(10)   REFERENCES customers(customer_id),
    product_id       VARCHAR(10)   REFERENCES products(product_id),
    product_name     VARCHAR(100),
    category         VARCHAR(50),
    region           VARCHAR(20),
    channel          VARCHAR(20),         -- Online / In-Store / Mobile App
    payment_method   VARCHAR(20),
    quantity         INT           NOT NULL CHECK (quantity > 0),
    unit_price       DECIMAL(10,2) NOT NULL,
    discount_pct     DECIMAL(5,2)  DEFAULT 0,
    net_unit_price   DECIMAL(10,2),
    revenue          DECIMAL(12,2) NOT NULL,
    cogs             DECIMAL(12,2),
    profit           DECIMAL(12,2),
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------------------------------
-- REFERENCE: Monthly Targets
-- -----------------------------------------------------------------------------
CREATE TABLE monthly_targets (
    id              SERIAL        PRIMARY KEY,
    year_month      CHAR(7)       NOT NULL,   -- YYYY-MM
    region          VARCHAR(20)   NOT NULL,
    revenue_target  DECIMAL(12,2),
    profit_target   DECIMAL(12,2),
    units_target    INT,
    UNIQUE (year_month, region)
);

-- Indexes for query performance
CREATE INDEX idx_sales_date        ON sales_transactions(date);
CREATE INDEX idx_sales_category    ON sales_transactions(category);
CREATE INDEX idx_sales_region      ON sales_transactions(region);
CREATE INDEX idx_sales_customer    ON sales_transactions(customer_id);
CREATE INDEX idx_sales_channel     ON sales_transactions(channel);
