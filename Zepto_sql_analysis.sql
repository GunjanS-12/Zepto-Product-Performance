create database zepto_project;

use zepto_project;

CREATE TABLE zepto (
    sku_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discount_percent DECIMAL(5,2),
    available_quantity INT,
    discount_selling_price DECIMAL(8,2),
    weight_gms INT,
    out_of_stock BOOLEAN,
    quantity INT
);

-- Data Exploration

-- Count of Rows
select count(*) from zepto;

-- Sample Data
select * from zepto limit 10;

-- Check NUll Values in Columns
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discount_percent is null
or
available_quantity is null
or
discount_selling_price is null
or
weight_gms is null
or
out_of_stock is null
or
quantity is null;

-- Different Product Category
select distinct category from zepto; 

-- Product in stock vs out of stock
select case
when out_of_stock=1 then 'out of stock'
else 'in stock'
end as Stock_Status,
count(*) as Product_Count
from zepto
group by Stock_Status;

-- Product names present multiple times
select name, count(sku_id) as "Number of sku"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;  
     --  ------------or -----------
SELECT name, COUNT(*) AS times_present
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY times_present DESC;

-- Data Cleaning

-- Product with price = 0
select * from zepto
where mrp=0 or discount_selling_price=0;

SET SQL_SAFE_UPDATES = 0;
delete from zepto where mrp=0;

-- Convert paise into rupees
update zepto
set mrp= mrp/100,
discount_selling_price= discount_selling_price/100;

select mrp, discount_selling_price
from zepto;

-- Data Analysis: 

-- Q1. Find the top 10 best value product based on the discount percentage. 
select name, category, discount_percent
from zepto
order by discount_percent desc 
limit 10;

-- Q2. What are the products with high MRP but out of stock?
select distinct name, mrp, out_of_stock
from zepto
where out_of_stock=1 and mrp>300
order by mrp desc;
 
 -- Q3. Calculate estimated revenue for each category.
 select category, 
 round(sum(discount_selling_price * quantity),2) as tot_revenue
 from zepto
 group by category
 order by tot_revenue;
 
-- Q4. Find all products where MRP is greater than 500 and discount is less than 10%.
select distinct name, mrp, discount_percent
from zepto
where mrp>500 and discount_percent<10
order by mrp desc, discount_percent desc;
 
-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category, round(avg(discount_percent),2) as avg_dict_per
from zepto
group by category
order by avg_dict_per desc
limit 5;

-- Q6. Find the price per gram for products above 100gm and sort by best value.
select distinct name, weight_gms, discount_selling_price,
round(discount_selling_price / weight_gms, 2) AS price_per_gram
from zepto
where weight_gms >= 100
order by price_per_gram asc;

-- Q7. Group the product into categories like low, medium, bulk.
select distinct name, weight_gms,
case 
when weight_gms<250 then "low"
when weight_gms between 250 and 1000 then "medium"
else "bulk"
end as product_size
from zepto; 

-- Q8. What is the total inventory weight per category?
select category,
sum(weight_gms * available_quantity) AS total_inventory_weight_gms
from zepto
group by category
order by total_inventory_weight_gms;



   
  

 
 



