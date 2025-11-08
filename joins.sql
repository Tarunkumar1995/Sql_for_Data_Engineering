select * from dim_customer;
select * from dim_store;
select * from fact_sales;
select * from dim_product;
select * from dim_date;




-- LEVEL 1 — Basic Joins
-- 1. Retrieve sales details by joining fact_sales with dim_product to show
-- product_name, quantity_sold, unit_price, and total_amount.
select 
        dp.product_name, 
		fs.quantity_sold, 
        fs.unit_price,
        fs.total_amount
from 
       fact_sales as fs
	   inner join dim_product as dp
       on fs.product_key = dp.product_key;
     
-- Join fact_sales with dim_customer to display each sale with the customer’s
-- first_name, last_name, and country.   
  
select 
          dc.first_name,
          dc.last_name,
          dc.country
from 
       fact_sales as fs
       inner join dim_customer dc on fs.customer_key = dc.customer_key;

-- Join fact_sales with dim_store to show
-- store_name, city, region, and total_amount.

select 
        ds.store_name,
        ds.city,
        ds.region,
        fs.total_amount
from 
       fact_sales as fs
       inner join dim_store ds on fs.store_key = ds.store_key;
       
-- Combine fact_sales + dim_product + dim_store
 -- to show store_name, product_name, and total sales amount.

select
          fs.sales_id,
          ds.store_name,
          dp.product_name,
          fs.quantity_sold,
          fs.total_amount
from fact_sales as fs
          inner join dim_store as ds
           on fs.store_key = ds.store_key
		 inner join dim_product as dp
          on fs.product_key = dp.product_key;

-- List each customer_name and the product_name they purchased.
-- (Hint: requires joining fact_sales → dim_customer → dim_product.)

select
	   fs.customer_key,
       fs.product_key,
       CONCAT(dc.first_name, ' ', dc.last_name) as full_name,
       dp.product_name
from fact_sales as fs
       inner join dim_customer as dc
         on fs.customer_key = dc.customer_key
	inner join dim_product as dp
         on fs.product_key = dp.product_key;
         
-- Retrieve product_name, unit_price, discount, and total_amount for every sale
-- to verify pricing details.

select 
        fs.product_key,
        dp.product_name,
        fs.unit_price,
        fs.discount,
        fs.total_amount
from
      fact_sales as fs
		inner join dim_product as dp
        on fs.product_key = dp.product_key;
        
-- LEVEL 2 --   
-- Get the total sales amount per customer by joining fact_sales and dim_customer.

select
        concat(dc.first_name,' ', dc.last_name) as full_name,
		sum(fs.total_amount) as total_sales_amount
from
       fact_sales as fs
inner join 
         dim_customer as dc on fs.customer_key = dc.customer_key
group by
        fs.customer_key
having full_name like '%Kelly'
order by
        total_sales_amount desc;

-- Find total quantity sold per product category by joining fact_sales and dim_product.
select 
       dp.category,
       sum(fs.quantity_sold) as Total_quantity
from 
       fact_sales as fs
       inner join dim_product as dp
       on fs.product_key =  dp.product_key
group by
        dp.category
order by
        Total_quantity desc;
	
-- Show total revenue by store region (join fact_sales → dim_store).

select
       ds.region,
       sum(fs.total_amount) as total_revenue
from 
       fact_sales as fs
       inner join dim_store as ds
       on fs.store_key = ds.store_key
group by
       ds.region
order by
       total_revenue;

 -- Calculate average discount per brand (join fact_sales → dim_product).
 
 select 
        dp.brand,
        avg(fs.discount) as avg_discount
from
      dim_product as dp
      inner join fact_sales as fs
      on dp.product_key = fs.product_key
group by
        dp.brand
order by
        avg_discount;
        
-- Retrieve total revenue per month and year (join fact_sales → dim_date).

select 
      dd.year,
      dd.month,
      sum(fs.total_amount) as total_amount
from
     dim_date as dd
     inner join fact_sales as fs on dd.date_key = fs.date_key
group by
      dd.year, dd.month
order by
       dd.year desc, dd.month desc;

-- Get total revenue by customer country and product category
-- (multi-join: fact_sales → dim_customer → dim_product).

select
       dc.country,
       dp.category,
       sum(fs.total_amount) as total_amount
from 
      fact_sales as fs
      inner join dim_customer as dc on fs.customer_key = dc.customer_key
      inner join dim_product as dp on fs.product_key = dp.product_key
group by
     dc.country,
     dp.category
 order by
         total_amount desc;
         
-- List top 5 customers by revenue (join fact + customer, aggregate, sort).
select
        concat(dc.first_name, ' ', dc.last_name) as full_name,
        sum(fs.total_amount) as total_revenue
from
      fact_sales as fs
      inner join dim_customer as dc
       on fs.customer_key = dc.customer_key
group by
       full_name
order by
      total_revenue desc
limit 5;

-- Display total quantity sold and total revenue per product along with
-- the store_name where it was sold.
select 
      ds.store_name,
      dp.product_name,
      sum(fs.quantity_sold) as total_quantity,
      sum(total_amount) as total_revenue
from fact_sales as fs
      inner join dim_store as ds 
        on fs.store_key =  ds.store_key
	  inner join dim_product as dp 
       on fs.product_key = dp.product_key
group by
      dp.product_name,
      ds.store_name,
      dp.product_key
-- LEVEL 3

-- Identify sales records that have no matching customer 
-- (use LEFT JOIN + WHERE customer_id IS NULL).

select 
         fs.sales_id,
         fs.customer_key,
         fs.total_amount
from 
          fact_sales as fs
left join dim_customer as dc
     on fs.customer_key = dc.customer_key
where dc.customer_key is null;

-- Find all sales that reference nonexistent products 
-- (use LEFT JOIN between fact_sales and dim_product).

SELECT
     fs.product_key,
     fs.total_amount
FROM  fact_sales AS fs
LEFT JOIN dim_product AS dp
     ON fs.product_key = dp.product_key
WHERE dp.product_key is null;

-- Find all sales that reference nonexistent stores 

SELECT
       fs.sales_id,
       fs.store_key
FROM fact_sales as fs
LEFT JOIN dim_store as ds
      on fs.store_key = ds.store_key
WHERE ds.store_key is null;

-- Display all customers who have never made a purchase

SELECT
        dc.customer_id,
		concat(dc.first_name, ' ', dc.last_name) as full_name
FROM dim_customer AS dc
LEFT JOIN fact_sales AS fs
     ON dc.customer_key = fs.customer_key
WHERE fs.customer_key is null;

--  Find stores that haven’t recorded any sales.

SELECT 
       ds.store_name
FROM dim_store AS ds
LEFT JOIN fact_sales AS fs
      ON ds.store_key = fs.store_key
WHERE fs.sales_id is null;

-- Join all five tables to create a complete analytical view with:
-- date, store_name, city, product_name, brand, customer_name, quantity_sold, total_amount.

SELECT 
       fs.sales_id,
      dd.date,
      ds.store_name,
      ds.city,
      dp.product_name,
      dp.brand,
      concat(dc.first_name, ' ', dc.last_name) as full_name,
      fs.quantity_sold,
      fs.total_amount
FROM fact_sales as fs
INNER JOIN dim_date as dd 
       ON fs.date_key = dd.date_key
INNER JOIN dim_store as ds
      ON fs.store_key = ds.store_key
INNER JOIN dim_product as dp
      ON fs.product_key = dp.product_key
INNER JOIN dim_customer as dc
      ON fs.customer_key = dc.customer_key
ORDER BY
      fs.sales_id;

-- Create a dataset that shows each customer’s first and last purchase date

select
	  concat(dc.first_name, ' ', dc.last_name) as full_name,
      min(dd.date) as first_purchase,
      max(dd.date) as last_purchase
from fact_sales as fs
inner join dim_customer as dc
      on fs.customer_key = dc.customer_key
inner join dim_date as dd
     on fs.date_key = dd.date_key
group by
	full_name
order by
     dc.customer_id;

-- Find the top-selling product for each region

-- select
--        dp.product_name,
--        ds.region,
--        sum(fs.total_amount) as total_amount
-- from fact_sales as fs
-- inner join dim_product as dp
--       on fs.product_key = dp.product_key
-- inner join dim_store as ds
--       on fs.store_key = ds.store_key
-- group by
--       ds.region,
--       dp.product_name
-- order by
--       ds.region desc,
--       total_amount desc;
