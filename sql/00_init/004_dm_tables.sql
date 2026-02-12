drop table if exists dm.dim_date cascade;
create table dm.dim_date (
  date_key        int primary key,
  date_value      date not null unique,
  year            int not null,
  month           int not null,
  month_name      text not null,
  quarter         int not null,
  week_of_year    int not null,
  day_of_month    int not null,
  day_name        text not null
);

drop table if exists dm.dim_customer cascade;
create table dm.dim_customer (
  customer_key    bigserial primary key,
  customer_id     text not null unique,
  customer_name   text,
  segment         text
);

drop table if exists dm.dim_product cascade;
create table dm.dim_product (
  product_key     bigserial primary key,
  product_id      text not null unique,
  product_name    text,
  category        text,
  sub_category    text
);

drop table if exists dm.dim_geo cascade;
create table dm.dim_geo (
  geo_key         bigserial primary key,
  country         text,
  region          text,
  state           text,
  city            text,
  postal_code     text,
  unique(country, region, state, city, postal_code)
);

drop table if exists dm.fact_sales cascade;
create table dm.fact_sales (
  sales_key       bigserial primary key,
  row_id          int,
  order_id        text not null,
  order_date_key  int not null references dm.dim_date(date_key),
  ship_date_key   int references dm.dim_date(date_key),
  ship_mode       text,
  customer_key    bigint not null references dm.dim_customer(customer_key),
  product_key     bigint not null references dm.dim_product(product_key),
  geo_key         bigint references dm.dim_geo(geo_key),
  sales           numeric(14,2),
  quantity        int,
  discount        numeric(6,4),
  profit          numeric(14,2)
);

create index if not exists ix_fact_sales_order_date_key on dm.fact_sales(order_date_key);
create index if not exists ix_fact_sales_customer_key on dm.fact_sales(customer_key);
create index if not exists ix_fact_sales_product_key on dm.fact_sales(product_key);
create index if not exists ix_fact_sales_geo_key on dm.fact_sales(geo_key);
