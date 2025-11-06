-- select
select * from dim_customer;
select 
      customer_id,
      email
from 
	dim_customer
limit 20;

-- WHERE

select 
       *
from
       dim_customer
where gender = 'F'and ((country ='France') or (join_date> '2022-01-01'));

-- LIKE (finds the logical pattern)

select 
      * 
from 
     dim_customer
where first_name like('G%y') and (gender = 'M');


-- Group By
select * from dim_product;
-- 1
select 
      category,
      avg(unit_price) as_Avg_Price,
      sum(unit_price) as Tot_Price
from
     dim_product
group by
        category;
-- 2

select 
      category,
      avg(unit_price) as Avg_Price,
      sum(unit_price) as Tot_Price
from
     dim_product
group by
        category
having Avg_Price > 500;

select * from dim_customer;
select * from dim_product;
select * from dim_date;
select * from dim_store;
select * from fact_sales;
      