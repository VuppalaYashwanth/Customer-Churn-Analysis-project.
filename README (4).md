# Data Directory

## Dataset Information

This directory should contain the IBM Telco Customer Churn dataset used for analysis.

### Download Dataset

**Source:** IBM Telco Customer Churn Dataset  
**Download from:** https://www.kaggle.com/datasets/blastchar/telco-customer-churn

### Files Expected

```
data/
├── WA_Fn-UseC_-Telco-Customer-Churn.csv   # Original dataset
├── cleaned_churn_data.csv                  # Cleaned version (generated)
└── cleaned_churn_data.pkl                  # Pickle format (generated)
```

### Dataset Structure

- **Rows:** ~7,043 customers
- **Columns:** 21 features
- **Size:** ~1 MB

### Features

| Category | Features |
|----------|----------|
| **Demographics** | customerID, gender, SeniorCitizen, Partner, Dependents |
| **Account Info** | tenure, Contract, PaperlessBilling, PaymentMethod |
| **Services** | PhoneService, MultipleLines, InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies |
| **Billing** | MonthlyCharges, TotalCharges |
| **Target** | Churn (Yes/No) |

### Data Dictionary

| Column | Type | Description |
|--------|------|-------------|
| customerID | string | Unique customer identifier |
| gender | string | Customer gender (Male/Female) |
| SeniorCitizen | int | Whether customer is senior citizen (1/0) |
| Partner | string | Whether customer has a partner (Yes/No) |
| Dependents | string | Whether customer has dependents (Yes/No) |
| tenure | int | Number of months customer has stayed |
| PhoneService | string | Whether customer has phone service (Yes/No) |
| MultipleLines | string | Whether customer has multiple lines (Yes/No/No phone service) |
| InternetService | string | Type of internet service (DSL/Fiber optic/No) |
| OnlineSecurity | string | Whether customer has online security (Yes/No/No internet service) |
| OnlineBackup | string | Whether customer has online backup (Yes/No/No internet service) |
| DeviceProtection | string | Whether customer has device protection (Yes/No/No internet service) |
| TechSupport | string | Whether customer has tech support (Yes/No/No internet service) |
| StreamingTV | string | Whether customer has streaming TV (Yes/No/No internet service) |
| StreamingMovies | string | Whether customer has streaming movies (Yes/No/No internet service) |
| Contract | string | Contract type (Month-to-month/One year/Two year) |
| PaperlessBilling | string | Whether customer has paperless billing (Yes/No) |
| PaymentMethod | string | Payment method (Electronic check/Mailed check/Bank transfer/Credit card) |
| MonthlyCharges | float | Monthly charge amount |
| TotalCharges | object/float | Total amount charged (needs conversion to numeric) |
| Churn | string | Whether customer churned (Yes/No) - **TARGET VARIABLE** |

### Setup Instructions

1. **Download the dataset:**
   ```bash
   # Visit Kaggle and download the dataset
   https://www.kaggle.com/datasets/blastchar/telco-customer-churn
   ```

2. **Place the file in this directory:**
   ```bash
   # Save as: WA_Fn-UseC_-Telco-Customer-Churn.csv
   ```

3. **Run the data cleaning notebook:**
   ```bash
   jupyter notebook ../Python/01_data_cleaning.ipynb
   ```

4. **Cleaned files will be generated automatically**

### Data Quality Issues

The original dataset has the following known issues that are handled in the cleaning script:

1. **TotalCharges Column**
   - Type: Object (should be numeric)
   - Contains empty strings for new customers (tenure = 0)
   - **Solution:** Convert to numeric and fill missing values

2. **Missing Values**
   - TotalCharges has ~11 missing values
   - **Solution:** Fill with MonthlyCharges * tenure

3. **Data Types**
   - SeniorCitizen is numeric (should be categorical)
   - **Solution:** Convert to object/category

### Privacy & Ethics

- This is a publicly available anonymized dataset
- No real customer PII (Personally Identifiable Information) is included
- Safe to use for portfolio projects and learning purposes

### License

Please refer to the original Kaggle dataset page for licensing information.

---

**Note:** Do not commit large data files to GitHub. Add them to `.gitignore`.
