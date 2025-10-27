CREATE DATABASE IF NOT EXISTS inventory_warehouse_db;

use inventory_warehouse_db;

-- creating tables
-- Table 1: Product
CREATE TABLE product (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  category VARCHAR(50),
  unit_price DECIMAL(10,2),
  supplier_id INT,
  CONSTRAINT fk_product_supplier FOREIGN KEY (supplier_id)
    REFERENCES supplier(supplier_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- Table 2:Supplier
CREATE TABLE supplier (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  supplier_name VARCHAR(100) NOT NULL,
  contact_name VARCHAR(100),
  phone VARCHAR(15),
  email VARCHAR(100),
  address VARCHAR(255)
);

-- Table 3: Warehouse
CREATE TABLE warehouse (
  warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
  warehouse_name VARCHAR(100) NOT NULL UNIQUE,
  location VARCHAR(100)
);


-- Table 4: Stock
CREATE TABLE stock (
  stock_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  warehouse_id INT NOT NULL,
  quantity INT DEFAULT 0,
  CONSTRAINT fk_stock_product FOREIGN KEY (product_id)
    REFERENCES product(product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_stock_warehouse FOREIGN KEY (warehouse_id)
    REFERENCES warehouse(warehouse_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE stock_alerts (
  alert_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  warehouse_id INT,
  alert_message VARCHAR(255),
  alert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 5: Purchase
CREATE TABLE purchase (
  purchase_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  supplier_id INT NOT NULL,
  purchase_date DATE NOT NULL,
  quantity INT NOT NULL,
  total_cost DECIMAL(10,2),
  CONSTRAINT fk_purchase_product FOREIGN KEY (product_id)
    REFERENCES product(product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_purchase_supplier FOREIGN KEY (supplier_id)
    REFERENCES supplier(supplier_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- table 6 :sales
CREATE TABLE sales (
  sale_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  sale_date DATE NOT NULL,
  quantity INT NOT NULL,
  total_price DECIMAL(10,2),
  warehouse_id INT,
  CONSTRAINT fk_sales_product FOREIGN KEY (product_id)
    REFERENCES product(product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_sales_warehouse FOREIGN KEY (warehouse_id)
    REFERENCES warehouse(warehouse_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);


-- inserting values to the tables

INSERT INTO supplier (supplier_name, contact_name, phone, email, address) VALUES
('TechSource Ltd', 'Amit Kumar', '9876543210', 'amit@techsource.com', 'Bengaluru, Karnataka'),
('GreenFoods Distributors', 'Priya Menon', '9876001122', 'priya@greenfoods.com', 'Chennai, Tamil Nadu'),
('BuildWell Hardware', 'Rajesh Iyer', '9812345678', 'rajesh@buildwell.com', 'Mumbai, Maharashtra'),
('ElectroMart Supplies', 'Deepa Nair', '9999988888', 'deepa@electromart.com', 'Hyderabad, Telangana'),
('FashionHouse Textiles', 'Karan Patel', '9823456710', 'karan@fashionhouse.com', 'Surat, Gujarat'),
('OfficePro Stationery', 'Sneha Gupta', '9777771234', 'sneha@officepro.com', 'Pune, Maharashtra'),
('AgroGrow Fertilizers', 'Manoj Verma', '9898989898', 'manoj@agrogrow.com', 'Lucknow, Uttar Pradesh'),
('MedicoPlus Pharma', 'Dr. Shalini Rao', '9900112233', 'shalini@medicoplus.com', 'Mysuru, Karnataka'),
('AutoParts Hub', 'Anil Mehta', '9811122233', 'anil@autopartshub.com', 'Delhi, NCR'),
('SmartHome Devices', 'Meena Reddy', '9922445566', 'meena@smarthome.com', 'Coimbatore, Tamil Nadu');

select * from supplier;

INSERT INTO warehouse (warehouse_name, location) VALUES
('Central Warehouse', 'Bengaluru'),
('North Hub', 'Delhi'),
('South Storage', 'Chennai'),
('East Depot', 'Kolkata'),
('West Logistics Center', 'Mumbai'),
('Coastal Warehouse', 'Visakhapatnam'),
('Inland Storage Unit', 'Hyderabad'),
('Metro Distribution Center', 'Pune'),
('Regional Warehouse', 'Ahmedabad'),
('Backup Storage Facility', 'Mysuru');

select * from warehouse;

INSERT INTO product (product_name, category, unit_price, supplier_id) VALUES
-- Electronics (Supplier 4: ElectroMart Supplies, Supplier 10: SmartHome Devices)
('Wireless Mouse', 'Electronics', 599.00, 4),
('Bluetooth Speaker', 'Electronics', 1499.00, 4),
('Smart LED Bulb', 'Smart Devices', 899.00, 10),
('Wi-Fi Router', 'Electronics', 1899.00, 10),
('Smart Plug', 'Smart Devices', 699.00, 10),

-- Hardware (Supplier 3: BuildWell Hardware)
('Hammer', 'Hardware', 250.00, 3),
('Electric Drill', 'Hardware', 2200.00, 3),
('Screwdriver Set', 'Hardware', 499.00, 3),
('Measuring Tape', 'Hardware', 299.00, 3),
('Safety Helmet', 'Hardware', 799.00, 3),

-- Food & Groceries (Supplier 2: GreenFoods Distributors)
('Organic Rice 5kg', 'Groceries', 549.00, 2),
('Sunflower Oil 1L', 'Groceries', 170.00, 2),
('Wheat Flour 10kg', 'Groceries', 620.00, 2),
('Instant Coffee 200g', 'Groceries', 290.00, 2),
('Dry Fruits Mix 500g', 'Groceries', 499.00, 2),

-- Stationery (Supplier 6: OfficePro Stationery)
('A4 Paper Pack', 'Stationery', 320.00, 6),
('Ballpoint Pen (Pack of 10)', 'Stationery', 150.00, 6),
('Notebook (200 Pages)', 'Stationery', 120.00, 6),
('File Folder Set', 'Stationery', 200.00, 6),
('Marker Pen Set', 'Stationery', 250.00, 6),

-- Textiles (Supplier 5: FashionHouse Textiles)
('Cotton Shirt', 'Clothing', 999.00, 5),
('Denim Jeans', 'Clothing', 1499.00, 5),
('Silk Scarf', 'Accessories', 799.00, 5),
('Leather Wallet', 'Accessories', 1299.00, 5),
('Formal Trousers', 'Clothing', 1399.00, 5);

select * from product;

INSERT INTO stock (product_id, warehouse_id, quantity) VALUES
-- Product 1-5 (Electronics & Smart Devices)
(1, 1, 120), (1, 3, 80),
(2, 2, 60), (2, 5, 100),
(3, 4, 90), (3, 6, 110),
(4, 5, 70), (4, 7, 130),
(5, 8, 60), (5, 10, 90),

-- Product 6-10 (Hardware)
(6, 2, 150), (6, 4, 120),
(7, 3, 90), (7, 5, 70),
(8, 6, 60), (8, 8, 100),
(9, 7, 80), (9, 9, 120),
(10, 10, 95), (10, 1, 70),

-- Product 11-15 (Groceries)
(11, 2, 200), (11, 4, 180),
(12, 3, 220), (12, 5, 190),
(13, 6, 250), (13, 7, 230),
(14, 8, 175), (14, 9, 160),
(15, 10, 210), (15, 1, 195),

-- Product 16-20 (Stationery)
(16, 2, 300), (16, 5, 280),
(17, 3, 220), (17, 7, 250),
(18, 4, 260), (18, 8, 230),
(19, 6, 240), (19, 9, 210),
(20, 10, 200), (20, 1, 270),

-- Product 21-25 (Clothing & Accessories)
(21, 2, 130), (21, 6, 150),
(22, 3, 110), (22, 7, 100),
(23, 4, 90), (23, 8, 80),
(24, 5, 70), (24, 9, 60),
(25, 10, 50), (25, 1, 75);


select * from stock;

INSERT INTO purchase (product_id, supplier_id, purchase_date, quantity, total_cost)
VALUES
-- Electronics purchases
(1, 1, '2025-01-10', 50, 35000.00),
(2, 1, '2025-01-12', 40, 24000.00),

-- Furniture purchases
(3, 2, '2025-02-05', 20, 50000.00),
(4, 2, '2025-02-10', 25, 37500.00),

-- Clothing purchases
(5, 3, '2025-03-01', 100, 40000.00),
(6, 3, '2025-03-03', 80, 32000.00),

-- Food & Beverages
(7, 4, '2025-04-01', 200, 30000.00),
(8, 4, '2025-04-05', 150, 22500.00),

-- Stationery
(9, 5, '2025-05-15', 300, 4500.00),
(10, 5, '2025-05-18', 250, 3750.00),

-- Hardware Tools
(11, 6, '2025-06-10', 60, 24000.00),
(12, 6, '2025-06-12', 70, 28000.00),

-- Sports Equipment
(13, 7, '2025-07-05', 40, 20000.00),
(14, 7, '2025-07-08', 35, 17500.00),

-- Books & Education
(15, 8, '2025-08-01', 90, 18000.00),
(16, 8, '2025-08-04', 85, 17000.00),

-- Cosmetics
(17, 9, '2025-09-01', 100, 25000.00),
(18, 9, '2025-09-03', 120, 30000.00),

-- Health Products
(19, 10, '2025-10-01', 150, 45000.00),
(20, 10, '2025-10-03', 130, 39000.00);

select * from purchase;

INSERT INTO sales (product_id, sale_date, quantity, total_price, warehouse_id) VALUES
(1, '2025-01-10', 25, 12500.00, 1),
(2, '2025-01-12', 15, 4500.00, 2),
(3, '2025-01-15', 40, 20000.00, 3),
(4, '2025-01-17', 10, 15000.00, 4),
(5, '2025-01-20', 30, 9000.00, 5),
(6, '2025-01-25', 12, 7200.00, 6),
(7, '2025-02-02', 8, 5600.00, 7),
(8, '2025-02-05', 20, 8000.00, 8),
(9, '2025-02-10', 10, 3000.00, 9),
(10, '2025-02-14', 18, 16200.00, 10),
(11, '2025-02-20', 25, 6250.00, 1),
(12, '2025-02-25', 14, 11200.00, 2),
(13, '2025-03-01', 30, 9000.00, 3),
(14, '2025-03-05', 22, 15400.00, 4),
(15, '2025-03-10', 40, 32000.00, 5),
(16, '2025-03-15', 9, 4500.00, 6),
(17, '2025-03-18', 16, 9600.00, 7),
(18, '2025-03-20', 11, 7700.00, 8),
(19, '2025-03-25', 20, 20000.00, 9),
(20, '2025-03-30', 15, 7500.00, 10);

select * from sales;



-- drop database inventory_warehouse_db;