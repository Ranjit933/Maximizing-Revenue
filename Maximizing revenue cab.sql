CREATE DATABASE Maximizing_Revenue;
USE Maximizing_Revenue;
SELECT * FROM taxi

-- To show how much rows
SELECT 
    COUNT(*)
FROM
    taxi
    
-- 1.Find total revenue for each cab driver

SELECT 
    VendorID, ROUND(SUM(fare_amount) * 100) AS total_Revenue
FROM
    taxi
GROUP BY VendorID

-- 2.Find the cab driver with the heightest total Vendor

SELECT 
    VendorID, ROUND(SUM(fare_amount) * 100) AS Total_Revenue
FROM
    taxi
GROUP BY VendorID
ORDER BY Total_Revenue DESC
LIMIT 1

-- 3.Find the total number of tips for each vendor

SELECT 
    VendorID, COUNT(*) AS total_trip
FROM
    taxi
GROUP BY VendorID

-- 4.Find the average fare trip for each vendor

SELECT 
    VendorID, ROUND(AVG(fare_amount) * 100) AS Avg_Fare
FROM
    taxi
GROUP BY VendorID

-- 5.Find the total revenue for a specific PU Location ID

SELECT 
    ROUND(SUM(total_amount) * 100) AS Total_Revenue
FROM
    taxi
WHERE
    PULocationID = 48

-- 6.Find the vendor with the highest average fare per trip

SELECT 
    VendorID, ROUND(AVG(total_amount) * 100) AS Avg_Fare
FROM
    taxi
GROUP BY VendorID
ORDER BY Avg_Fare DESC
LIMIT 1

-- 7.Find total revenue per day of the week

SELECT 
    DAYOFWEEK(tpep_pickup_datetime) AS Day_of_week,
    ROUND(SUM(total_amount) * 100) AS Total_Revenue
FROM
    taxi
GROUP BY DAYOFWEEK(tpep_pickup_datetime)

-- 8.Get the average toatl amount where congestion surcharge is not null

SELECT 
    AVG(total_amount) AS Avg_Total_Amount
FROM
    taxi
WHERE
   Congestion_surcharge IS NOT NULL

-- 9.Find thehighest extra value where payment_type is cash (1=cash and 2= credit card)

SELECT 
    MAX(extra) AS Max_extra
FROM
    taxi
WHERE
    payment_type = 1
    
-- 10.Find the pick up and drop off time in munites

SELECT 
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    TIMESTAMPDIFF(MINUTE,
        tpep_pickup_datetime,
        tpep_dropoff_datetime) AS Duration_Minute
FROM
    taxi
    
-- 11.Find the pick up and drop off time in hours

SELECT 
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    TIMESTAMPDIFF(HOUR,
        tpep_pickup_datetime,
        tpep_dropoff_datetime) AS Duration_Hours
FROM
    taxi
 
 -- 12.Find the total revnue (sum of total_amount) for each month in 2020
 
SELECT 
    DATE_FORMAT(tpep_pickup_datetime, '%Y-%m') AS Month,
    ROUND(SUM(total_amount) * 100) AS Total_revenue
FROM
    taxi
GROUP BY Month
ORDER BY month

-- 13.Get the average fare_amount and tip_amount for each day of the week

SELECT 
    DAYNAME(tpep_pickup_datetime) AS day_of_week,
    ROUND(AVG(fare_amount) * 100, 2) AS Avg_Fare,
    ROUND(AVG(tip_amount) * 100, 2) AS Avg_tip
FROM
    taxi
GROUP BY day_of_week
ORDER BY FIELD(day_of_week,
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thrusday',
        'Friday',
        'Saturday',
        'Sunday')
        
-- 14.Find the top 5 location with the heightest average trip_distance

SELECT 
    PULocationID,
    ROUND(AVG(trip_distance) * 100, 2) AS Avg_Distance
FROM
    taxi
GROUP BY PULocationID
ORDER BY Avg_Distance DESC
LIMIT 5

-- 15.List all trip where the total_amount was greater than the sum of fare_amount, tip_amount and
-- tools_amount by more than 2 dollors

SELECT 
    *
FROM
    taxi
WHERE
    total_amount > (fare_amount + tip_amount + tolls_amount + 2)
    
-- 16.Find the total fare_amount for each combination of RatecodeID and payment_type

SELECT RatecodeID,payment_type,ROUND(SUM(fare_amount)*100,2) AS Total_Fare
FROM taxi
GROUP BY RatecodeID,payment_type

-- 17.Get the average total_amount for trip where DOLoactaionID is 100 and PULocationID is 50

SELECT 
    ROUND(AVG(total_amount) * 100, 2) AS Avf_Total_Amount
FROM
    taxi
WHERE
    DOLocationID = 100 AND PULocationID = 50

-- 18.calculate the percentage of trip with tip_amount greater than 10 dollars for each payment_type

SELECT 
    payment_type,
    ROUND((SUM(CASE
        WHEN tip_amount > 10 THEN 1
        ELSE 0
    END) / COUNT(*)) * 100,2) AS percentage_Above_10
FROM
    taxi
GROUP BY payment_type

-- 19.Find the 10 heighest fare_amount records and include their tpep_picup_datetime

SELECT 
    fare_amount, tpep_pickup_datetime
FROM
    taxi
ORDER BY fare_amount DESC
LIMIT 10

-- 20.Determine the total fare_amount and average tip_amount for each day of the month for July 2020

SELECT DAY(tpep_pickup_datetime) AS Day_Of_Month,
		ROUND(SUM(fare_amount)*100,2) AS Total_Fare,
        ROUND(AVG(tip_amount)*100,2) AS Avg_Tip
FROM taxi
WHERE MONTH(tpep_pickup_datetime) = 1 AND YEAR(tpep_pickup_datetime) = 2020
GROUP BY Day_Of_Month
ORDER BY Day_Of_Month

-- 21.Identify the VendorID with the heighest total tolls_amount and list the top 3 PULocationID for that vendorID

SELECT PULocationID,SUM(tolls_amount) AS Total_tolls
FROM taxi
WHERE VendorID = (
					SELECT VendorID 
					FROM taxi
                    GROUP BY VendorID 
                    ORDER BY SUM(tolls_amount) DESC
                    LIMIT 1
                    )
GROUP BY PULocationID
ORDER BY Total_tolls DESC
LIMIT 3

-- 22.Calculate the moving average of fare amount over a 30-day window and classify each trip as 'Above Avg or 'Below Avg' 

SELECT tpep_pickup_datetime,fare_amount,
	AVG(fare_amount) OVER(ORDER BY tpep_pickup_datetime ROWS BETWEEn 29 PRECEDING AND CURRENT ROW) AS Moving_avg_fare,
    CASE
		WHEN fare_amount > AVG(fare_amount) OVER(ORDER BY tpep_pickup_datetime ROWS BETWEEn 29 PRECEDING AND CURRENT ROW) THEN 'Above Average'
        ELSE 'Below Average'
        END AS fare_comparison
        FROM taxi
        
-- 23.Determine the total tip amount and categorize it based on ranges(e.g,'Low,'Medium','High')

SELECT VendorID,tip_amount,
	   CASE
          WHEN tip_amount < 5 THEN 'LOW'
          WHEN tip_amount BETWEEN 5 AND 15 THEN 'Medium'
          ELSE 'High'
          END AS tip_category
FROM taxi

-- 24.Calculate the percentage of trips with each payment_type where the fare mount is greater than 50

SELECT 
    payment_type,
    (SUM(CASE
        WHEN fare_amount > 50 THEN 1
        ELSE 0
    END) / COUNT(*)) * 100 AS Percentage_above_50
FROM
    taxi
GROUP BY payment_type

-- 25.Find the minimum,maximum and average fare amount for each PULocationID and categorize based on average fare amount

SELECT PULocationID,
		MIN(fare_amount) AS min_fare,
        MAX(fare_amount) AS max_fare,
        AVG(fare_amount) AS avg_fare,
        CASE
           WHEN AVG(fare_amount) < 20 THEN 'Low'
           WHEN AVG(fare_amount) BETWEEN 20 AND 50 THEN 'Medium'
           ELSE 'High'
           END AS fare_category
FROM taxi
GROUP BY PULocationID

-- 26.Determine the total fare amount for each RatecodeID and compare it to the total fare amount for
-- trips with passenger_count greater than 3

WITH high_passenger_fares AS (
	SELECT SUM(total_amount) AS high_passenger_total
    FROM taxi
    WHERE passenger_count > 3
)
 SELECT 
	RatecodeID,
    SUM(total_amount) AS ratecode_total,
    CASE
		WHEN SUM(total_amount) > (SELECT high_passenger_total FROM high_passenger_fares) THEN 'Above High Passenger Total'
        ELSE 'Below high Passenger Total'
        END AS total_comparison
FROM taxi
GROUP BY RatecodeID

-- 27.Calculate the median tip amount for trips that occurred in the month with the highest average fare amount

WITH monthly_averages AS(
    SELECT 
		DATE_FORMAT(tpep_pickup_datetime, '%Y-%m') AS month,
        AVG(fare_amount) AS avg_fare
        FROM taxi
        GROUP BY DATE_FORMAT(tpep_pickup_datetime,'%Y-%m')
),
highest_month AS (
		SELECT month
        FROM monthly_averages
        ORDER BY avg_fare DESC
        LIMIT 1
),
median_tips AS (
	SELECT 
		tip_amount
	FROM ( 
      SELECT
			tip_amount,
            ROW_NUMBER() OVER(ORDER BY tip_amount) AS rn,
            COUNT(*) OVER() AS total_count
		FROM taxi
        WHERE DATE_FORMAT(tpep_pickup_datetime,'%Y-%m') = (SELECT month FROM highest_month)
) AS ranked
 WHERE rn IN (total_count / 2, total_count / 2 + 1)
)
SELECT AVG(tip_amount) AS median_tip_amount
FROM median_tips

-- 28.Find the top 3 DOLocationID with the highest average fare_amount for trips that have tip_amount less than $5

SELECT 
    DOLocationID, AVG(fare_amount) AS avg_fare
FROM
    taxi
WHERE
    tip_amount < 5
GROUP BY DOLocationID
ORDER BY avg_fare DESC
LIMIT 3

-- 29. Find the days with the highest average tip_amount and categorize these days as 'High','Medium',or'Low'based on the average 

WITH daily_avg_tips AS ( 
  SELECT 
	DATE(tpep_pickup_datetime) AS day,
    ROUND(AVG(tip_amount)*100,2) AS avg_tip
FROM taxi
GROUP BY DATE(tpep_pickup_datetime)
)
 SELECT 
    day,
    avg_tip,
    CASE 
		WHEN avg_tip < 5 THEN 'Low'
        WHEN avg_tip BETWEEN 5 AND 15 THEN 'Medium'
        ELSE 'High'
	END AS tip_category
FROM daily_avg_tips
ORDER BY avg_tip DESC

-- 30.Calculate nthe difference between the maximum and minimum fare amount for each day and rank the days based on this difference

SELECT 
	DATE(tpep_pickup_datetime) AS pickup_date,
    MAX(fare_amount) - MIN(fare_amount) AS fare_diff,
    RANK() OVER(ORDER BY MAX(fare_amount) - MIN(fare_amount) DESC) AS day_rank
FROM taxi
GROUP BY DATE(tpep_pickup_datetime)

-- 31.Determine the average total_amount for trips categorized as 'High based on categorized as
-- 'High' based on fare_amount and compare it with the overall average

SELECT 
    AVG(total_amount) AS avg_high_fare_total,
    AVG(total_amount) - (
        SELECT AVG(total_amount) FROM taxi
    ) AS comparison_with_overall_avg
FROM taxi
WHERE fare_amount > (
    SELECT AVG(fare_amount) FROM taxi
);

-- 32.Determine the fare amount with the heighest tip for each PULocationID and categorize these fares based on tip amount ranges  

SELECT
	PULocationID, fare_amount,tip_amount,
    CASE 
		WHEN tip_amount < 5 THEN 'Low Tip'
        WHEN tip_amount BETWEEN 5 AND 15 THEN 'Medium Tip'
        ELSE 'High tip'
        END AS tip_Category
	FROM taxi
    WHERE tip_amount =  (
			SELECT MAX(tip_amount)
            FROM taxi AS t2
            WHERE t2.PULocationID = taxi.PULocationID
)

-- 33.Determine the percentage of trips where fare_amount is greater than the average fare amount for 
-- trip with a tip_amount greater than $10

SELECT 
   (COUNT(CASE WHEN fare_amount > (
       SELECT AVG(fare_amount) FROM taxi
       ) THEN 1 END) / COUNT(*)) * 100 AS percentage_above_avg
FROM taxi
WHERE tip_amount > 10

-- 34.Calculate the average fare_amount for trips with a tolls_amount in the top 25% and categorize the trips by store_and_fwd_flag

WITH top_25_percent_tolls AS (
	 SELECT
		tolls_amount,
        PERCENT_RANK() OVER(ORDER BY tolls_amount DESC) AS percentile
        FROM taxi
)
SELECT 
	store_and_fwd_flag,
    AVG(fare_amount) AS avg_fare
FROM taxi
JOIN top_25_percent_tolls ttp ON taxi.tolls_amount = ttp.tolls_amount
WHERE ttp.percentile <= 0.25
GROUP BY store_and_fwd_flag

-- 35.Find the VendorID with the highest average total_amount for trips where the congestion_surchare is greater
-- than 1.00 and categorize them as 'High' if their average total_amount is above $50 otherwise categorize them as 'Low'

SELECT VendorID,
		AVG(total_amount) AS avg_total_amount,
        CASE
			WHEN AVG(total_amount) > 50 THEN 'High'
            ELSE 'Low'
		END AS category
FROM taxi
WHERE congestion_surcharge > 1.00
GROUP BY VendorID
ORDER BY avg_total_amount DESC
LIMIT 1