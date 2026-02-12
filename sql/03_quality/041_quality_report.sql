drop materialized view if exists qc.quality_report;

create materialized view qc.quality_report as
select
  now() as report_dts,
  count(*) as total_rows,

  avg( (customer_name is null)::int ) as pct_null_customer_name,
  avg( (postal_code is null)::int ) as pct_null_postal_code,
  avg( (ship_date is null)::int ) as pct_null_ship_date,

  avg( (sales <= 0)::int ) as pct_sales_non_positive,
  avg( (quantity <= 0)::int ) as pct_qty_non_positive,
  avg( (discount < 0 or discount > 1)::int ) as pct_discount_out_of_range,
  avg( (ship_date is not null and ship_date < order_date)::int ) as pct_ship_before_order
from stg.orders_clean;

create index if not exists ix_qc_report_dts on qc.quality_report(report_dts);
