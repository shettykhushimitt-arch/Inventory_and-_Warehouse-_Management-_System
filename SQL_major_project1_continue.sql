use inventory_warehouse_db;


-- list all products with their supplier names
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    s.supplier_name
FROM product p
JOIN supplier s ON p.supplier_id = s.supplier_id
ORDER BY p.product_name;

-- show stock availability with warehouse details
SELECT 
    p.product_name,
    w.warehouse_name,
    s.quantity
FROM stock s
JOIN product p ON s.product_id = p.product_id
JOIN warehouse w ON s.warehouse_id = w.warehouse_id
ORDER BY w.warehouse_name, p.product_name;

-- display purchases with supplier and product info

SELECT 
    pur.purchase_id,
    p.product_name,
    s.supplier_name,
    pur.quantity,
    pur.total_cost,
    pur.purchase_date
FROM purchase pur
JOIN product p ON pur.product_id = p.product_id
JOIN supplier s ON pur.supplier_id = s.supplier_id
ORDER BY pur.purchase_date desc ;

-- Total stock per warehouse

SELECT 
    w.warehouse_name,
    SUM(s.quantity) AS total_stock
FROM stock s
JOIN warehouse w ON s.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name
ORDER BY total_stock DESC;

-- Total purchase cost per supplier
SELECT 
    sup.supplier_name,
    SUM(pur.total_cost) AS total_purchase_cost
FROM purchase pur
JOIN supplier sup ON pur.supplier_id = sup.supplier_id
GROUP BY sup.supplier_name
ORDER BY total_purchase_cost DESC;

-- total sales revenue per product
SELECT 
    p.product_name,
    SUM(sal.total_price) AS total_revenue
FROM sales sal
JOIN product p ON sal.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Show suppliers whose total purchase exceeds ₹50,000
SELECT 
    s.supplier_name,
    SUM(pur.total_cost) AS total_purchase
FROM purchase pur
JOIN supplier s ON pur.supplier_id = s.supplier_id
GROUP BY s.supplier_name
HAVING total_purchase > 50000
ORDER BY total_purchase DESC;

-- List products sold more than 500 units total
SELECT 
    p.product_name,
    SUM(sal.quantity) AS total_units_sold
FROM sales sal
JOIN product p ON sal.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(sal.quantity) > 500
ORDER BY total_units_sold DESC;

-- Find top 5 best-selling products
SELECT 
    p.product_name,
    SUM(quantity) AS total_sold
FROM sales sal
JOIN product p ON sal.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- Show total units sold per product (all products)
SELECT 
    p.product_name,
    SUM(sal.quantity) AS total_units_sold
FROM sales sal
JOIN product p ON sal.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC;


-- Find least-stocked items (below 50)
SELECT 
    p.product_name,
    SUM(quantity) AS total_stock
FROM sales sal
JOIN product p ON sal.product_id = p.product_id
GROUP BY p.product_name
HAVING total_stock < 50
ORDER BY total_stock ASC;

-- Monthly sales summary
SELECT 
DATE_FORMAT(sal.sale_date, '%Y-%m') AS month,
SUM(sal.total_price) AS monthly_revenue 
FROM sales sal 
GROUP BY DATE_FORMAT(sal.sale_date, '%Y-%m') 
ORDER BY month;

-- ________________________________________________________________________________________________________________ 
-- Stock Transfer Procedure


DELIMITER $$
CREATE PROCEDURE transfer_stock(
  IN p_product_id INT,
  IN p_from_warehouse INT,
  IN p_to_warehouse INT,
  IN p_quantity INT
)
BEGIN
  DECLARE available_qty INT;

  -- Check available stock in source warehouse
  SELECT quantity INTO available_qty
  FROM stock
  WHERE product_id = p_product_id AND warehouse_id = p_from_warehouse;

  IF available_qty < p_quantity THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Insufficient stock in source warehouse';
  ELSE
    -- Deduct from source
    UPDATE stock
    SET quantity = quantity - p_quantity
    WHERE product_id = p_product_id AND warehouse_id = p_from_warehouse;

    -- Add to destination
    INSERT INTO stock (product_id, warehouse_id, quantity)
    VALUES (p_product_id, p_to_warehouse, p_quantity)
    ON DUPLICATE KEY UPDATE quantity = quantity + p_quantity;
  END IF;
END $$
DELIMITER ;

CALL transfer_stock(1, 1, 2, 15);

-- Low-stock alert trigger
DELIMITER $$
CREATE TRIGGER trg_low_stock_alert
AFTER UPDATE ON stock
FOR EACH ROW
BEGIN
  IF NEW.quantity < 20 THEN
    INSERT INTO stock_alerts (product_id, warehouse_id, alert_message)
    VALUES (NEW.product_id, NEW.warehouse_id,
            CONCAT('Low stock alert for Product ID ', NEW.product_id,
                   ' in Warehouse ID ', NEW.warehouse_id,
                   '. Remaining qty: ', NEW.quantity));
  END IF;
END $$
DELIMITER ;

update stock set quantity=1 where stock_id=1;
update stock set quantity=10 where stock_id=5;
select * from stock_alerts;

-- ___________________________________________________________________________________________________________________

-- testing
SHOW TABLES;
DESCRIBE product;
DESCRIBE supplier;
DESCRIBE purchase;
DESCRIBE warehouse;
DESCRIBE stock;
DESCRIBE sales;
DESCRIBE stock_alerts;







