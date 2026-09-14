-- Comprehensive Multi-Year Data Quality & Comprehensive Audit Pipeline
SELECT '2017_Taxi_Trips' AS Trip_Year, COUNT(*) AS Total_Rows,
SUM(CASE WHEN VendorID IS NULL THEN 1 ELSE 0 END) AS Missing_VendorIDs,
SUM(CASE WHEN lpep_pickup_datetime IS NULL THEN 1 ELSE 0 END) AS Missing_Ipep_pickup_datetime,
SUM(CASE WHEN lpep_dropoff_datetime IS NULL THEN 1 ELSE 0 END) AS Missing_Ipep_dropoff_datetime,
SUM(CASE WHEN Store_and_fwd_flag IS NULL THEN 1 ELSE 0 END) AS Missing_Store_and_fwd_flag,
SUM(CASE WHEN RatecodeID IS NULL THEN 1 ELSE 0 END) AS Missing_RatecodeID,
SUM(CASE WHEN PULocationID IS NULL THEN 1 ELSE 0 END) AS Missing_PULocationID,
SUM(CASE WHEN DOLocationID IS NULL THEN 1 ELSE 0 END) AS Missing_DOLocationID,
SUM(CASE WHEN passenger_count IS NULL THEN 1 ELSE 0 END) AS Missing_passenger_count,
SUM(CASE WHEN trip_distance IS NULL THEN 1 ELSE 0 END) AS Missing_trip_distance,
SUM(CASE WHEN fare_amount IS NULL THEN 1 ELSE 0 END) AS Missing_fare_amount,
SUM(CASE WHEN extra IS NULL THEN 1 ELSE 0 END) AS Missing_extra,
SUM(CASE WHEN mta_tax IS NULL THEN 1 ELSE 0 END) AS Missing_mta_tax,
SUM(CASE WHEN tip_amount IS NULL THEN 1 ELSE 0 END) AS Missing_tip_amount,
SUM(CASE WHEN tolls_amount IS NULL THEN 1 ELSE 0 END) AS Missing_tolls_amount,
SUM(CASE WHEN improvement_surcharge IS NULL THEN 1 ELSE 0 END) AS Missing_total_amount,
SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS Missing_total_amount,
SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS Missing_payment_type,
SUM(CASE WHEN trip_type IS NULL THEN 1 ELSE 0 END) AS Missing_trip_type
FROM dbo.[2017_taxi_trips]

UNION ALL

SELECT '2018_Taxi_Trips' AS Trip_Year, COUNT(*) AS Total_Rows,
SUM(CASE WHEN VendorID IS NULL THEN 1 ELSE 0 END) AS Missing_VendorIDs,
SUM(CASE WHEN lpep_pickup_datetime IS NULL THEN 1 ELSE 0 END) AS Missing_Ipep_pickup_datetime,
SUM(CASE WHEN lpep_dropoff_datetime IS NULL THEN 1 ELSE 0 END) AS Missing_Ipep_dropoff_datetime,
SUM(CASE WHEN Store_and_fwd_flag IS NULL THEN 1 ELSE 0 END) AS Missing_Store_and_fwd_flag,
SUM(CASE WHEN RatecodeID IS NULL THEN 1 ELSE 0 END) AS Missing_RatecodeID,
SUM(CASE WHEN PULocationID IS NULL THEN 1 ELSE 0 END) AS Missing_PULocationID,
SUM(CASE WHEN DOLocationID IS NULL THEN 1 ELSE 0 END) AS Missing_DOLocationID,
SUM(CASE WHEN passenger_count IS NULL THEN 1 ELSE 0 END) AS Missing_passenger_count,
SUM(CASE WHEN trip_distance IS NULL THEN 1 ELSE 0 END) AS Missing_trip_distance,
SUM(CASE WHEN fare_amount IS NULL THEN 1 ELSE 0 END) AS Missing_fare_amount,
SUM(CASE WHEN extra IS NULL THEN 1 ELSE 0 END) AS Missing_extra,
SUM(CASE WHEN mta_tax IS NULL THEN 1 ELSE 0 END) AS Missing_mta_tax,
SUM(CASE WHEN tip_amount IS NULL THEN 1 ELSE 0 END) AS Missing_tip_amount,
SUM(CASE WHEN tolls_amount IS NULL THEN 1 ELSE 0 END) AS Missing_tolls_amount,
SUM(CASE WHEN improvement_surcharge IS NULL THEN 1 ELSE 0 END) AS Missing_total_amount,
SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS Missing_total_amount,
SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS Missing_payment_type,
SUM(CASE WHEN trip_type IS NULL THEN 1 ELSE 0 END) AS Missing_trip_type
FROM dbo.[2018_taxi_trips]

UNION ALL

SELECT '2019_Taxi_Trips' AS Trip_Year, COUNT(*) AS Total_Trips,
SUM(CASE WHEN VendorID IS NULL THEN 1 ELSE 0 END) AS Missing_VendorIDs,
SUM(CASE WHEN lpep_pickup_datetime IS NULL THEN 1 ELSE 0 END) AS Missing_Ipep_pickup_datetime,
SUM(CASE WHEN lpep_dropoff_datetime IS NULL THEN 1 ELSE 0 END) AS Missing_Ipep_dropoff_datetime,
SUM(CASE WHEN Store_and_fwd_flag IS NULL THEN 1 ELSE 0 END) AS Missing_Store_and_fwd_flag,
SUM(CASE WHEN RatecodeID IS NULL THEN 1 ELSE 0 END) AS Missing_RatecodeID,
SUM(CASE WHEN PULocationID IS NULL THEN 1 ELSE 0 END) AS Missing_PULocationID,
SUM(CASE WHEN DOLocationID IS NULL THEN 1 ELSE 0 END) AS Missing_DOLocationID,
SUM(CASE WHEN passenger_count IS NULL THEN 1 ELSE 0 END) AS Missing_passenger_count,
SUM(CASE WHEN trip_distance IS NULL THEN 1 ELSE 0 END) AS Missing_trip_distance,
SUM(CASE WHEN fare_amount IS NULL THEN 1 ELSE 0 END) AS Missing_fare_amount,
SUM(CASE WHEN extra IS NULL THEN 1 ELSE 0 END) AS Missing_extra,
SUM(CASE WHEN mta_tax IS NULL THEN 1 ELSE 0 END) AS Missing_mta_tax,
SUM(CASE WHEN tip_amount IS NULL THEN 1 ELSE 0 END) AS Missing_tip_amount,
SUM(CASE WHEN tolls_amount IS NULL THEN 1 ELSE 0 END) AS Missing_tolls_amount,
SUM(CASE WHEN improvement_surcharge IS NULL THEN 1 ELSE 0 END) AS Missing_total_amount,
SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS Missing_total_amount,
SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS Missing_payment_type,
SUM(CASE WHEN trip_type IS NULL THEN 1 ELSE 0 END) AS Missing_trip_type
FROM dbo.[2019_taxi_trips]

UNION ALL

SELECT '2020_Taxi_Trips' AS Trip_Year,COUNT(*) AS Total_Trips,
SUM(CASE WHEN VendorID IS NULL THEN 1 ELSE 0 END) AS Missing_VendorIDs,
SUM(CASE WHEN lpep_pickup_datetime IS NULL THEN 1 ELSE 0 END) AS Missing_Ipep_pickup_datetime,
SUM(CASE WHEN lpep_dropoff_datetime IS NULL THEN 1 ELSE 0 END) AS Missing_Ipep_dropoff_datetime,
SUM(CASE WHEN Store_and_fwd_flag IS NULL THEN 1 ELSE 0 END) AS Missing_Store_and_fwd_flag,
SUM(CASE WHEN RatecodeID IS NULL THEN 1 ELSE 0 END) AS Missing_RatecodeID,
SUM(CASE WHEN PULocationID IS NULL THEN 1 ELSE 0 END) AS Missing_PULocationID,
SUM(CASE WHEN DOLocationID IS NULL THEN 1 ELSE 0 END) AS Missing_DOLocationID,
SUM(CASE WHEN passenger_count IS NULL THEN 1 ELSE 0 END) AS Missing_passenger_count,
SUM(CASE WHEN trip_distance IS NULL THEN 1 ELSE 0 END) AS Missing_trip_distance,
SUM(CASE WHEN fare_amount IS NULL THEN 1 ELSE 0 END) AS Missing_fare_amount,
SUM(CASE WHEN extra IS NULL THEN 1 ELSE 0 END) AS Missing_extra,
SUM(CASE WHEN mta_tax IS NULL THEN 1 ELSE 0 END) AS Missing_mta_tax,
SUM(CASE WHEN tip_amount IS NULL THEN 1 ELSE 0 END) AS Missing_tip_amount,
SUM(CASE WHEN tolls_amount IS NULL THEN 1 ELSE 0 END) AS Missing_tolls_amount,
SUM(CASE WHEN improvement_surcharge IS NULL THEN 1 ELSE 0 END) AS Missing_total_amount,
SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS Missing_total_amount,
SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS Missing_payment_type,
SUM(CASE WHEN trip_type IS NULL THEN 1 ELSE 0 END) AS Missing_trip_type
FROM dbo.[2020_taxi_trips];