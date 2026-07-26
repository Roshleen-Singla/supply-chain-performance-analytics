-- Advanced EDA


-- Cumulative Analysis
-- What is the running total of revenue month over month?
select order_month, total_sales, sum(total_sales) over(order by order_month) as running_total_by_month
from(
select
	date_format(Order_date_clean, '%Y-%M') as order_month,
    sum(Sales) as total_sales
from fact_orders
where Order_date_clean is not null
group by date_format(Order_date_clean, '%Y-%M')) as t;

-- What is the cumulative profit over time?
select order_year, Order_Profit, sum(Order_Profit) over(order by order_year) as running_profit_by_year
from(
select
	date_format(Order_date_clean, '%Y') as order_year,
    sum(Order_Profit_Per_Order) as Order_Profit
from fact_orders
where Order_date_clean is not null
group by date_format(Order_date_clean, '%Y')) as yearly_profit;


-- Change Over Time
-- How has monthly revenue changed year over year?
select 
	order_month, 
 	round(current_sales,2), 
    round(lag(current_sales, 12) over(order by order_month),2) as previous_sales,
    round((current_sales - (lag(current_sales, 12) over(order by order_month))),2)  as abs_sales_diff
from 
(select 
    date_format(Order_date_clean, "%Y-%m") as order_month,
    sum(Sales) as current_sales
from fact_orders
where Order_date_clean is not null
group by date_format(Order_date_clean, "%Y-%m")) t;

-- Which months consistently show highest and lowest sales?
select
	month,
    avg_monthly_sales,
    dense_rank() over (order by avg_monthly_sales desc) as highest_rank,
    dense_rank() over (order by avg_monthly_sales asc) as lowest_rank
from(
select 
	month,
    avg(monthly_sales) as avg_monthly_sales
from(
select 
	year(Order_date_clean) as order_year,
	month(Order_date_clean) as order_month,
    monthname(Order_date_clean) as month,
    sum(Sales) as monthly_sales
from fact_orders
where Order_date_clean is not null
group by 
	year(Order_date_clean),
	month(Order_date_clean),
    monthname(Order_date_clean)) t
group by month, order_month) as monthlysales
order by highest_rank;

-- How has late delivery risk changed over time (monthly trend)?
select
	year(Order_date_clean) as order_year,
    monthname(Order_date_clean) as month,
    count(Late_delivery_risk) as risk_analysis
from fact_orders
where Order_date_clean is not null and Late_delivery_risk = 1
group by 
	year(Order_date_clean),
    monthname(Order_date_clean);
    
    
    
-- Performance
-- Which customers are above and below average order value?
with cust_avg as (
select Customer_Id, avg(Sales) as customer_avg
from fact_orders
group by Customer_id
), overall_avg as(
select avg(Sales) as overall_average
from fact_orders
)
select
    c.Customer_Id,
    round(c.customer_avg, 2) as customer_avg,
    round(o.overall_average, 2) as overall_order_avg,
    case when c.customer_avg > o.overall_average then "Above Average"
		 when c.customer_avg < o.overall_average then "Below Average"
	     else "Average"
	end as performance
from cust_avg as c
cross join overall_avg as o
order by c.customer_avg;

-- Which products perform above and below average profit ratio?
with prod_avg as (
select Product_Card_Id, avg(Order_Item_Profit_Ratio) as order_prod_avg
from fact_orders
group by Product_Card_Id
), overall_product_avg as(
select avg(Order_Item_Profit_Ratio) as overall_order_prod_avg
from fact_orders
)
select
    p.Product_Card_Id,
    round(p.order_prod_avg, 4) as product_avg_profit_ratio,
    round(o.overall_order_prod_avg, 4) as overall_product_avg_profit_ratio,
    case when p.order_prod_avg > o.overall_order_prod_avg then "Above Average"
		 when p.order_prod_avg < o.overall_order_prod_avg then "Below Average"
	     else "Average"
	end as performance
from prod_avg as p
cross join overall_product_avg as o
order by p.order_prod_avg;

-- Which regions have above average late delivery rate?
with region_late_delivery_avg as (
select Order_Region, avg(Late_delivery_risk) as region_late_delivery_risk
from fact_orders
group by Order_Region
), overall_late_delivery_avg as(
select avg(Late_delivery_risk) as late_delivery_risk
from fact_orders
)
select
    r.Order_Region,
    round(r.region_late_delivery_risk, 4) as region_late_delivery_risk,
    round(o.late_delivery_risk, 4) as late_delivery_risk,
    case when r.region_late_delivery_risk > o.late_delivery_risk then "Above Average"
		 when r.region_late_delivery_risk < o.late_delivery_risk then "Below Average"
	     else "Average"
	end as late_delivery_risk
from region_late_delivery_avg as r
cross join overall_late_delivery_avg as o
order by r.region_late_delivery_risk;

-- Part to Whole
-- What % of total revenue does each market contribute?
with market_sales as(
select Market , sum(Sales) as revenue_market
from fact_orders
group by Market)
select 
	Market,
    revenue_market,
    sum( revenue_market) over() as total_revenue,
    round(((revenue_market/sum( revenue_market) over())*100), 2) as per_market
from market_sales;

-- What % of total orders does each shipping mode represent?
with shipping_orders as(
select Shipping_Mode , count(Order_Item_Id) as orders_per_mode
from fact_orders
group by Shipping_Mode)
select 
	Shipping_Mode,
    orders_per_mode,
    sum(orders_per_mode) over() as total_orders,
    round(((orders_per_mode/sum(orders_per_mode) over())*100), 2) as per_order
from shipping_orders;

-- What % of total profit does each customer segment contribute?
with customer_segment_profit as(
select c.Customer_Segment, sum(o.Order_Profit_Per_Order) as segment_profit
from dim_customers c
left join fact_orders o
on c.Customer_Id = o.Customer_Id
group by c.Customer_Segment)
select 
	Customer_Segment,
    segment_profit,
    sum(segment_profit) over() as total_profit,
    round(((segment_profit/sum(segment_profit) over())*100), 2) as per_profit_segemnt
from customer_segment_profit;

-- Data Segmentation
-- Segment customers into High, Medium, Low value based on total revenue they generate
with customer_revenue as(
select Customer_Id, sum(Sales) as total_sales
from fact_orders
group by Customer_Id)
select 
	Customer_Id,
    total_sales,
    case when total_sales < 500 then 'Low'
         when total_sales between 500 and 1500 then 'Medium'
         else "High"
	end as segment_customers_revenue
from customer_revenue;

-- Segment products into High, Medium, Low margin based on profit ratio
with product_profit_ratio as(
select Product_Card_Id, sum(Order_Item_Profit_Ratio) as total_profit
from fact_orders
group by Product_Card_Id)
select 
	Product_Card_Id,
    total_profit,
    case when total_profit < 100  then 'Low'
         when total_profit between 500 and 1500 then 'Medium'
         else "High"
	end as segment_customers_revenue
from product_profit_ratio;

-- Segment orders into Early, On-time, Late based on real vs scheduled shipping days
select 
	Order_Item_Id,
    Days_for_shipping_real,
    Days_for_shipment_scheduled,
    Days_for_shipping_real - Days_for_shipment_scheduled as shipping_delay,
    case when Days_for_shipping_real < Days_for_shipment_scheduled then "Early"
         when Days_for_shipping_real = Days_for_shipment_scheduled then "On-Time"
         else "Late"
	end as shipping_status
from fact_orders;
