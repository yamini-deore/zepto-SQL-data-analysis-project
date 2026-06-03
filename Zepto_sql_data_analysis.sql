DROP TABLE IF EXISTS ZEPTO;

USE `zepto-sql`;

CREATE TABLE ZEPTO (
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountpercent numeric(5,2),
availableQuantity integer,
discountsellingprice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);

-- data exploration

-- count of rows
select *  from zepto_v2
limit 10;
SHOW TABLES;

-- null values

select * from zepto_v2
where name is null;

-- different product category

select distinct category from zepto_v2
order by category;

-- products in stock vs out of stock
SHOW COLUMNS FROM zepto_v2;
SELECT outOfStock, COUNT(*)
FROM zepto_v2
GROUP BY outOfStock;

-- PRODUCT NAMES PRESENT MULTIPLE TIMES

SELECT * FROM ZEPTO_V2;

SELECT NAME,COUNT(*) AS "NUMBER OF skuS" FROM ZEPTO_V2
GROUP BY NAME
HAVING COUNT(*)>1
ORDER BY count(*) DESC;

-- DATA CLEANING

-- PRODUCTS WITH PRICE = 0
SELECT  * from zepto_v2
where mrp=0 or discountedsellingprice =0;

SELECT COUNT(*)
FROM zepto_v2
WHERE mrp = 0;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM zepto_v2
WHERE mrp = 0;


-- convert paisee to rupees
 update zepto_v2
 set mrp= mrp/100.0,
 discountedsellingprice=discountedsellingprice/100.0;
 
 select mrp,discountedsellingprice from zepto_v2;

-- Business Questions

-- Q1. Find the top 10 best-value products based on the discount percentage.(highest value)
SELECT DISTINCT name, mrp, discountPercent
FROM zepto_v2
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name, mrp
FROM zepto_v2
WHERE outOfStock = 'TRUE'
  AND mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto_v2
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto_v2
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto_v2
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto_v2
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto_v2;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto_v2
GROUP BY category
ORDER BY total_weight;



 

