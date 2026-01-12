-- Data Modeling

-- Customer Table
CREATE TABLE customer(
customer_id INT AUTO_INCREMENT PRIMARY KEY,
`Name` VARCHAR(100),
`Email` VARCHAR(100), 
Phone VARCHAR(100), 
Address VARCHAR(100), 
Country VARCHAR(100),
Age INT,
Gender VARCHAR(100),
Income VARCHAR(100),
Customer_Segment VARCHAR(100)
);

INSERT INTO customer(
`Name`,`Email`, Phone, Address, Country, Age, Gender, Income, Customer_Segment)
SELECT DISTINCT `Name`,`Email`, Phone, Address, Country, Age, Gender, Income, Customer_Segment
FROM retail.clean2;



-- Product Table
CREATE TABLE Product(
product_id INT AUTO_INCREMENT PRIMARY KEY,
Product_Category VARCHAR(100),
Product_Brand VARCHAR(100),
Product_Type VARCHAR(100),
products VARCHAR(100)
);

INSERT INTO Product(
Product_Category, product_brand, product_type, products)
SELECT DISTINCT product_category, product_brand, product_type, products
FROM retail.clean2
WHERE products IS NOT NULL;


-- Transaction Table (Bridge)
CREATE TABLE Transactions(
Transaction_id INT PRIMARY KEY,
Customer_id INT,
product_id INT,
`Date` DATE,
`time` TIME,
Amount DOUBLE,
total_amount DOUBLE,
Feedback VARCHAR(100),
Shipping_method VARCHAR(100),
Payment_method VARCHAR(100),
Order_status VARCHAR(100),
Ratings INT,

FOREIGN KEY (Customer_id) REFERENCES customer(customer_id),
FOREIGN KEY (product_id) REFERENCES product(product_id)
);

INSERT INTO transactions(
transaction_id,
customer_id,
product_id,
`Date`,
`Time`,
Amount,
total_amount,
Feedback,
Shipping_method,
payment_method,
order_status,
Ratings
)
SELECT rc.transaction_id, c.customer_id, p.product_id, rc.`Date`, rc.`Time`, rc.amount, rc.total_amount, rc.feedback, rc.shipping_method, rc.payment_method, rc.order_status, rc.ratings
FROM retail.clean2 rc
JOIN customer c
ON rc.`name` = c.`name`
AND rc.Email = c.email
AND rc.phone = c.phone
AND rc.Address = c.address
JOIN product p 
ON rc.product_category = p.product_category
AND rc.product_brand = p.product_brand
AND rc.product_type = p.product_type
AND rc.products = p.products;

