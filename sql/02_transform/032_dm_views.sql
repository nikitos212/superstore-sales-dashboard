create or replace view dm.v_fact_sales as
select
  fs.*,
  d1.date_value as order_date,
  d2.date_value as ship_date,
  case
    when d2.date_value is null then null
    else (d2.date_value - d1.date_value)
  end as ship_days
from dm.fact_sales fs
join dm.dim_date d1 on d1.date_key = fs.order_date_key
left join dm.dim_date d2 on d2.date_key = fs.ship_date_key;
