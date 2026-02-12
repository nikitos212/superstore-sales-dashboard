\set ON_ERROR_STOP on

TRUNCATE dm.fact_sales, dm.dim_date;

-- 1) dim_date: генерим календарь по min/max order_date/ship_date из staging
DO $$
DECLARE
  d_min date;
  d_max date;
BEGIN
  SELECT
    min(order_date),
    max(greatest(order_date, coalesce(ship_date, order_date)))
  INTO d_min, d_max
  FROM stg.orders_clean;

  IF d_min IS NULL THEN
    RAISE EXCEPTION 'stg.orders_clean is empty';
  END IF;

  INSERT INTO dm.dim_date (date_key, date_value, year, month, month_name, quarter, week_of_year, day_of_month, day_name)
  SELECT
    to_char(d, 'YYYYMMDD')::int as date_key,
    d as date_value,
    extract(year from d)::int,
    extract(month from d)::int,
    trim(to_char(d, 'TMMonth')) as month_name,
    extract(quarter from d)::int,
    extract(week from d)::int,
    extract(day from d)::int,
    trim(to_char(d, 'TMDay')) as day_name
  FROM generate_series(d_min, d_max, interval '1 day') AS g(d);
END $$;

-- 2) dim_customer (ровно 1 строка на customer_id)
INSERT INTO dm.dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT ON (customer_id)
  customer_id,
  customer_name,
  segment
FROM stg.orders_clean
ORDER BY customer_id, load_dts DESC
ON CONFLICT (customer_id) DO UPDATE
SET customer_name = excluded.customer_name,
    segment       = excluded.segment;

-- 3) dim_product (ровно 1 строка на product_id)
INSERT INTO dm.dim_product (product_id, product_name, category, sub_category)
SELECT DISTINCT ON (product_id)
  product_id,
  product_name,
  category,
  sub_category
FROM stg.orders_clean
ORDER BY product_id, load_dts DESC
ON CONFLICT (product_id) DO UPDATE
SET product_name = excluded.product_name,
    category     = excluded.category,
    sub_category = excluded.sub_category;

-- 4) dim_geo (натуральный ключ)
INSERT INTO dm.dim_geo (country, region, state, city, postal_code)
SELECT DISTINCT
  country, region, state, city, postal_code
FROM stg.orders_clean
ON CONFLICT (country, region, state, city, postal_code) DO NOTHING;

-- 5) fact_sales
INSERT INTO dm.fact_sales (
  row_id, order_id, order_date_key, ship_date_key, ship_mode,
  customer_key, product_key, geo_key,
  sales, quantity, discount, profit
)
SELECT
  s.row_id,
  s.order_id,
  d_order.date_key,
  d_ship.date_key,
  s.ship_mode,
  c.customer_key,
  p.product_key,
  g.geo_key,
  s.sales, s.quantity, s.discount, s.profit
FROM stg.orders_clean s
JOIN dm.dim_date d_order ON d_order.date_value = s.order_date
LEFT JOIN dm.dim_date d_ship ON d_ship.date_value = s.ship_date
JOIN dm.dim_customer c ON c.customer_id = s.customer_id
JOIN dm.dim_product  p ON p.product_id  = s.product_id
LEFT JOIN dm.dim_geo g ON (g.country, g.region, g.state, g.city, g.postal_code)
                       IS NOT DISTINCT FROM (s.country, s.region, s.state, s.city, s.postal_code);
