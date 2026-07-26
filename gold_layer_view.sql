-- creating gold layer view

-- customer
create view gold_sc.dim_customers as 
select distinct 
	Customer_Id,
    Customer_Fname,
    Customer_Lname,
    Customer_Email,
    Customer_Segment,
    Customer_City,
    Customer_State,
    Customer_Country,
    Customer_Street,
    Customer_Zipcode
from silver_sc.customers;

select *
from gold_sc.dim_customers;

-- products
create view gold_sc.dim_products as 
select distinct
	Product_Card_Id,
    Product_Name, 
    Product_Category_Id, 
    Category_Name, 
    Product_Price, 
    Product_Status,
    Product_Description, 
    Product_Image,
	Department_Id, 
    Department_Name
from silver_sc.products;

select *
from gold_sc.dim_products;


-- orders
create view gold_sc.fact_orders as 
select
	Order_Item_Id,
    Order_Id,
    Customer_Id,
    Product_Card_Id,
    Order_date_clean,
	Shipping_date_clean,
    Payment_Type,
    Shipping_Mode,
    Delivery_Status,
    Late_delivery_risk,
    Days_for_shipping_real,
    Days_for_shipment_scheduled,
	Order_Status,
	Order_Item_Quantity,
    Order_Item_Product_Price,
    Order_Item_Discount,
    Order_Item_Discount_Rate,
    Order_Item_Profit_Ratio,
    Sales,
    Sales_per_customer,
    Order_Item_Total,
    Benefit_per_order,
    Order_Profit_Per_Order,
    Order_City,
    Order_State,
    Order_Country,
    Order_Region,
    Order_Zipcode,
    Market,
    Latitude,
    Longitude
from silver_sc.orders;

select *
from gold_sc.fact_orders;

select min(Order_Item_Profit_Ratio), max(Order_Item_Profit_Ratio), avg(Order_Item_Profit_Ratio)
from fact_orders