-- SQL Retail Sales Analysis - P1

-- CREATE TABLE
CREATE TABLE RETAIL_SALES
             (
              transactions_id INT PRIMARY KEY, 
	          sale_date DATE,
	          sale_time TIME,
	          customer_id INT,
	          gender VARCHAR(15),	
	          age INT,	
	          category VARCHAR(15),
	          quantity INT,
	          price_per_unit FLOAT,	
	          cogs FLOAT,	
	          total_sale FLOAT
              );

SELECT * FROM RETAIL_SALES
LIMIT 10;

SELECT COUNT (*) FROM RETAIL_SALES

--- DATA CLEANING {CHECKING FOR NULL VALUES AND DELETING THEM}
SELECT * FROM RETAIL_SALES
WHERE TRANSACTIONS_ID IS NULL

--AGE WAS NOT SELECTED HERE
SELECT * FROM RETAIL_SALES
WHERE SALE_DATE IS NULL
OR SALE_TIME IS NULL
OR CUSTOMER_ID IS NULL
OR GENDER IS NULL
OR CATEGORY IS NULL
OR QUANTITY IS NULL
OR PRICE_PER_UNIT IS NULL
OR COGS IS NULL
OR TOTAL_SALE IS NULL

DELETE FROM RETAIL_SALES
WHERE SALE_DATE IS NULL
OR SALE_TIME IS NULL
OR CUSTOMER_ID IS NULL
OR GENDER IS NULL
OR CATEGORY IS NULL
OR QUANTITY IS NULL
OR PRICE_PER_UNIT IS NULL
OR COGS IS NULL
OR TOTAL_SALE IS NULL

SELECT COUNT (*) FROM RETAIL_SALES

-- DATA EXPLORATION
-- HOW MUCH SALES DO WE HAVE?
SELECT COUNT (*)AS TOTAL_SALES FROM RETAIL_SALES 

--HOW MANY UNIQUE CUSTOMERS DO WE HAVE? {Same customer may make multiple purchases}
SELECT COUNT (DISTINCT CUSTOMER_ID)AS TOTAL_CUSTOMERS FROM RETAIL_SALES

--DISTINCT CATEGORIES
SELECT COUNT (DISTINCT CATEGORY)AS CATEGORIES FROM RETAIL_SALES
SELECT DISTINCT CATEGORY AS CATEGORIES FROM RETAIL_SALES

-- DATA ANALYSIS
--1. RETRIEVE ALL SALES MADE ON 5TH NOV
SELECT * FROM RETAIL_SALES
WHERE SALE_DATE = '2022-11-05';

--2.RETRIEVE ALL DATA WHERE CATEGORY IS CLOTHING AND QTY SOLD IS MORE
--THAN 4 IN THE MONTH OF NOV 2022

-- Case-insensitive match

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND
TO_CHAR(sale_date,'YYYY-MM')='2022-11'
AND
QUANTITY >=4

--3 CALCULATE TOTAL SALES FOR EACH CATEGORY
SELECT Category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM RETAIL_SALES
GROUP BY Category

--4 AVG AGE OF CUSTOMERS WHO PURCHASED FROM BEAUTY CATEGORY
SELECT 
ROUND(AVG (age),2) as AVERAGE_AGE
FROM RETAIL_SALES
WHERE Category = 'Beauty'

--5 ALL TRANSACTIONS WHERE TOTAL SALES IS > 1000
SELECT * FROM RETAIL_SALES
WHERE Total_sale > 1000

--6 TOTAL TRANSACTIONS (TRANSACTIONS_ID) MADE BY EACH GENDER IN EACH CATEGORY
SELECT
   category,
   gender,
   COUNT(*) as TOTAL_TRANSACTIONS
FROM RETAIL_SALES
GROUP BY
  category,
  gender
ORDER BY category  

--7 CALCULATE AVG SALES FOR EACH MONTH AND BEST SELLING MONTH IN EACH YEAR
SELECT 
    YEAR,
	MONTH,
	AVERAGE_SALES	
FROM
(
  SELECT
  EXTRACT (YEAR FROM sale_date) as YEAR,
  EXTRACT (MONTH FROM sale_date) as MONTH,
  AVG(total_sale) as AVERAGE_SALES,
  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC)
  FROM RETAIL_SALES
  GROUP BY 1,2
) AS T1
WHERE rank =1

--8 TOP 5 CUSTOMERS BASED ON HIGHEST TOTAL SALES

SELECT
  customer_id,
  SUM(total_sale) as total_sales
FROM RETAIL_SALES
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--9 NUMBER OF UNIQUE CUSTOMERS WHO HAVE PURCHASED ITEMS FROM EACH CATEGORY
SELECT 
  category,
  COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMERS
FROM RETAIL_SALES
GROUP BY 1

--10 CREATE EACH SHIFT AND NUMBER OF ORDERS
--MORNING <=12 ; AFTERNOON 12-17 ; EVENING >17

WITH HOURLY_SALE
AS
(
SELECT *,
CASE
   WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'MORNING'
   WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
   ELSE 'EVENING'
  END AS SHIFT
FROM RETAIL_SALES
)
SELECT 
  SHIFT,
  COUNT (*)AS TOTAL_ORDERS
FROM HOURLY_SALE
GROUP BY SHIFT



