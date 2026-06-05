-- Phase 5 DML 2 & 3

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


-- 4.3.2. Data Aggregation and Subqueries (Group by & Subqueries)

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

-- SQL Views

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