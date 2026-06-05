
-- MySQL dump 10.13  Distrib 8.0.43, for macos15.4 (arm64)
--
-- Host: 127.0.0.1    Database: tcsDB
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Accounts`
--

DROP TABLE IF EXISTS `Accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Accounts` (
  `AccountID` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `Role` enum('Admin','Cashier','Customer') NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`AccountID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Accounts`
--

LOCK TABLES `Accounts` WRITE;
/*!40000 ALTER TABLE `Accounts` DISABLE KEYS */;
INSERT INTO `Accounts` VALUES (1,'admin_sal','0b14d501a594442a01c6859541bcb3e8164d183d32937b851835442f69d5c94e','Admin',1),(2,'admin_ousaphea','6cf615d5bcaac778352a8f1f3360d23f02f34ec182e259897fd6ce485d7870d4','Admin',1),(3,'cashier_rathanak','5906ac361a137e2d286465cd6588ebb5ac3f5ae955001100bc41577c3d751764','Cashier',1),(4,'student_jingpo','b97873a40f73abedd8d685a7cd5e5f85e4a9cfb83eac26886640a0813850122b','Customer',1),(5,'student_sopheary','8b2c86ea9cf2ea4eb517fd1e06b74f399e7fec0fef92e3b482a6cf2e2b092023','Customer',1),(6,'student_vannara','598a1a400c1dfdf36974e69d7e1bc98593f2e15015eed8e9b7e47a83b31693d5','Customer',1),(7,'student_vireak','5860836e8f13fc9837539a597d4086bfc0299e54ad92148d54538b5c3feefb7c','Customer',1),(8,'faculty_dara','57f3ebab63f156fd8f776ba645a55d96360a15eeffc8b0e4afe4c05fa88219aa','Customer',1);
/*!40000 ALTER TABLE `Accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cash_Drawers`
--

DROP TABLE IF EXISTS `Cash_Drawers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cash_Drawers` (
  `DrawerID` int NOT NULL AUTO_INCREMENT,
  `LocationID` int NOT NULL,
  `OpenedBy_AccountID` int NOT NULL,
  `OpenTime` datetime DEFAULT CURRENT_TIMESTAMP,
  `CloseTime` datetime DEFAULT NULL,
  `StartingBalance` decimal(10,2) NOT NULL,
  `ActualEndingBalance` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`DrawerID`),
  KEY `LocationID` (`LocationID`),
  KEY `OpenedBy_AccountID` (`OpenedBy_AccountID`),
  CONSTRAINT `cash_drawers_ibfk_1` FOREIGN KEY (`LocationID`) REFERENCES `Pickup_Locations` (`LocationID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `cash_drawers_ibfk_2` FOREIGN KEY (`OpenedBy_AccountID`) REFERENCES `Accounts` (`AccountID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `cash_drawers_chk_1` CHECK ((`StartingBalance` >= 0)),
  CONSTRAINT `cash_drawers_chk_2` CHECK ((`ActualEndingBalance` >= 0)),
  CONSTRAINT `cash_drawers_chk_3` CHECK ((`CloseTime` > `OpenTime`))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cash_Drawers`
--

LOCK TABLES `Cash_Drawers` WRITE;
/*!40000 ALTER TABLE `Cash_Drawers` DISABLE KEYS */;
INSERT INTO `Cash_Drawers` VALUES (1,1,3,'2026-05-23 13:12:23','2026-05-23 17:30:00',100.00,137.00),(2,1,3,'2026-05-24 08:00:00','2026-05-24 18:00:00',100.00,125.50),(3,1,3,'2026-05-25 08:00:00','2026-05-25 18:00:00',100.00,108.00),(4,1,3,'2026-05-26 08:00:00','2026-05-26 18:00:00',100.00,112.00),(5,1,3,'2026-05-27 08:00:00','2026-05-27 18:00:00',100.00,124.00),(6,1,3,'2026-05-28 08:00:00','2026-05-28 18:00:00',100.00,116.63),(7,1,3,'2026-05-29 08:00:00','2026-05-29 18:00:00',100.00,113.00),(8,1,3,'2026-05-30 08:00:00','2026-05-30 18:00:00',100.00,110.00),(9,1,3,'2026-05-31 08:00:00','2026-05-31 18:00:00',100.00,118.00),(10,1,3,'2026-03-10 08:00:00','2026-03-10 18:00:00',100.00,100.00),(11,2,3,'2026-03-22 08:00:00','2026-03-22 18:00:00',100.00,112.00),(12,1,3,'2026-03-28 08:00:00','2026-03-28 18:00:00',100.00,100.00),(13,2,3,'2026-04-05 08:00:00','2026-04-05 18:00:00',100.00,116.00),(14,1,3,'2026-04-12 08:00:00','2026-04-12 18:00:00',100.00,100.00),(15,2,3,'2026-04-20 08:00:00','2026-04-20 18:00:00',100.00,138.50);
/*!40000 ALTER TABLE `Cash_Drawers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Categories`
--

DROP TABLE IF EXISTS `Categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categories` (
  `CategoryID` int NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(50) NOT NULL,
  PRIMARY KEY (`CategoryID`),
  UNIQUE KEY `CategoryName` (`CategoryName`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categories`
--

LOCK TABLES `Categories` WRITE;
/*!40000 ALTER TABLE `Categories` DISABLE KEYS */;
INSERT INTO `Categories` VALUES (4,'Electronics'),(3,'Merchandise'),(2,'Stationery'),(1,'Textbooks');
/*!40000 ALTER TABLE `Categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customers` (
  `CustomerID` int NOT NULL AUTO_INCREMENT,
  `AccountID` int NOT NULL,
  `InstitutionalID` varchar(20) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Major` varchar(50) DEFAULT NULL,
  `CustomerType` enum('Student','Faculty') NOT NULL DEFAULT 'Student',
  `VerificationStatus` enum('Pending','Verified','Rejected') NOT NULL DEFAULT 'Pending',
  `RewardPoints` int NOT NULL DEFAULT '0',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`CustomerID`),
  UNIQUE KEY `AccountID` (`AccountID`),
  UNIQUE KEY `InstitutionalID` (`InstitutionalID`),
  UNIQUE KEY `Email` (`Email`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`AccountID`) REFERENCES `Accounts` (`AccountID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customers`
--

LOCK TABLES `Customers` WRITE;
/*!40000 ALTER TABLE `Customers` DISABLE KEYS */;
INSERT INTO `Customers` VALUES (1,4,'e20230182','PHAI Jingpo','jingpo@itc.edu.kh','GIC','Student','Verified',22,1),(2,5,'e20230244','RIN Sopheary','sopheary@itc.edu.kh','GIC','Student','Verified',6,1),(3,6,'e20230241','PHUONG Sovannara','sovannara@itc.edu.kh','GIC','Student','Verified',13,1),(4,7,'e20231004','SOK Vireak','sokvireak@itc.edu.kh','GIC','Student','Verified',9,1),(5,8,'f20150099','DARA Sok','dara@itc.edu.kh',NULL,'Faculty','Verified',20,1);
/*!40000 ALTER TABLE `Customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Inventory_Logs`
--

DROP TABLE IF EXISTS `Inventory_Logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Inventory_Logs` (
  `LogID` int NOT NULL AUTO_INCREMENT,
  `ProductID` int NOT NULL,
  `AccountID` int NOT NULL,
  `ChangeType` enum('Sale','Restock','Damage') NOT NULL,
  `QuantityChanged` int NOT NULL,
  `LogDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LogID`),
  KEY `ProductID` (`ProductID`),
  KEY `AccountID` (`AccountID`),
  CONSTRAINT `inventory_logs_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `inventory_logs_ibfk_2` FOREIGN KEY (`AccountID`) REFERENCES `Accounts` (`AccountID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `inventory_logs_chk_1` CHECK ((`QuantityChanged` <> 0))
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Inventory_Logs`
--

LOCK TABLES `Inventory_Logs` WRITE;
/*!40000 ALTER TABLE `Inventory_Logs` DISABLE KEYS */;
INSERT INTO `Inventory_Logs` VALUES (1,1,1,'Restock',10,'2026-05-23 13:31:23'),(2,2,1,'Restock',5,'2026-05-23 13:31:23'),(3,3,1,'Restock',100,'2026-05-23 13:31:23'),(4,4,1,'Restock',10,'2026-05-23 13:31:23'),(5,6,1,'Restock',20,'2026-05-23 13:31:23'),(6,7,1,'Restock',20,'2026-05-23 13:31:23'),(7,1,4,'Sale',-1,'2026-05-23 13:50:55'),(8,3,4,'Sale',-2,'2026-05-23 13:50:55'),(9,6,6,'Sale',-1,'2026-05-23 13:50:55'),(10,4,3,'Sale',-1,'2026-05-23 13:50:55'),(11,7,3,'Sale',-1,'2026-05-23 13:50:55'),(12,2,3,'Sale',-1,'2026-05-23 13:50:55'),(13,4,4,'Sale',-1,'2026-05-24 09:15:00'),(14,3,4,'Sale',-1,'2026-05-24 09:15:00'),(15,1,3,'Sale',-1,'2026-05-24 14:20:00'),(16,6,6,'Sale',-1,'2026-05-25 10:05:00'),(17,7,6,'Sale',-1,'2026-05-25 10:05:00'),(18,5,3,'Sale',-1,'2026-05-25 16:45:00'),(19,3,8,'Sale',-3,'2026-05-26 11:30:00'),(20,2,3,'Sale',-1,'2026-05-26 15:00:00'),(21,1,5,'Sale',-1,'2026-05-27 09:00:00'),(22,4,3,'Sale',-2,'2026-05-27 12:30:00'),(23,5,7,'Sale',-1,'2026-05-28 10:15:00'),(24,3,3,'Sale',-5,'2026-05-28 14:00:00'),(25,4,4,'Sale',-1,'2026-05-29 11:45:00'),(26,6,3,'Sale',-1,'2026-05-29 15:30:00'),(27,2,6,'Sale',-1,'2026-05-30 08:30:00'),(28,7,3,'Sale',-1,'2026-05-30 13:20:00'),(29,1,8,'Sale',-1,'2026-05-31 09:10:00'),(30,6,8,'Sale',-1,'2026-05-31 09:10:00'),(31,4,3,'Sale',-1,'2026-05-31 16:00:00'),(32,5,3,'Sale',-1,'2026-05-31 16:00:00'),(33,7,6,'Sale',-1,'2026-05-31 17:07:00'),(34,4,3,'Sale',-1,'2026-03-22 14:16:00'),(35,2,3,'Sale',-1,'2026-03-28 09:11:00'),(36,5,3,'Sale',-2,'2026-04-05 10:46:00'),(37,7,3,'Sale',-1,'2026-04-12 14:21:00'),(38,3,3,'Sale',-2,'2026-04-12 14:21:00'),(39,1,3,'Sale',-1,'2026-04-20 16:31:00'),(40,6,3,'Sale',-1,'2026-04-20 16:31:00');
/*!40000 ALTER TABLE `Inventory_Logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Order_Items`
--

DROP TABLE IF EXISTS `Order_Items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Order_Items` (
  `OrderID` int NOT NULL,
  `ProductID` int NOT NULL,
  `Quantity` int NOT NULL DEFAULT '1',
  `Subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderID`,`ProductID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `Orders` (`OrderID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_items_chk_1` CHECK ((`Quantity` > 0)),
  CONSTRAINT `order_items_chk_2` CHECK ((`Subtotal` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Order_Items`
--

LOCK TABLES `Order_Items` WRITE;
/*!40000 ALTER TABLE `Order_Items` DISABLE KEYS */;
INSERT INTO `Order_Items` VALUES (1,1,1,25.50),(1,3,2,7.00),(2,4,1,12.00),(3,6,1,13.00),(4,2,1,12.00),(4,7,1,13.00),(5,3,1,3.50),(5,4,1,12.00),(6,1,1,25.50),(7,6,1,13.00),(7,7,1,10.00),(8,5,1,8.00),(9,3,3,10.50),(10,2,1,12.00),(11,1,1,25.50),(12,4,2,24.00),(13,5,1,8.00),(14,3,5,17.50),(15,4,1,12.00),(16,6,1,13.00),(17,2,1,12.00),(18,7,1,10.00),(19,1,1,25.50),(19,6,1,13.00),(20,4,1,12.00),(20,5,1,8.00),(21,7,1,10.00),(22,1,1,25.50),(22,3,1,3.50),(23,4,1,12.00),(24,2,1,15.00),(25,5,2,16.00),(26,3,2,7.00),(26,7,1,10.00),(27,1,1,25.50),(27,6,1,13.00);
/*!40000 ALTER TABLE `Order_Items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `CustomerID` int DEFAULT NULL,
  `LocationID` int NOT NULL,
  `PromoID` int DEFAULT NULL,
  `OrderDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TotalAmount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `OrderStatus` enum('Pending','Ready','Completed','Cancelled') DEFAULT 'Pending',
  PRIMARY KEY (`OrderID`),
  KEY `CustomerID` (`CustomerID`),
  KEY `LocationID` (`LocationID`),
  KEY `PromoID` (`PromoID`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`LocationID`) REFERENCES `Pickup_Locations` (`LocationID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`PromoID`) REFERENCES `Promotions` (`PromoID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `orders_chk_1` CHECK ((`TotalAmount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (1,1,1,1,'2026-05-23 13:34:41',29.25,'Completed'),(2,2,2,NULL,'2026-05-23 13:34:41',12.00,'Completed'),(3,3,1,2,'2026-05-23 13:34:41',12.35,'Completed'),(4,4,2,NULL,'2026-05-23 13:34:41',25.00,'Completed'),(5,1,1,1,'2026-05-24 09:15:00',13.95,'Completed'),(6,NULL,2,NULL,'2026-05-24 14:20:00',25.50,'Completed'),(7,3,1,2,'2026-05-25 10:05:00',21.85,'Completed'),(8,NULL,2,NULL,'2026-05-25 16:45:00',8.00,'Completed'),(9,5,1,NULL,'2026-05-26 11:30:00',10.50,'Completed'),(10,1,2,NULL,'2026-05-26 15:00:00',12.00,'Completed'),(11,2,1,1,'2026-05-27 09:00:00',22.95,'Completed'),(12,NULL,2,NULL,'2026-05-27 12:30:00',24.00,'Completed'),(13,4,1,NULL,'2026-05-28 10:15:00',8.00,'Completed'),(14,5,2,2,'2026-05-28 14:00:00',16.63,'Completed'),(15,1,1,1,'2026-05-29 11:45:00',10.80,'Completed'),(16,NULL,2,NULL,'2026-05-29 15:30:00',13.00,'Completed'),(17,3,1,2,'2026-05-30 08:30:00',11.40,'Completed'),(18,NULL,2,NULL,'2026-05-30 13:20:00',10.00,'Completed'),(19,5,1,NULL,'2026-05-31 09:10:00',38.50,'Completed'),(20,1,2,1,'2026-05-31 16:00:00',18.00,'Completed'),(21,3,2,NULL,'2026-05-31 17:05:00',10.00,'Completed'),(22,1,1,2,'2026-03-10 11:30:00',27.55,'Completed'),(23,NULL,2,NULL,'2026-03-22 14:15:00',12.00,'Completed'),(24,3,1,2,'2026-03-28 09:10:00',14.25,'Completed'),(25,NULL,2,NULL,'2026-04-05 10:45:00',16.00,'Completed'),(26,4,1,2,'2026-04-12 14:20:00',16.15,'Completed'),(27,5,2,NULL,'2026-04-20 16:30:00',38.50,'Completed');
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payments`
--

DROP TABLE IF EXISTS `Payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payments` (
  `PaymentID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `DrawerID` int DEFAULT NULL,
  `PaymentDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `PaymentMethod` enum('Cash','KHQR') NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `PaymentStatus` enum('Completed','Pending','Failed') DEFAULT 'Completed',
  PRIMARY KEY (`PaymentID`),
  KEY `OrderID` (`OrderID`),
  KEY `DrawerID` (`DrawerID`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `Orders` (`OrderID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`DrawerID`) REFERENCES `Cash_Drawers` (`DrawerID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `payments_chk_1` CHECK ((`Amount` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payments`
--

LOCK TABLES `Payments` WRITE;
/*!40000 ALTER TABLE `Payments` DISABLE KEYS */;
INSERT INTO `Payments` VALUES (1,1,NULL,'2026-05-23 13:43:18','KHQR',29.25,'Completed'),(2,2,1,'2026-05-23 13:43:18','Cash',12.00,'Completed'),(3,3,NULL,'2026-05-23 13:43:18','KHQR',12.35,'Completed'),(4,4,1,'2026-05-23 13:43:18','Cash',25.00,'Completed'),(5,5,NULL,'2026-05-24 09:16:00','KHQR',13.95,'Completed'),(6,6,2,'2026-05-24 14:22:00','Cash',25.50,'Completed'),(7,7,NULL,'2026-05-25 10:06:00','KHQR',21.85,'Completed'),(8,8,3,'2026-05-25 16:47:00','Cash',8.00,'Completed'),(9,9,NULL,'2026-05-26 11:32:00','KHQR',10.50,'Completed'),(10,10,4,'2026-05-26 15:02:00','Cash',12.00,'Completed'),(11,11,NULL,'2026-05-27 09:02:00','KHQR',22.95,'Completed'),(12,12,5,'2026-05-27 12:32:00','Cash',24.00,'Completed'),(13,13,NULL,'2026-05-28 10:17:00','KHQR',8.00,'Completed'),(14,14,6,'2026-05-28 14:02:00','Cash',16.63,'Completed'),(15,15,NULL,'2026-05-29 11:47:00','KHQR',10.80,'Completed'),(16,16,7,'2026-05-29 15:32:00','Cash',13.00,'Completed'),(17,17,NULL,'2026-05-30 08:32:00','KHQR',11.40,'Completed'),(18,18,8,'2026-05-30 13:22:00','Cash',10.00,'Completed'),(19,19,NULL,'2026-05-31 09:12:00','KHQR',38.50,'Completed'),(20,20,9,'2026-05-31 16:02:00','Cash',18.00,'Completed'),(21,21,NULL,'2026-05-31 17:06:00','KHQR',10.00,'Failed'),(22,21,NULL,'2026-05-31 17:07:00','KHQR',10.00,'Completed'),(23,22,NULL,'2026-03-10 11:31:00','KHQR',27.55,'Completed'),(24,23,11,'2026-03-22 14:16:00','Cash',12.00,'Completed'),(25,24,NULL,'2026-03-28 09:11:00','KHQR',14.25,'Completed'),(26,25,13,'2026-04-05 10:46:00','Cash',16.00,'Completed'),(27,26,NULL,'2026-04-12 14:21:00','KHQR',16.15,'Completed'),(28,27,15,'2026-04-20 16:31:00','Cash',38.50,'Completed');
/*!40000 ALTER TABLE `Payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pickup_Locations`
--

DROP TABLE IF EXISTS `Pickup_Locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pickup_Locations` (
  `LocationID` int NOT NULL AUTO_INCREMENT,
  `LocationName` varchar(100) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LocationID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pickup_Locations`
--

LOCK TABLES `Pickup_Locations` WRITE;
/*!40000 ALTER TABLE `Pickup_Locations` DISABLE KEYS */;
INSERT INTO `Pickup_Locations` VALUES (1,'5 Makara Entrance','Fast pickup near the ITC front entrance.'),(2,'Building J','Convenient pickup for GIC students.');
/*!40000 ALTER TABLE `Pickup_Locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Products`
--

DROP TABLE IF EXISTS `Products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Products` (
  `ProductID` int NOT NULL AUTO_INCREMENT,
  `CategoryID` int NOT NULL,
  `SupplierID` int NOT NULL,
  `Title` varchar(150) NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `StockQuantity` int NOT NULL DEFAULT '0',
  `ReorderLevel` int NOT NULL DEFAULT '10',
  `ItemCondition` enum('New','Used') NOT NULL DEFAULT 'New',
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ProductID`),
  KEY `CategoryID` (`CategoryID`),
  KEY `SupplierID` (`SupplierID`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`CategoryID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`SupplierID`) REFERENCES `Suppliers` (`SupplierID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `products_chk_1` CHECK ((`Price` >= 0)),
  CONSTRAINT `products_chk_2` CHECK ((`StockQuantity` >= 0)),
  CONSTRAINT `products_chk_3` CHECK ((`ReorderLevel` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Products`
--

LOCK TABLES `Products` WRITE;
/*!40000 ALTER TABLE `Products` DISABLE KEYS */;
INSERT INTO `Products` VALUES (1,1,1,'Introduction to Relational Algebra',25.50,4,10,'New',1),(2,1,4,'C++ Object-Oriented Programming Vol 2',15.00,1,10,'Used',1),(3,2,3,'Premium Graphing Notebook',3.50,86,30,'New',1),(4,3,3,'ITC Circular Blue Logo T-Shirt',12.00,3,15,'New',1),(5,4,2,'USB-C Fast Charging Cable',8.00,15,10,'New',1),(6,1,4,'Organic Chemistry',13.00,15,10,'New',1),(7,1,4,'Statistics for Engineers',10.00,15,10,'New',1);
/*!40000 ALTER TABLE `Products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Promotions`
--

DROP TABLE IF EXISTS `Promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Promotions` (
  `PromoID` int NOT NULL AUTO_INCREMENT,
  `PromoCode` varchar(20) NOT NULL,
  `DiscountPercentage` decimal(5,2) NOT NULL,
  `ValidFrom` datetime DEFAULT NULL,
  `ValidUntil` datetime DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`PromoID`),
  UNIQUE KEY `PromoCode` (`PromoCode`),
  CONSTRAINT `promotions_chk_1` CHECK (((`DiscountPercentage` > 0) and (`DiscountPercentage` <= 100))),
  CONSTRAINT `promotions_chk_2` CHECK ((`ValidUntil` > `ValidFrom`))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotions`
--

LOCK TABLES `Promotions` WRITE;
/*!40000 ALTER TABLE `Promotions` DISABLE KEYS */;
INSERT INTO `Promotions` VALUES (1,'MIDTERM5',10.00,'2026-05-15 00:00:00','2026-05-30 00:00:00',1),(2,'WELCOME-S2-2026',5.00,'2026-02-01 00:00:00','2026-07-01 00:00:00',1);
/*!40000 ALTER TABLE `Promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reviews`
--

DROP TABLE IF EXISTS `Reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reviews` (
  `ReviewID` int NOT NULL AUTO_INCREMENT,
  `ProductID` int NOT NULL,
  `CustomerID` int NOT NULL,
  `Rating` int NOT NULL,
  `Comment` varchar(500) DEFAULT NULL,
  `ReviewDate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ReviewID`),
  KEY `ProductID` (`ProductID`),
  KEY `CustomerID` (`CustomerID`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `reviews_chk_1` CHECK ((`Rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reviews`
--

LOCK TABLES `Reviews` WRITE;
/*!40000 ALTER TABLE `Reviews` DISABLE KEYS */;
INSERT INTO `Reviews` VALUES (1,1,1,5,'Perfect book for database class! Highly recommended.','2026-05-23 14:17:31'),(2,4,2,4,'Comfortable material, but I wish it came in a darker blue.','2026-05-23 14:17:31'),(3,6,3,5,'Great condition, very helpful for my chemistry assignments.','2026-05-23 14:17:31'),(4,2,4,4,'Solid examples on linked lists, exactly what I needed for practice.','2026-05-23 14:17:31');
/*!40000 ALTER TABLE `Reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Suppliers`
--

DROP TABLE IF EXISTS `Suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Suppliers` (
  `SupplierID` int NOT NULL AUTO_INCREMENT,
  `CompanyName` varchar(100) NOT NULL,
  `ContactName` varchar(100) DEFAULT NULL,
  `Phone` varchar(20) NOT NULL,
  PRIMARY KEY (`SupplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Suppliers`
--

LOCK TABLES `Suppliers` WRITE;
/*!40000 ALTER TABLE `Suppliers` DISABLE KEYS */;
INSERT INTO `Suppliers` VALUES (1,'ITC University Press','Dr. Chea','012345678'),(2,'Phnom Penh Tech Distrib','Sokheng','098765432'),(3,'Cambodia Campus Gear','Vannak','011223344'),(4,'6$ Bookstore','Rangsey','098123321');
/*!40000 ALTER TABLE `Suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_active_storefront`
--

DROP TABLE IF EXISTS `v_active_storefront`;
/*!50001 DROP VIEW IF EXISTS `v_active_storefront`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_active_storefront` AS SELECT 
 1 AS `ProductID`,
 1 AS `Title`,
 1 AS `Price`,
 1 AS `StockQuantity`,
 1 AS `CategoryName`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_customer_receipts`
--

DROP TABLE IF EXISTS `v_customer_receipts`;
/*!50001 DROP VIEW IF EXISTS `v_customer_receipts`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_customer_receipts` AS SELECT 
 1 AS `OrderID`,
 1 AS `OrderDate`,
 1 AS `Customer`,
 1 AS `Product`,
 1 AS `Quantity`,
 1 AS `Subtotal`,
 1 AS `TotalAmount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_low_stock_alerts`
--

DROP TABLE IF EXISTS `v_low_stock_alerts`;
/*!50001 DROP VIEW IF EXISTS `v_low_stock_alerts`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_low_stock_alerts` AS SELECT 
 1 AS `Title`,
 1 AS `StockQuantity`,
 1 AS `ReorderLevel`,
 1 AS `CompanyName`,
 1 AS `Phone`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_sales_past_30_days`
--

DROP TABLE IF EXISTS `v_sales_past_30_days`;
/*!50001 DROP VIEW IF EXISTS `v_sales_past_30_days`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_sales_past_30_days` AS SELECT 
 1 AS `OrderID`,
 1 AS `SaleDate`,
 1 AS `CustomerName`,
 1 AS `TotalAmount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_sales_past_7_days`
--

DROP TABLE IF EXISTS `v_sales_past_7_days`;
/*!50001 DROP VIEW IF EXISTS `v_sales_past_7_days`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_sales_past_7_days` AS SELECT 
 1 AS `OrderID`,
 1 AS `SaleDate`,
 1 AS `CustomerName`,
 1 AS `TotalAmount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_student_accounts`
--

DROP TABLE IF EXISTS `v_student_accounts`;
/*!50001 DROP VIEW IF EXISTS `v_student_accounts`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_student_accounts` AS SELECT 
 1 AS `CustomerID`,
 1 AS `InstitutionalID`,
 1 AS `FullName`,
 1 AS `Major`,
 1 AS `Email`,
 1 AS `CustomerType`,
 1 AS `RewardPoints`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_active_storefront`
--

/*!50001 DROP VIEW IF EXISTS `v_active_storefront`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_active_storefront` AS select `p`.`ProductID` AS `ProductID`,`p`.`Title` AS `Title`,`p`.`Price` AS `Price`,`p`.`StockQuantity` AS `StockQuantity`,`c`.`CategoryName` AS `CategoryName` from (`products` `p` join `categories` `c` on((`p`.`CategoryID` = `c`.`CategoryID`))) where (`p`.`isActive` = true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_customer_receipts`
--

/*!50001 DROP VIEW IF EXISTS `v_customer_receipts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_customer_receipts` AS select `o`.`OrderID` AS `OrderID`,`o`.`OrderDate` AS `OrderDate`,`c`.`FullName` AS `Customer`,`p`.`Title` AS `Product`,`oi`.`Quantity` AS `Quantity`,`oi`.`Subtotal` AS `Subtotal`,`o`.`TotalAmount` AS `TotalAmount` from (((`orders` `o` join `customers` `c` on((`o`.`CustomerID` = `c`.`CustomerID`))) join `order_items` `oi` on((`o`.`OrderID` = `oi`.`OrderID`))) join `products` `p` on((`oi`.`ProductID` = `p`.`ProductID`))) where (`o`.`OrderStatus` = 'Completed') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_low_stock_alerts`
--

/*!50001 DROP VIEW IF EXISTS `v_low_stock_alerts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_low_stock_alerts` AS select `p`.`Title` AS `Title`,`p`.`StockQuantity` AS `StockQuantity`,`p`.`ReorderLevel` AS `ReorderLevel`,`s`.`CompanyName` AS `CompanyName`,`s`.`Phone` AS `Phone` from (`products` `p` join `suppliers` `s` on((`p`.`SupplierID` = `s`.`SupplierID`))) where ((`p`.`StockQuantity` < `p`.`ReorderLevel`) and (`p`.`isActive` = true)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sales_past_30_days`
--

/*!50001 DROP VIEW IF EXISTS `v_sales_past_30_days`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_sales_past_30_days` AS select `o`.`OrderID` AS `OrderID`,cast(`o`.`OrderDate` as date) AS `SaleDate`,coalesce(`c`.`FullName`,'Walk-in Guest') AS `CustomerName`,`o`.`TotalAmount` AS `TotalAmount` from (`orders` `o` left join `customers` `c` on((`o`.`CustomerID` = `c`.`CustomerID`))) where ((`o`.`OrderStatus` = 'Completed') and (`o`.`OrderDate` >= ('2026-05-01' - interval 30 day)) and (`o`.`OrderDate` <= '2026-05-01')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sales_past_7_days`
--

/*!50001 DROP VIEW IF EXISTS `v_sales_past_7_days`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_sales_past_7_days` AS select `o`.`OrderID` AS `OrderID`,cast(`o`.`OrderDate` as date) AS `SaleDate`,coalesce(`c`.`FullName`,'Walk-in Guest') AS `CustomerName`,`o`.`TotalAmount` AS `TotalAmount` from (`orders` `o` left join `customers` `c` on((`o`.`CustomerID` = `c`.`CustomerID`))) where ((`o`.`OrderStatus` = 'Completed') and (`o`.`OrderDate` >= (curdate() - interval 7 day)) and (`o`.`OrderDate` <= curdate())) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_student_accounts`
--

/*!50001 DROP VIEW IF EXISTS `v_student_accounts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_student_accounts` AS select `customers`.`CustomerID` AS `CustomerID`,`customers`.`InstitutionalID` AS `InstitutionalID`,`customers`.`FullName` AS `FullName`,`customers`.`Major` AS `Major`,`customers`.`Email` AS `Email`,`customers`.`CustomerType` AS `CustomerType`,`customers`.`RewardPoints` AS `RewardPoints` from `customers` where (`customers`.`CustomerType` = 'Student') */
/*!50002 WITH CASCADED CHECK OPTION */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-30 23:15:48
