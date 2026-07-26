-- creating three tables from one raw table because working with one table can turn into messy data handling 
-- customers, products, orders

-- Customers_table
create table silver_sc.customers as
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
from supply_chain_bronze;

-- Products_table
create table silver_sc.products as
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
from supply_chain_bronze;

-- Orders_table
create table silver_sc.Orders as
select Order_Item_Id,
    Order_Id,
    Customer_Id,
    Product_Card_Id,
    case 
		when Order_Date like "%-%" then str_to_date(Order_Date, '%m-%d-%Y %H:%i')
        else str_to_date(Order_Date, '%m/%d/%Y %H:%i')
	end as Order_date_clean,
     case 
		when Shipping_Date like "%-%" then str_to_date(Shipping_Date, '%m-%d-%Y %H:%i')
        else str_to_date(Shipping_Date, '%m/%d/%Y %H:%i')
	end as Shipping_date_clean,
    Type AS Payment_Type,
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
from supply_chain_bronze;