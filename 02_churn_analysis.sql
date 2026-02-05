-- =========================================
-- Customer Churn Analysis - Deep Dive
-- =========================================
-- Purpose: Analyze churn patterns and identify key drivers
-- Database: MySQL/PostgreSQL
-- Author: Your Name
-- Date: February 2026
-- =========================================

USE churn_analysis;

-- 1. OVERALL CHURN METRICS
-- =========================================

-- Overall churn rate and customer counts
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS retained_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers;

-- 2. CHURN BY CONTRACT TYPE
-- =========================================

SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM customers
GROUP BY Contract
ORDER BY churn_rate DESC;

-- 3. CHURN BY TENURE GROUPS
-- =========================================

SELECT 
    CASE 
        WHEN tenure <= 6 THEN '0-6 months'
        WHEN tenure <= 12 THEN '6-12 months'
        WHEN tenure <= 24 THEN '12-24 months'
        WHEN tenure <= 48 THEN '24-48 months'
        ELSE '48+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY tenure_group
ORDER BY 
    CASE 
        WHEN tenure <= 6 THEN 1
        WHEN tenure <= 12 THEN 2
        WHEN tenure <= 24 THEN 3
        WHEN tenure <= 48 THEN 4
        ELSE 5
    END;

-- 4. CHURN BY INTERNET SERVICE TYPE
-- =========================================

SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM customers
GROUP BY InternetService
ORDER BY churn_rate DESC;

-- 5. CHURN BY PAYMENT METHOD
-- =========================================

SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- 6. CHURN BY TECH SUPPORT
-- =========================================

SELECT 
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
WHERE InternetService != 'No'
GROUP BY TechSupport
ORDER BY churn_rate DESC;

-- 7. CHURN BY SENIOR CITIZEN STATUS
-- =========================================

SELECT 
    CASE 
        WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
        ELSE 'Non-Senior'
    END AS senior_status,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY senior_status;

-- 8. REVENUE ANALYSIS
-- =========================================

-- Revenue at risk from churned customers
SELECT 
    SUM(MonthlyCharges) AS monthly_revenue_lost,
    SUM(MonthlyCharges) * 12 AS annual_revenue_at_risk,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge_churned
FROM customers
WHERE Churn = 'Yes';

-- Revenue comparison: Churned vs Retained
SELECT 
    Churn,
    COUNT(*) AS customer_count,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(SUM(TotalCharges), 2) AS total_lifetime_revenue,
    ROUND(AVG(TotalCharges), 2) AS avg_lifetime_value
FROM customers
GROUP BY Churn;

-- 9. COMBINED RISK FACTORS
-- =========================================

-- High-risk customer profile
SELECT 
    Contract,
    CASE 
        WHEN tenure <= 6 THEN '0-6 months'
        WHEN tenure <= 12 THEN '6-12 months'
        ELSE '12+ months'
    END AS tenure_group,
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY Contract, tenure_group, PaymentMethod
HAVING COUNT(*) >= 10
ORDER BY churn_rate DESC
LIMIT 20;

-- 10. SERVICE ADOPTION VS CHURN
-- =========================================

-- Customers with no add-on services
SELECT 
    'No Add-on Services' AS customer_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
WHERE OnlineSecurity = 'No' 
    AND OnlineBackup = 'No' 
    AND DeviceProtection = 'No' 
    AND TechSupport = 'No'
    AND InternetService != 'No'

UNION ALL

-- Customers with 1-2 services
SELECT 
    '1-2 Add-on Services' AS customer_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
WHERE InternetService != 'No'
    AND (
        (CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END)
    ) BETWEEN 1 AND 2

UNION ALL

-- Customers with 3+ services
SELECT 
    '3+ Add-on Services' AS customer_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
WHERE InternetService != 'No'
    AND (
        (CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END)
    ) >= 3;

-- 11. MONTHLY CHARGE ANALYSIS
-- =========================================

-- Churn by monthly charge brackets
SELECT 
    CASE 
        WHEN MonthlyCharges < 30 THEN 'Under $30'
        WHEN MonthlyCharges < 60 THEN '$30-$60'
        WHEN MonthlyCharges < 90 THEN '$60-$90'
        ELSE '$90+'
    END AS charge_bracket,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY charge_bracket
ORDER BY 
    CASE 
        WHEN MonthlyCharges < 30 THEN 1
        WHEN MonthlyCharges < 60 THEN 2
        WHEN MonthlyCharges < 90 THEN 3
        ELSE 4
    END;

-- 12. PAPERLESS BILLING IMPACT
-- =========================================

SELECT 
    PaperlessBilling,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customers
GROUP BY PaperlessBilling;

-- =========================================
-- END OF CHURN ANALYSIS SCRIPT
-- =========================================
