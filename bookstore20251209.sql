CREATE DATABASE  IF NOT EXISTS `bookstore_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bookstore_db`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bookstore_db
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `isbn` varchar(20) DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `main_author` varchar(100) DEFAULT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `price` decimal(8,2) NOT NULL,
  `description` text,
  `category` varchar(50) DEFAULT NULL,
  `keywords` text COMMENT '逗号分隔的关键字',
  `cover_image_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,NULL,'Java核心技术 卷I','Cay S. Horstmann','机械工业出版社',119.00,NULL,'编程','Java,编程,基础',NULL,'2025-12-09 11:39:40'),(2,NULL,'深入理解Java虚拟机','周志明','机械工业出版社',129.00,NULL,'编程','Java,JVM,虚拟机',NULL,'2025-12-09 11:39:40'),(3,NULL,'数据库系统概念','Abraham Silberschatz','机械工业出版社',89.00,NULL,'数据库','数据库,SQL,原理',NULL,'2025-12-09 11:39:40'),(4,NULL,'MySQL必知必会','Ben Forta','人民邮电出版社',49.00,NULL,'数据库','MySQL,入门,SQL',NULL,'2025-12-09 11:39:40'),(5,NULL,'Python编程从入门到实践','Eric Matthes','人民邮电出版社',89.00,NULL,'编程','Python,编程,入门',NULL,'2025-12-09 11:39:40'),(6,NULL,'算法导论','Thomas H. Cormen','机械工业出版社',128.00,NULL,'算法','算法,计算机科学',NULL,'2025-12-09 11:39:40'),(7,NULL,'计算机网络：自顶向下方法','James F. Kurose','机械工业出版社',89.00,NULL,'网络','网络,TCP/IP',NULL,'2025-12-09 11:39:40'),(8,NULL,'操作系统概念','Abraham Silberschatz','高等教育出版社',79.00,NULL,'操作系统','操作系统,原理',NULL,'2025-12-09 11:39:40'),(9,NULL,'设计模式：可复用面向对象软件的基础','Erich Gamma','机械工业出版社',35.00,NULL,'设计模式','设计模式,面向对象',NULL,'2025-12-09 11:39:40'),(10,NULL,'Clean Code','Robert C. Martin','人民邮电出版社',59.00,NULL,'编程','代码,最佳实践,编程',NULL,'2025-12-09 11:39:40');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_supplier`
--

DROP TABLE IF EXISTS `book_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_supplier` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `supplier_id` int NOT NULL,
  `supply_price` decimal(8,2) DEFAULT NULL COMMENT '供应商报价',
  `is_preferred` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_book_supplier` (`book_id`,`supplier_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `book_supplier_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `book_supplier_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_supplier`
--

LOCK TABLES `book_supplier` WRITE;
/*!40000 ALTER TABLE `book_supplier` DISABLE KEYS */;
INSERT INTO `book_supplier` VALUES (1,1,1,95.20,1),(2,2,1,103.20,1),(3,3,1,71.20,1),(4,4,2,39.20,1),(5,5,2,71.20,1),(6,6,1,102.40,1);
/*!40000 ALTER TABLE `book_supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL COMMENT 'SHA256加密',
  `real_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `account_balance` decimal(10,2) DEFAULT '0.00',
  `credit_level` int DEFAULT '1',
  `total_purchased` decimal(12,2) DEFAULT '0.00' COMMENT '累计消费金额',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `username` (`username`),
  CONSTRAINT `chk_credit_level` CHECK ((`credit_level` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'customer1','d514f1983d328763051138dba05fbc0cdb67381989e1ec08c8c9d03a68d20c4d','张小明','zhang@test.com',NULL,NULL,5000.00,3,0.00,'2025-12-09 11:39:40','2025-12-09 11:39:40'),(2,'customer2','9e105614518d919e129a40da1a8fb69c345ab641efa60306f20ced9d72b602a7','李小红','li@test.com',NULL,NULL,2000.00,2,0.00,'2025-12-09 11:39:40','2025-12-09 11:39:40'),(3,'admin','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9','系统管理员','admin@bookstore.com',NULL,NULL,10000.00,5,0.00,'2025-12-09 11:39:40','2025-12-09 11:39:40');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery` (
  `delivery_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `detail_id` int NOT NULL,
  `delivered_quantity` int NOT NULL,
  `delivery_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tracking_number` varchar(100) DEFAULT NULL,
  `courier_company` varchar(50) DEFAULT NULL,
  `shipping_cost` decimal(8,2) DEFAULT '0.00',
  `notes` text,
  PRIMARY KEY (`delivery_id`),
  KEY `order_id` (`order_id`),
  KEY `detail_id` (`detail_id`),
  CONSTRAINT `delivery_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
  CONSTRAINT `delivery_ibfk_2` FOREIGN KEY (`detail_id`) REFERENCES `order_detail` (`detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery`
--

LOCK TABLES `delivery` WRITE;
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `inventory_id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `quantity` int DEFAULT '0',
  `low_stock_threshold` int DEFAULT '10',
  `location_code` varchar(50) DEFAULT NULL,
  `last_restocked` date DEFAULT NULL,
  PRIMARY KEY (`inventory_id`),
  UNIQUE KEY `book_id` (`book_id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,1,50,10,NULL,NULL),(2,2,30,5,NULL,NULL),(3,3,20,5,NULL,NULL),(4,4,100,20,NULL,NULL),(5,5,3,5,NULL,NULL),(6,6,15,5,NULL,NULL),(7,7,25,10,NULL,NULL),(8,8,40,10,NULL,NULL),(9,9,60,15,NULL,NULL),(10,10,45,10,NULL,NULL);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(20) NOT NULL COMMENT '业务订单号: ORD20240115001',
  `customer_id` int NOT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `shipping_address` text,
  `status` enum('pending','paid','shipping','completed','cancelled') DEFAULT 'pending',
  `discount_rate` decimal(3,2) DEFAULT '1.00' COMMENT '折扣率',
  `final_amount` decimal(10,2) GENERATED ALWAYS AS ((`total_amount` * `discount_rate`)) STORED,
  `notes` text,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `detail_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `book_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(8,2) NOT NULL COMMENT '下单时的单价',
  `subtotal` decimal(10,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED,
  `status` enum('pending','partially_shipped','shipped') DEFAULT 'pending',
  PRIMARY KEY (`detail_id`),
  UNIQUE KEY `uk_order_book` (`order_id`,`book_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_detail_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stockout_register`
--

DROP TABLE IF EXISTS `stockout_register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stockout_register` (
  `register_id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `requested_quantity` int DEFAULT '1',
  `customer_id` int DEFAULT NULL COMMENT '谁申请的，可为空',
  `register_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','processed') DEFAULT 'pending',
  `priority` int DEFAULT '5' COMMENT '1-10，数字越小优先级越高',
  `notes` text,
  PRIMARY KEY (`register_id`),
  UNIQUE KEY `uk_pending_book` (`book_id`,`status`) COMMENT '同一本书只能有一条待处理记录',
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `stockout_register_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
  CONSTRAINT `stockout_register_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stockout_register`
--

LOCK TABLES `stockout_register` WRITE;
/*!40000 ALTER TABLE `stockout_register` DISABLE KEYS */;
/*!40000 ALTER TABLE `stockout_register` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `supplier_id` int NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(100) NOT NULL,
  `contact_person` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text,
  `rating` decimal(2,1) DEFAULT '5.0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'机械工业出版社','张经理','010-88379666','service@cmpbook.com',NULL,5.0,'2025-12-09 11:39:40'),(2,'人民邮电出版社','李经理','010-67132865','service@ptpress.com.cn',NULL,5.0,'2025-12-09 11:39:40'),(3,'清华大学出版社','王经理','010-62782989','service@tup.tsinghua.edu.cn',NULL,5.0,'2025-12-09 11:39:40');
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_book_inventory`
--

DROP TABLE IF EXISTS `v_book_inventory`;
/*!50001 DROP VIEW IF EXISTS `v_book_inventory`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_book_inventory` AS SELECT 
 1 AS `book_id`,
 1 AS `title`,
 1 AS `main_author`,
 1 AS `publisher`,
 1 AS `price`,
 1 AS `category`,
 1 AS `keywords`,
 1 AS `quantity`,
 1 AS `low_stock_threshold`,
 1 AS `stock_status`,
 1 AS `cover_image_url`,
 1 AS `description`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_customer_orders`
--

DROP TABLE IF EXISTS `v_customer_orders`;
/*!50001 DROP VIEW IF EXISTS `v_customer_orders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_customer_orders` AS SELECT 
 1 AS `order_id`,
 1 AS `order_number`,
 1 AS `order_date`,
 1 AS `order_status`,
 1 AS `total_amount`,
 1 AS `final_amount`,
 1 AS `shipping_address`,
 1 AS `customer_id`,
 1 AS `username`,
 1 AS `real_name`,
 1 AS `credit_level`,
 1 AS `total_items`,
 1 AS `total_quantity`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'bookstore_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_CreateOrder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CreateOrder`(
    IN p_customer_id INT,
    IN p_shipping_address TEXT,
    IN p_items JSON,  -- [{"book_id":1, "quantity":2}, ...]
    OUT p_order_id INT,
    OUT p_order_number VARCHAR(20),
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- TODO: 实现订单创建逻辑
    SET p_order_id = 1000 + FLOOR(RAND() * 9000);
    SET p_order_number = CONCAT('ORD', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(p_order_id, 3, '0'));
    SET p_success = 0;
    SET p_message = '待实现完整逻辑';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_GetCustomerOrders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetCustomerOrders`(
    IN p_customer_id INT,
    IN p_status VARCHAR(20),
    IN p_page INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT;
    SET v_offset = (p_page - 1) * p_page_size;
    
    SELECT 
        SQL_CALC_FOUND_ROWS
        order_id,
        order_number,
        order_date,
        order_status,
        total_amount,
        final_amount,
        total_items,
        total_quantity
    FROM v_Customer_Orders
    WHERE customer_id = p_customer_id
      AND (p_status IS NULL OR order_status = p_status)
    ORDER BY order_date DESC
    LIMIT v_offset, p_page_size;
    
    SELECT FOUND_ROWS() AS total_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_LoginCustomer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_LoginCustomer`(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    OUT p_customer_id INT,
    OUT p_customer_name VARCHAR(100),
    OUT p_credit_level INT,
    OUT p_balance DECIMAL(10,2),
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_hash VARCHAR(255);
    
    -- 获取用户信息
    SELECT customer_id, password_hash, real_name, credit_level, account_balance 
    INTO v_customer_id, v_hash, p_customer_name, p_credit_level, p_balance
    FROM Customer 
    WHERE username = p_username;
    
    IF v_customer_id IS NULL THEN
        SET p_success = 1002;
        SET p_message = '用户不存在';
        SET p_customer_id = -1;
    ELSEIF v_hash != p_password_hash THEN
        SET p_success = 1002;
        SET p_message = '密码错误';
        SET p_customer_id = -1;
    ELSE
        SET p_customer_id = v_customer_id;
        SET p_success = 0;
        SET p_message = '登录成功';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_RegisterCustomer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_RegisterCustomer`(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    IN p_email VARCHAR(100),
    IN p_real_name VARCHAR(100),
    OUT p_customer_id INT,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 暂存实现
    DECLARE user_count INT;
    
    -- 检查用户名是否存在
    SELECT COUNT(*) INTO user_count 
    FROM Customer 
    WHERE username = p_username;
    
    IF user_count > 0 THEN
        SET p_success = 1001;
        SET p_message = '用户名已存在';
        SET p_customer_id = -1;
    ELSE
        -- 插入新用户
        INSERT INTO Customer (username, password_hash, email, real_name)
        VALUES (p_username, p_password_hash, p_email, p_real_name);
        
        SET p_customer_id = LAST_INSERT_ID();
        SET p_success = 0;
        SET p_message = '注册成功';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_SearchBooks` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_SearchBooks`(
    IN p_keyword VARCHAR(100),
    IN p_category VARCHAR(50),
    IN p_min_price DECIMAL(8,2),
    IN p_max_price DECIMAL(8,2),
    IN p_in_stock_only BOOLEAN,
    IN p_page INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT;
    SET v_offset = (p_page - 1) * p_page_size;
    
    SELECT 
        SQL_CALC_FOUND_ROWS
        book_id,
        title,
        main_author,
        publisher,
        price,
        category,
        quantity,
        stock_status,
        cover_image_url
    FROM v_Book_Inventory
    WHERE (p_keyword IS NULL OR p_keyword = '' 
           OR title LIKE CONCAT('%', p_keyword, '%')
           OR main_author LIKE CONCAT('%', p_keyword, '%')
           OR keywords LIKE CONCAT('%', p_keyword, '%'))
      AND (p_category IS NULL OR category = p_category)
      AND (p_min_price IS NULL OR price >= p_min_price)
      AND (p_max_price IS NULL OR price <= p_max_price)
      AND (NOT p_in_stock_only OR stock_status != 'out_of_stock')
    ORDER BY book_id
    LIMIT v_offset, p_page_size;
    
    -- 返回总记录数
    SELECT FOUND_ROWS() AS total_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_book_inventory`
--

/*!50001 DROP VIEW IF EXISTS `v_book_inventory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_book_inventory` AS select `b`.`book_id` AS `book_id`,`b`.`title` AS `title`,`b`.`main_author` AS `main_author`,`b`.`publisher` AS `publisher`,`b`.`price` AS `price`,`b`.`category` AS `category`,`b`.`keywords` AS `keywords`,coalesce(`i`.`quantity`,0) AS `quantity`,`i`.`low_stock_threshold` AS `low_stock_threshold`,(case when (coalesce(`i`.`quantity`,0) = 0) then 'out_of_stock' when (coalesce(`i`.`quantity`,0) < `i`.`low_stock_threshold`) then 'low_stock' else 'in_stock' end) AS `stock_status`,`b`.`cover_image_url` AS `cover_image_url`,`b`.`description` AS `description` from (`book` `b` left join `inventory` `i` on((`b`.`book_id` = `i`.`book_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_customer_orders`
--

/*!50001 DROP VIEW IF EXISTS `v_customer_orders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_customer_orders` AS select `o`.`order_id` AS `order_id`,`o`.`order_number` AS `order_number`,`o`.`order_date` AS `order_date`,`o`.`status` AS `order_status`,`o`.`total_amount` AS `total_amount`,`o`.`final_amount` AS `final_amount`,`o`.`shipping_address` AS `shipping_address`,`c`.`customer_id` AS `customer_id`,`c`.`username` AS `username`,`c`.`real_name` AS `real_name`,`c`.`credit_level` AS `credit_level`,count(distinct `od`.`detail_id`) AS `total_items`,sum(`od`.`quantity`) AS `total_quantity` from ((`order` `o` join `customer` `c` on((`o`.`customer_id` = `c`.`customer_id`))) left join `order_detail` `od` on((`o`.`order_id` = `od`.`order_id`))) group by `o`.`order_id` */;
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

-- Dump completed on 2025-12-09 19:44:31
