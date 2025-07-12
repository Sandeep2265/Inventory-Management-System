SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;


-- CREATE TRIGGER PurchaseStockLevel AFTER INSERT ON Purchases
-- FOR EACH ROW 
-- BEGIN 
--     UPDATE Products
-- 		SET Stock_Level = Stock_Level + NEW.Quantity
-- 		WHERE Product_ID = NEW.Product_ID;
-- END;


-- CREATE TRIGGER SaleStockLevel AFTER INSERT ON Sales
-- FOR EACH ROW 
-- BEGIN 
            
--     DECLARE current INT;
-- 	DECLARE restock INT;
-- 	DECLARE threshold INT;	
--     DECLARE nearest INT;	

--     UPDATE Products
-- 	SET Stock_Level = Stock_Level - NEW.Quantity
-- 	WHERE Product_ID = NEW.Product_ID;
	
-- 	SELECT Stock_Level, Restock, Threshold INTO current, restock, threshold
-- 	FROM Products
-- 	WHERE Product_ID = NEW.Product_ID;


	
-- 	IF current < threshold THEN
--     	-- UPDATE Inventory
-- 	    -- SET Stock_Level = Stock_Level + restock
-- 	    -- WHERE Warehouse_ID = nearest AND Product_ID = NEW.Product_ID;
	
--         UPDATE Products
-- 	    SET Stock_Level = Stock_Level + restock
-- 	    WHERE Product_ID = NEW.Product_ID;
-- 	END IF;
-- END;

-- updating stock and ordering 
-- trigger to add into inventory once a warehhouse is created
-- trigger to add to purchases once a product is bought

CREATE TRIGGER AddInventory AFTER INSERT ON Warehouses
FOR EACH ROW 
BEGIN

	INSERT INTO Inventory (Warehouse_ID, Product_ID, Stock_Level)
    SELECT NEW.Warehouse_ID, Products.Product_ID, Products.Restock  FROM Products;

	INSERT INTO Purchases (Supplier_ID, Product_ID, Quantity, Price_Per_Product)
	SELECT Products.Supplier_ID, Products.Product_ID, Products.Restock, Products.Price FROM Products;

	UPDATE Products 
	SET	Products.Stock_Level = Products.Stock_Level + Products.Restock;

END;

	-- DECLARE current_stock INT;
	
	-- SELECT Stock_Level INTO current_stock
    -- FROM Inventory
    -- WHERE Warehouse_ID = W_ID AND Product_ID = P_ID;

-- CREATE PROCEDURE AlterWarehouse(IN W_ID INT, IN P_ID INT, IN Quantity INT)
-- BEGIN

-- 	UPDATE Inventory
-- 	SET Stock_Level = Stock_Level - Quantity
-- 	WHERE Warehouse_ID = W_ID AND Product_ID = P_ID;

-- END;

-- CREATE PROCEDURE InsertSale(IN User_ID VARCHAR(10), IN P_ID INT, IN Quantity INT)
-- BEGIN
-- 	DECLARE price Decimal(10, 2);
-- 	START TRANSACTION;

-- 	SELECT Products.Price INTO price
-- 	FROM Products
-- 	WHERE Product_ID = P_ID;

-- 	UPDATE Products 
-- 	SET	Products.Stock_Level = Products.Stock_Level - Quantity
-- 	WHERE Product_ID = P_ID;
	
-- 	INSERT INTO Sales(User_ID, Product_ID, Quantity, Price_Per_Product) VALUES (User_ID, P_ID, Quantity, price);



-- 	COMMIT;
-- END;

CREATE PROCEDURE InsertSale(IN User_ID VARCHAR(10), IN P_ID INT, IN Quantity INT, IN W_ID INT)
BEGIN
	DECLARE price Decimal(10, 2);
	DECLARE current Decimal(10, 2);
	DECLARE restock Decimal(10, 2);
	DECLARE threshold Decimal(10, 2);

	START TRANSACTION;

	SELECT Products.Price INTO price
	FROM Products
	WHERE Product_ID = P_ID;

	SELECT Inventory.Stock_Level INTO current
	FROM Inventory
	WHERE Warehouse_ID = W_ID AND Product_ID = P_ID;

	UPDATE Products 
	SET	Products.Stock_Level = Products.Stock_Level - Quantity
	WHERE Product_ID = P_ID;

	IF current >= Quantity THEN
	
		INSERT INTO Sales(User_ID, Product_ID, Quantity, Price_Per_Product) VALUES (User_ID, P_ID, Quantity, price);

		UPDATE Inventory 
		SET Inventory.Stock_Level = Inventory.Stock_Level - Quantity 
		WHERE Warehouse_ID = W_ID AND Product_ID = P_ID;

		

		SELECT Products.Restock INTO restock
		FROM Products
		WHERE Product_ID = P_ID;

		SELECT Products.Threshold INTO threshold
		FROM Products
		WHERE Product_ID = P_ID;

		IF current < threshold THEN 

			UPDATE Inventory
			SET Inventory.Stock_Level = Inventory.Stock_Level + restock
			WHERE Warehouse_ID = W_ID AND Product_ID = P_ID;

			CALL InsertPurchase((SELECT Supplier_ID FROM Products WHERE Product_ID=P_ID), P_ID, restock);
		END IF;
	COMMIT;

	ELSE
		ROLLBACK;
	END IF;

END;


CREATE PROCEDURE InsertPurchase(IN Supplier_ID INT, IN P_ID INT, IN Quantity INT)
BEGIN
	DECLARE price Decimal(10,2);
	START TRANSACTION;

	SELECT Products.Price INTO price
	FROM Products
	WHERE Product_ID = P_ID;

	UPDATE Products 
	SET	Products.Stock_Level = Products.Stock_Level + Quantity
	WHERE Product_ID = P_ID;

	INSERT INTO Purchases(Supplier_ID, Product_ID, Quantity, Price_Per_Product) VALUES (Supplier_ID, P_ID, Quantity, price);

	COMMIT;
END;


