-- =========================================
-- Customer Churn Analysis - Data Extraction
-- =========================================
-- Purpose: Extract and prepare customer data for analysis
-- Database: MySQL/PostgreSQL
-- Author: Your Name
-- Date: February 2026
-- =========================================

-- 1. DATABASE SETUP
-- =========================================

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS churn_analysis;
USE churn_analysis;

-- 2. VIEW ALL DATA
-- =========================================

-- Quick overview of the dataset
SELECT * 
FROM customers 
LIMIT 10;

-- 3. BASIC STATISTICS
-- =========================================

-- Total number of customers
SELECT 
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customerID) AS unique_customers
FROM customers;

-- Dataset date range
SELECT 
    MIN(tenure) AS min_tenure,
    MAX(tenure) AS max_tenure,
    AVG(tenure) AS avg_tenure
FROM customers;

-- 4. DATA QUALITY CHECKS
-- =========================================

-- Check for missing values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS missing_customerID,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS missing_tenure,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS missing_monthly_charges,
    SUM(CASE WHEN TotalCharges IS NULL OR TotalCharges = '' THEN 1 ELSE 0 END) AS missing_total_charges,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS missing_churn
FROM customers;

-- Check for duplicates
SELECT 
    customerID, 
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customerID
HAVING COUNT(*) > 1;

-- 5. EXPORT CLEAN DATA
-- =========================================

-- Export cleaned dataset for Python analysis
SELECT 
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    CAST(MonthlyCharges AS DECIMAL(10,2)) AS MonthlyCharges,
    CAST(CASE 
        WHEN TotalCharges = '' OR TotalCharges IS NULL THEN 0 
        ELSE TotalCharges 
    END AS DECIMAL(10,2)) AS TotalCharges,
    Churn
FROM customers
WHERE customerID IS NOT NULL;

-- 6. SUMMARY STATISTICS
-- =========================================

-- Churn distribution
SELECT 
    Churn,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) AS percentage
FROM customers
GROUP BY Churn;

-- Gender distribution
SELECT 
    gender,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) AS percentage
FROM customers
GROUP BY gender;

-- Contract type distribution
SELECT 
    Contract,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) AS percentage
FROM customers
GROUP BY Contract
ORDER BY customer_count DESC;

-- Revenue statistics
SELECT 
    ROUND(MIN(MonthlyCharges), 2) AS min_monthly_charges,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(MAX(MonthlyCharges), 2) AS max_monthly_charges,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue,
    ROUND(SUM(TotalCharges), 2) AS total_lifetime_revenue
FROM customers;

-- =========================================
-- END OF DATA EXTRACTION SCRIPT
-- =========================================
