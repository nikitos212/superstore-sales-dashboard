-- Создание базы данных
CREATE DATABASE superstore;
\c superstore;

-- Таблица заказов (основная)
CREATE TABLE orders (
    row_id SERIAL PRIMARY KEY,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(20),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales NUMERIC(10,2),
    quantity INTEGER,
    discount NUMERIC(5,2),
    profit NUMERIC(10,2)
);

-- Таблица менеджеров
CREATE TABLE people (
    person VARCHAR(100),
    region VARCHAR(20),
    PRIMARY KEY (person, region)
);

-- Таблица возвратов
CREATE TABLE returns (
    order_id VARCHAR(20),
    returned VARCHAR(10)
);