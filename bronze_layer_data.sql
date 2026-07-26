-- loading bronze layer data
SHOW VARIABLES LIKE 'secure_file_priv';

truncate table supply_chain_bronze;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply_chain.csv'
INTO TABLE supply_chain_bronze
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Type, Days_for_shipping_real, Days_for_shipment_scheduled,
    Benefit_per_order, Sales_per_customer, Delivery_Status,
    Late_delivery_risk, Category_Id, Category_Name,
    Customer_City, Customer_Country, Customer_Email,
    Customer_Fname, Customer_Id, Customer_Lname,
    Customer_Password, Customer_Segment, Customer_State,
    Customer_Street, Customer_Zipcode, Department_Id,
    Department_Name, Latitude, Longitude, Market,
    Order_City, Order_Country, Order_Customer_Id,
    Order_Date, Order_Id, Order_Item_Cardprod_Id,
    Order_Item_Discount, Order_Item_Discount_Rate,
    Order_Item_Id, Order_Item_Product_Price,
    Order_Item_Profit_Ratio, Order_Item_Quantity,
    Sales, Order_Item_Total, Order_Profit_Per_Order,
    Order_Region, Order_State, Order_Status,
    Order_Zipcode, Product_Card_Id, Product_Category_Id,
    Product_Description, Product_Image, Product_Name,
    Product_Price, Product_Status, Shipping_Date, Shipping_Mode
);