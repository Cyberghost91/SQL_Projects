-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_orders
FROM
    orders; -- Total_orders = 21350
    
-- Calculate the total revenue generated from pizza sales.
select
round(sum(order_details.quantity * pizzas.price),2) as Total_Revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id;   -- Total_Revenue = 817860.05

-- Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Identify the most common pizza size ordered 
select pizzas.size, count(order_details.order_detail_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pizza_types.category, SUM(order_details.quantity) as total_quantity
FROM pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by total_quantity desc;

-- Determine the distribution of orders by hour of the day.
select extract(hour from order_time) as hour_of_the_day, count(*) as total_orders from orders
group by hour_of_the_day
order by hour_of_the_day;

-- Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) as average_number_of_pizzas_per_day from
(SELECT orders.order_date, sum(order_details.quantity) as quantity
FROM orders join order_details
on orders.order_id = order_details.order_id
GROUP BY order_date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,
sum(order_details.quantity * pizzas.price) as Revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by Revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,
round(sum(order_details.quantity * pizzas.price) / (select
round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id) *100,2) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by Revenue desc;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, revenue from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn<=3;








