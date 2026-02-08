-- Импорт данных в PostgreSQL из CSV

-- 1. Копирование данных заказов
COPY orders(
    order_id, order_date, ship_date, ship_mode, customer_id, 
    customer_name, segment, country, city, state, postal_code, 
    region, product_id, category, sub_category, product_name, 
    sales, quantity, discount, profit
)
FROM '/путь/к/файлу/Superstore.csv' 
DELIMITER ',' 
CSV HEADER;

-- 2. Создайте файл people.csv и импортируйте
COPY people(person, region)
FROM '/путь/к/файлу/people.csv'
DELIMITER ',' CSV HEADER;

-- 3. Создайте файл returns.csv и импортируйте
COPY returns(order_id, returned)
FROM '/путь/к/файлу/returns.csv'
DELIMITER ',' CSV HEADER;