# Power BI Dashboard Guide

## Overview
This guide explains how to create the Customer Churn Analysis dashboard in Power BI.

## Prerequisites
- Power BI Desktop (latest version)
- Cleaned dataset: `cleaned_churn_data.csv`
- DAX measures file: `DAX_measures.txt`

---

## Step-by-Step Instructions

### 1. Import Data

1. Open Power BI Desktop
2. Click **Get Data** → **Text/CSV**
3. Navigate to `data/cleaned_churn_data.csv`
4. Click **Load**

### 2. Data Modeling

#### Create Relationships (if using multiple tables)
- Not required for single table analysis
- If you split into fact/dimension tables, create relationships

#### Create Calculated Columns

```dax
// Tenure Group
TenureGroup = 
SWITCH(
    TRUE(),
    Customers[tenure] <= 6, "0-6 months",
    Customers[tenure] <= 12, "6-12 months",
    Customers[tenure] <= 24, "12-24 months",
    Customers[tenure] <= 48, "24-48 months",
    "48+ months"
)

// Charge Group
ChargeGroup = 
SWITCH(
    TRUE(),
    Customers[MonthlyCharges] < 30, "Low (<$30)",
    Customers[MonthlyCharges] < 60, "Medium ($30-$60)",
    Customers[MonthlyCharges] < 90, "High ($60-$90)",
    "Very High ($90+)"
)

// Service Count
ServiceCount = 
    (IF(Customers[OnlineSecurity] = "Yes", 1, 0)) +
    (IF(Customers[OnlineBackup] = "Yes", 1, 0)) +
    (IF(Customers[DeviceProtection] = "Yes", 1, 0)) +
    (IF(Customers[TechSupport] = "Yes", 1, 0)) +
    (IF(Customers[StreamingTV] = "Yes", 1, 0)) +
    (IF(Customers[StreamingMovies] = "Yes", 1, 0))
```

#### Add DAX Measures
Copy all measures from `DAX_measures.txt` into Power BI

---

## Dashboard Pages

### Page 1: Executive Overview

**Purpose:** High-level KPIs and overall churn metrics

**Visuals:**

1. **KPI Cards (Top Row)**
   - Total Customers
   - Churn Rate %
   - Annual Revenue at Risk
   - Avg Monthly Charge

2. **Donut Chart: Churn Distribution**
   - Field: Churn
   - Values: Count of customerID

3. **Line Chart: Churn Trend Over Tenure**
   - X-axis: tenure
   - Y-axis: Churn Rate
   - Legend: Contract

4. **Bar Chart: Revenue by Churn Status**
   - X-axis: Churn
   - Y-axis: Total Monthly Revenue

5. **Card: Action Required**
   - Measure: Action Required

**Filters/Slicers:**
- Contract Type
- Internet Service
- Senior Citizen

**Color Scheme:**
- Churned: Red (#e74c3c)
- Retained: Green (#2ecc71)
- Neutral: Blue (#3498db)

---

### Page 2: Churn Drivers Analysis

**Purpose:** Identify key factors driving churn

**Visuals:**

1. **Clustered Bar Chart: Churn Rate by Contract**
   - X-axis: Contract
   - Y-axis: Churn Rate
   - Data Labels: ON

2. **Stacked Column Chart: Churn by Tenure Group**
   - X-axis: TenureGroup
   - Y-axis: Count
   - Legend: Churn

3. **Matrix: Churn by Services**
   - Rows: OnlineSecurity, OnlineBackup, TechSupport
   - Values: Churn Rate

4. **Tree Map: Churn by Payment Method**
   - Group: PaymentMethod
   - Values: Count of Churned Customers

5. **Scatter Plot: Monthly Charges vs Tenure**
   - X-axis: tenure
   - Y-axis: MonthlyCharges
   - Legend: Churn
   - Size: TotalCharges

6. **100% Stacked Bar: Internet Service**
   - Axis: InternetService
   - Legend: Churn

**Slicers:**
- Gender
- Partner Status
- Dependents

---

### Page 3: High-Risk Customers

**Purpose:** Identify and prioritize retention efforts

**Visuals:**

1. **Table: High-Risk Customer List**
   - Columns:
     - customerID
     - tenure
     - Contract
     - MonthlyCharges
     - TotalCharges
     - Internet Service
     - Tech Support
   - Filter: Churn = "No" AND tenure < 12 AND Contract = "Month-to-month"
   - Sort by: MonthlyCharges (Descending)

2. **KPI Cards:**
   - High Value Customers
   - High Value Churn Rate
   - MTM Revenue at Risk

3. **Gauge: New Customer Churn Rate**
   - Value: New Customer Churn Rate
   - Target: 0.30 (30%)

4. **Waterfall Chart: Revenue Segmentation**
   - Categories: Retained Revenue, Churned Revenue
   - Values: Monthly Charges

5. **Ribbon Chart: Top Churn Segments**
   - Axis: TenureGroup
   - Legend: Contract
   - Values: Churn Rate

**Filters:**
- Tenure Group
- Charge Group
- Service Count

**Drill-through:**
- Enable drill-through to customer detail page
- Fields: customerID

---

## Dashboard Design Best Practices

### Layout
- Use consistent spacing (10-15px margins)
- Align visuals using grid layout
- Group related visuals together

### Colors
- **Primary Palette:**
  - Churned: #e74c3c (Red)
  - Retained: #2ecc71 (Green)
  - High Risk: #f39c12 (Orange)
  - Neutral: #3498db (Blue)

- **Background:**
  - White (#FFFFFF) or light gray (#F7F9FA)

### Typography
- **Title:** Segoe UI, 16pt, Bold
- **Headers:** Segoe UI, 12pt, Semibold
- **Body:** Segoe UI, 10pt, Regular

### Tooltips
Create custom tooltips showing:
- Customer count
- Churn rate
- Revenue impact

### Bookmarks
Create bookmarks for:
- Default view
- High risk view
- Contract analysis view

---

## Interactive Features

### 1. Slicers
- Make slicers sync across pages
- Use dropdown style for space efficiency

### 2. Cross-filtering
- Enable cross-filtering between visuals
- Use Ctrl+Click for multi-select

### 3. Drill-through
- Create detail page for individual customer analysis
- Add "Back" button

### 4. Buttons
- Add navigation buttons between pages
- Create "Reset Filters" button

### 5. Dynamic Titles
Use measures in titles:
```dax
DynamicTitle = 
"Churn Analysis - " & [Churn Rate %] & " Churn Rate"
```

---

## Performance Optimization

1. **Reduce Visual Count**
   - Max 8-10 visuals per page
   - Use tabs or bookmarks for additional views

2. **Optimize DAX**
   - Use variables
   - Avoid complex calculated columns
   - Use measures instead

3. **Limit Data**
   - Import only necessary columns
   - Filter at source if possible

4. **Aggregation**
   - Pre-aggregate where possible
   - Use summarized tables for large datasets

---

## Publishing

### 1. Save Work
```
File → Save As → churn_dashboard.pbix
```

### 2. Publish to Power BI Service
```
Home → Publish → Select Workspace
```

### 3. Schedule Refresh (if using live data)
- Configure data source credentials
- Set refresh schedule

### 4. Share
- Share link with stakeholders
- Create app for end users
- Set permissions

---

## Maintenance Checklist

- [ ] Update data source connection
- [ ] Refresh dataset
- [ ] Verify DAX measures
- [ ] Test all filters and slicers
- [ ] Check visual performance
- [ ] Update documentation
- [ ] Review with stakeholders

---

## Troubleshooting

### Issue: "Cannot create relationship"
**Solution:** Check data types and unique values

### Issue: "Circular dependency in measures"
**Solution:** Review measure dependencies, use variables

### Issue: "Visual takes too long to load"
**Solution:** Reduce data, optimize DAX, increase aggregation

### Issue: "Data refresh fails"
**Solution:** Check credentials, gateway connection, data source

---

## Additional Resources

- [Power BI Documentation](https://docs.microsoft.com/power-bi/)
- [DAX Guide](https://dax.guide/)
- [Power BI Community](https://community.powerbi.com/)

---

**Dashboard Completion Time:** 2-3 hours  
**Difficulty Level:** Intermediate  
**Last Updated:** February 2026
