Create database Ecommerce_project

use Ecommerce_project

select * from olist_orders_dataset
select * from olist_order_items_dataset
select * from olist_order_payments
select * from olist_order_reviews
select * from olist_customers
select * from olist_products
select * from olist_sellers_dataset
select * from olist_geolocation
select * from product_category_name_translation


select count(*) as Total_rows from olist_orders_dataset

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_orders_dataset'


SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS order_status_nulls,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS purchase_date_nulls,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS approved_date_nulls,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS carrier_date_nulls,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS customer_delivery_nulls,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS estimated_date_nulls
FROM olist_orders_dataset;

--How many orders are there for each order status?

select order_status, count(order_status) as Total_orders from olist_orders_dataset group by order_status

--What percentage of total orders falls under each order status?

select order_status , count(*) as Total_orders, count(*) * 100.0/sum(count(*)) over() as pct from olist_orders_dataset group by order_status


--What is the average delivery time for orders that were successfully delivered to customers?

select avg(datediff(day,order_purchase_timestamp, order_delivered_customer_date)) as average_delivery_time from olist_orders_dataset where order_status = 'delivered'

--What is the total payment value received through each payment type?

select payment_type, sum(payment_value) as Total_payment_value from olist_order_payments group by payment_type

--How many unique customers are there in each customer state?

select customer_state, count(distinct customer_unique_id) as Total_unique_customers from olist_customers group by customer_state

--Which product categories have generated the highest total sales value?

select p.product_category_name, sum(oi.price) as total_sales from olist_order_items_dataset oi
inner join olist_products p on oi.product_id = p.product_id group by p.product_category_name
order by total_sales desc

--Which sellers have generated the highest total sales value?

select s.seller_id, sum(oi.price) as Total_sales from olist_order_items_dataset oi inner join olist_sellers_dataset s on oi.seller_id = s.seller_id group by s.seller_id order by total_sales desc

--What is the total payment value for each order, and how many payment transactions were made for each order?

select o.order_id, sum(p.payment_value) as Total_payment_value, count(p.payment_value) as Total_transactions from olist_orders_dataset o inner join olist_order_payments p on o.order_id = p.order_id group by o.order_id 

--Which customers have placed more than 3 orders?

select customer_id, count(order_id) as Total_orders from olist_orders_dataset group by customer_id having count(order_id) > 3

--How many orders were placed in each month?

select month(order_purchase_timestamp) as order_month, datename(month,order_purchase_timestamp) as Month_name, count(order_id) as Total_orders from olist_orders_dataset group by month(order_purchase_timestamp), datename(month,order_purchase_timestamp) order by Total_orders desc

--What is the average product price for each product category?

select p.product_category_name, avg(oi.price) as Avg_product_category from olist_order_items_dataset oi inner join olist_products p on p.product_id = oi.product_id group by p.product_category_name

--Which customers have the highest total payment value?

select c.customer_id, sum(p.payment_value) as Total_payment_value from olist_orders_dataset o inner join olist_customers c on c.customer_id = o.customer_id inner join olist_order_payments p on o.order_id = p.order_id group by c.customer_id order by total_payment_value desc

--Which customer states have the highest number of successfully delivered orders?

select c.customer_state, count(o.order_status) as successfully_delivered_orders from olist_orders_dataset o inner join olist_customers c on c.customer_id = o.customer_id where order_status = 'delivered' group by c.customer_state order by successfully_delivered_orders desc

--What is the average review score for each customer state?

select c.customer_state, avg(r.review_score) as Avg_review_score from olist_customers c inner join olist_orders_dataset o on c.customer_id = o.customer_id inner join olist_order_reviews r  on o.order_id = r.order_id group by c.customer_state

--What is the total payment value generated through each payment type, along with the number of orders using each payment type?

select p.payment_type, sum(p.payment_value) as Total_payment_value, count(distinct o.order_id) as No_of_orders from olist_orders_dataset o inner join olist_order_payments p on o.order_id = p.order_id group by p.payment_type

==============================================================================
--Key Insights
==============================================================================

-- 1. Order Status
-- Delivered orders accounted for the largest share of total orders.

-- 2. Payment Analysis
-- Credit card generated the highest total payment value.

-- 3. Product Category
-- beleza_saude generated the highest total sales value.

-- 4. Seller Performance
-- seller 4869f7a5dfa277a7dca6462dcf3b52b2 generated the highest total sales value.

-- 5. Monthly Orders
-- August month recorded the highest number of orders.
