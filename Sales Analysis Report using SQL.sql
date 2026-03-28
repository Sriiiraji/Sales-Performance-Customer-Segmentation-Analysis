create database capstone;
use capstone;

create table customers
(customer_id int primary key,
first_name varchar(50),
last_name varchar(50),
email varchar(100),
phone varchar(20),
street varchar(100),
city varchar(50),
state varchar(50),
zip_code varchar(10)
);

create table brands (
brand_id int primary key,
brand_name varchar(100));

create table categories (
category_id int primary key,
category_name varchar(100));

CREATE TABLE order_items (
order_id int,
item_id int,
product_id int,
product_name varchar(100),
quantity int,
list_price decimal(10,2),
discount decimal(10,2),
total_price decimal(10,2),
primary key (order_id, item_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id));

CREATE TABLE orders (
order_id int primary key,
customer_id int,
order_status varchar(20),
order_date date,
required_date date,
shipped_date date,
store_id int,
staff_id int,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (store_id) REFERENCES stores(store_id),
FOREIGN KEY (staff_id) REFERENCES staffs(staff_id));

CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
brand_id INT,
category_id INT,
model_year INT,
list_price DECIMAL(10,2),
FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
FOREIGN KEY (category_id) REFERENCES categories(category_id));

CREATE TABLE stores (
store_id INT PRIMARY KEY,
store_name VARCHAR(100),
phone VARCHAR(20),
email VARCHAR(100),
street varchar(100),
city VARCHAR(50),
state VARCHAR(50),
zip_code VARCHAR(10)
);

CREATE TABLE staffs (
staff_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email_id VARCHAR(100),
phone_number VARCHAR(20),
active INT,
store_id INT,
manager_id INT,
FOREIGN KEY (store_id) REFERENCES stores(store_id));

create table stocks (
store_id int,
product_id int,
quantity int,
PRIMARY KEY (store_id, product_id),
FOREIGN KEY (store_id) REFERENCES stores(store_id),
FOREIGN KEY (product_id) REFERENCES products(product_id));


select * from capstone.orders;
select * from capstone.brands;
select * from capstone.categories;
select * from capstone.customers;
select * from capstone.order_items;
select * from capstone.products;
select * from capstone.staffs;
select * from capstone.stocks;
select * from capstone.stores;


-- Inner Join for Order Details

select o.order_id,o.order_date,p.product_name,oi.quantity,oi.list_price from capstone.orders o
join order_items oi
on o.order_id=oi.order_id
join products p
on oi.product_id=p.product_id;

-- Total Sales by Store

select o.store_id,sum(oi.total_price) as total_sales from capstone.orders o
join order_items oi
on o.order_id=oi.order_id
group by o.store_id;

-- Top 5 Selling Products

select product_id,sum(quantity) as most_sold_products from capstone.order_items
group by product_id
order by most_sold_products desc limit 5;

-- Customer Purchase Summary

select o.customer_id, count(o.order_id) as total_orders_placed, sum(oi.quantity) as total_items_purchased,sum(oi.total_price) as total_revenue from capstone.orders o
join order_items oi
on o.order_id = oi.order_id
group by o.customer_id;

-- Segment Customers by Total Spend
select o.customer_id, sum(oi.total_price) as total_spend, 
case
when sum(total_price) < 1000 then "low"
when sum(total_price) between 1000 and 5000 then "medium"
else "high"
end as segment from capstone.orders o
join order_items oi
on o.order_id = oi.order_id
group by o.customer_id;

-- Staff Performance Analysis
select o.staff_id, sum(oi.total_price) as total_revenue from capstone.orders o
join order_items oi
on o.order_id = oi.order_id
group by o.staff_id;

-- Stock Alert Query

select p.product_name,s.store_id,s.product_id,s.quantity from capstone.products p
join stocks s
on p.product_id=s.product_id
where s.quantity < 10
order by s.quantity desc;

create table customer_segments(customer_id INT,recency INT,frequency INT,monetary DECIMAL(10,2),segment VARCHAR(50));



select * from capstone.customer_segments;




