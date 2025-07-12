INSERT INTO Users (User_ID, User_Password, Name, Email, Address) VALUES ('12', '12', 'John Doe', 'john@gmail.com', POINT(40.7128, -74.0060));
INSERT INTO Admins VALUES ('00', '12', 'Admin');
INSERT INTO Categories VALUES (1, 'Technology');
INSERT INTO Suppliers (Supplier_Name, Phone, Location) 
VALUES ('Fresh Farms Ltd', 12345, ST_GeomFromText('POINT(78.4867 17.3850)'));

INSERT INTO Products (Product_Name, Price, Category_ID, Supplier_ID) VALUES 
('Laptop', 599.99, 1, 1),
('Smartphone', 299.99, 1, 1),
('Headphones', 49.99, 1, 1),
('Keyboard', 19.99, 1, 1),
('Mouse', 14.99, 1, 1),
('Monitor', 199.99, 1, 1),
('Printer', 129.99, 1, 1),
('External Hard Drive', 89.99, 1, 1);






call InsertSale(12, 1, 40, 1);
call InsertPurchase(1, 1, 4);

INSERT INTO Warehouses (Warehouse_Name, Location) VALUES
('West', POINT(20, 10)),
('East', POINT(-30, -12)); 