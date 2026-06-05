# Techno Campus Store (TCS) - Database Architecture

![Database Status](https://img.shields.io/badge/Database-MySQL-blue.svg)
![Normalization](https://img.shields.io/badge/Normalization-BCNF-success.svg)
![Timeline](https://img.shields.io/badge/Duration-30_Days-orange.svg)

## Project Overview
The Techno Campus Store (TCS) is a highly secure platform designed to manage the daily operations of a university store at the Institute of Technology of Cambodia (ITC). This repository contains the complete backend database architecture, structured mathematically to eliminate data anomalies and ensure strict financial integrity. 

This database sprint was completed over a **30-day duration**, officially wrapping up on **May 2, 2026**.

## System Architecture & Highlights

### 1. Strict BCNF Normalization
The database schema was heavily refactored from an initial universal relation of 60 intertwined attributes into **13 distinct tables**. The architecture passes both the **Lossless Join Test** and the **Dependency Preserving Test**, achieving full Boyce-Codd Normal Form (BCNF) to guarantee zero data loss and prevent insertion/deletion anomalies.

### 2. Advanced Analytics & Window Functions
Business intelligence leaderboards are automatically generated using advanced SQL window functions rather than application-layer logic:
* Utilizes `RANK() OVER (ORDER BY...)` to calculate top-revenue products.
* Implements the `PARTITION BY` clause to compute independent top-spender leaderboards for Students and Faculty simultaneously in a single query execution.

### 3. Database Views & Time-Series Logic
Complex multi-table joins are abstracted from the frontend application using SQL Views:
* `v_Customer_Receipts`: Automates a four-table join to instantly generate point-of-sale receipt data, handling walk-in customers cleanly via `COALESCE` and `LEFT JOIN` logic.
* `v_Sales_Past_7_Days`: Introduces rolling chronological logic utilizing dynamic date functions to track weekly revenue without manual code adjustments.

### 4. Data Integrity & Financial Reconciliation
* **Constraints:** Enforces strict `CHECK` constraints to mathematically prevent negative pricing and inventory logic errors. 
* **Role-Based Access:** Utilizes `ENUM` typing to secure the system between Admins, Cashiers, and Customers.
* **Audit Trails:** Implements soft-deletion rules (`FOREIGN KEY ... ON DELETE RESTRICT`) to preserve historical financial records, including payments handled via Bakong KHQR and cash gateways.
