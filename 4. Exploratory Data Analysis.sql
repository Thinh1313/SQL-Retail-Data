-- Exploratory Data Analysis

-- Find the amount of nulls for each column.
SELECT
	SUM(Transaction_id IS NULL) AS transaction_ID_NULLs,
    SUM(Customer_ID IS NULL) AS Customer_ID_NULLs,
    SUM(`Name` IS NULL) AS Name_NULLs,
    SUM(Email IS NULL) AS Email_NULLs,
    SUM(Phone IS NULL) AS Phone_NULLs,
	SUM(Address IS NULL) AS Address_NULLs,
    SUM(CITY IS NULL) AS CITY_NULLs,
    SUM(State IS NULL) AS State_NULLs,
    SUM(Zipcode IS NULL) AS Zipcode_NULLs,
    SUM(Country IS NULL) AS Country_NULLs,
	SUM(Age IS NULL) AS Age_NULLs,
    SUM(Gender IS NULL) AS Gender_NULLs,
    SUM(Income IS NULL) AS Income_NULLs,
    SUM(Customer_Segment IS NULL) AS Customer_Segment_NULLs,
    SUM(`Date` IS NULL) AS Date_NULLs,
	SUM(`Year` IS NULL) AS Year_NULLs,
    SUM(`Month` IS NULL) AS Month_NULLs,
    SUM(`Time` IS NULL) AS Time_NULLs,
    SUM(Total_purchases IS NULL) AS Total_purchases_NULLs,
    SUM(Amount IS NULL) AS Amount_NULLs,
	SUM(total_amount IS NULL) AS total_amount_NULLs,
    SUM(product_category IS NULL) AS product_category_NULLs,
    SUM(product_brand IS NULL) AS product_brand_NULLs,
    SUM(product_type IS NULL) AS product_type_NULLs,
    SUM(Feedback IS NULL) AS Feedback_NULLs,
	SUM(Shipping_method IS NULL) AS Shipping_method_NULLs,
    SUM(payment_method IS NULL) AS Payment_method_NULLs,
    SUM(order_status IS NULL) AS Order_status_NULLs,
    SUM(Ratings IS NULL) AS Ratings_NULLs,
    SUM(products IS NULL) AS products_NULLs
FROM retail.clean2


-- Each transaction in this dataset is a unique transaction.
SELECT COUNT(*) AS row_amount, COUNT(DISTINCT(Transaction_ID)) AS Unique_transactions
FROM retail.clean2

-- Customer_ID is not unique meaning that multiple customers can have the same customer_IDs.
SELECT Customer_ID, COUNT(DISTINCT(`Name`)) AS Name_Count
FROM retail.clean2
WHERE customer_ID IS NOT NULL
GROUP BY Customer_ID
HAVING Name_Count > 1

-- USA largely leads in transactions followed by UK, Germany, Australia, and Canada
SELECT COUNTRY, COUNT(*) AS Transaction_amount
FROM retail.clean2
GROUP BY Country
ORDER BY transaction_amount DESC;

-- There aren't any errors in total_amount, Amount, or total_purchases
SELECT *
FROM retail.clean1
WHERE total_amount IS NOT NULL AND Amount IS NOT NULL AND Total_purchases IS NOT NULL AND ABS(total_amount - (Amount * Total_purchases)) > 0.05;
  
-- Minimum age is 18 and maximum age is 70 
SELECT MIN(age) AS Youngest, MAX(age) AS Oldest, COUNT(*) AS total_transactions, SUM(AGE < 13) AS under_13, SUM(AGE BETWEEN 13 AND 17) AS teens, SUM(AGE > 100) AS over_100
FROM retail.clean2;

-- premium does not mean highest income. Most customers fall into regular customer segment and have low to medium income.
SELECT customer_segment, Income, COUNT(*) AS amount
FROM retail.clean2
WHERE customer_segment IS NOT NULL AND Income IS NOT NULL
GROUP BY customer_segment, Income
ORDER BY amount DESC;

-- Transactions largely occured during 2023. Transactions throughout the months were evenly distributed.
SELECT `Year`, COUNT(*) AS transaction_count
FROM retail.clean2
GROUP BY `Year`
ORDER BY transaction_count DESC;

SELECT `Month`, COUNT(*) AS transaction_count
FROM retail.clean2
GROUP BY `Month`
ORDER BY transaction_count DESC;

SELECT HOUR(`time`) AS `Hour`, COUNT(*) AS amount
FROM retail.clean2
GROUP BY `Hour`
ORDER BY amount DESC;

-- View distribution of order status from all transactions. View feedback amount from all transactions.
SELECT order_status, COUNT(*) AS amount
FROM retail.clean2
GROUP BY order_status
ORDER BY amount DESC;
  
SELECT Feedback, ROUND(AVG(ratings),2) AS average_rating, COUNT(*) AS `Count`
FROM retail.clean2
WHERE Feedback IS NOT NULL AND ratings IS NOT NULL
GROUP BY Feedback
ORDER BY average_rating DESC;

-- City and State are broken and not useful data. Many city values had large amounts of incorrect state values.
-- Don't use city and state columns in analysis
SELECT Country, CITY, State, count(*) AS amount
FROM retail.clean2
WHERE city = "San Diego"
GROUP BY Country, CITY, State
ORDER BY amount DESC;