-- Create the database for the Online Bookstore
CREATE DATABASE OnlineBookstore;

-- Use the OnlineBookstore database
USE OnlineBookstore;

-- Create the Authors table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL
);

-- Insert data into Authors table
INSERT INTO Authors
(AuthorID,AuthorName)
VALUES
(2411032,"William Shakespeare"),
(2311740,"George Orwell"),
(2411872,"J.K. Rowling"),
(2111018,"R K Narayan"),
(2411096,"William Faulkner");
select * from Authors order by AuthorID Asc;

-- Create the Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    PriceInDollar DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
    On update cascade
    on delete cascade
);
-- Insert data into Books Table
INSERT INTO Books
(BookID,Title,AuthorID,PriceInDollar,StockQuantity)
VALUES
(701,"The Tragedie of Romeo and Juliet",2411032,6.65,100),
(702,"The Tragedy of Macbeth",2411032,4.65,80),
(703,"Nineteen Eighty-Four",2311740,9.65,100),
(704,"Animal Farm",2311740,10.0,20),
(705,"Politics and the English Language",2311740,5.65,100),
(706,"Harry Potter and the Philosopher's Stone",2411872,8.0,50),
(707,"The Running Grave",2411872,3.65,70),
(708,"Malgudi Days",2111018,7.65,25),
(709,"Swami and Friends",2111018,2.67,75),
(710,"The Sound and the Fury",2411096,12.50,100);
select * from Books order by BookId asc;

-- Create the Customers table
CREATE TABLE Customers  (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE
);

-- Insert data into Customers table
INSERT INTO Customers
(CustomerID,CustomerName,Email)
VALUES
(2211086,"Ansh Girdher","Anshgirdher173@gmail.com"),
(2211087,"Ammy Doomra","Ammydoomra786@gmail.com"),
(2211094,"Lavish Garg","lavishgarg23@gmail.com"),
(2211096,"Ridham Goyal","ridhamgoyal89@gmail.com"),
(2211033,"Paras Sharma","sharma67@gmail.com"),
(2211034,"Rohit Khurana","rk6754@gmail.com"),
(2211055,"Vansh Sharma","vansh2456@gmail.com"),
(2211097,"Angel Doomra","Angeldoomra789@gmail.com"),
(2211011,"Amit Doomra","Amit890@gmail.com"),
(2211003,"Jyoti","jyotigaba63@gmail.com");

-- Again Insert Data Into Customers
INSERT INTO Customers VALUES (2211093,"Rana Watts","ranawatts67@gmail.com");
Select * from Customers order by customerID asc;

-- Create the Orders table
CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    On UPDATE CASCADE
    ON DELETE CASCADE
    
);

-- Insert data Into Orders table
INSERT INTO Orders
(OrderID,CustomerID,Orderdate)
VALUES
(2401,2211086,"2024-01-03"),
(2402,2211087,"2024-01-03"),
(2403,2211094,"2023-12-30"),
(2404,2211096,"2023-09-03"),
(2405,2211033,"2023-09-26"),
(2406,2211034,"2024-01-01"),
(2407,2211055,"2024-01-02"),
(2408,2211097,"2022-04-08"),
(2409,2211011,"2023-11-09"),
(2410,2211003,"2023-09-30");
INSERT INTO Orders VALUES (2411,2211093,"2024-01-03");
Select * from Orders order by Orderdate asc;

-- Create the OrderItems table
CREATE TABLE OrderItems (
	Book_Name Varchar(70) NOT NULL,
    OrderItemID INT,
    OrderID INT,
    BookID INT,
    Quantity INT DEFAULT 1,
    TotalPrice_In_Dollar DECIMAL(10, 2) NOT NULL,
    City Varchar(80) NOT NULL,
    PRIMARY KEY(OrderItemID,OrderID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- Insert data into OrderItems
INSERT INTO OrderItems
(book_Name,OrderItemID,OrderID,City,BookID,Quantity,TotalPrice_In_Dollar)
VALUES
("The Tragedie of Romeo and Juliet",401,2401,"Sri Muktsar Sahib",702,1,6.65),
("The Tragedie of Romeo and Juliet",401,2402,"Jalalabad",702,1,6.65),
("Nineteen Eighty-Four",402,2405,"Sri Muktsar Sahib",703,1,9.65),
("Harry Potter and the Philosopher's Stone",403,2410,"Jalalabad",706,1,8.0),
("Politics and the English Language",404,2409,"Jalalabad",705,1,5.65),
("Politics and the English Language",404,2408,"Jalalabad",705,1,5.65);

-- Turn off Update Safe Mode
SET sql_safe_updates=0;

-- Update data into orderitems
UPDATE orderitems
SET BookID=701
where book_Name="The Tragedie of Romeo and Juliet";
Select * from Orderitems;

-- Again Insert Data Into Orderitems
INSERT INTO OrderItems
(book_Name,OrderItemID,OrderID,City,BookID,Quantity,TotalPrice_In_Dollar)
VALUES
("Malgudi Days",405,2403,"Bangalore",708,1,8.65), 
("Swami and Friends",406,2404,"Bangalore",709,1,2.67), 
("The Running Grave",403,2406,"Bangalore",707,1,3.65), 
("Malgudi Days",405,2407,"Bangalore",708,1,8.65), 
("The Tragedie of Romeo and Juliet",401,2411,"Malout",701,1,6.65);


-- Query to retrieve customer order history
SELECT Customers.CustomerName,OrderItems.City,Orders.OrderID, Orders.OrderDate, Books.Title As Title_of_the_book, OrderItems.Quantity, OrderItems.TotalPrice_In_Dollar AS Total_Price_In_Dollar
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
JOIN Books ON OrderItems.BookID = Books.BookID
ORDER BY Orders.OrderDate DESC;

-- Query to retrieve popular books
SELECT Books.Title, COUNT(OrderItems.BookID) AS SalesCount
FROM OrderItems
JOIN Books ON OrderItems.BookID = Books.BookID
GROUP BY Books.Title
ORDER BY SalesCount DESC
LIMIT 5;

-- Query to retrieve best-selling authors
SELECT Authors.AuthorName, COUNT(Books.BookID) AS SalesCount
FROM OrderItems
JOIN Books ON OrderItems.BookID = Books.BookID
JOIN Authors ON Books.AuthorID = Authors.AuthorID
GROUP BY Authors.AuthorName
ORDER BY SalesCount desc;

-- Creating Views for Bangalore Branch
CREATE VIEW Bangalore_Branch As
SELECT Customers.CustomerName,OrderItems.City,Orders.OrderID, Orders.OrderDate, Books.Title, OrderItems.Quantity, OrderItems.TotalPrice_In_Dollar
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
JOIN Books ON OrderItems.BookID = Books.BookID
WHERE City IN("Bangalore")
ORDER BY Orders.OrderDate DESC;

SELECT * FROM Bangalore_Branch ORDER BY OrderID ASC;

SELECT * FROM Muktsar_Branch ORDER BY OrderID ASC;

-- Creating Views for Muktsar Branch
CREATE VIEW Muktsar_Branch As
SELECT Customers.CustomerName,OrderItems.City,Orders.OrderID, Orders.OrderDate, Books.Title, OrderItems.Quantity, OrderItems.TotalPrice_In_Dollar
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
JOIN Books ON OrderItems.BookID = Books.BookID
WHERE City IN("Sri Muktsar Sahib","Muktsar")
ORDER BY Orders.OrderDate DESC;

SELECT * fROM Muktsar_Branch ORDER BY OrderID ASC;

-- Creating Views for Jalalabad Branch
CREATE VIEW Jalalabad_Branch As
SELECT Customers.CustomerName,OrderItems.City,Orders.OrderID, Orders.OrderDate, Books.Title, OrderItems.Quantity, OrderItems.TotalPrice_In_Dollar
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
JOIN Books ON OrderItems.BookID = Books.BookID
WHERE City IN("Jalalabad") 
ORDER BY Orders.OrderDate DESC;

SELECT * fROM Jalalabad_Branch ORDER BY OrderID ASC;

-- Creating Views for Malout Branch
CREATE VIEW Malout_Branch As
SELECT Customers.CustomerName,OrderItems.City,Orders.OrderID, Orders.OrderDate, Books.Title, OrderItems.Quantity, OrderItems.TotalPrice_In_Dollar
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
JOIN Books ON OrderItems.BookID = Books.BookID
WHERE City IN("Malout") 
ORDER BY Orders.OrderDate DESC;

SELECT * FROM Malout_Branch ORDER BY OrderID ASC;
