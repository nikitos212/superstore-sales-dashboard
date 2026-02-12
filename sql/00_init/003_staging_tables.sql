drop table if exists stg.orders_clean;

create table stg.orders_clean (
  row_id              int,
  order_id            text not null,
  order_date          date not null,
  ship_date           date,
  ship_mode           text,
  customer_id         text not null,
  customer_name       text,
  segment             text,
  country             text,
  city                text,
  state               text,
  postal_code         text,
  region              text,
  product_id          text not null,
  category            text,
  sub_category        text,
  product_name        text,
  sales               numeric(14,2),
  quantity            int,
  discount            numeric(6,4),
  profit              numeric(14,2),
  load_dts            timestamptz not null default now()
);

create index if not exists ix_stg_orders_order_date on stg.orders_clean(order_date);
create index if not exists ix_stg_orders_order_id on stg.orders_clean(order_id);
create index if not exists ix_stg_orders_customer_id on stg.orders_clean(customer_id);
create index if not exists ix_stg_orders_product_id on stg.orders_clean(product_id);
