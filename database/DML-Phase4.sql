-- Phase 4: Data Manipulation Language (DML) - 

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