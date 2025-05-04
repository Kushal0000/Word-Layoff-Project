# 🚀 SQL Data Cleaning & Exploratory Data Analysis: Layoffs Dataset 📊

This project showcases a complete end-to-end data analytics workflow using **MySQL** to clean, transform, and analyze a real-world Layoffs dataset. The goal was to enhance data quality, perform exploratory data analysis (EDA), and derive business-ready insights that reflect industry trends and organizational behavior during economic downturns.

---

## 📁 Project Overview

- ✅ **Objective**: Clean and analyze a layoffs dataset to identify key trends across companies, industries, and geographies.
- ✅ **Tools Used**: MySQL, SQL Window Functions, CTEs, Joins, Data Aggregation
- ✅ **Skills Demonstrated**: Data Cleaning, Data Transformation, Deduplication, EDA, Business Insight Generation

---

## 🔧 Data Cleaning & Transformation Steps

- Standardized categorical values** (e.g., unified “Crypto” and “Crypto Currency” under one category)
- Removed duplicates** using `ROW_NUMBER()` and CTE logic
- Handled null values** by: Filling missing industries using company data with `JOIN`
- Converting date strings using `STR_TO_DATE()`
- Trimmed extra spaces** with `TRIM()` to clean text fields
- Adjusted data types for time-based analysis
- Created clean, analysis-ready tables for downstream insights

---

## 📈 Exploratory Data Analysis (EDA)

Performed EDA using aggregate functions, filters, and window functions to uncover trends and generate KPIs.

### Key Analyses:
- 📊 Total layoffs by **company, country, industry, and year**
- 🏆 Top 5 companies with highest layoffs per year using `DENSE_RANK()`
- 🔄 **Rolling monthly total** of layoffs to capture progression over time
- 🧩 Identified companies with **100% workforce layoffs**
- 💰 Compared layoffs to **funding raised** (where available)

---

## 💡 Key Insights

- 🔥 **Tech & Crypto** sectors were among the hardest hit
- 🌍 **United States, India, and the UK** had the highest layoff volumes
- 📉 Layoffs dropped temporarily in **2021**, possibly due to post-pandemic recovery efforts
- 📈 **Late 2022 – Early 2023** marked the peak period for workforce reductions
- 🏢 Certain companies appeared in the **top 5 layoff list** consistently across multiple years
- 📌 High-risk indicators: 100% laid-off ratio, large funding + layoffs, repeated top-rank in layoffs

---

## 🧰 SQL Techniques Used

- **Common Table Expressions (CTEs)**
- **Window Functions**: `ROW_NUMBER()`, `DENSE_RANK()`
- **Aggregations**: `SUM()`, `COUNT()`, `AVG()`
- **Data Formatting**: `TRIM()`, `STR_TO_DATE()`, type casting
- **Joins** for imputing missing data
- **Conditional Logic**: `CASE WHEN`, NULL checks

---

## ✅ Outcomes

This project demonstrates:
- Proficiency in SQL for real-world **data cleaning and preparation**
- Ability to extract **meaningful KPIs** from large, messy datasets
- Strong **data storytelling** and pattern recognition
- Skills relevant for roles in **Data Analysis**, **Business Intelligence**, or **Risk Analytics**

---

## 📬 Contact

📧 Email: kushalpatel22900@gmail.com 
🔗 LinkedIn:www.linkedin.com/in/kushal-patel-47a281135

Let’s connect and collaborate on data-driven projects!

---


