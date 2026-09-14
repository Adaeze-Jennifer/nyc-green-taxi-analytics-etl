-- 1. PRICING AND REVENUE ANALYTICS
-- A. Which hour of the day across all four years, yields the highest average total fare per trip?

WITH CombinedTrips AS (
     SELECT 2017 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS Pickup_Hour,total_amount
     FROM dbo.[2017_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2018 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS Pickup_Hour,total_amount
     FROM dbo.[2018_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2019 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS Pickup_Hour, total_amount
     FROM dbo.[2019_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2020 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS Pickup_Hour, total_amount
     FROM dbo.[2020_Taxi_Trips_Cleaned]
),
HourlyMetrics AS (
      SELECT
      Data_Year,
      Pickup_Hour,
      COUNT(*) AS Total_Trips,
      CAST(AVG(total_amount) AS DECIMAL(10,2)) AS Avg_Total_Amount
FROM CombinedTrips
GROUP BY Data_Year, Pickup_Hour
),
RankedHours AS (
      SELECT
      Data_Year,
      Pickup_Hour,
      Total_Trips,
      Avg_Total_Amount,
      DENSE_RANK() OVER (PARTITION BY Data_Year ORDER BY Avg_Total_Amount DESC) AS Profit_Rank
      FROM HourlyMetrics
)
SELECT Data_Year, Profit_Rank, Pickup_Hour,Total_Trips,Avg_Total_Amount
FROM RankedHours
WHERE Profit_Rank <= 3
ORDER BY Data_Year ASC, Profit_Rank ASC;

-- 1. PRICING AND REVENUE ANALYTICS
-- B. Do Passengers tip a higher percentage of the fare on short trips versus long trips?

WITH CombinedCreditTrips AS (
     SELECT 2017 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS trip_distance, fare_amount, tip_amount
     FROM dbo.[2017_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2018 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS trip_distance, fare_amount, tip_amount
     FROM dbo.[2018_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2019 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS trip_distance, fare_amount, tip_amount
     FROM dbo.[2019_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2020 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS trip_distance, fare_amount, tip_amount
     FROM dbo.[2020_Taxi_Trips_Cleaned]
     ),
 DistanceBuckets AS (
     SELECT
     Data_Year,
     fare_amount,
     tip_amount,
     CASE
         WHEN trip_distance <=2 THEN '1. Short (0-2 miles)'
         WHEN trip_distance <=5 THEN '2. Medium (2-5 miles)'
         WHEN trip_distance <= 10 THEN '3. Long (5-10 miles)'
         ELSE '4. Extra Long (10+ miles)'
END AS Distance_Category
FROM CombinedCreditTrips
)
     SELECT
     Data_Year,
     Distance_Category,
     COUNT(*) AS Total_Trips,
     CAST(AVG(fare_amount) AS DECIMAL(10,2)) AS Avg_Fare,
     CAST(AVG(tip_amount) AS DECIMAL(10,2)) AS Avg_Tip,
     CAST(AVG((tip_amount/NULLIF(fare_amount,0)) * 100) AS DECIMAL(10,2)) AS Avg_Tip_Percentage
FROM DistanceBuckets
GROUP BY Data_Year, Distance_Category
ORDER BY Data_Year ASC, Distance_Category ASC;

-- 1. PRICING AND REVENUE ANALYTICS
-- C. What is the average total revenue difference between credit card payments and cash paymemts

WITH CombinedPayments AS (
     SELECT 2017 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS payment_type, fare_amount, tip_amount, total_amount
     FROM dbo.[2017_Taxi_Trips_Cleaned]
     WHERE payment_type IN (1,2) AND total_amount >= 0

     UNION ALL

     SELECT 2018 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS payment_type, fare_amount, tip_amount, total_amount
     FROM dbo.[2018_Taxi_Trips_Cleaned]
     WHERE payment_type IN (1,2) AND total_amount >= 0

     UNION ALL

     SELECT 2019 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS payment_type, fare_amount, tip_amount, total_amount
     FROM dbo.[2019_Taxi_Trips_Cleaned]
     WHERE payment_type IN (1,2) AND total_amount >= 0

     UNION ALL

     SELECT 2020 AS Data_Year, DATEPART(hour, lpep_pickup_datetime) AS payment_type, fare_amount, tip_amount, total_amount
     FROM dbo.[2020_Taxi_Trips_Cleaned]
     WHERE payment_type IN (1,2) AND total_amount >= 0
     ),
LabeledPayments AS (
    SELECT
      Data_Year,
      CASE
         WHEN payment_type = 1 THEN 'Credit Card'
         WHEN payment_type = 2 THEN 'Cash'
         ELSE 'Other'
      END AS Payment_Method,
      fare_amount,
      tip_amount,
      total_amount
    FROM CombinedPayments
)
SELECT
  Data_Year,
  Payment_Method,
      COUNT(*) AS Total_Trips,
      CAST(AVG(fare_amount) AS DECIMAL(10,2)) AS Avg_Fare,
      CAST(AVG(tip_amount) AS DECIMAL(10,2)) AS Avg_Tip,
      CAST(AVG(total_amount) AS DECIMAL(10,2)) AS Avg_Total_Revenue
FROM LabeledPayments
WHERE Payment_Method IN ('Credit Card', 'Cash')
GROUP BY Data_Year, Payment_Method
ORDER BY Data_Year ASC, Payment_Method ASC;

-- 2. OPERATIONAL EFFICIENCY & DEMOGRAPHICS
-- D. How many trips recorded a passenger count of 0 but still generated a positive fare amount? 
--    What is the total revenue sitting in these anomalies?

WITH CombinedGhosts AS (
     SELECT 2017 AS Data_Year, passenger_count, fare_amount,total_amount FROM dbo.[2017_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2018 AS Data_Year, passenger_count, fare_amount,total_amount FROM dbo.[2018_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2019 AS Data_Year, passenger_count, fare_amount,total_amount FROM dbo.[2019_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2020 AS Data_Year, passenger_count, fare_amount,total_amount FROM dbo.[2020_Taxi_Trips_Cleaned]
)
SELECT
     Data_Year,
     COUNT(*) AS Ghost_Trip_Count,
     CAST(SUM(fare_amount) AS DECIMAL(10,2)) AS Total_Ghost_Base_Fare,
     CAST(SUM(total_amount) AS DECIMAL(10,2)) AS Total_Ghost_Revenue_Collected
FROM CombinedGhosts
WHERE passenger_count = 0 AND total_amount > 0
GROUP BY Data_Year
ORDER BY Data_Year ASC;

-- 2. OPERATIONAL EFFICIENCY & DEMOGRAPHICS
-- E. Do trips with higher passenger counts (e.g. 3+ people) result in longer distance and higher fares, or are they mostly short group trips?

WITH CombinedPassengerGroups AS (
     SELECT 2017 AS Data_Year, passenger_count, trip_distance,total_amount FROM dbo.[2017_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2018 AS Data_Year, passenger_count, trip_distance,total_amount FROM dbo.[2018_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2019 AS Data_Year, passenger_count, trip_distance,total_amount FROM dbo.[2019_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2020 AS Data_Year, passenger_count,trip_distance,total_amount FROM dbo.[2020_Taxi_Trips_Cleaned]
),
GroupBuckets AS (
SELECT
     Data_Year,
     trip_distance,
     total_amount,
     CASE
         WHEN passenger_count = 1 THEN '1. Solo Rider'
         WHEN passenger_count = 2 THEN '2. Duo Riders'
         ELSE '3. Group (3+ Riders)'
    END AS Rider_Setup
FROM CombinedPassengerGroups
)
SELECT
      Data_Year,
      Rider_Setup,
      COUNT(*) AS Total_Trips,
      CAST(AVG(trip_distance) AS DECIMAL(10,2)) AS Avg_Distance,
      CAST(AVG(total_amount) AS DECIMAL(10,2)) AS Avg_Total_Amount
FROM GroupBuckets
GROUP BY Data_Year, Rider_Setup
ORDER BY Data_Year ASC, Rider_Setup ASC;

-- 2. OPERATIONAL EFFICIENCY & DEMOGRAPHICS
-- F. What was the percentage drop in total trip volume and total revenue April 2019 and April 2020?

WITH AprilComparison AS (
     SELECT 2019 AS Data_Year, total_amount FROM dbo.[2019_Taxi_Trips_Cleaned] WHERE DATEPART(month,lpep_pickup_datetime) = 4 
     AND total_amount >= 0
     UNION ALL
     SELECT 2020 AS Data_Year, total_amount FROM dbo.[2020_Taxi_Trips_Cleaned] WHERE DATEPART(month, lpep_pickup_datetime) = 4
     AND total_amount >= 0
)
SELECT
      Data_Year,
      COUNT(*) AS Total_April_Trips,
      CAST(SUM(total_amount) AS DECIMAL(14,2)) AS Total_April_Revenue,
      CAST(AVG(total_amount) AS DECIMAL(10,0)) AS Avg_Amount_Per_Trip
FROM AprilComparison
GROUP BY Data_Year
ORDER BY Data_Year ASC;

-- 3. GEOSPATIAL AND ROUTING INSIGHTS
-- G. What are the Top 5 busiest Pickup Locations (PULocationID) across the entire dataset and what is the average distance travelled from them?

WITH CombinedLocations AS (
     SELECT PULocationID, trip_distance, total_amount FROM dbo.[2017_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT PULocationID, trip_distance, total_amount FROM dbo.[2018_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT PULocationID, trip_distance, total_amount FROM dbo.[2019_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT PULocationID, trip_distance, total_amount FROM dbo.[2020_Taxi_Trips_Cleaned]
)
    SELECT TOP 5
    PULocationID,
    COUNT(*) AS Total_Pickups,
    CAST(AVG(trip_distance) AS DECIMAL(10,2)) AS Avg_Distance_Traveled,
    CAST(AVG(total_amount) AS DECIMAL(10,2)) AS Avg_Total_Revenue
FROM CombinedLocations
GROUP BY PULocationID
ORDER BY Total_Pickups DESC;

-- GEOSPATIAL AND ROUTING INSIGHTS
-- H. Which common pickup-to-dropoff routes have the lowest calculated speed (Distance/Duration), indicating heavy traffic congestion?

WITH CombinedRoutes AS (
     SELECT lpep_pickup_datetime, lpep_dropoff_datetime, PULocationID, DOLocationID, trip_distance FROM dbo.[2017_Taxi_Trips_Cleaned] 
     WHERE trip_distance >=0.5
     UNION ALL
     SELECT lpep_pickup_datetime, lpep_dropoff_datetime, PULocationID, DOLocationID, trip_distance FROM dbo.[2018_Taxi_Trips_Cleaned]
     WHERE trip_distance >=0.5
     UNION ALL
     SELECT lpep_pickup_datetime, lpep_dropoff_datetime, PULocationID, DOLocationID, trip_distance FROM dbo.[2019_Taxi_Trips_Cleaned] 
     WHERE trip_distance >=0.5
     UNION ALL
     SELECT lpep_pickup_datetime, lpep_dropoff_datetime, PULocationID, DOLocationID, trip_distance FROM dbo.[2020_Taxi_Trips_Cleaned] 
     WHERE trip_distance >=0.5
 ),
 RouteSpeeds AS (
    SELECT
    PULocationID,
    DOLocationID,
    COUNT(*) AS Total_Trips,
    CAST(AVG(trip_distance) AS DECIMAL(10,2)) AS Avg_Distance,
    -- Force decimal division by multiplying trip_distance by 1.0
    CAST(AVG((trip_distance *3600.0) / NULLIF(DATEDIFF(second,lpep_pickup_datetime, lpep_dropoff_datetime),0)) AS DECIMAL(10,2)) AS Avg_Speed_MPH
FROM CombinedRoutes
GROUP BY PULocationID, DOLocationID
HAVING COUNT(*) >= 500 
-- Filters out rare/one-off routes to ensure statistical relevance
AND AVG(DATEDIFF(second, lpep_pickup_datetime, lpep_dropoff_datetime)) > 60
)
SELECT TOP 10 PULocationID, DOLocationID, Total_Trips, Avg_Distance, Avg_Speed_MPH
FROM RouteSpeeds
ORDER BY Avg_Speed_MPH ASC;

-- 4. MACRO TRENDS (MULTI-YEAR UNION ANALYTICS)
-- I. How did the total market share of traditional green taxi trips change year-over-year from 2017 to 2020 after we filtered out of the app-based
--    missing data?

WITH YearlyVolumes AS (
     SELECT 2017 AS Data_Year FROM dbo.[2017_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2018 AS Data_Year FROM dbo.[2018_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2019 AS Data_Year FROM dbo.[2019_Taxi_Trips_Cleaned]
     UNION ALL
     SELECT 2020 AS Data_Year FROM dbo.[2020_Taxi_Trips_Cleaned]
)
SELECT
     Data_Year,
     COUNT(*) AS Total_Annual_Trips
FROM YearlyVolumes
GROUP BY Data_Year
ORDER BY Data_Year ASC;


-- 4. MACRO TRENDS (MULTI-YEAR UNION ANALYTICS)
-- J. Are long distance dropoff trips (defined as the top 10% of distances) more likely to be charged standard rates or negotiated flat rates (RatecodeID)

WITH CombinedLongDistances AS (
     SELECT 2017 AS Data_Year, trip_distance, RatecodeID FROM dbo.[2017_Taxi_Trips_Cleaned] WHERE trip_distance > 0
     UNION ALL
     SELECT 2018 AS Data_Year, trip_distance, RatecodeID FROM dbo.[2018_Taxi_Trips_Cleaned] WHERE trip_distance > 0
     UNION ALL
     SELECT 2019 AS Data_Year, trip_distance, RatecodeID FROM dbo.[2019_Taxi_Trips_Cleaned] WHERE trip_distance > 0
     UNION ALL
     SELECT 2020 AS Data_Year, trip_distance, RatecodeID FROM dbo.[2020_Taxi_Trips_Cleaned] WHERE trip_distance > 0
),
DistanceThresholds AS (
    SELECT
    Data_Year,
    trip_distance,
    RatecodeID,
    -- Dynamically calculate the 90th percentile threshold across all combined trips
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY trip_distance) OVER() AS Long_Trip_Cutoff
FROM CombinedLongDistances
),
FilteredLongTrips AS (
    SELECT
    Data_Year,
    CASE
        WHEN RatecodeID = 1 THEN 'Standard Rate (Metered)'
        WHEN RatecodeID = 2 THEN 'JFK Airport Flat Rate'
        WHEN RatecodeID = 3 THEN 'Negotiated Flat Rate'
        ELSE 'Other Special Rate'
    END AS Pricing_Structure
    FROM DistanceThresholds
    WHERE trip_distance >= Long_Trip_Cutoff
)
SELECT
      Data_Year,
      Pricing_Structure,
      COUNT(*) AS Total_Trips
FROM FilteredLongTrips
GROUP BY Data_Year, Pricing_Structure
ORDER BY Data_Year ASC, Total_Trips DESC;
