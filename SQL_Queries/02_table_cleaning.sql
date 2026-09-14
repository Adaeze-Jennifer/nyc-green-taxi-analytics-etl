
--1. Create Cleaned 2017 Table
SELECT*
INTO dbo.[2017_Taxi_Trips_Cleaned]
FROM dbo.[2017_taxi_trips]
WHERE VendorID IS NOT NULL
AND trip_type IS NOT NULL;

--2. Create Cleaned 2018 Table
SELECT*
INTO dbo.[2018_Taxi_Trips_Cleaned]
FROM dbo.[2018_taxi_trips]
WHERE VendorID IS NOT NULL
AND trip_type IS NOT NULL;

--3. Create Cleaned 2019 Table
SELECT*
INTO dbo.[2019_Taxi_Trips_Cleaned]
FROM dbo.[2019_taxi_trips]
WHERE VendorID IS NOT NULL
AND trip_type IS NOT NULL
AND total_amount IS NOT NULL
AND trip_type IS NOT NULL;

--4. Create Cleaned 2020 Table
SELECT*
INTO dbo.[2020_Taxi_Trips_Cleaned]
FROM dbo.[2020_taxi_trips]
WHERE VendorID IS NOT NULL
AND trip_type IS NOT NULL;