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
