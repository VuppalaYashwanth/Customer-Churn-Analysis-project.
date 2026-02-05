# Setup Instructions

Complete guide to set up and run the Customer Churn Analysis project.

---

## 📋 Prerequisites

### Required Software
- **Python 3.8+** - [Download](https://www.python.org/downloads/)
- **MySQL or PostgreSQL** - [MySQL Download](https://dev.mysql.com/downloads/) or [PostgreSQL Download](https://www.postgresql.org/download/)
- **Jupyter Notebook** - Installed via pip
- **Power BI Desktop** - [Download](https://powerbi.microsoft.com/desktop/)
- **Git** - [Download](https://git-scm.com/)

### Optional but Recommended
- **VS Code** - [Download](https://code.visualstudio.com/)
- **DBeaver** or **MySQL Workbench** - For database management
- **Anaconda** - [Download](https://www.anaconda.com/) (includes Jupyter)

---

## 🚀 Installation Steps

### 1. Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/Customer-Churn-Analysis.git

# Navigate to project directory
cd Customer-Churn-Analysis
```

### 2. Set Up Python Environment

#### Option A: Using venv (Recommended)
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r Python/requirements.txt
```

#### Option B: Using Anaconda
```bash
# Create conda environment
conda create -n churn_analysis python=3.8

# Activate environment
conda activate churn_analysis

# Install dependencies
pip install -r Python/requirements.txt
```

### 3. Download Dataset

1. Visit [Kaggle - Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
2. Download `WA_Fn-UseC_-Telco-Customer-Churn.csv`
3. Place the file in the `data/` directory

```bash
# Your data folder should look like:
data/
└── WA_Fn-UseC_-Telco-Customer-Churn.csv
```

### 4. Set Up Database (Optional for SQL Practice)

#### MySQL Setup
```sql
-- Connect to MySQL
mysql -u root -p

-- Create database
CREATE DATABASE churn_analysis;

-- Use database
USE churn_analysis;

-- Import data (method 1: using MySQL Workbench)
-- Table > Data Import Wizard > Select CSV file

-- Or (method 2: using command line)
LOAD DATA INFILE '/path/to/WA_Fn-UseC_-Telco-Customer-Churn.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

#### PostgreSQL Setup
```sql
-- Connect to PostgreSQL
psql -U postgres

-- Create database
CREATE DATABASE churn_analysis;

-- Connect to database
\c churn_analysis

-- Create table and import data
-- (Use pgAdmin or DBeaver for easier import)
```

---

## 🎯 Running the Project

### Step 1: SQL Analysis (Optional)

```bash
# Navigate to SQL directory
cd SQL

# Run queries in your database client
# Execute in order:
# 1. 01_data_extraction.sql
# 2. 02_churn_analysis.sql
# 3. 03_customer_segmentation.sql
```

### Step 2: Python Analysis

```bash
# Start Jupyter Notebook
jupyter notebook

# Navigate to Python folder and run notebooks in order:
# 1. 01_data_cleaning.ipynb
# 2. 02_exploratory_analysis.ipynb
# 3. 03_churn_prediction.ipynb
```

#### Or run from command line:
```bash
cd Python

# Convert notebooks to Python scripts
jupyter nbconvert --to script 01_data_cleaning.ipynb

# Run the script
python 01_data_cleaning.py
```

### Step 3: Power BI Dashboard

1. Open Power BI Desktop
2. Click **Get Data** → **Text/CSV**
3. Load `data/cleaned_churn_data.csv`
4. Follow instructions in `PowerBI/Dashboard_Creation_Guide.md`
5. Import DAX measures from `PowerBI/DAX_measures.txt`
6. Create visualizations as described

---

## 🔧 Configuration

### Database Configuration

Create a `.env` file in the root directory:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=churn_analysis
DB_USER=root
DB_PASSWORD=your_password
```

### Python Configuration

Update database connection in Python scripts if needed:

```python
import os
from dotenv import load_dotenv
import pymysql

load_dotenv()

# Database connection
connection = pymysql.connect(
    host=os.getenv('DB_HOST'),
    port=int(os.getenv('DB_PORT')),
    user=os.getenv('DB_USER'),
    password=os.getenv('DB_PASSWORD'),
    database=os.getenv('DB_NAME')
)
```

---

## 📊 Project Workflow

```
1. Data Collection
   └── Download dataset from Kaggle
   
2. SQL Analysis (Optional)
   ├── Import data to database
   ├── Run extraction queries
   ├── Analyze churn patterns
   └── Create customer segments
   
3. Python Analysis
   ├── Data cleaning
   ├── Exploratory analysis
   ├── Feature engineering
   └── Build ML models
   
4. Power BI Dashboard
   ├── Import cleaned data
   ├── Create DAX measures
   ├── Build visualizations
   └── Publish dashboard
   
5. Documentation
   └── Update README with findings
```

---

## 🧪 Testing

### Verify Installation

```bash
# Test Python packages
python -c "import pandas, numpy, sklearn, matplotlib, seaborn; print('All packages installed!')"

# Test Jupyter
jupyter notebook --version

# Test database connection
python -c "import pymysql; print('PyMySQL installed!')"
```

### Run Quick Test

```python
# test_setup.py
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split

print("✓ All imports successful!")

# Load data
try:
    df = pd.read_csv('data/WA_Fn-UseC_-Telco-Customer-Churn.csv')
    print(f"✓ Dataset loaded: {df.shape}")
except:
    print("✗ Dataset not found. Please download it.")
```

---

## 🐛 Troubleshooting

### Common Issues

#### Issue 1: "Module not found"
```bash
# Solution: Install missing package
pip install <package-name>
```

#### Issue 2: "Permission denied" on macOS/Linux
```bash
# Solution: Add execute permission
chmod +x script_name.py
```

#### Issue 3: "VCRUNTIME140.dll missing" on Windows
```bash
# Solution: Install Visual C++ Redistributable
# Download from Microsoft website
```

#### Issue 4: Jupyter notebook won't start
```bash
# Solution: Reinstall Jupyter
pip uninstall jupyter
pip install jupyter
```

#### Issue 5: Database connection error
```bash
# Solution: Check credentials and service status
# MySQL:
sudo service mysql status
# PostgreSQL:
sudo service postgresql status
```

### Getting Help

1. Check [Issues](https://github.com/yourusername/Customer-Churn-Analysis/issues)
2. Review documentation in `docs/` folder
3. Reach out via email or LinkedIn

---

## 📁 Directory Structure After Setup

```
Customer-Churn-Analysis/
│
├── data/
│   ├── WA_Fn-UseC_-Telco-Customer-Churn.csv    # Original data
│   ├── cleaned_churn_data.csv                   # Generated after cleaning
│   └── cleaned_churn_data.pkl                   # Generated after cleaning
│
├── Python/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_exploratory_analysis.ipynb
│   ├── 03_churn_prediction.ipynb
│   └── requirements.txt
│
├── SQL/
│   ├── 01_data_extraction.sql
│   ├── 02_churn_analysis.sql
│   └── 03_customer_segmentation.sql
│
├── PowerBI/
│   ├── churn_dashboard.pbix                     # Created by you
│   ├── DAX_measures.txt
│   └── Dashboard_Creation_Guide.md
│
├── images/                                       # Generated by notebooks
│   ├── overall_churn_distribution.png
│   ├── contract_type_analysis.png
│   └── ... (other visualizations)
│
├── models/                                       # Generated by ML notebook
│   ├── random_forest_churn_model.pkl
│   └── scaler.pkl
│
├── .gitignore
├── LICENSE
├── README.md
└── SETUP.md                                     # This file
```

---

## ✅ Verification Checklist

- [ ] Python 3.8+ installed
- [ ] All Python packages installed
- [ ] Dataset downloaded
- [ ] Jupyter Notebook running
- [ ] Database setup (optional)
- [ ] Power BI Desktop installed
- [ ] Git configured
- [ ] Test script runs successfully

---

## 🎓 Next Steps

1. ✓ Complete setup
2. Run `01_data_cleaning.ipynb`
3. Run `02_exploratory_analysis.ipynb`
4. Run `03_churn_prediction.ipynb`
5. Create Power BI dashboard
6. Document findings
7. Update README with results
8. Share on GitHub/LinkedIn

---

## 📞 Support

**Project Maintainer:** Your Name  
**Email:** your.email@example.com  
**LinkedIn:** [Your LinkedIn Profile](https://linkedin.com/in/yourprofile)

---

**Happy Analyzing! 📊**
