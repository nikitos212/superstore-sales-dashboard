-- Создание витрины данных для анализа
CREATE VIEW sales_data_mart AS
SELECT 
    -- Дата
    DATE_TRUNC('month', o.order_date) AS order_month,
    EXTRACT(YEAR FROM o.order_date) AS order_year,
    EXTRACT(MONTH FROM o.order_date) AS order_month_num,
    
    -- География
    o.region,
    o.state,
    o.city,
    
    -- Категории
    o.category,
    o.sub_category,
    o.segment,
    
    -- Продукт
    o.product_id,
    o.product_name,
    
    -- Менеджер
    p.person AS manager,
    
    -- Возвраты
    CASE WHEN r.returned = 'Yes' THEN 1 ELSE 0 END AS is_returned,
    
    -- Метрики
    SUM(o.sales) AS total_sales,
    SUM(o.profit) AS total_profit,
    SUM(o.quantity) AS total_quantity,
    AVG(o.discount) AS avg_discount,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT o.customer_id) AS customer_count,
    
    -- Расчетные показатели
    SUM(o.profit) / NULLIF(SUM(o.sales), 0) AS profit_margin,
    SUM(o.sales) / COUNT(DISTINCT o.customer_id) AS avg_sales_per_customer
    
FROM orders o
LEFT JOIN people p ON o.region = p.region
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY 
    DATE_TRUNC('month', o.order_date),
    EXTRACT(YEAR FROM o.order_date),
    EXTRACT(MONTH FROM o.order_date),
    o.region, o.state, o.city,
    o.category, o.sub_category, o.segment,
    o.product_id, o.product_name,
    p.person,
    r.returned;