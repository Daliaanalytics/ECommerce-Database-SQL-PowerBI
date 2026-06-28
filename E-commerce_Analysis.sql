use [E-CommerceDB];

create table categories(
        category_id int primary key,
		category_name nvarchar(100) not null
);

create table customers( 
       customer_id INT PRIMARY KEY,
       first_name NVARCHAR(100),
       last_name NVARCHAR(100),
       email NVARCHAR(150),
       city NVARCHAR(100),
       country NVARCHAR(100),
       registration_date DATE
);


create table products(
       product_id INT PRIMARY KEY,
       product_name NVARCHAR(200),
       category_id INT FOREIGN KEY  REFERENCES Categories(category_id),
       price DECIMAL(10, 2),
       stock_quantity INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    status NVARCHAR(50),
    total_amount DECIMAL(10, 2)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    quantity INT,
    unit_price DECIMAL(10, 2)
);


bulk insert categories
from 'C:\Users\MKcomputer\Documents\E-Commerce_Data_Analysis\categories.csv'
with(
   firstrow=2,
   fieldterminator= ',',
   rowterminator= '0x0a',
   tablock
  );

  select * from categories;

BULK INSERT Customers
FROM 'C:\Users\MKcomputer\Documents\E-Commerce_Data_Analysis\customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT products
FROM 'C:\Users\MKcomputer\Documents\E-Commerce_Data_Analysis\products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

select * from products;

BULK INSERT orders
FROM 'C:\Users\MKcomputer\Documents\E-Commerce_Data_Analysis\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

select * from Orders;

BULK INSERT order_items
FROM 'C:\Users\MKcomputer\Documents\E-Commerce_Data_Analysis\order_items.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

select * from order_items;


select 'categories' as TableName, count(*) as rows from categories
union all
select 'customers', count(*) from customers
union all
select 'products', count(*) from products
union all
select 'orders', count(*) from orders
union all
select 'order_items', count(*) from Order_Items;



select * from categories;
select * from products;
select * from Orders;
select * from customers;
select * from Order_Items;

select status,
       count(*) as Total_Orders,
	   sum(total_amount) as Total_Revenue
from Orders
group by status
order by Total_Revenue desc;

select c.first_name+ ' '+ c.last_name as Customer_Name,
       count(o.order_id) as Total_Orders,
	   sum(o.total_amount) as Total_Spent
from customers c
inner join orders o on c.customer_id= o.customer_id
group by c.first_name, c.last_name
order by Total_Spent desc
offset 0 rows fetch next 10 rows only;


select cat.category_name,
       count(oi.order_item_id) as Total_Orders,
	   sum(oi.quantity) as Total_Quantity_Sold,
	   sum(oi.quantity * oi.unit_price) as Total_Revenue
from categories cat 
inner join products p on cat.category_id= p.category_id
inner join Order_Items oi on oi.product_id= p.product_id
group by cat.category_name
order by Total_Revenue desc;

select * from categories;
select * from products;
select * from Orders;
select * from customers;
select * from Order_Items;

select p.product_name,
       sum(oi.quantity) as Total_quantity,
	   sum(oi.quantity * oi.unit_price) as Total_revenue
from products p
inner join Order_Items oi on p.product_id= oi.product_id
group by p.product_name
order by Total_quantity desc
offset 0 rows fetch next 10 rows only;

select c.first_name + ' ' + c.last_name as Customer_name,
       c.email,
	   o.order_id
from customers c
left join orders o on c.customer_id= o.customer_id
where o.order_id is null;


select year(order_date) as order_year,
       month(order_date) as order_month,
	   count(order_id) as total_orders,
	   sum(total_amount) as total_revenue
from Orders
group by YEAR(order_date), MONTH(order_date)
order by order_year, order_month;