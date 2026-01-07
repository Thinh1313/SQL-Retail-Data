-- DELETE exact duplicates (4 rows)
CREATE TABLE clean1 AS
SELECT *
FROM ( 
SELECT *,
	ROW_NUMBER() OVER (PARTITION BY Transaction_ID, Customer_ID, `Name`, Email, Phone, Address, CITY, State, Zipcode, Country, Age, Gender, Income, Customer_Segment, `Date`, `Year`, `Month`, `Time`, Total_purchases, Amount, total_amount, Product_category, product_brand, product_type, Feedback, Shipping_method, Payment_method, Order_status, ratings, products
					   ORDER BY transaction_id
                        ) AS rownumber
FROM retail.messy
) clean
WHERE rownumber = 1;

-- Delete transaction_ID nulls (333 rows)
DELETE 
FROM retail.clean1 
WHERE transaction_ID IS NULL



-- Two transaction_id duplicates
-- 1. Transaction_ID is the same. Everything in the row is the same besides a few columns
-- 2. Transaction_ID is the same. Everything else is different
-- Create a flag for transaction_id duplicates
ALTER TABLE clean1
ADD COLUMN transaction_duplicate INT DEFAULT 0;

UPDATE clean1
SET transaction_duplicate = 1
WHERE transaction_id IN (
	SELECT Transaction_ID
    FROM (SELECT Transaction_id, COUNT(*) OVER (PARTITION BY transaction_ID) AS dup_count
		  FROM retail.clean1
    ) table1
	WHERE dup_count > 1
);


-- IDENTIFY type of flag
ALTER TABLE clean1
ADD COLUMN same_transactionid_different_customer INT DEFAULT 0;

ALTER TABLE clean1
ADD COLUMN same_transactionid_different_info INT DEFAULT 0;

UPDATE retail.clean1
SET same_transactionid_different_customer = 1
WHERE transaction_id IN (
	SELECT transaction_id FROM(
		SELECT transaction_id
		FROM retail.clean1
		GROUP BY transaction_id
		HAVING COUNT(DISTINCT(customer_id)) > 1
    ) table1
);
    
UPDATE retail.clean1
SET same_transactionid_different_info = 1
WHERE transaction_duplicate = 1 AND same_transactionid_different_customer = 0

CREATE VIEW flagged_data AS
SELECT * FROM retail.clean1
WHERE transaction_duplicate = 1;

CREATE TABLE clean2 AS
SELECT * FROM retail.clean1
WHERE transaction_duplicate = 0;

ALTER TABLE clean2
DROP COLUMN rownumber,
DROP COLUMN transaction_duplicate,
DROP COLUMN same_transactionid_different_customer,
DROP COLUMN same_transactionid_different_info;


