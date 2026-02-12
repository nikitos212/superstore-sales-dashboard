truncate table stg.orders_clean;

insert into stg.orders_clean (
  row_id, order_id, order_date, ship_date, ship_mode,
  customer_id, customer_name, segment,
  country, city, state, postal_code, region,
  product_id, category, sub_category, product_name,
  sales, quantity, discount, profit
)
select
  nullif(trim(row_id), '')::int,
  trim(order_id),
  to_date(trim(order_date), 'MM/DD/YYYY'),
  case
    when nullif(trim(ship_date), '') is null then null
    else to_date(trim(ship_date), 'MM/DD/YYYY')
  end,
  nullif(trim(ship_mode),''),
  trim(customer_id),
  nullif(trim(customer_name),''),
  nullif(trim(segment),''),
  nullif(trim(country),''),
  nullif(trim(city),''),
  nullif(trim(state),''),
  nullif(trim(postal_code),''),
  nullif(trim(region),''),
  trim(product_id),
  nullif(trim(category),''),
  nullif(trim(sub_category),''),
  nullif(trim(product_name),''),
  nullif(trim(sales),'')::numeric,
  nullif(trim(quantity),'')::int,
  nullif(trim(discount),'')::numeric,
  nullif(trim(profit),'')::numeric
from raw.superstore_orders
where nullif(trim(order_id),'') is not null
  and nullif(trim(customer_id),'') is not null
  and nullif(trim(product_id),'') is not null
  and nullif(trim(order_date),'') is not null;
