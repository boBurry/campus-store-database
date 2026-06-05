-- ==============================================================
-- PHASE 3: DATA DEFINITION LANGUAGE (DDL) & SCHEMA CREATION
-- ==============================================================

CREATE DATABASE tcsDB;
USE tcsDB;

CREATE TABLE Accounts (
	AccountID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM("Admin", "Cashier", "Customer") NOT NULL, 
    isActive BOOL NOT NULL DEFAULT TRUE
);
describe Accounts;

CREATE TABLE Customers (
	CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT UNIQUE NOT NULL,
    InstitutionalID VARCHAR(20) UNIQUE NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Major VARCHAR(50),
    CustomerType ENUM("Student", "Faculty") NOT NULL DEFAULT "Student",
    VerificationStatus ENUM("Pending", "Verified","Rejected") NOT NULL DEFAULT "Pending",
    RewardPoints INT NOT NULL DEFAULT 0,
    isActive BOOL NOT NULL DEFAULT TRUE,
    
	FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON UPDATE CASCADE ON DELETE RESTRICT
);
describe Customers;

CREATE TABLE Suppliers (
	SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100) , 
	Phone VARCHAR(20) NOT NULL
);
describe Suppliers;

CREATE TABLE Categories (
	CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) UNIQUE NOT NULL
);
describe Categories;

CREATE TABLE Products (
	ProductID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryID INT NOT NULL,
    SupplierID INT NOT NULL,
    Title VARCHAR(150) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0 ),
    StockQuantity INT NOT NULL DEFAULT 0 CHECK (StockQuantity >= 0),
    ReorderLevel INT NOT NULL DEFAULT 10 CHECK (ReorderLevel >= 0),
    ItemCondition ENUM("New", "Used") NOT NULL DEFAULT "New",
    isActive BOOL NOT NULL DEFAULT TRUE,
    
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON UPDATE CASCADE ON DELETE RESTRICT
);
describe Products;

CREATE TABLE Promotions (
	PromoID INT PRIMARY KEY AUTO_INCREMENT,
    PromoCode VARCHAR(20) UNIQUE NOT NULL,
    DiscountPercentage DECIMAL(5,2) NOT NULL CHECK (DiscountPercentage > 0 AND DiscountPercentage <= 100),
    ValidFrom DATETIME,
    ValidUntil DATETIME,
	isActive BOOL NOT NULL DEFAULT TRUE,
    
    CHECK (ValidUntil > ValidFrom)
);
describe Promotions;

CREATE TABLE Inventory_Logs (
	LogID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    AccountID INT NOT NULL,
    ChangeType ENUM("Sale", "Restock", "Damage") NOT NULL,
    QuantityChanged INT NOT NULL CHECK (QuantityChanged != 0),
    LogDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
	FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON UPDATE CASCADE ON DELETE RESTRICT
);
describe Inventory_Logs;

CREATE TABLE Pickup_Locations (
	LocationID INT PRIMARY KEY AUTO_INCREMENT,
    LocationName VARCHAR(100) NOT NULL,
    Description VARCHAR(255)
);
describe Pickup_Locations;

CREATE TABLE Cash_Drawers (
	DrawerID INT PRIMARY KEY AUTO_INCREMENT,
    LocationID INT NOT NULL,
    OpenedBy_AccountID INT NOT NULL,
    OpenTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    CloseTime DATETIME,
    StartingBalance DECIMAL (10,2) NOT NULL CHECK (StartingBalance >= 0),
    ActualEndingBalance DECIMAL (10,2) CHECK (ActualEndingBalance >= 0),
    
    CHECK (CloseTime > OpenTime),
    FOREIGN KEY (LocationID) REFERENCES Pickup_Locations(LocationID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (OpenedBy_AccountID) REFERENCES Accounts(AccountID) ON UPDATE CASCADE ON DELETE RESTRICT
);
describe Cash_Drawers;

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NULL,
    LocationID INT NOT NULL,
    PromoID INT,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (TotalAmount >= 0),
    OrderStatus ENUM("Pending", "Ready", "Completed", "Cancelled") DEFAULT "Pending",
    
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (LocationID) REFERENCES Pickup_Locations(LocationID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (PromoID) REFERENCES Promotions(PromoID) ON UPDATE CASCADE ON DELETE RESTRICT
);
describe Orders;

CREATE TABLE Order_Items (
	OrderID INT NOT NULL,
    ProductID INT NOT NULL, 
    Quantity INT NOT NULL DEFAULT 1 CHECK (Quantity > 0),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON UPDATE CASCADE ON DELETE RESTRICT
);
describe Order_Items;

CREATE TABLE Payments (
	PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    DrawerID INT,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod ENUM("Cash", "KHQR") NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentStatus ENUM("Completed", "Pending", "Failed") DEFAULT "Completed",
    
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (DrawerID) REFERENCES Cash_Drawers(DrawerID) ON UPDATE CASCADE ON DELETE RESTRICT
);
describe Payments;

CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment VARCHAR(500),
    ReviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON UPDATE CASCADE  ON DELETE RESTRICT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON UPDATE CASCADE ON DELETE RESTRICT
);
describe Reviews;

-- Check Constraint 
SELECT 
    CONSTRAINT_CATALOG, 
    CONSTRAINT_SCHEMA, 
    CONSTRAINT_NAME, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    CONSTRAINT_TYPE, 
    ENFORCED
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'tcsDB';

-- Foreign Key Constraint
SELECT 
    kcu.CONSTRAINT_SCHEMA, 
    kcu.CONSTRAINT_NAME, 
    kcu.TABLE_NAME, 
    kcu.COLUMN_NAME, 
    kcu.REFERENCED_TABLE_NAME, 
    kcu.REFERENCED_COLUMN_NAME, 
    rc.UPDATE_RULE, 
    rc.DELETE_RULE
FROM information_schema.KEY_COLUMN_USAGE kcu
JOIN information_schema.REFERENTIAL_CONSTRAINTS rc 
    ON kcu.CONSTRAINT_NAME = rc.CONSTRAINT_NAME 
    AND kcu.CONSTRAINT_SCHEMA = rc.CONSTRAINT_SCHEMA
WHERE kcu.TABLE_SCHEMA = 'tcsDB' 
  AND kcu.REFERENCED_TABLE_NAME IS NOT NULL;
  
-- Logic Constraint
SELECT 
    cc.CONSTRAINT_SCHEMA, 
    cc.CONSTRAINT_NAME, 
    tc.TABLE_NAME, 
    tc.CONSTRAINT_TYPE, 
    cc.CHECK_CLAUSE
FROM information_schema.CHECK_CONSTRAINTS cc
JOIN information_schema.TABLE_CONSTRAINTS tc 
    ON cc.CONSTRAINT_NAME = tc.CONSTRAINT_NAME 
    AND cc.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
WHERE cc.CONSTRAINT_SCHEMA = 'tcsDB';

-- ==============================================================
-- PHASE 4: DATA MANIPULATION LANGUAGE (DML) - SEEDING
-- ==============================================================

USE tcsDB;

-- SECTION 1: INDEPENDENT TABLE SEEDING

-- 1. Accounts
INSERT INTO Accounts (Username, PasswordHash, Role, isActive) VALUES 
('admin_sal', SHA2('password1', 256), 'Admin', 1),
('admin_ousaphea', SHA2('password2', 256), 'Admin', 1),
('cashier_rathanak', SHA2('password3', 256), 'Cashier', 1),
('student_jingpo', SHA2('password4', 256), 'Customer', 1),
('student_sopheary', SHA2('password5', 256), 'Customer', 1),
('student_vannara', SHA2('password6', 256), 'Customer', 1),
('student_vireak', SHA2('password7', 256), 'Customer', 1),
('faculty_dara', SHA2('password8', 256), 'Customer', 1);

-- 2. Categories
INSERT INTO Categories (CategoryName) VALUES 
('Engineering Textbooks'),
('Stationery & Supplies'),
('ITC Merchandise'),
('Electronics & Accessories');

-- 3. Suppliers
INSERT INTO Suppliers (CompanyName, ContactName, Phone) VALUES 
('ITC University Press', 'Dr. Chea', '012345678'),
('Phnom Penh Tech Distrib', 'Sokheng', '098765432'),
('Cambodia Campus Gear', 'Vannak', '011223344'),
('6$ Bookstore','Rangsey','098123321');

-- 4. Pickup Locations
INSERT INTO Pickup_Locations (LocationName, Description) VALUES 
('5 Makara Entrance', 'Fast pickup near the ITC front entrance.'),
('Building J', 'Convenient pickup for GIC students.');

-- 5. Promotions
INSERT INTO Promotions (PromoCode, DiscountPercentage, ValidFrom, ValidUntil) VALUES 
('MIDTERM5', 10.00, '2026-05-15 00:00:00', '2026-05-30 00:00:00'),
('WELCOME-S2-2026', 5.00, '2026-02-01 00:00:00', '2026-07-01 00:00:00');

-- SECTION 2: DEPENDENT TABLE SEEDING

-- 6. Customers 
INSERT INTO Customers (AccountID, InstitutionalID, FullName, Email, Major, CustomerType, VerificationStatus) VALUES 
(4, 'e20230182', 'PHAI Jingpo', 'jingpo@itc.edu.kh', 'GIC', 'Student', 'Verified'),
(5, 'e20230244', 'RIN Sopheary', 'sopheary@itc.edu.kh', 'GIC', 'Student', 'Verified'),
(6, 'e20230241', 'PHUONG Sovannara', 'sovannara@itc.edu.kh', 'GIC', 'Student', 'Verified'),
(7, 'e20231004', 'SOK Vireak', 'sokvireak@itc.edu.kh', 'GIC', 'Student', 'Verified'),
(8, 'f20150099', 'DARA Sok', 'dara@itc.edu.kh', NULL, 'Faculty', 'Pending');

-- 7. Products 
INSERT INTO Products (CategoryID, SupplierID, Title, Price, StockQuantity, ReorderLevel, ItemCondition) VALUES 
(1, 1, 'Introduction to Relational Algebra', 25.50, 0, 10, 'New'),
(1, 4, 'C++ Object-Oriented Programming Vol 2', 15.00, 0, 10, 'Used'),
(2, 3, 'Premium Graphing Notebook', 3.50, 0, 30, 'New'),
(3, 3, 'ITC Circular Blue Logo T-Shirt', 12.00, 0, 15, 'New'),
(4, 2, 'USB-C Fast Charging Cable', 8.00, 0, 10, 'New'),
(1, 4, 'Organic Chemistry', 13.00, 0, 10, 'New'),
(1, 4, 'Statistics for Engineers', 10.00, 0, 10, 'New');

-- SECTION 3: DAILY SETUP & INVENTORY INITIALIZATION

-- 8. Open Cash Drawer
-- Simulates opening the register for the start of the business day
INSERT INTO Cash_Drawers (LocationID, OpenedBy_AccountID, StartingBalance) 
VALUES (1, 3, 100.00);

-- 9. Initial Inventory Restock Logs
-- Records administrative receiving of supplier deliveries
INSERT INTO Inventory_Logs (ProductID, AccountID, ChangeType, QuantityChanged) VALUES 
(1, 1, 'Restock', 10),   
(2, 1, 'Restock', 5),    
(3, 1, 'Restock', 100),  
(4, 1, 'Restock', 10),   
(5, 1, 'Restock', 20),
(6, 1, 'Restock', 20),   
(7, 1, 'Restock', 20);   

-- 10. Manual Inventory Updates
-- Manually syncing product stock quantities 
UPDATE Products SET StockQuantity = StockQuantity + 10  WHERE ProductID = 1; 
UPDATE Products SET StockQuantity = StockQuantity + 5   WHERE ProductID = 2;  
UPDATE Products SET StockQuantity = StockQuantity + 100 WHERE ProductID = 3;  
UPDATE Products SET StockQuantity = StockQuantity + 10  WHERE ProductID = 4;  
UPDATE Products SET StockQuantity = StockQuantity + 20  WHERE ProductID = 5;  
UPDATE Products SET StockQuantity = StockQuantity + 20  WHERE ProductID = 6;  
UPDATE Products SET StockQuantity = StockQuantity + 20  WHERE ProductID = 7;  

-- SECTION 4: (ORDER PROCESSING)

-- 11. Create Orders
-- Generates order parent records; TotalAmount defaults to 0.00
INSERT INTO Orders (CustomerID, LocationID, PromoID, OrderStatus) VALUES 
(1, 1, 1, 'Completed'),   
(2, 2, NULL, 'Completed'),  
(3, 1, 2, 'Completed'),   
(4, 2, NULL, 'Completed');  

-- 12. Add Order Items
-- Links products and quantities to specific orders, calculating manual subtotals
INSERT INTO Order_Items (OrderID, ProductID, Quantity, Subtotal) VALUES 
(1, 1, 1, 25.50), 
(1, 3, 2, 7.00),  
(2, 4, 1, 12.00), 
(3, 6, 1, 13.00), 
(4, 7, 1, 13.00), 
(4, 2, 1, 12.00); -- Manual 20% discount applied for 'Used' item condition

-- 13. Update Order Totals
-- calculate subtotals and applies promotional percentage logic
UPDATE Orders SET TotalAmount = 29.25 WHERE OrderID = 1; 
UPDATE Orders SET TotalAmount = 12.00 WHERE OrderID = 2; 
UPDATE Orders SET TotalAmount = 12.35 WHERE OrderID = 3; 
UPDATE Orders SET TotalAmount = 25.00 WHERE OrderID = 4; 

-- 14. Process Payments
-- Records finalized settlement of order totals via Cash or KHQR
INSERT INTO Payments (OrderID, DrawerID, PaymentMethod, Amount, PaymentStatus) VALUES 
(1, NULL, 'KHQR', 29.25, 'Completed'), 
(2, 1, 'Cash', 12.00, 'Completed'),      
(3, NULL, 'KHQR', 12.35, 'Completed'), 
(4, 1, 'Cash', 25.00, 'Completed');      

-- SECTION 5: POST-SALE OPERATIONS & CUSTOMER SATISFACTION

-- 15. Insert Inventory Logs (Sales)
INSERT INTO Inventory_Logs (ProductID, AccountID, ChangeType, QuantityChanged) VALUES 
(1, 4, 'Sale', -1),   -- Digital KHQR Purchase
(3, 4, 'Sale', -2),   -- Digital KHQR Purchase
(6, 6, 'Sale', -1),   -- Digital KHQR Purchase
(4, 3, 'Sale', -1),   -- In-Store Cash Purchase
(7, 3, 'Sale', -1),   -- In-Store Cash Purchase
(2, 3, 'Sale', -1);   -- In-Store Cash Purchase

-- 16. Manual Inventory Updates (Sales Deductions)
-- Deducting sold quantities from the Products table
UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 1;  
UPDATE Products SET StockQuantity = StockQuantity - 2 WHERE ProductID = 3;  
UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 4;  
UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 6;  
UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 7;  
UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 2; 

-- 17. Close the Cash Drawer
-- Simulates End of day Operation
UPDATE Cash_Drawers 
SET 
    CloseTime = CONCAT(CURDATE(), ' 17:30:00'), 
    ActualEndingBalance = 137.00
WHERE DrawerID = 1;

-- 18. Product Reviews
-- Records customer feedback on purchased items
INSERT INTO Reviews (ProductID, CustomerID, Rating, Comment) VALUES 
(1, 1, 5, 'Perfect book for database class! Highly recommended.'),
(4, 2, 4, 'Comfortable material, but I wish it came in a darker blue.'),
(6, 3, 5, 'Great condition, very helpful for my chemistry assignments.'),
(2, 4, 4, 'Solid examples on linked lists, exactly what I needed for practice.');

-- Section 6: Data Retrieval 

-- Account Operations
-- View all user accounts and their assigned roles
SELECT Username, Role FROM Accounts;

-- Customer Operations
-- Find specific types of customers (Students vs. Faculty) and active users
SELECT * FROM Customers WHERE CustomerType = 'Student';
SELECT * FROM Customers WHERE CustomerType = 'Faculty';
SELECT * FROM Customers WHERE isActive = TRUE;

-- Product Operations
-- Low Stock Alert: Find items that need to be restocked soon
SELECT Title, StockQuantity, ReorderLevel 
FROM Products 
WHERE StockQuantity < ReorderLevel;

-- Show used items that are currently for sale
SELECT Title, Price, StockQuantity 
FROM Products 
WHERE ItemCondition = 'Used' AND isActive = TRUE;

-- Find items above or below specific price points
SELECT * FROM Products WHERE Price > 10.00;
SELECT * FROM Products WHERE Price < 5.00;

-- Promotion Operations
-- Show active discounts from highest to lowest percentage
SELECT * FROM Promotions 
WHERE isActive = 1 
ORDER BY DiscountPercentage DESC;

-- Order Operations
-- Show all completed orders in order of date
SELECT OrderID, CustomerID, TotalAmount, OrderStatus 
FROM Orders 
WHERE OrderStatus = 'Completed'
ORDER BY OrderDate ASC;

-- Find all orders where the customer used a discount code
SELECT * FROM Orders WHERE PromoID IS NOT NULL;

-- Payment Operations
-- Show all customer payments from highest to lowest
SELECT * FROM Payments ORDER BY Amount DESC;

-- Inventory Log Operations
-- View the history of stock changes (Sales vs. Restocks)
SELECT * FROM Inventory_Logs ORDER BY LogDate DESC;
SELECT * FROM Inventory_Logs WHERE ChangeType = 'Sale';
SELECT * FROM Inventory_Logs WHERE ChangeType = 'Restock';

-- Update Reward Point to each Customers
UPDATE Customers c
LEFT JOIN (
    SELECT CustomerID, SUM(TotalAmount) AS TotalSpent
    FROM Orders
    WHERE OrderStatus = 'Completed'
    GROUP BY CustomerID
) AS OrderTotals ON c.CustomerID = OrderTotals.CustomerID
SET c.RewardPoints = COALESCE(FLOOR(OrderTotals.TotalSpent / 5), 0);

-- ==============================================================
-- PHASE 5: DATA MANIPULATION LANGUAGE (DML) 2 & 3 - ADVANCED QUERIES
-- ==============================================================

-- View full customer profile alongside their account credentials and roles
SELECT c.CustomerID, c.FullName, c.Email, c.Major, c.CustomerType, c.VerificationStatus, c.RewardPoints, a.Username, a.Role, a.isActive AS AccountActive 
FROM Customers c 
JOIN Accounts a ON c.AccountID = a.AccountID;

-- Find customers within a specific reward point range
SELECT FullName, RewardPoints 
FROM Customers 
WHERE RewardPoints BETWEEN 5 AND 100;

-- Full product list with category and supplier names
SELECT p.ProductID, p.Title, p.Price, p.StockQuantity, p.ItemCondition, p.isActive, c.CategoryName, s.CompanyName AS SupplierName 
FROM Products p 
JOIN Categories c ON p.CategoryID = c.CategoryID 
JOIN Suppliers s ON p.SupplierID = s.SupplierID 
ORDER BY p.ProductID;

-- Show only active products that customers can buy right now
SELECT p.Title, p.Price, p.StockQuantity, c.CategoryName, s.CompanyName 
FROM Products p 
JOIN Categories c ON p.CategoryID = c.CategoryID 
JOIN Suppliers s ON p.SupplierID = s.SupplierID 
WHERE p.isActive = TRUE;

-- Find active used items for sale
SELECT p.Title, p.Price, s.CompanyName 
FROM Products p 
JOIN Suppliers s ON p.SupplierID = s.SupplierID 
WHERE p.ItemCondition = 'Used' AND p.isActive = TRUE;

-- Filter for all Engineering textbooks currently in the system
SELECT p.Title, p.Price, p.ItemCondition 
FROM Products p 
JOIN Categories c ON p.CategoryID = c.CategoryID 
WHERE c.CategoryName = 'Textbooks';

-- Find products within a specific price range
SELECT p.Title, p.Price, c.CategoryName 
FROM Products p 
JOIN Categories c ON p.CategoryID = c.CategoryID 
WHERE p.Price BETWEEN 5.00 AND 20.00;

-- Search for any product containing the word Algebra
SELECT * FROM Products 
WHERE Title LIKE '%Algebra%';

-- View order details with customer names and pickup locations
SELECT o.OrderID, o.OrderDate, o.TotalAmount, o.OrderStatus, c.FullName AS CustomerName, pl.LocationName 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Pickup_Locations pl ON o.LocationID = pl.LocationID;

-- View orders with their applied promo codes
SELECT o.OrderID, o.TotalAmount, o.OrderStatus, c.FullName, pr.PromoCode, pr.DiscountPercentage 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Promotions pr ON o.PromoID = pr.PromoID;

-- Filter for orders that did not use promo discount
SELECT o.OrderID, o.TotalAmount, o.OrderStatus, c.FullName 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
WHERE o.PromoID IS NULL;

-- Show orders that are completed
SELECT o.OrderID, o.OrderDate, o.TotalAmount, o.OrderStatus, c.FullName, pl.LocationName 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Pickup_Locations pl ON o.LocationID = pl.LocationID 
WHERE o.OrderStatus IN ('Completed');

-- Find orders made between specific dates
SELECT o.OrderID, o.OrderDate, o.TotalAmount, c.FullName 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
WHERE o.OrderDate BETWEEN '2026-03-23' AND '2026-05-24';

-- View complete order history for a single specific customer
SELECT o.OrderID, o.OrderDate, o.TotalAmount, o.OrderStatus, pl.LocationName 
FROM Orders o 
JOIN Pickup_Locations pl ON o.LocationID = pl.LocationID 
WHERE o.CustomerID = 5;

-- Link order items to product names
SELECT oi.OrderID, p.Title, oi.Quantity, oi.Subtotal 
FROM Order_Items oi 
JOIN Products p ON oi.ProductID = p.ProductID 
ORDER BY oi.OrderID;

-- Detailed receipt showing customer, items, and total amount
SELECT o.OrderID, c.FullName AS Customer, p.Title AS Product, oi.Quantity, oi.Subtotal, o.TotalAmount, o.OrderStatus 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Order_Items oi ON o.OrderID = oi.OrderID 
JOIN Products p ON oi.ProductID = p.ProductID;

-- Create a detailed receipt for a specific order
SELECT p.Title, oi.Quantity, oi.Subtotal 
FROM Order_Items oi 
JOIN Products p ON oi.ProductID = p.ProductID 
WHERE oi.OrderID = 1;

-- Link a payment to its specific order total and status
SELECT pay.PaymentID, pay.PaymentDate, pay.Amount, pay.PaymentMethod, pay.PaymentStatus, o.OrderStatus, o.TotalAmount 
FROM Payments pay 
JOIN Orders o ON pay.OrderID = o.OrderID;

-- Identifies the specific cash drawer and location for a cash payment
SELECT pay.PaymentID, pay.Amount, pay.PaymentDate, cd.DrawerID, pl.LocationName 
FROM Payments pay 
JOIN Cash_Drawers cd ON pay.DrawerID = cd.DrawerID 
JOIN Pickup_Locations pl ON cd.LocationID = pl.LocationID 
WHERE pay.PaymentMethod = 'Cash' 
ORDER BY PaymentID ASC;

-- Financial view of, who is the customer, how much and how they pay
SELECT pay.PaymentID, c.FullName, pay.Amount, pay.PaymentMethod, pay.PaymentStatus 
FROM Payments pay 
JOIN Orders o ON pay.OrderID = o.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- Search specifically for failed payments
SELECT pay.PaymentID, c.FullName, pay.Amount, pay.PaymentMethod 
FROM Payments pay 
JOIN Orders o ON pay.OrderID = o.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID 
WHERE pay.PaymentStatus = 'Failed';

-- Complete history of all cash drawer shifts
SELECT cd.DrawerID, pl.LocationName, a.Username AS OpenedBy, cd.OpenTime, cd.CloseTime, cd.StartingBalance, cd.ActualEndingBalance 
FROM Cash_Drawers cd 
JOIN Pickup_Locations pl ON cd.LocationID = pl.LocationID 
JOIN Accounts a ON cd.OpenedBy_AccountID = a.AccountID;

-- Find any cash drawers that are still open
SELECT cd.DrawerID, pl.LocationName, a.Username, cd.OpenTime, cd.StartingBalance 
FROM Cash_Drawers cd 
JOIN Pickup_Locations pl ON cd.LocationID = pl.LocationID 
JOIN Accounts a ON cd.OpenedBy_AccountID = a.AccountID 
WHERE cd.CloseTime IS NULL;

-- View inventory changes and the employee who made them
SELECT il.LogID, p.Title AS Product, a.Username AS ModifiedBy, il.ChangeType, il.QuantityChanged, il.LogDate 
FROM Inventory_Logs il 
JOIN Products p ON il.ProductID = p.ProductID 
JOIN Accounts a ON il.AccountID = a.AccountID 
ORDER BY il.LogDate DESC;


-- ==============================================================
-- 4.3.2. Data Aggregation and Subqueries (Group by & Subqueries)
-- ==============================================================

-- Calculate total revenue from completed orders
SELECT SUM(TotalAmount) AS TotalRevenue 
FROM Orders 
WHERE OrderStatus = 'Completed';

-- Calculate the average dollar amount per order
SELECT FORMAT(AVG(TotalAmount), 2) AS AverageOrderAmount 
FROM Orders;

-- Show total orders and revenue for each day
SELECT DATE(OrderDate) AS Day, COUNT(*) AS TotalOrders, SUM(TotalAmount) AS DailyRevenue 
FROM Orders 
GROUP BY DATE(OrderDate) 
ORDER BY Day;

-- Show total orders and revenue for each month
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, COUNT(*) AS TotalOrders, SUM(TotalAmount) AS MonthlyRevenue 
FROM Orders 
GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
ORDER BY Year, Month;

-- Show total orders and revenue for each pickup location
SELECT pl.LocationName, COUNT(o.OrderID) AS TotalOrders, SUM(o.TotalAmount) AS TotalRevenue 
FROM Orders o 
JOIN Pickup_Locations pl ON o.LocationID = pl.LocationID 
GROUP BY pl.LocationName;

-- Find out which promo codes were used the most
SELECT pr.PromoCode, pr.DiscountPercentage, COUNT(o.OrderID) AS TimesUsed 
FROM Orders o 
JOIN Promotions pr ON o.PromoID = pr.PromoID 
GROUP BY pr.PromoID, pr.PromoCode, pr.DiscountPercentage;

-- Find the best-selling products
SELECT p.Title, SUM(oi.Quantity) AS TotalSold, SUM(oi.Subtotal) AS TotalRevenue 
FROM Order_Items oi 
JOIN Products p ON oi.ProductID = p.ProductID 
GROUP BY p.ProductID, p.Title 
ORDER BY TotalSold DESC;

-- Calculate the total dollar value of all products in stock
SELECT c.CategoryName, SUM(p.Price * p.StockQuantity) AS TotalStockValue 
FROM Products p 
JOIN Categories c ON c.CategoryID = p.CategoryID 
GROUP BY CategoryName 
ORDER BY TotalStockValue DESC;

-- Find products that have never been bought
SELECT p.ProductID, p.Title 
FROM Products p 
LEFT JOIN Order_Items oi ON p.ProductID = oi.ProductID 
WHERE oi.ProductID IS NULL;

-- Find low-stock items and see how many have been sold
SELECT p.Title, p.StockQuantity, p.ReorderLevel, SUM(oi.Quantity) AS TotalSold 
FROM Products p 
JOIN Order_Items oi ON p.ProductID = oi.ProductID 
GROUP BY p.ProductID, p.Title, p.StockQuantity, p.ReorderLevel 
HAVING p.StockQuantity < p.ReorderLevel 
ORDER BY TotalSold DESC;

-- Find items that need to be restocked and their supplier info
SELECT p.Title, p.StockQuantity, p.ReorderLevel, s.CompanyName, s.ContactName, s.Phone 
FROM Products p 
JOIN Suppliers s ON p.SupplierID = s.SupplierID 
WHERE p.StockQuantity < p.ReorderLevel;

-- Count how many active products need to be restocked
SELECT COUNT(*) AS ProductsNeedingRestock 
FROM Products 
WHERE StockQuantity < ReorderLevel AND isActive = TRUE;

-- Count products and find the average price in each category
SELECT c.CategoryName, COUNT(p.ProductID) AS TotalProducts, FORMAT(AVG(p.Price), 2) AS AveragePrice 
FROM Products p 
JOIN Categories c ON c.CategoryID = p.CategoryID 
GROUP BY CategoryName 
ORDER BY TotalProducts DESC;

-- Subquery: Find the most expensive product within each category
SELECT c.CategoryName, p1.Title, p1.Price 
FROM Products p1 
JOIN Categories c ON p1.CategoryID = c.CategoryID 
WHERE p1.Price = (SELECT MAX(p2.Price) FROM Products p2 WHERE p2.CategoryID = p1.CategoryID);

-- Count how many products each supplier provides
SELECT s.CompanyName, COUNT(p.ProductID) AS TotalProducts 
FROM Products p 
JOIN Suppliers s ON p.SupplierID = s.SupplierID 
GROUP BY s.CompanyName;

-- Find the average quantity of items sold per line item
SELECT AVG(Quantity) AS AvgQtyPerItem 
FROM Order_Items;

-- Count total users grouped by Student and Faculty
SELECT CustomerType, COUNT(*) AS TotalCustomers 
FROM Customers 
GROUP BY CustomerType;

-- Find out which customers have spent the most money
SELECT c.FullName, COUNT(o.OrderID) AS TotalOrders, SUM(o.TotalAmount) AS TotalSpent 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
GROUP BY c.CustomerID, c.FullName 
ORDER BY TotalSpent DESC;

-- Find the top 5 customers with the highest reward points
SELECT FullName, RewardPoints 
FROM Customers 
ORDER BY RewardPoints DESC 
LIMIT 5;

-- Compare average reward points by customer type
SELECT CustomerType, AVG(RewardPoints) AS AvgPoints 
FROM Customers 
GROUP BY CustomerType;

-- View all product reviews with customer names
SELECT r.ReviewID, p.Title AS Product, c.FullName AS Customer, r.Rating, r.Comment, r.ReviewDate 
FROM Reviews r 
JOIN Products p ON r.ProductID = p.ProductID 
JOIN Customers c ON r.CustomerID = c.CustomerID;

-- Find products that do not have any reviews yet
SELECT p.ProductID, p.Title 
FROM Products p 
LEFT JOIN Reviews r ON p.ProductID = r.ProductID 
WHERE r.ProductID IS NULL;

-- View the total number of inventory changes for each reason
SELECT p.Title, il.ChangeType, SUM(il.QuantityChanged) AS TotalQuantityChanged 
FROM Inventory_Logs il 
JOIN Products p ON il.ProductID = p.ProductID 
GROUP BY p.ProductID, p.Title, il.ChangeType;

-- See which Account(Staff/Customer) make the most inventory changes
SELECT a.Username, a.Role, COUNT(il.LogID) AS TotalChanges 
FROM Inventory_Logs il 
JOIN Accounts a ON il.AccountID = a.AccountID 
GROUP BY a.AccountID, a.Username, a.Role 
ORDER BY TotalChanges DESC;

-- View inventory changes by month and year
SELECT YEAR(LogDate) AS Year, MONTH(LogDate) AS Month, ChangeType, COUNT(*) AS TotalLogs 
FROM Inventory_Logs 
GROUP BY YEAR(LogDate), MONTH(LogDate), ChangeType 
ORDER BY Year, Month;

-- View the total cash collected by each cash drawer
SELECT cd.DrawerID, pl.LocationName, SUM(p.Amount) AS TotalCashCollected 
FROM Payments p 
JOIN Cash_Drawers cd ON p.DrawerID = cd.DrawerID 
JOIN Pickup_Locations pl ON cd.LocationID = pl.LocationID 
WHERE p.PaymentMethod = 'Cash' AND p.PaymentStatus = 'Completed' 
GROUP BY cd.DrawerID, pl.LocationName 
ORDER BY DrawerID ASC;

-- Compare how many times KHQR and Cash were used
SELECT PaymentMethod, COUNT(*) AS TotalTransactions, SUM(Amount) AS TotalAmount 
FROM Payments 
WHERE PaymentStatus = 'Completed' 
GROUP BY PaymentMethod;

-- Count payments by their status (Completed, Failed, etc.)
SELECT PaymentStatus, COUNT(*) AS Total, SUM(Amount) AS TotalAmount 
FROM Payments 
GROUP BY PaymentStatus;

-- Calculate what percentage of total revenue comes from each category
SELECT c.CategoryName, SUM(oi.Subtotal) AS CategoryRevenue, 
ROUND(SUM(oi.Subtotal) / (SELECT SUM(Subtotal) FROM Order_Items) * 100, 2) AS RevenuePercentage 
FROM Order_Items oi 
JOIN Products p ON oi.ProductID = p.ProductID 
JOIN Categories c ON p.CategoryID = c.CategoryID 
GROUP BY c.CategoryName 
ORDER BY CategoryRevenue DESC;

-- Calculate the exact amount of money a customer saved using a promo code
SELECT c.FullName, pr.PromoCode, pr.DiscountPercentage, o.TotalAmount AS FinalAmount, 
ROUND(o.TotalAmount / (1 - pr.DiscountPercentage / 100) - o.TotalAmount, 2) AS Savings 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Promotions pr ON o.PromoID = pr.PromoID 
WHERE o.OrderStatus = 'Completed';

-- Connect Orders, Customers, Locations, Items, and Payments
SELECT o.OrderID, c.FullName AS Customer, pl.LocationName AS PickupLocation, 
o.OrderDate, COUNT(oi.ProductID) AS TotalItems, o.TotalAmount, o.OrderStatus, 
pay.PaymentMethod, pay.PaymentStatus 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
JOIN Pickup_Locations pl ON o.LocationID = pl.LocationID 
JOIN Order_Items oi ON o.OrderID = oi.OrderID 
LEFT JOIN Payments pay ON pay.OrderID = o.OrderID 
GROUP BY o.OrderID, c.FullName, pl.LocationName, o.OrderDate, o.TotalAmount, o.OrderStatus, pay.PaymentMethod, pay.PaymentStatus
ORDER BY OrderDate ASC;

-- Ranks products from highest to lowest based on total revenue generated.
SELECT *, RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank 
FROM (
    SELECT p.ProductID, p.Title, SUM(oi.Subtotal) AS TotalRevenue 
    FROM Products AS p 
    JOIN Order_Items AS oi ON p.ProductID = oi.ProductID 
    GROUP BY p.ProductID, p.Title
) AS T;

-- Ranks the absolute highest spending customers across the entire store.
SELECT *, RANK() OVER (ORDER BY TotalSpent DESC) AS SpenderRank 
FROM (
    SELECT c.CustomerID, c.FullName, SUM(o.TotalAmount) AS TotalSpent 
    FROM Customers AS c 
    JOIN Orders AS o ON c.CustomerID = o.CustomerID 
    WHERE o.OrderStatus = 'Completed' 
    GROUP BY c.CustomerID, c.FullName
) AS T;

-- Creates independent spending leaderboards for Students and Faculty simultaneously.
SELECT * ,RANK() OVER (PARTITION BY CustomerType ORDER BY TotalSpent DESC) AS SpenderRank 
FROM (
    SELECT c.CustomerID, c.FullName, c.CustomerType, SUM(o.TotalAmount) AS TotalSpent 
    FROM Customers AS c 
    JOIN Orders AS o ON c.CustomerID = o.CustomerID 
    WHERE o.OrderStatus = 'Completed' 
    GROUP BY c.CustomerID, c.FullName, c.CustomerType
) AS T;

-- Creates independent bestseller leaderboards for every product category simultaneously.
SELECT *,
    RANK() OVER (PARTITION BY CategoryName ORDER BY TotalRevenue DESC) AS CategoryRank, 
    CategoryName, 
    Title AS Product, 
    TotalRevenue 
FROM (
    SELECT c.CategoryName, p.ProductID, p.Title, 
        SUM(oi.Subtotal) AS TotalRevenue 
    FROM Products p 
    JOIN Categories c ON p.CategoryID = c.CategoryID 
    JOIN Order_Items oi ON p.ProductID = oi.ProductID 
    JOIN Orders o ON oi.OrderID = o.OrderID
    WHERE o.OrderStatus = 'Completed' 
    GROUP BY c.CategoryName, p.ProductID, p.Title
) AS ProductSales;

-- ==============================================================
-- DATABASE VIEWS
-- ==============================================================

CREATE VIEW v_Active_Storefront AS
SELECT p.ProductID, p.Title, p.Price, p.StockQuantity, c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.isActive = TRUE;

SELECT * FROM v_Active_Storefront;


CREATE VIEW v_Low_Stock_Alerts AS
SELECT p.Title, p.StockQuantity, p.ReorderLevel, s.CompanyName, s.Phone
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.StockQuantity < p.ReorderLevel 
AND p.isActive = TRUE;

SELECT * FROM v_Low_Stock_Alerts;

CREATE VIEW v_Customer_Receipts AS
SELECT 
    o.OrderID, 
    o.OrderDate, 
    c.FullName AS Customer, 
    p.Title AS Product, 
    oi.Quantity, 
    oi.Subtotal, 
    o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
WHERE o.OrderStatus = 'Completed';

SELECT * FROM v_Customer_Receipts
ORDER BY OrderDate ASC;

CREATE OR REPLACE VIEW v_Student_Accounts AS
SELECT 
    CustomerID, 
    InstitutionalID, 
    FullName,
    Major,
    Email, 
    CustomerType, 
    RewardPoints
FROM Customers
WHERE CustomerType = 'Student'
WITH CHECK OPTION;

SELECT * FROM v_Student_Accounts; 

 -- View for the Past 7 Days
CREATE VIEW v_Sales_Past_7_Days AS
SELECT 
    o.OrderID,
    DATE(o.OrderDate) AS SaleDate,
    COALESCE(c.FullName, 'Walk-in Guest') AS CustomerName,
    o.TotalAmount
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderStatus = 'Completed'
  AND o.OrderDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
  AND o.OrderDate <= CURDATE();
SELECT * FROM v_Sales_Past_7_Days;

-- View to fetch completed sales from the 30 days prior to May 1, 2026
CREATE VIEW v_Sales_Past_30_Days AS
SELECT 
    o.OrderID,
    DATE(o.OrderDate) AS SaleDate,
    COALESCE(c.FullName, 'Walk-in Guest') AS CustomerName,
    o.TotalAmount
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderStatus = 'Completed'
  AND o.OrderDate >= DATE_SUB("2026-05-01", INTERVAL 30 DAY)
  AND o.OrderDate <= "2026-05-01";
SELECT * FROM v_Sales_Past_30_Days;