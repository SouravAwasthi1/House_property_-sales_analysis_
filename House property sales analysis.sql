-- Important Questions--

-- Q1: Which date corresponds to the highest number of sales? 
SELECT Datesold,
    COUNT(*) AS NumberOfSales FROM raw_sales
GROUP BY
    Datesold
ORDER BY
    NumberOfSales DESC
LIMIT 1;


-- Q2: Which year witnessed the lowest number of sales?-- 
select year(datesold) as saleyear, count(*) as Numberofsales from raw_sales
group by saleyear
order by Numberofsales limit 1

-- Q3: Find out the postcode with the highest average price per sale? 
SELECT
    postcode,
    AVG(price) AS AveragePrice FROM raw_sales
GROUP BY
    postcode
ORDER BY
    AveragePrice DESC
LIMIT 1;

-- Q4: Use the window function to deduce the top six postcodes by year's price.-- 

WITH RankedPostcodes AS (
    SELECT Postcode, YEAR(Datesold) AS SaleYear, Price,
        ROW_NUMBER() OVER (PARTITION BY YEAR(Datesold) ORDER BY Price DESC) AS RowNum
    FROM raw_sales)
SELECT Postcode, SaleYear, Price FROM RankedPostcodes
WHERE RowNum <= 6
ORDER BY SaleYear, RowNum;

-- Basic SQL Queries:
-- Q1: Retrieve all columns from the "raw_sales" table for properties with more than 3 bedrooms.

select * from sales 
where bedrooms >= 3

-- Q2 Find the property with the highest price and display its details.
select propertyType, price from raw_sales
order by price desc limit 1

-- Q3 : List the unique postcodes in the dataset.
select distinct(postcode) from raw_sales

-- Filtering and Sorting: 

-- Q4: Retrieve the 10 most recent property sales based on the "Datesold" column.

select * from raw_sales
order by datesold desc limit 10

-- Q5 : Find the top 5 most expensive property sales.
select propertyType, price from raw_sales
order by price desc  limit 5

-- Q6: Retrieve properties more than & equal 3 bedrooms and a price between 7000000 and 8000000
select * from raw_sales 
where bedrooms >= 3
and price between 7000000 and 8000000

-- Aggregation and Grouping:

-- Q7:Find the total number of properties sold in each month

 select month(datesold) as saleMonth,count(*) NumberOfSales from raw_sales
 group by saleMonth
 order by NumberOfSales 
 
--  Q8: Calculate the median price for properties with 2, 3, 4, and 5 bedrooms.

WITH BedroomMedian AS (
    SELECT Bedrooms, Price,
        ROW_NUMBER() OVER (PARTITION BY Bedrooms ORDER BY Price) AS RowAsc,
        ROW_NUMBER() OVER (PARTITION BY Bedrooms ORDER BY Price DESC) AS RowDesc
    FROM raw_sales
    WHERE Bedrooms IN (2, 3, 4, 5))
SELECT Bedrooms, AVG(Price) AS MedianPrice
FROM BedroomMedian
WHERE
    RowAsc = RowDesc OR RowAsc + 1 = RowDesc OR RowAsc = RowDesc + 1
GROUP BY Bedrooms;


-- Data Transformation:
-- Q9 : Calculate the price per bedroom for each property.

select *, price / bedrooms as PricePerBedroom
from raw_sales

-- Q10: Categorize properties into price ranges (e.g., low, medium, high) based on their sale price.
select price,
case
when price > 400000 then "high"
when price >= 200000 and price <=400000 then "medium"
else "low"
end as PriceRange
from raw_sales
