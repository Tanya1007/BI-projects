-- ----------------------------------------------------------------------DATA WRANGLING-----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*CREATING AND USING A DATABASE*/
CREATE DATABASE salesDataWalmart;
USE salesDataWalmart;

/* CREATING A TABLE */

CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL (10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL (12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9) NOT NULL,
gross_income DECIMAL (12,4) NOT NULL,
rating FLOAT(2,1) NOT NULL
);

/* I HAVE INSERTED THE DATA USING THE IMPORT FUNCTION AND I USED A CSV FILE FOR THE DATASET */

/*VIEW ALL THE DATA */

Select * FROM salesdatawalmart.sales;

-- -------------------------------------------------------FEATURE ENGINEERING-----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* INSERTING A NEW COLUMN */
SELECT time,
(CASE
	WHEN `time` BETWEEN "00;00;00" AND "12;00;00" THEN "morning"
    WHEN `time`BETWEEN "12;00;00" AND "16;00;00" THEN "afternoon"
    ELSE "evening"
    END
    )
    AS time_of_date
    FROM sales;
    
 ALTER TABLE sales
 ADD COLUMN time_of_day VARCHAR(20);
 
 /* UPDATING NEW RECORDS */
 
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
    );
    
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);   
 
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);


Select * from sales;

-- -----------------------------------------------------------EXPLORATORY DATA ANALYSIS-----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ------1. How many unique cities does the data have?

SELECT DISTINCT city from sales;

SELECT COUNT(DISTINCT city) from sales;

/* WE HAVE 3 DIFFERENT CITIES. */

-- ------2. Which city has which branch?

SELECT DISTINCT city,
branch
FROM sales;

-- ------3. How many unique product lines does the data have?

SELECT DISTINCT product_line
FROM sales;

SELECT COUNT(DISTINCT product_line)
FROM sales;

/* WE HAVE 6 DIFFERENT PRODUCT LINES. */

-- ------4. What is the most common payment method?

SELECT payment_method, 
COUNT(payment_method) AS Cnt_of_payment_method
FROM sales
GROUP BY payment_method
ORDER BY Cnt_of_payment_method DESC;

/* WE CAN SEE HERE THAT CASH IS THE PAYMENT METHOD WHICH IS USED THE MOST AND CREDIT CARD IS THE PAYMENT METHOD WHICH IS USED VERY LESS */


-- ------5. What is the most selling product line?

SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

/* WE CAN SEE HERE THAT ELECTRONIC ACCESSORIES IS THE MOST SELLING PRODUCT LINE */

-- ------6. What is the total revenue by month?

SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;


-- ------7. What month had the largest COGS(Category of Goods Sold)?

SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs DESC;

/* IN JANUARY, THE LARGEST CATEGORY OF GOODS WERE SOLD. */


-- ------8. What product line had the largest revenue?

SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

/* FOOD AND BEVERAGES IS THE CATEGORY WHICH HAS GENERATED THE LARGEST REVENUE. */


-- ------9. What is the city with the largest revenue?

SELECT
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city 
ORDER BY total_revenue DESC;

/* NAYPYITAW IS THE CITY WITH THE LARGEST REVENUE */

-- ------10. What product line had the largest VAT?

SELECT
	product_line,
	AVG(VAT) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

/* HOME AND LIFESTYLE HAVE THE LARGEST TAX */

-- ------11. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	(CASE
		WHEN AVG(quantity) > 5.5 THEN "Good"
        ELSE "Bad"
    END)
    AS remark
FROM sales
GROUP BY product_line;

-- ------12. Which branch sold more products than average product sold?

SELECT branch,
SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING qty> 
(SELECT AVG(quantity) FROM sales);

/* BRANCH A SOLD THE MOST PRODUCTS THAN THE AVERAGE NUMBER OF PRODCUTS SOLD*/

-- ------13. What is the most common product line by gender

SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

/* AMONG FEMALES THE MOST COMMON PRODUCT LINE IS FASHION ACCESSORIES AND AMONG MALES IT IS HEALTH AND BEAUTY */

-- ------14. What is the average rating of each product line?

SELECT 
AVG(rating) as avg_rating, product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- ------15. What is the number of Sales made in each time of the day per weekday

SELECT
time_of_day, day_name,
COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day, day_name
ORDER BY total_sales DESC;

/* THERE ARE MORE SALES IN THE EVENING FOR MOST DAYS */

-- ------16. Which type of customer type brings the most revenue?

SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

/* MEMBER BRINGS THE MOST REVENUE */

-- ------17. Which city has the largest TAX percentage?

SELECT
	city,
    ROUND(AVG(VAT), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

/* NAYPYITAW HAS THE LARGEST VAT PERCENTAGE. */

-- ------18. Which customer type pays the most in VAT?

SELECT
	customer_type,
	AVG(VAT) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax DESC;

/* MEMBER PAYS THE MOST VAT. */


-- ------19. How many unique customer types does the data have?

SELECT
	COUNT(DISTINCT customer_type) AS count
FROM sales;

/* THERE ARE 2 CUSTOMER TYPES IN THIS DATASET. */


-- ------20. What is the most common customer type?

SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

/* THE MOST COMMON CUSTOMER TYPE IS MEMBER. */

-- ------21. Which customer type buys the most?

SELECT
	customer_type,
    COUNT(*) AS cstm_cnt
FROM sales
GROUP BY customer_type;

/* MEMBER BUYS THE MOST. */


-- ------22. What is the gender of most of the customers?

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

/* MALES BUY THE MOST. */


-- ------23. What is the gender distribution per branch?

SELECT
	gender, branch,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender, branch
ORDER BY gender_cnt DESC;

/* HIGHEST NUMBER OF MALES ARE IN BRANCH A AND HIGHEST NUMBER OF FEMALES ARE IN BRANCH C;

-- ------24. Which time of the day do customers give most ratings. */

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

/* PEOPLE GIVE THE MOST RATING IN AFTERNOON. */

-- ------25. Which time of the day do customers give most ratings per branch?

SELECT
	time_of_day, branch,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;


-- ------26. Which day of the week has the best avg ratings?

SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

/* MOST SALES WERE MADE ON MONDAY. */

-- ------27. Which day of the week has the best average ratings per branch?

SELECT 
	day_name, branch,
	COUNT(day_name) AS total_sales
FROM sales
GROUP BY day_name, branch
ORDER BY total_sales DESC;












