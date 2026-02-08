-- Примеры аналитических запросов

-- 1. Топ-10 самых прибыльных продуктов
SELECT 
    product_name,
    category,
    SUM(profit) AS total_profit,
    SUM(sales) AS total_sales
FROM orders
GROUP BY product_name, category
ORDER BY total_profit DESC
LIMIT 10;

-- 2. Динамика продаж по месяцам
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS monthly_sales,
    SUM(profit) AS monthly_profit
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- 3. Конверсия по регионам (заказы на клиента)
SELECT 
    region,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(COUNT(DISTINCT order_id) * 1.0 / COUNT(DISTINCT customer_id), 2) AS orders_per_customer
FROM orders
GROUP BY region
ORDER BY orders_per_customer DESC;

-- 4. Анализ возвратов
SELECT 
    o.category,
    o.sub_category,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN r.returned = 'Yes' THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN r.returned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY o.category, o.sub_category
HAVING COUNT(*) > 10
ORDER BY return_rate DESC;