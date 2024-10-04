-- bad one
explain
(select
    count(o.order_id) / count(distinct c.email) as averege_customer_order ,
    p.product_category as category,
    count(o.order_id) as orders_count,
    count(distinct c.email) as unique_cust_count
from opt_orders o
join opt_clients c on o.client_id = c.id
join opt_products p on o.product_id = p.product_id
where c.status = 'active'
group by p.product_category
order by averege_customer_order desc
limit 1)

union

(select
    count(o.order_id) / count(distinct c.email) as averege_customer_order ,
    p.product_category as category,
    count(o.order_id) as orders_count,
    count(distinct c.email) as unique_cust_count
from opt_orders o
join opt_clients c on o.client_id = c.id
join opt_products p on o.product_id = p.product_id
where c.status = 'active'
group by p.product_category
order by averege_customer_order asc
limit 1);

-- optimized one

create index idx_clients_status on opt_clients(status);
create index idx_orders_client_id on opt_orders(client_id);
create index idx_orders_product_id on opt_orders(product_id);
create index idx_products_category on opt_products(product_category);

explain
with order_stats as (
    select
        p.product_category as category,
        count(o.order_id) as orders_count,
        count(distinct c.email) as unique_cust_count
    from opt_orders o
    join opt_clients c on o.client_id = c.id
    join opt_products p on o.product_id = p.product_id
    where c.status = 'active'
    group by p.product_category
)

(select
    orders_count / unique_cust_count as average_customer_order ,
    category,
    orders_count,
    unique_cust_count
from order_stats
order by average_customer_order desc
limit 1)

union all

(select orders_count / unique_cust_count as average_customer_order ,
    category,
    orders_count,
    unique_cust_count
from order_stats
order by average_customer_order asc
limit 1);

git init
git remote add origin https://github.com/yegqr/DB-HW-2.git
git branch -M main
git add .
git commit -m "Initial commit"
git push -u origin main