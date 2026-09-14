🚕 NYC Green Taxi Analytics: Multi-Year ETL Pipeline & Market Dynamics Case Study (2017–2020)

📌 Project Overview
This repository documents an end-to-end data analytics and engineering project executed on the New York City Taxi and Limousine Commission (TLC) Green Taxi dataset spanning four consecutive fiscal years (2017–2020).
The project covers the full data lifecycle: beginning with a rigorous database schema audit, moving to structural ETL data pipeline engineering to isolate platform anomalies, and culminating in advanced business logic queries to extract high-value insights on fleet operations, pricing strategies, consumer behaviors, and market contractions.

💼 Key Business Impact Delivered:
Data Integrity Architecture: Successfully audited millions of raw rows and engineered automated isolation pipelines to extract and purge 942,199 corrupted, app-based rideshare records, preserving calculation accuracy.
Operational Optimization: Identified a critical high-yield driver window (5:00 AM – 6:00 AM) that maximizes revenue per hour by capturing early commutes before daytime traffic peak.
Geospatial & Velocity Intelligence: Mapped the fleet's primary geographic stronghold (Upper Manhattan / Harlem) and profiled traffic bottlenecks mathematically, exposing a ~7.2 MPH gridlock corridor in Downtown Brooklyn.
Macro Market Metrics: Quantified a historic 89.7% structural market contraction over a 36-month period, mapping the combined impact of rideshare competition and pandemic lockdowns.

🛠️ Tech Stack & Skills Demonstrated
Database Engine: Microsoft SQL Server / SQL Server Management Studio (SSMS)
Advanced SQL Core: Common Table Expressions (CTEs), Window Functions (DENSE_RANK(), PERCENTILE_CONT()), Conditional Aggregations, Relational Joins/Unions, Metadata Caching.
Automation Engineering: Python (pyodbc, logging) for automated ETL orchestration.

Analytical Frameworks: Data Auditing, Fraud/Anomaly Detection, Dynamic Velocity Profiling, Geospatial Staging, Trend Tracking.
📂 Repository Structure
├── DATA_DICTIONARY.md         # Detailed breakdown of business codes & metadata rules
├── ETL_Automation_Pipeline.py # Python script for multi-year table cleaning automation
├── SQL_Queries/
│   ├── 01_Data_Audit.sql      # Diagnostic scripts for missing parameter tracking
│   ├── 02_Table_Cleaning.sql  # SELECT INTO segregation and isolation pipeline scripts
│   └── 03_Business_Logic.sql  # 10 advanced business questions solved with analytic SQL
└── README.md                  # Comprehensive project portfolio documentation

🕵️‍♂️ Phase 1: Data Integrity Audit & Pipeline Engineering
Before running business diagnostics, a structural data audit was conducted. A critical problem was identified in the 2019 and 2020 data streams: exactly 414,107 rows (2019) and 528,092 rows (2020) were missing values across core operational columns (VendorID, passenger_count, RatecodeID, payment_type).
Root Cause Analysis
Research into NYC TLC regulatory updates revealed that around 2019, the city began integrating raw app-based rideshare data (High-Volume For-Hire Vehicles, like Uber/Lyft) into green taxi schemas. Because these platforms do not use traditional in-cab hardware, traditional telemetry data columns defaulted to NULL.
The Analytics Strategy: Attempting to fill these entries with default values (like assuming 1 passenger via ISNULL) would artificially inflate traditional taxi volume by nearly 1 million rides, ruining core metrics. Instead, a defensive isolation pipeline was engineered to purge these records and isolate traditional green taxi behaviors.
