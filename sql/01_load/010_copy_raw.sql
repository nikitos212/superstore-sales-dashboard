truncate table raw.superstore_orders;

copy raw.superstore_orders (
  row_id, order_id, order_date, ship_date, ship_mode,
  customer_id, customer_name, segment,
  country, city, state, postal_code, region,
  product_id, category, sub_category, product_name,
  sales, quantity, discount, profit
)
from '/data/raw/superstore_orders.csv'
with (format csv, header true);
