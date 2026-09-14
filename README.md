# 🚕 NYC Green Taxi Analytics: Multi-Year ETL Pipeline & Market Dynamics Case Study (2017–2020)

## 📌 Project Overview
This repository documents an end-to-end data analytics and engineering project executed on the New York City Taxi and Limousine Commission (TLC) Green Taxi dataset spanning four consecutive fiscal years (2017–2020).

The project covers the full data lifecycle: beginning with a rigorous database schema audit, moving to structural ETL data pipeline engineering to isolate platform anomalies, and culminating in advanced business logic queries to extract high-value insights on fleet operations, pricing strategies, consumer behaviors, and market contractions.

## 💼 Key Business Impact Delivered:
- **Data Integrity Architecture:** Successfully audited millions of raw rows and engineered automated isolation pipelines to extract and purge 942,199 corrupted, app-based rideshare records, preserving calculation accuracy.
- **Operational Optimization:** Identified a critical high-yield driver window (5:00 AM – 6:00 AM) that maximizes revenue per hour by capturing early commutes before daytime traffic peak.
- **Geospatial & Velocity Intelligence:** Mapped the fleet's primary geographic stronghold (Upper Manhattan / Harlem) and profiled traffic bottlenecks mathematically, exposing a ~7.2 MPH gridlock corridor in Downtown Brooklyn.
- **Macro Market Metrics:** Quantified a historic 89.7% structural market contraction over a 36-month period, mapping the combined impact of rideshare competition and pandemic lockdowns.

## 🛠️ Tech Stack & Skills Demonstrated
- **Database Engine:** Microsoft SQL Server / SQL Server Management Studio (SSMS)
- **Advanced SQL Core:** Common Table Expressions (CTEs), Window Functions (DENSE_RANK(), PERCENTILE_CONT()), Conditional Aggregations, Relational Joins/Unions, Metadata Caching.
- **Analytical Frameworks:** Data Auditing, Fraud/Anomaly Detection, Dynamic Velocity Profiling, Geospatial Staging, Trend Tracking.

## 📂 Repository Structure
```text
├── DATA_DICTIONARY.md         # Detailed breakdown of business codes & metadata rules
├── SQL_Queries/
│   ├── 01_Data_Audit.sql      # Diagnostic scripts for missing parameter tracking
│   ├── 02_Table_Cleaning.sql  # SELECT INTO segregation and isolation pipeline scripts
│   └── 03_Business_Logic.sql  # 10 advanced business questions solved with analytic SQL
└── README.md                  # Comprehensive project portfolio documentation
```

## Phase 1: Data Integrity Audit & Pipeline Engineering
Before running business diagnostics, a structural data audit was conducted. A critical problem was identified in the 2019 and 2020 data streams: exactly 414,107 rows (2019) and 528,092 rows (2020) were missing values across core operational columns (VendorID, passenger_count, RatecodeID, payment_type).

### Root Cause Analysis
Research into NYC TLC regulatory updates revealed that around 2019, the city began integrating raw app-based rideshare data (High-Volume For-Hire Vehicles, like Uber/Lyft) into green taxi schemas. Because these platforms do not use traditional in-cab hardware, traditional telemetry data columns defaulted to NULL.

**The Analytics Strategy:** Attempting to fill these entries with default values (like assuming 1 passenger via ISNULL) would artificially inflate traditional taxi volume by nearly 1 million rides, ruining core metrics. Instead, a defensive isolation pipeline was engineered to purge these records and isolate traditional green taxi behaviors.

```
--Pipeline Segregation: Isolating traditional taxi telemetry from rideshare data
SELECT * 
INTO dbo.2019_Taxi_Trips_Cleaned 
FROM dbo.[2019_taxi_trips]
WHERE VendorID IS NOT NULL; -- Excludes the 414,107 incomplete rideshare entries
```

## 📈 Phase 2: Core Analytical Solutions & Insights
*Note: To maintain readability, the top executive highlights are detailed below. The complete, production-ready source code solving all 10 business analytical inquires can be reviewed directly in the [SQL_Queries/03_business_logic.sql](SQL_Queries/03_business_logic.sql) file.*

### The 10 Core Analytical Inquiries Solved:
 **A. PRICING AND REVENUE ANALYTICS**
 
*  **1. The High-value Time Window:** Which hour of the day across all four years, yields the highest average total fare per trip?
*  **2. The Tip-to-Fare Ratio:** Do Passengers tip a higher percentage of the fare on short trips versus long trips?
*  **3. The Cash vs. Credit Card Premium:** What is the average total revenue difference between credit card payments and cash paymemts
  
*  **B. OPERATIONAL EFFICIENCY & DEMOGRAPHICS**
*  **4. The "Ghost Trip" Anomaly:** How many trips recorded a passenger count of 0 but still generated a positive fare amount? What is the total revenue sitting in these anomalies?
*  **5. Multi-Efficiency:** Do trips with higher passenger counts (e.g. 3+ people) result in longer distance and higher fares, or are they mostly short group trips?
*  **6. The Pandemic Volume Collapse:** What was the percentage drop in total trip volume and total revenue April 2019 and April 2020?
*  
* -- **C. GEOSPATIAL AND ROUTING INSIGHTS**
* -- **7. High-Demand Hotspots:** What are the Top 5 busiest Pickup Locations (PULocationID) across the entire dataset and what is the average   distance travelled from them?
* -- **8. The Congestion Trap**  Which common pickup-to-drop-off routes have the lowest calculated speed (Distance/Duration), indicating heavy traffic congestion?
 
*  **D. MACRO TRENDS (MULTI-YEAR UNION ANALYTICS)**
*  **9. Yearly Market Share Shift:** How did the total market share of traditional green taxi trips change year-over-year from 2017 to 2020 after we filtered out of the app-based missing data?
* **10. The Long-Distance Dropoff Rejection** Are long distance drop-off trips (defined as the top 10% of distances) more likely to be charged standard rates or negotiated flat rates (RatecodeID)
---
### Key Analytical Findings & Executive Highlights
### 1. The High-Value Shift Window (Question 1)
**Objective:** Find the top 3 most profitable hours of the day per year based on average ticket size.

**Technical Approach:** Extracted timestamps using DATEPART, computed averages across years using a nested UNION ALL structure, and ranked output via DENSE_RANK() OVER (PARTITION BY...).
```
-- Sliced snippet of the ranking layer
RankedHours AS (
    SELECT Data_Year, Pickup_Hour, Total_Trips, Avg_Total_Amount,
           DENSE_RANK() OVER (PARTITION BY Data_Year ORDER BY Avg_Total_Amount DESC) AS Profit_Rank
    FROM HourlyMetrics
)
SELECT * FROM RankedHours WHERE Profit_Rank <= 3;
```
| Data_Year | Profit_Rank | Pickup_Hour | Total_Trips | Avg_Total_Amount |
|-----------|-------------|-------------|-------------|------------------|
| 2017      | 1           | 5           | 111909      | 17.41            |
| 2017      | 2           | 6           | 159484      | 16.94            |
| 2017      | 3           | 4           | 165959      | 15.52            |
| 2018      | 1           | 6           | 135943      | 21.06            |
| 2018      | 2           | 5           | 80927       | 20.19            |
| 2018      | 3           | 7           | 270726      | 18.37            |
| 2019      | 1           | 6           | 84599       | 21.80            |
| 2019      | 2           | 5           | 45210       | 20.33            |
| 2019      | 3           | 7           | 173036      | 18.28            |
| 2020      | 1           | 5           | 8786        | 21.17            |
| 2020      | 2           | 6           | 19285       | 20.98            |
| 2020      | 3           | 4           | 8968        | 17.06            |

**Insight:** **5:00 AM and 6:00 AM** consistently ranked as the most profitable hours per trip across all four years, capturing high-fare long-distance airport runs and early worker commutes before morning gridlock sets in.

## 2. The Cash vs. Credit Card Premium (Question 3)
**Objective:** Profile total revenue generation across distinct consumer payment categories.

| Data_Year | Payment_Method | Total_Trips | Avg_Fare | Avg_Tip | Avg_Total_Revenue |
|-----------|----------------|-------------|----------|---------|-------------------|
| 2017      | Cash           | 253696      | 11.78    | 1.20    | 14.33             |
| 2017      | Credit Card    | 348539      | 11.48    | 1.18    | 14.01             |
| 2018      | Cash           | 137632      | 11.92    | 1.14    | 14.42             |
| 2018      | Credit Card    | 192200      | 11.54    | 1.11    | 14.01             |
| 2019      | Cash           | 72347       | 12.16    | 1.20    | 15.01             |
| 2019      | Credit Card    | 104978      | 11.71    | 1.16    | 14.51             |
| 2020      | Cash           | 12183       | 12.69    | 1.18    | 15.57             |
| 2020      | Credit Card    | 18143       | 11.98    | 1.16    | 14.82             |

**Insight:** Contrary to industry assumptions, **Cash transactions consistently generated a higher average total amount than Credit Cards** across all periods (e.g., 2017: **$14.33** cash average vs. **$14.01** credit card average). This indicates a strong consumer preference for cash on longer, high-value routes.

## 3. "Ghost Trip" Anomaly Detection (Question 4)
Objective: Audit and catch system hardware faults (trips with 0 passengers that billed a positive fare).

| Data_Year | Ghost_Trip_Count | Total_Ghost_Base_Fare | Total_Ghost_Revenue_Collected |
|-----------|------------------|-----------------------|-------------------------------|
| 2017      | 1754             | 33164.33              | 35529.09                      |
| 2018      | 12278            | 159740.74             | 189969.83                     |
| 2019      | 11627            | 148705.80             | 177698.56                     |
| 2020      | 3166             | 37694.58              | 44052.83                      |

**Insight:** Uncovered a massive system hardware or logging software bug in 2018, where zero-passenger trips exploded from **1,754** (2017) to **12,278** (2018), capturing **$189,969.83** in unverified revenue.

## 4. Congestion Trap & Velocity Profiling (Question 8)
**Objective:** Profile trip durations and trip distances to map heavy traffic bottlenecks.

**Technical Solution:** Managed SQL Server integer division limitations by using a * 1.0 decimal multiplier, and isolated true gridlock using a HAVING clause filter for realistic trip durations.

```
-- Network velocity computation equation snippet
CAST(AVG((trip_distance * 3600.0) / NULLIF(DATEDIFF(second, lpep_pickup_datetime, lpep_dropoff_datetime), 0)) AS DECIMAL(10, 2)) AS Avg_Speed_MPH
```
| PULocationID | DOLocationID | Total_Trips | Avg_Distance | Avg_Speed_MPH |
|--------------|--------------|-------------|--------------|---------------|
| 52           | 65           | 6630        | 1.05         | 7.17          |
| 25           | 65           | 12691       | 0.97         | 7.51          |
| 123          | 149          | 957         | 1.53         | 7.51          |
| 178          | 165          | 639         | 1.29         | 7.52          |
| 227          | 26           | 910         | 1.56         | 7.57          |
| 65           | 33           | 19662       | 1.05         | 7.64          |
| 165          | 178          | 568         | 1.54         | 7.64          |
| 26           | 165          | 1544        | 2.83         | 7.64          |
| 97           | 25           | 31483       | 1.01         | 7.67          |
| 33           | 65           | 17268       | 0.99         | 7.80          |

**Insight:** Isolated the worst transit corridor in Brooklyn: **Zone 52 to Zone 65** (Red Hook to Downtown Brooklyn), charting a crawling speed of **7.17 MPH** across **6,630 trips.**

## 5. Macro Industry Contraction (Question 9)
**Objective:** Measure the multi-year macro trend of traditional green taxi volume over time.

| Data_Year | Total_Annual_Trips |
|-----------|--------------------|
| 2017      | 11740640           |
| 2018      | 8807240            |
| 2019      | 5629584            |
| 2020      | 1205954            |

**Insight:** Charted a catastrophic **89.7%** drop in volume over 36 months, plunging from **11.74 Million trips** (2017) down to **1.21 Million trips** (2020). This highlights the combined structural pressure of rideshare expansion and pandemic shutdowns (with April 2020 experiencing a sharp 95.2% volume collapse).

## 📈 Strategic Recommendations Developed
**1. Target High-Yield Hubs:** Fleet distribution should be stationed near regional strongholds like East Harlem North (Zone 74), which logged 1.88M+ rides, focusing on high-frequency neighborhood trips.

**2. Early Mobility Incentives:**  Fleet managers should encourage drivers to start shifts early to catch the high-yield 5:00 AM – 6:00 AM window, maximizing morning revenue per hour before traffic peaks.

**3. Dynamic Congestion Routing:** Incorporate velocity maps into fleet tracking software to route drivers around known bottlenecks like the Downtown Brooklyn corridor during rush hours.

**4. Business Diversification:** With traditional street hails down nearly 90%, traditional fleet survival requires a shift toward B2B corporate courier contracts, medical transport logistics, or direct e-hail app integrations.

### 👤 Contact & Connections
- _**Name:**_ _Adaeze Jennifer Onuigbo_
- _**Role:**_ _Data Analyst / Business Intelligence Analyst_
- _**LinkedIn:**_ _[Link](https://www.linkedin.com/in/adaezeonuigbo)_
- _**Portfolio / Website:**_ _[ Portfolio Link]_
