CREATE database IF NOT EXISTS IMS;
use IMS;

CREATE TABLE IF NOT EXISTS Categories(
Category_ID INT AUTO_INCREMENT PRIMARY KEY,
Category_Name VARCHAR(70) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Suppliers(
Supplier_ID INT AUTO_INCREMENT PRIMARY KEY,
Supplier_Name VARCHAR(70) NOT NULL,
Phone INT, 
Location POINT NOT NULL
);

CREATE TABLE IF NOT EXISTS Products(
Product_ID INT AUTO_INCREMENT PRIMARY KEY,
Product_Name VARCHAR(70) UNIQUE NOT NULL,
Category_ID INT NOT NULL,
Supplier_ID INT NOT NULL,
Stock_Level INT DEFAULT 0,
Restock INT NOT NULL DEFAULT 100,
Threshold INT NOT NULL DEFAULT 40,
Price DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (Category_ID) references Categories(Category_ID),
FOREIGN KEY (Supplier_ID) references Suppliers(Supplier_ID)
);

-- DROP INDEX idx_product ON Products;
CREATE INDEX idx_product ON Products(Product_Name);

-- DROP INDEX idx_stock ON Products;
CREATE INDEX idx_stock ON Products(Stock_Level);

CREATE TABLE IF NOT EXISTS Warehouses(
Warehouse_ID INT AUTO_INCREMENT PRIMARY KEY,
Warehouse_Name VARCHAR(70) NOT NULL,
Location POINT NOT NULL
);

-- DROP INDEX idx_location ON Warehouses;
CREATE SPATIAL INDEX idx_location ON Warehouses(Location);

CREATE TABLE IF NOT EXISTS Inventory(
Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
Warehouse_ID INT NOT NULL,
Product_ID INT NOT NULL,
Stock_Level INT NOT NULL DEFAULT 0,
FOREIGN KEY (Warehouse_ID) references Warehouses(Warehouse_ID),
FOREIGN KEY (Product_ID) references Products(Product_ID)
);

CREATE TABLE IF NOT EXISTS Users(
User_ID VARCHAR(10) PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Email VARCHAR(50) NOT NULL,
User_Password VARCHAR(15) NOT NULL,
Address POINT NOT NULL
-- Nearest_ID INT,
-- FOREIGN KEY (Nearest_ID) REFERENCES Warehouses(Warehouse_ID)
);

CREATE TABLE IF NOT EXISTS Admins(
Admin_ID VARCHAR(10) PRIMARY KEY,
Admin_Password VARCHAR(15) NOT NULL,
Role VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS Sales(
Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
User_ID VARCHAR(10) NOT NULL,
Product_ID INT NOT NULL,
Quantity INT NOT NULL,
Price_Per_Product Decimal(10,2),
FOREIGN KEY (User_ID) references Users(User_ID),
FOREIGN KEY (Product_ID) references Products(Product_ID)
);


-- Total_Price Decimal(10,2),

CREATE TABLE IF NOT EXISTS Purchases(
Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
Supplier_ID INT NOT NULL,
Product_ID INT NOT NULL,
Quantity INT NOT NULL,
Price_Per_Product Decimal(10,2),
FOREIGN KEY (Supplier_ID) references Suppliers(Supplier_ID),
FOREIGN KEY (Product_ID) references Products(Product_ID)
);


