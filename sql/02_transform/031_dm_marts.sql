drop materialized view if exists dm.mv_sales_monthly;
create materialized view dm.mv_sales_monthly as
select
  dd.year,
  dd.month,
  dd.month_name,
  sum(fs.sales) as revenue,
  sum(fs.profit) as profit,
  sum(fs.quantity) as qty,
  count(distinct fs.order_id) as orders,
  case when sum(fs.sales) = 0 then null else sum(fs.profit)/sum(fs.sales) end as margin_pct
from dm.fact_sales fs
join dm.dim_date dd on dd.date_key = fs.order_date_key
group by dd.year, dd.month, dd.month_name;

create index if not exists ix_mv_sales_monthly_ym on dm.mv_sales_monthly(year, month);

drop materialized view if exists dm.mv_sales_geo;
create materialized view dm.mv_sales_geo as
select
  g.country, g.region, g.state, g.city,
  sum(fs.sales) as revenue,
  sum(fs.profit) as profit,
  count(distinct fs.order_id) as orders
from dm.fact_sales fs
left join dm.dim_geo g on g.geo_key = fs.geo_key
group by g.country, g.region, g.state, g.city;

create index if not exists ix_mv_sales_geo_region on dm.mv_sales_geo(region);

drop materialized view if exists dm.mv_sales_product;
create materialized view dm.mv_sales_product as
select
  p.category, p.sub_category, p.product_name,
  sum(fs.sales) as revenue,
  sum(fs.profit) as profit,
  sum(fs.quantity) as qty
from dm.fact_sales fs
join dm.dim_product p on p.product_key = fs.product_key
group by p.category, p.sub_category, p.product_name;

create index if not exists ix_mv_sales_product_cat on dm.mv_sales_product(category, sub_category);
