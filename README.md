# 🏭 Inventory and Warehouse Management System

## 📘 Overview

The **Inventory and Warehouse Management System** is a database-driven project designed to streamline product storage, supplier management, stock tracking, purchases, and sales operations.
This project simulates how real-world inventory systems operate in industries such as manufacturing, retail, or logistics — ensuring **data integrity, automation, and analytical insights**.

The project was implemented using **MySQL** and follows a structured database design approach with normalization, foreign key constraints, triggers, and advanced analytical queries.

---

## 🎯 Objectives

* To design a **normalized database** structure for managing inventory and warehouse operations.
* To implement **referential integrity** using foreign key constraints.
* To enable **data analysis** using SQL joins, aggregation, and filtering.
* To automate alerts using **triggers** for low-stock situations.
* To simulate a realistic warehouse management scenario using **sample data (50–100 rows)**.

---

## 🧩 Phase 1: Research & Design (Entity Identification)

### Identified Entities

1. **Supplier** – Stores information about product suppliers.
2. **Product** – Details about goods supplied and their pricing.
3. **Warehouse** – Contains warehouse location and identification.
4. **Stock** – Tracks quantity of each product available in each warehouse.
5. **Purchase** – Records product purchase transactions from suppliers.
6. **Sales** – Logs sales transactions to customers.

These entities together ensure that all aspects of product flow — from supplier to sale — are managed efficiently.

---

## 🧱 Phase 2: ER Diagram & Normalization

### 🔹 ER Diagram

The **ER Diagram** was created using [dbdiagram.io](https://dbdiagram.io), connecting entities with appropriate cardinalities:

* **Supplier → Product** (1-to-many)
* **Product → Stock** (1-to-many)
* **Warehouse → Stock** (1-to-many)
* **Product → Purchase** (1-to-many)
* **Product → Sales** (1-to-many)

### 🔹 Normalization

The schema was normalized up to **Third Normal Form (3NF)** to:

* Remove data redundancy.
* Ensure dependency preservation.
* Enhance data integrity.

Each table contains atomic values and no transitive dependencies.

---

## 🧮 Phase 3: Table Creation & Constraints

Each table is created with **primary keys, foreign keys, and unique constraints** to maintain integrity.

### 🧾 Example: Product Table

```sql
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
```

**Highlights:**

* **AUTO_INCREMENT** for unique IDs.
* **ON DELETE SET NULL** ensures product data remains even if supplier is removed.
* **ON UPDATE CASCADE** automatically updates supplier references.

---

## 📊 Phase 4: Data Population (Inserting Sample Dataset)

Realistic datasets were inserted for all tables — around **50–100 rows total** — to simulate real business scenarios.

### Tables Populated:

* `supplier`
* `warehouse`
* `product`
* `stock`
* `purchase`
* `sales`

Each table includes meaningful data such as:

* Supplier locations across India.
* Multiple warehouses for product distribution.
* Varying product quantities and unit prices.
* Transactional data with realistic dates and amounts.

---

## ⚙️ Phase 5: Advanced Queries (Reports & Analysis)

### 🔹 A. JOIN Queries

**1. List products with their supplier names**

```sql
SELECT p.product_name, s.supplier_name
FROM product p
JOIN supplier s ON p.supplier_id = s.supplier_id;
```

**2. Show stock availability with warehouse details**

```sql
SELECT w.warehouse_name, p.product_name, s.quantity
FROM stock s
JOIN warehouse w ON s.warehouse_id = w.warehouse_id
JOIN product p ON s.product_id = p.product_id;
```

**3. Display purchases with supplier and product info**

```sql
SELECT pur.purchase_id, p.product_name, s.supplier_name, pur.quantity, pur.total_cost
FROM purchase pur
JOIN product p ON pur.product_id = p.product_id
JOIN supplier s ON pur.supplier_id = s.supplier_id;
```

---

### 🔹 B. Aggregate & Group Queries

**1. Total stock per warehouse**

```sql
SELECT w.warehouse_name, SUM(s.quantity) AS total_stock
FROM stock s
JOIN warehouse w ON s.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name
ORDER BY total_stock DESC;
```

**2. Total purchase cost per supplier**

```sql
SELECT s.supplier_name, SUM(pur.total_cost) AS total_purchase_cost
FROM purchase pur
JOIN supplier s ON pur.supplier_id = s.supplier_id
GROUP BY s.supplier_name;
```

**3. Total sales revenue per product**

```sql
SELECT p.product_name, SUM(sal.total_price) AS total_revenue
FROM sales sal
JOIN product p ON sal.product_id = p.product_id
GROUP BY p.product_name;
```

---

### 🔹 C. HAVING & Filtering Queries

**1. Show suppliers whose total purchase exceeds ₹50,000**

```sql
SELECT s.supplier_name, SUM(pur.total_cost) AS total_purchase
FROM purchase pur
JOIN supplier s ON pur.supplier_id = s.supplier_id
GROUP BY s.supplier_name
HAVING total_purchase > 50000;
```

**2. List products sold more than 500 units total**

```sql
SELECT p.product_name, SUM(sal.quantity) AS total_units_sold
FROM sales sal
JOIN product p ON sal.product_id = p.product_id
GROUP BY p.product_name
HAVING total_units_sold > 500
ORDER BY total_units_sold DESC;
```

---

### 🔹 D. Analytical / Reporting Queries

**1. Find top 5 best-selling products**

```sql
SELECT p.product_name, SUM(sal.quantity) AS total_sold
FROM sales sal
JOIN product p ON sal.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;
```

**2. Find least-stocked items**

```sql
SELECT p.product_name, SUM(s.quantity) AS current_stock
FROM stock s
JOIN product p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY current_stock ASC
LIMIT 5;
```

**3. Monthly sales summary**

```sql
SELECT MONTH(sale_date) AS month, SUM(total_price) AS monthly_sales
FROM sales
GROUP BY MONTH(sale_date)
ORDER BY month;
```

---

## 🚨 Phase 6: Triggers & Stored Procedures (Automation)

### 🔔 Trigger: Low Stock Alert

Automatically inserts alerts when stock drops below a threshold.

```sql
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
```

**Purpose:**
To notify when any warehouse runs low on specific products.

---

## 🧪 Phase 7: Testing & Validation

### ✅ Validation Steps

* Verified all **foreign key relationships** and cascading updates.
* Checked **JOIN** and **HAVING** queries for accurate grouping results.
* Tested **low stock trigger** by reducing quantities below threshold.
* Ensured all tables maintain **referential integrity**.

---

## 💾 Phase 8: Exporting SQL File

To export the complete database structure and data:

```bash
mysqldump -u root -p inventory_db > inventory_project.sql
```

This `.sql` file contains:

* All table definitions
* Constraints and foreign keys
* Data inserts
* Triggers

It can be easily imported into another MySQL environment using:

```bash
mysql -u root -p inventory_db < inventory_project.sql
```

---

## 🧾 Phase 9: Conclusion

This **Inventory and Warehouse Management System** demonstrates the full lifecycle of a database project:

* From **design and normalization**
* To **data management and automation**
* To **analytical query reporting**

It reflects a real-world use case in warehouse operations and showcases SQL proficiency through practical implementation, optimization, and automation.

---

## 🧑‍💻 Technologies Used

* **Database:** MySQL
* **Design Tool:** dbdiagram.io
* **Export Tool:** MySQL Workbench / phpMyAdmin
* **Language:** SQL

---

## ✍️ Author

**Khushi Shetty**
3rd Semester Engineering Student (VTU)
Focused on Database Design, SQL Development, and Data Analytics.
