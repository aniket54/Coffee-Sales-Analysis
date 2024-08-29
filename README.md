# Coffee-Sales-Analysis 


### Project Overview
This Data analysis project aims to provide insights into the sales performance of coffe shop. By analyzing various aspects of the sales data, wee seek to identify trends, make data driven recommendation, and gain deeper understanding of the company's performance.

### Data Sources
Sales Data : The primary data set is used for this analysis is the "Coffee_Shop_Sales.csv" file, containing detailed information about each sale made by the company.

### Tools

- MySQL - Data Analysis 
- Power BI - Creating Report

### Data Cleaning  / Preparation

In the intial data preparation phase, we performed the following task
- Data loading and inspection
- Data cleaning and formatting

### Exploratory Data Analysis 

EDA involved exploring the sales data to answer the key questions, such as : 

- What is the sales trend for respective month  ?
- What is the month-on-month increase or decrease in sales ?
- What is the total number of order for respective month  ?
- What is the month-on-month increase or decrease in orders ?
- What is the total number of quantity for respective month  ?
- What is the month-on-month increase or decrease in quantity ?

### Data Analysis
Include some intersting code/feature worked with 

```SQL
SELECT ROUND(SUM(transaction_qty * unit_price)) AS Total_Sales_March
FROM coffee_shop_sales
WHERE MONTHNAME(transaction_date) = "March";
'''
### Result / Findings

The analysis results are summarised as follows  :
1. The product category " Coffee" is the best performing category in terms of sales and revenue
2. The product type " Barista Espresso" is the best performing product type in terms of sales and revenue


### Recommendations

Based on the analysis, we recommend the following actions :
- Focus on expanding and promting products in " Coffee Beans", "Branded" and "Loosed Tea'.
