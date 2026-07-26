-- simple exploratory data analysis

-- database exploration
select * from information_schema.columns
where table_name = 'dim_customers';

-- How many total records are in fact_orders?
select count(*)
from fact_orders; -- 180519

-- How many unique orders exist?
select count(distinct Order_Id)
from fact_orders;

-- How many unique customers have placed orders?
select  * 
from fact_orders;

select count(distinct Customer_Id) as unique_customers
from fact_orders 
where Order_Id is not null;

select count(*)
from dim_customers;

-- How many unique products have been ordered?
select count(distinct Product_Card_Id) as unique_products
from fact_orders 
where Order_Id is not null;


-- Dimension Exploration

select distinct(Customer_Segment)
from dim_customers;

select distinct Payment_Type
from fact_orders;

select distinct Market
from fact_orders;

select distinct Order_Status
from fact_orders;

select distinct Delivery_Status
from fact_orders;

select distinct Shipping_Mode
from fact_orders;

-- Date Exploration
select min(Order_date_clean) as first_order, max(Order_date_clean) as last_order, timestampdiff(year, min(Order_date_clean), max(Order_date_clean)) as year, timestampdiff(month, min(Order_date_clean), max(Order_date_clean)) as month
from fact_orders;

select 
	min(Order_date_clean) as first_order, 
    max(Order_date_clean) as last_order,
    count(distinct year(Order_date_clean)) as distinct_years,
    count(distinct date_format(Order_date_clean, '%y-%m')) as distinct_months
from fact_orders;

select min(Shipping_date_clean), max(Shipping_date_clean)
from fact_orders;

-- Measure Exploration
-- What is the min, max and average of Sales?
-- What is the min, max and average of Order_Profit_Per_Order?
-- What is the min, max and average of Order_Item_Discount_Rate?
-- What is the min, max and average of Days_for_shipping_real?

select min(Sales), max(Sales), avg(Sales)
from fact_orders;

select min(Order_Profit_Per_Order), max(Order_Profit_Per_Order), avg(Order_Profit_Per_Order)
from fact_orders;

select min(Order_Item_Discount_Rate), max(Order_Item_Discount_Rate), avg(Order_Item_Discount_Rate)
from fact_orders;

select min(Order_Item_Discount), max(Order_Item_Discount), avg(Order_Item_Discount)
from fact_orders;

select min(Days_for_shipping_real), max(Days_for_shipping_real), avg(Days_for_shipping_real)
from fact_orders;

-- Magnitude
-- Total revenue (Sales) across all orders?
-- Total profit across all orders?
-- Total quantity sold across all orders?

select sum(Sales)
from fact_orders;

select sum(Order_Profit_Per_Order)
from fact_orders;

select sum(Order_Item_Quantity)
from fact_orders;

-- Ranking
-- Which top 5 categories generate the most revenue?
-- Which top 5 regions generate the most revenue?
-- Which top 5 products generate the most profit?
-- Which shipping mode is used most frequently?
-- Which customer segment places the most orders?

select
    p.Category_Name, 
    sum(o.Sales)
from dim_products as p
left join fact_orders as o
	on p.Product_Card_Id = o.Product_Card_Id
group by p.Category_Name
limit 5;

select Order_Region, sum(Sales)
from fact_orders
group by Order_Region
order by sum(Sales) desc
limit 5;

select
    p.Product_Name, 
    sum(o.Sales)
from dim_products as p
left join fact_orders as o
	on p.Product_Card_Id = o.Product_Card_Id
group by p.Product_Name
order by sum(Sales) desc
limit 5;

select Shipping_Mode, count(Shipping_Mode)
from fact_orders
group by Shipping_Mode;


select
    c.Customer_Segment, 
    count(o.Order_Id)
from dim_customers as c
left join fact_orders as o
	on c.Customer_Id = o.Customer_Id
group by c.Customer_Segment
order by count(o.Order_Id) desc
limit 5;


