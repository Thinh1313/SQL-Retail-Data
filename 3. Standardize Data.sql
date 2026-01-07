-- Standardize Data
SELECT * FROM retail.clean2 

-- Assign `date` as date data type and match year and month to `date`
ALTER TABLE retail.clean2
ADD COLUMN date_new DATE;

UPDATE retail.clean2
SET date_new = STR_TO_DATE(`Date`,'%m/%d/%Y');

ALTER TABLE retail.clean2
DROP COLUMN `Date`;

ALTER TABLE retail.clean2
MODIFY COLUMN date_new DATE AFTER Customer_Segment;

ALTER TABLE retail.clean2
RENAME COLUMN date_new TO `Date`;

-- Correct year values
UPDATE retail.clean2
SET `Year` = YEAR(`Date`)
WHERE `Date` IS NOT NULL;

-- Correct month values
UPDATE retail.clean2
SET `Month` = MONTHNAME(`Date`)
WHERE `Date` IS NOT NULL;


-- Fill in nulls for amount, total_amount, and total_purchases
UPDATE retail.clean2
SET Total_purchases = total_amount / Amount
WHERE total_amount IS NOT NULL AND amount IS NOT NULL AND total_purchases IS NULL;

UPDATE retail.clean2
SET Amount = total_amount / Total_purchases
WHERE total_amount IS NOT NULL AND total_purchases IS NOT NULL and Amount IS NULL;

UPDATE retail.clean2
SET total_amount = total_purchases * amount
WHERE amount IS NOT NULL AND total_purchases IS NOT NULL AND total_amount IS NULL;


UPDATE retail.clean2
SET amount = ROUND(amount,2)
WHERE amount IS NOT NULL;

UPDATE retail.clean2
SET total_amount = ROUND(total_amount,2)
WHERE total_amount IS NOT NULL;


-- FIX NULLs for product category, brand, and type
-- Product_type has no NULLs. Assign product_category values by evaluating its brand.
-- Home Decor (Bed Bath & Beyond, Home Depot, IKEA), Grocery(Pepsi, Coca-Cola, Nestle), Electronics(Samsung, Sony, Apple, Whirepool, Mitsubhisi, Bluestar), Clothing(Zara, Nike, Adidas),Books(HarperCollins,Penguin Books, Random House)


-- Fill in product_category Nulls first
UPDATE retail.clean2
SET product_category = "Home Decor"
WHERE product_category IS NULL AND product_brand IN("Bed Bath & Beyond", "Home Depot", "IKEA");

UPDATE retail.clean2
SET product_category = "Grocery"
WHERE product_category IS NULL AND product_brand IN ("Pepsi","Coca-Cola","Nestle");

UPDATE retail.clean2
SET product_category = "Electronics"
WHERE product_category IS NULL AND product_brand IN ("Samsung","Apple","Sony","Whirepool","Mitsubhisi","Bluestar");

UPDATE retail.clean2
SET product_category = "Clothing"
WHERE product_category IS NULL AND product_brand IN ("Zara","Adidas","Nike");

UPDATE retail.clean2
SET product_category = "Books"
WHERE product_category IS NULL AND product_brand IN ("Penguin Books","Random House","HarperCollins");


-- UNIQUE in each product_type
-- BB&B(Kitchen, Bedding, Bathroom), IKEA(Lighting), Home Depot(Tools)
-- Nestle (Coffee, Chocolate, Snacks)
-- Whirepool(Fridge), Mitsubhisi(Mitsubhisi 1.5 Ton 3 Star Split AC), Sony(Headphones), Apple(Laptop), Bluestar(BlueStar AC)
-- Zara(Shirt,Jeans,Dress), Nike(Shorts), Adidas(Jacket)
-- Penguin Books(Children's), HarperCollins(Thriller), Random House(Literature)

-- Books
UPDATE retail.clean2
SET product_brand = "HarperCollins"
WHERE product_brand IS NULL AND product_type = "Thriller";

UPDATE retail.clean2
SET product_brand = "Penguin Books"
WHERE product_brand IS NULL AND product_type = "Children's";

UPDATE retail.clean2
SET product_brand = "Random House"
WHERE product_brand IS NULL AND product_type = "Literature";

-- Clothes
UPDATE retail.clean2
SET product_brand = "Zara"
WHERE product_brand IS NULL AND product_type IN("Shirt","Jeans","Dress");

UPDATE retail.clean2
SET product_brand = "Nike"
WHERE product_brand IS NULL AND product_type = "Shorts";

UPDATE retail.clean2
SET product_brand = "Adidas"
WHERE product_brand IS NULL AND product_type = "Jacket";

-- Electronics
UPDATE retail.clean2
SET product_brand = "Whirepool"
WHERE product_brand IS NULL AND product_type = "Fridge";

UPDATE retail.clean2
SET product_brand = "Mitsubhisi"
WHERE product_brand IS NULL AND product_type = "Mitsubhisi 1.5 Ton 3 Star Split AC";

UPDATE retail.clean2
SET product_brand = "Sony"
WHERE product_brand IS NULL AND product_type = "Headphones";

UPDATE retail.clean2
SET product_brand = "Apple"
WHERE product_brand IS NULL AND product_type = "Laptop";

UPDATE retail.clean2
SET product_brand = "Bluestar"
WHERE product_brand IS NULL AND product_type = "BlueStar AC";

-- Home Decor
UPDATE retail.clean2
SET product_brand = "Bed Bath & Beyond"
WHERE product_brand IS NULL AND product_type IN ("Kitchen","Bedding","Bathroom")

UPDATE retail.clean2
SET product_brand = "IKEA"
WHERE product_brand IS NULL AND product_type = "Lighting";

UPDATE retail.clean2
SET product_brand = "Home Depot"
WHERE product_brand IS NULL AND product_type = "Tools";

-- Grocery
UPDATE retail.clean2
SET product_brand = "Nestle"
WHERE product_brand IS NULL AND product_type IN("Coffee","Snacks","Chocolate");


-- When Feedback is NULL, rating is also NULL. Meaning that customer most likely didn't leave a review.
UPDATE retail.clean2
SET Feedback = "NA"
WHERE Feedback IS NULL;

UPDATE retail.clean2
SET Gender = "Unknown"
WHERE Gender IS NULL;

-- Feedback and Rating follow a pattern. Bad(1), Average(2), Good(3 or 4), Excellent(4 or 5)


UPDATE retail.clean2
SET ratings = 3.5
WHERE Feedback = "Good" AND ratings IS NULL;

UPDATE retail.clean2
SET ratings = 4.5
WHERE Feedback = "Excellent" AND ratings IS NULL;

-- Turn time column from VARCHAR into Time data type.
SELECT `Time`
FROM retail.clean2
WHERE `time` IS NOT NULL AND `time` NOT REGEXP '^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$';

ALTER TABLE retail.clean2
MODIFY `time` TIME;
