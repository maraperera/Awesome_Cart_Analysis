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
