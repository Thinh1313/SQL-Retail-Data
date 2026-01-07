-- CREATE DATABASE Retail
CREATE DATABASE retail;
USE retail;

-- Create Table
CREATE TABLE messy(Transaction_ID int,
					  Customer_ID int,
                      Name VARCHAR(100),
                      Email VARCHAR(100),
                      Phone Bigint,
                      Address VARCHAR(100),
                      CITY VARCHAR(100),
                      State VARCHAR(100),
                      Zipcode int,
                      Country VARCHAR(100),
                      Age int,
                      Gender VARCHAR(100),
                      Income VARCHAR(100),
                      Customer_Segment VARCHAR(100),
                      Date VARCHAR(100),
                      Year int,
                      Month VARCHAR(100),
                      Time VARCHAR(100),
                      Total_purchases int,
                      Amount DOUBLE,
                      total_amount DOUBLE,
                      Product_Category VARCHAR(100),
                      Product_Brand VARCHAR(100),
                      Product_Type VARCHAR(100),
                      Feedback VARCHAR(100),
                      Shipping_Method VARCHAR(100),
                      Payment_Method VARCHAR(100),
                      Order_status VARCHAR(100),
                      Ratings int,
                      products VARCHAR(100));
                      

-- Import CSV data into Messy Table         
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Proj6DataMessy.csv'
INTO TABLE messy
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;                      
