-- 1) Дубли row_id в staging
select 'dup_row_id' as test, row_id, count(*) as cnt
from stg.orders_clean
group by row_id
having count(*) > 1;

-- 2) Некорректные даты (ship_date < order_date)
select 'ship_before_order' as test, order_id, order_date, ship_date
from stg.orders_clean
where ship_date is not null and ship_date < order_date;

-- 3) Аномальные скидки
select 'discount_out_of_range' as test, order_id, discount
from stg.orders_clean
where discount is not null and (discount < 0 or discount > 1);

-- 4) Продажи <= 0
select 'sales_non_positive' as test, order_id, sales
from stg.orders_clean
where sales is not null and sales <= 0;

-- 5) quantity <= 0
select 'qty_non_positive' as test, order_id, quantity
from stg.orders_clean
where quantity is not null and quantity <= 0;
