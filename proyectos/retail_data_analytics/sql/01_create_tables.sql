-- Crear la base de datos y tablas, voy a utilizar snake_case
CREATE DATABASE retail;
GO

USE retail;
GO
-- Crear los esquemas
CREATE SCHEMA raw; -- Datos crudos
GO
CREATE SCHEMA clean; -- Datos limpios
GO

-- Crear las tablas para datos crudos
DROP TABLE IF EXISTS raw.customers;
CREATE TABLE raw.customers (
    customer_id       INT,
    first_name        NVARCHAR(100),
    last_name         NVARCHAR(100),
    email             NVARCHAR(150),
    phone             NVARCHAR(20),
    city              NVARCHAR(100),
    country           NVARCHAR(50),
    age               NVARCHAR(10),
    registration_date NVARCHAR(20)
);
GO

DROP TABLE IF EXISTS raw.products;
CREATE TABLE raw.products (
    product_id    INT,
    product_name  NVARCHAR(150),
    category      NVARCHAR(50),
    price         NVARCHAR(20),
    stock         NVARCHAR(10),
    supplier      NVARCHAR(100),
    created_at    NVARCHAR(20)
);
GO

DROP TABLE IF EXISTS raw.orders;
CREATE TABLE raw.orders (
    order_id        INT,
    customer_id     NVARCHAR(10),
    order_date      NVARCHAR(20),
    total_amount    NVARCHAR(20),
	status          NVARCHAR(30),
    payment_method  NVARCHAR(30),
    shipping_city   NVARCHAR(100),
    notes           NVARCHAR(300)
);
GO

DROP TABLE IF EXISTS raw.order_products;
CREATE TABLE raw.order_products (
    order_product_id INT,
    order_id         NVARCHAR(10),
    product_id       NVARCHAR(10),
    quantity         NVARCHAR(10),
    unit_price       NVARCHAR(20),
    discount         NVARCHAR(10),
    subtotal         NVARCHAR(20)
);
GO

-- Tablas limpias

DROP TABLE IF EXISTS clean.customers;
CREATE TABLE clean.customers (
    customer_id       INT,
    first_name        NVARCHAR(50),
    last_name         NVARCHAR(50),
    email             NVARCHAR(150),
    phone             NVARCHAR(20),
    city              NVARCHAR(100),
    country           NVARCHAR(50),
    age               TINYINT,
    registration_date DATE,
    CONSTRAINT pk_clean_customers PRIMARY KEY (customer_id)
);
GO

DROP TABLE IF EXISTS clean.products;
CREATE TABLE clean.products (
    product_id   INT NOT NULL,
    product_name NVARCHAR(150) NOT NULL,
    category     NVARCHAR(50),
    price        DECIMAL(10, 2),
    stock        INT,
    supplier     NVARCHAR(100),
    created_at   DATE,
    CONSTRAINT pk_clean_products PRIMARY KEY (product_id)
);
GO

DROP TABLE IF EXISTS clean.orders;
CREATE TABLE clean.orders (
    order_id       INT NOT NULL,
    customer_id    INT NOT NULL,
    order_date     DATE,
    total_amount   DECIMAL(10, 2),
    status         NVARCHAR(20),
    payment_method NVARCHAR(30),
    shipping_city  NVARCHAR(100),
    notes          NVARCHAR(300),
    CONSTRAINT pk_clean_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
        REFERENCES clean.customers (customer_id)
);
GO

DROP TABLE IF EXISTS clean.order_products;
CREATE TABLE clean.order_products (
    order_product_id INT NOT NULL,
    order_id         INT NOT NULL,
    product_id       INT NOT NULL,
    quantity         INT,
    unit_price       DECIMAL(10, 2),
    discount         DECIMAL(5, 2),
    subtotal         DECIMAL(10, 2),
    CONSTRAINT pk_clean_order_products  PRIMARY KEY (order_product_id),
    CONSTRAINT fk_op_orders FOREIGN KEY (order_id)
        REFERENCES clean.orders (order_id),
    CONSTRAINT fk_op_products FOREIGN KEY (product_id)
        REFERENCES clean.products (product_id)
);
GO