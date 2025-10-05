# Awesome Cart E-commerce Analytics - SQL Project

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=sql&logoColor=white)
![Data Analytics](https://img.shields.io/badge/Data_Analytics-008080?style=for-the-badge&logo=data&logoColor=white)

A comprehensive SQL analysis of a fictional e-commerce platform "Awesome Cart" demonstrating intermediate to advanced SQL techniques for business intelligence and data analytics.

## 📊 Project Overview

This project simulates the work of a Data Analyst at an e-commerce company, transforming raw operational data into actionable business insights. The analysis covers customer behavior, product performance, sales trends, and operational efficiency using PostgreSQL.

## 🎯 Business Objectives

- **Customer Analytics**: Understand purchasing patterns, customer lifetime value, and retention
- **Product Performance**: Identify best-selling products, profitability, and category trends
- **Sales Optimization**: Analyze seasonal trends, growth metrics, and regional performance
- **Operational Efficiency**: Evaluate supplier performance and inventory insights

## 🔍 Business Questions Answered

### Customer Analysis
1. **Who are our most valuable customers?** - Customer Lifetime Value analysis
2. **Can we segment customers into groups based on purchase behavior?** - Customer segmentation by frequency and value
3. **How well are we retaining customers over time?** - Cohort analysis for retention rates
4. **How long does it take for customers to make their second purchase?** - Time-to-second-purchase analysis
5. **Which new customers show potential to become high-value?** - Customer value prediction based on initial behavior

### Sales & Performance Analysis
6. **Is our business growing month-over-month?** - Monthly sales trends with growth percentages
7. **What are our best and worst performing products?** - Product performance and profitability analysis
8. **Which customers haven't purchased in the last 90 days?** - Re-engagement campaign identification

### Product & Operational Insights
9. **What products are frequently purchased together?** - Market basket analysis for cross-selling
10. **Which suppliers are performing best?** - Supplier performance ranking by profitability
11. **What are the best-selling products in each geographic region?** - Regional sales performance analysis

## 📈 Analysis Results

### 1. Customer Lifetime Value Analysis
**Business Question:** Who are our most valuable customers?

![Customer LTV Analysis](result/01.jpg)

**Key Insights:**
- **Keith Henry** is the top customer with $1,298 lifetime value from just 2 orders
- **Justin Price** follows closely with $1,246 from 3 orders
- **Mark Thompson** has the most orders (14) but ranks 6th in total value
- Top 5 customers represent significant revenue concentration

### 2. Monthly Sales Trends & Growth
**Business Question:** Is our business growing month-over-month?

![Monthly Sales Trends](result/02.jpg)

**Key Insights:**
- **Massive 258.81% growth** in April 2025 followed by significant decline
- **Volatile performance** with alternating high-growth and negative-growth months
- **Strong recovery** in July with 124.40% growth after June's 73.90% increase
- **September shows promise** with 84.21% growth from August's -49.70% decline

### 3. Product Performance & Profitability
**Business Question:** What are our best and worst performing products?

![Product Performance](result/03.jpg)

**Key Insights:**
- **Face Mask Set** has incredible 98.35% profit margin generating $981.50 profit
- **Exercise equipment** (Treadmill, Elliptical, Rowing Machine) are high-revenue, high-margin products
- **Books and Grocery items** show surprisingly high margins (Dracula: 92.77%, Dark Chocolate: 98.38%)
- **Electronics** like USB-C Hub have excellent margins (84.83%)

### 4. Customer Re-engagement Identification
**Business Question:** Which customers haven't purchased in the last 90 days?

![Re-engagement Candidates](result/04.jpg)

**Key Insights:**
- **39 customers identified** for re-engagement campaigns
- Multiple customers with **NULL last order dates** indicating no purchases at all
- **Christopher Lewis** last purchased in July 2025 - prime candidate for win-back
- **Daniel Baker** is a high-value customer ($598 LTV) who needs re-engagement

### 5. Customer Segmentation Analysis
**Business Question:** Can we segment customers into groups based on purchase behavior?

![Customer Segmentation](result/05.jpg)

**Key Insights:**
- **10 High Value Regular Customers** spending average $892.20 each
- **30 Medium Value New Customers** with $207.74 average spend
- **14 inactive High Value customers** - significant revenue opportunity
- Clear segmentation enables targeted marketing strategies

### 6. Market Basket Analysis
**Business Question:** What products are frequently purchased together?

![Product Affinity](result/06.jpg)

**Key Insights:**
- **Ergonomic Office Chair + LEGO Starship Model** purchased together 3 times (1.80% penetration)
- **Multiple product pairings** with 2 co-purchases each
- **Cross-selling opportunities** identified for office furniture and electronics
- Low overall penetration rates suggest room for improvement in bundling

### 7. Customer Cohort Retention Analysis
**Business Question:** How well are we retaining customers over time?

![Cohort Analysis](result/07.jpg)

**Key Insights:**
- **January cohort** shows 23.81% retention after 3 months, dropping to 4.76% by month 4
- **February cohort** maintains better medium-term retention (42.86% in month 7)
- **March cohort** shows strongest performance with 52.94% retention in month 4
- **Significant drop-off** after initial purchase across all cohorts

### 8. Supplier Performance Ranking
**Business Question:** Which suppliers are performing best?

![Supplier Performance](result/08.jpg)

**Key Insights:**
- **Washington Inc** (Japan) leads with 98.35% profit margin on Face Mask Sets
- **Cox and Sons** (Oman) and **Hughes Ltd** (Austria) dominate exercise equipment
- **Flores and Sons** (Comoros) achieves 98.38% margin on Dark Chocolate
- **Johnson PLC** has broad product portfolio with consistent performance

### 9. Time-to-Second-Purchase Analysis
**Business Question:** How long does it take for customers to make their second purchase?

![Second Purchase Timing](result/09.jpg)

**Key Insights:**
- **Only 6 customers** make second purchase within 7 days
- **Majority (28 customers)** take 31-90 days for second purchase
- **22 customers** in the 8-30 day range show moderate engagement
- Significant opportunity to improve early re-engagement

### 10. Category Performance Trends
**Business Question:** How do sales trends look for each product category over time?

![Category Trends](result/10.jpg)

**Key Insights:**
- **Clothing category** shows massive fluctuations with 1,399.90% growth in March
- **Electronics** demonstrates strong recovery with 70.50% growth in August
- **Books category** maintains steady performance with some volatility
- **Grocery** starts strong but data appears incomplete for full trend analysis

### 11. Regional Sales Performance
**Business Question:** What are the best-selling products in each geographic region?

![Regional Performance](result/11.jpg)

**Key Insights:**
- **Alaska (AK)** shows diverse preferences across categories
- **California (CA)** favors health and fitness products
- **Illinois (IL)** leads in grocery purchases (Extra Virgin Olive Oil)
- **District of Columbia (DC)** shows premium preferences with Adjustable Dumbbell Set
- Clear geographic patterns enable region-specific inventory planning

## 🗄️ Database Schema

The database follows a normalized relational design with 5 core tables:

```mermaid
erDiagram
    customers ||--o{ orders : places
    customers {
        serial customer_id PK
        varchar first_name
        varchar last_name
        varchar email
        varchar city
        varchar state
        date date_registered
    }
    
    orders ||--o{ order_items : contains
    orders {
        serial order_id PK
        integer customer_id FK
        timestamp order_date
        varchar status
    }
    
    order_items }o--|| products : refers_to
    order_items {
        serial order_item_id PK
        integer order_id FK
        integer product_id FK
        integer quantity
        decimal price_at_time_of_order
    }
    
    products }o--|| suppliers : supplied_by
    products {
        serial product_id PK
        varchar product_name
        varchar category
        decimal price
        decimal cost
        integer supplier_id FK
    }
    
    suppliers {
        serial supplier_id PK
        varchar supplier_name
        varchar country
    }
