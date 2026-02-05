-- =========================================
-- Customer Segmentation Analysis
-- =========================================
-- Purpose: Segment customers for targeted retention strategies
-- Database: MySQL/PostgreSQL
-- Author: Your Name
-- Date: February 2026
-- =========================================

USE churn_analysis;

-- 1. CREATE CUSTOMER RISK SCORE
-- =========================================

-- Comprehensive risk scoring based on multiple factors
SELECT 
    customerID,
    gender,
    SeniorCitizen,
    tenure,
    Contract,
    MonthlyCharges,
    TotalCharges,
    Churn,
    
    -- Risk Score Calculation (0-100)
    (
        -- Contract risk (40 points max)
        CASE 
            WHEN Contract = 'Month-to-month' THEN 40
            WHEN Contract = 'One year' THEN 15
            ELSE 5
        END +
        
        -- Tenure risk (30 points max)
        CASE 
            WHEN tenure <= 6 THEN 30
            WHEN tenure <= 12 THEN 20
            WHEN tenure <= 24 THEN 10
            ELSE 5
        END +
        
        -- Payment method risk (15 points max)
        CASE 
            WHEN PaymentMethod = 'Electronic check' THEN 15
            ELSE 5
        END +
        
        -- Tech support risk (10 points max)
        CASE 
            WHEN TechSupport = 'No' AND InternetService != 'No' THEN 10
            ELSE 0
        END +
        
        -- Service adoption risk (5 points max)
        CASE 
            WHEN (
                CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END
            ) = 0 AND InternetService != 'No' THEN 5
            ELSE 0
        END
    ) AS risk_score,
    
    -- Risk Category
    CASE 
        WHEN (
            CASE WHEN Contract = 'Month-to-month' THEN 40 WHEN Contract = 'One year' THEN 15 ELSE 5 END +
            CASE WHEN tenure <= 6 THEN 30 WHEN tenure <= 12 THEN 20 WHEN tenure <= 24 THEN 10 ELSE 5 END +
            CASE WHEN PaymentMethod = 'Electronic check' THEN 15 ELSE 5 END +
            CASE WHEN TechSupport = 'No' AND InternetService != 'No' THEN 10 ELSE 0 END +
            CASE WHEN (
                CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END
            ) = 0 AND InternetService != 'No' THEN 5 ELSE 0 END
        ) >= 70 THEN 'Critical Risk'
        WHEN (
            CASE WHEN Contract = 'Month-to-month' THEN 40 WHEN Contract = 'One year' THEN 15 ELSE 5 END +
            CASE WHEN tenure <= 6 THEN 30 WHEN tenure <= 12 THEN 20 WHEN tenure <= 24 THEN 10 ELSE 5 END +
            CASE WHEN PaymentMethod = 'Electronic check' THEN 15 ELSE 5 END +
            CASE WHEN TechSupport = 'No' AND InternetService != 'No' THEN 10 ELSE 0 END +
            CASE WHEN (
                CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END
            ) = 0 AND InternetService != 'No' THEN 5 ELSE 0 END
        ) >= 50 THEN 'High Risk'
        WHEN (
            CASE WHEN Contract = 'Month-to-month' THEN 40 WHEN Contract = 'One year' THEN 15 ELSE 5 END +
            CASE WHEN tenure <= 6 THEN 30 WHEN tenure <= 12 THEN 20 WHEN tenure <= 24 THEN 10 ELSE 5 END +
            CASE WHEN PaymentMethod = 'Electronic check' THEN 15 ELSE 5 END +
            CASE WHEN TechSupport = 'No' AND InternetService != 'No' THEN 10 ELSE 0 END +
            CASE WHEN (
                CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END +
                CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END
            ) = 0 AND InternetService != 'No' THEN 5 ELSE 0 END
        ) >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
    
FROM customers
ORDER BY risk_score DESC;

-- 2. CUSTOMER SEGMENTS
-- =========================================

-- Segment 1: New High-Value At-Risk
SELECT 
    'New High-Value At-Risk' AS segment,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(SUM(MonthlyCharges) * 12, 2) AS annual_revenue_at_risk
FROM customers
WHERE tenure <= 12 
    AND MonthlyCharges > 70
    AND Contract = 'Month-to-month'

UNION ALL

-- Segment 2: Long-Term Loyalists
SELECT 
    'Long-Term Loyalists' AS segment,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(SUM(MonthlyCharges) * 12, 2) AS annual_revenue_at_risk
FROM customers
WHERE tenure > 48 
    AND Contract IN ('One year', 'Two year')

UNION ALL

-- Segment 3: Budget Conscious
SELECT 
    'Budget Conscious' AS segment,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(SUM(MonthlyCharges) * 12, 2) AS annual_revenue_at_risk
FROM customers
WHERE MonthlyCharges < 30

UNION ALL

-- Segment 4: Service Maximizers
SELECT 
    'Service Maximizers' AS segment,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(SUM(MonthlyCharges) * 12, 2) AS annual_revenue_at_risk
FROM customers
WHERE (
    CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END
) >= 3;

-- 3. HIGH-PRIORITY RETENTION TARGETS
-- =========================================

-- Top 100 customers for immediate retention efforts
SELECT 
    customerID,
    tenure,
    Contract,
    MonthlyCharges,
    TotalCharges,
    InternetService,
    TechSupport,
    PaymentMethod,
    
    -- Retention Priority Score
    (MonthlyCharges * 12) * 
    CASE 
        WHEN Contract = 'Month-to-month' AND tenure <= 6 THEN 5.0
        WHEN Contract = 'Month-to-month' AND tenure <= 12 THEN 3.0
        WHEN Contract = 'Month-to-month' THEN 2.0
        ELSE 1.0
    END AS retention_priority_value,
    
    -- Recommended Action
    CASE 
        WHEN Contract = 'Month-to-month' AND tenure <= 6 THEN 'Onboarding Support + Contract Incentive'
        WHEN Contract = 'Month-to-month' AND MonthlyCharges > 70 THEN 'Premium Contract Offer'
        WHEN TechSupport = 'No' AND InternetService != 'No' THEN 'Free Tech Support Trial'
        WHEN PaymentMethod = 'Electronic check' THEN 'Auto-Pay Incentive'
        ELSE 'General Retention Offer'
    END AS recommended_action
    
FROM customers
WHERE Churn = 'No'  -- Only active customers
ORDER BY retention_priority_value DESC
LIMIT 100;

-- 4. CUSTOMER LIFETIME VALUE SEGMENTS
-- =========================================

SELECT 
    CASE 
        WHEN TotalCharges < 500 THEN 'Low LTV'
        WHEN TotalCharges < 2000 THEN 'Medium LTV'
        WHEN TotalCharges < 5000 THEN 'High LTV'
        ELSE 'Very High LTV'
    END AS ltv_segment,
    COUNT(*) AS customer_count,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(tenure), 1) AS avg_tenure_months,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM customers
GROUP BY ltv_segment
ORDER BY 
    CASE 
        WHEN TotalCharges < 500 THEN 1
        WHEN TotalCharges < 2000 THEN 2
        WHEN TotalCharges < 5000 THEN 3
        ELSE 4
    END;

-- 5. ACTIONABLE CUSTOMER LIST FOR MARKETING
-- =========================================

-- Export list for targeted campaigns
SELECT 
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    Contract,
    MonthlyCharges,
    
    -- Campaign Type
    CASE 
        WHEN Contract = 'Month-to-month' AND tenure <= 6 THEN 'Welcome Campaign'
        WHEN Contract = 'Month-to-month' AND tenure > 6 THEN 'Contract Upgrade Campaign'
        WHEN PaymentMethod = 'Electronic check' THEN 'Auto-Pay Campaign'
        WHEN TechSupport = 'No' AND InternetService != 'No' THEN 'Support Services Campaign'
        ELSE 'General Retention Campaign'
    END AS campaign_type,
    
    -- Expected Impact
    CASE 
        WHEN Contract = 'Month-to-month' AND tenure <= 6 THEN 'High'
        WHEN Contract = 'Month-to-month' THEN 'High'
        WHEN TechSupport = 'No' THEN 'Medium'
        ELSE 'Low'
    END AS expected_impact
    
FROM customers
WHERE Churn = 'No'
    AND (
        (Contract = 'Month-to-month') OR
        (PaymentMethod = 'Electronic check') OR
        (TechSupport = 'No' AND InternetService != 'No')
    )
ORDER BY 
    CASE 
        WHEN Contract = 'Month-to-month' AND tenure <= 6 THEN 1
        WHEN Contract = 'Month-to-month' THEN 2
        WHEN TechSupport = 'No' THEN 3
        ELSE 4
    END,
    MonthlyCharges DESC;

-- =========================================
-- END OF CUSTOMER SEGMENTATION SCRIPT
-- =========================================
