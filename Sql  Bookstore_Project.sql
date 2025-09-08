
-- BOOKSTORE PROJECT QUERIES
create database bookstore_project;
use bookstore_project;
create table books(Book_ID	int primary key, Title varchar(100), Author varchar(30), Genre varchar(20),	Published_Year varchar(5), Price numeric(10,2), Stock int);
create table customers(Customer_ID int primary key,	Name varchar(30), Email varchar(30),Phone varchar(30),City varchar(30),Country varchar(30));
create table orders(Order_ID int primary key, Customer_ID int references customers(customer_ID),Book_ID int references books(book_ID),Order_Date date, Quantity int, Total_Amount numeric(10,2));

-- inserting data into tables by copying from the csv files
Load data infile 'C:/Users/deepa/Downloads/customers(1).csv' into table orders
fields terminated by ',' enclosed by '"'
lines terminated by '\n' ignore 1 rows;

Load data infile 'C:/Users/deepa/Downloads/books.csv' into table orders
fields terminated by ',' enclosed by '"'
lines terminated by '\n' ignore 1 rows;

Load data infile 'C:/Users/deepa/Downloads/Orders(1).csv' into table orders
fields terminated by ',' enclosed by '"'
lines terminated by '\n' ignore 1 rows;

-- BASIC QUERIES 

-- 1. retrieve all books in the "fiction" genre
select * from books where genre = 'Fiction';

-- 2. find books published after the year 1950
select * from books where published_year > 1950;

-- 3. list all customers from canada
select * from customers where country = 'Canada';

-- 4. show orders placed in november 2023
select * from orders 
where month(order_date) = 11 and year(order_date) = 2023;

-- 5. retrieve the total stock of books available
select sum(stock) as total_stock from books;

-- 6. find the details of the most expensive book
select * from books order by price desc limit 1;

-- 7. show all customers who ordered more than 1 quantity of a book
select c.name from customers c join orders o on c.customer_id = o.customer_id where o.quantity > 1;

-- 8. retrieve all orders where the total amount exceeds $20
select * from orders where total_amount > 20 order by total_amount asc;

-- 9. list all genres available in the books table
select distinct genre as all_genre from books;

-- 10. find the book with the lowest stock
select * from books order by stock asc limit 1;

-- 11. calculate the total revenue generated from all orders
select sum(total_amount) as total_revenue from orders;

-- 12. find all books by a specific author (e.g., 'j.k. rowling')
select * from books where author = 'J.K. Rowling';

-- 13. show all customers living in a specific city (e.g., 'toronto')
select * from customers where city = 'Toronto';

-- 14. list all books with price between $10 and $20
select * from books where price between 10 and 20;

-- 15. find customers from either 'usa' or 'canada'
select * from customers where country in ('USA','Canada');

-- 16. retrieve orders placed in the last 7 days
select * from orders where order_date >= curdate() - interval 7 day;

-- 17. count number of books in each genre
select genre, count(*) as number_of_books from books group by genre;

-- 18. show all books starting with letter 'h'
select * from books where title like 'H%';

-- 19. find the maximum priced book in each genre
select genre, max(price) as max_price from books group by genre;

-- INTERMEDIATE QUERIES 

-- 20. retrieve the total number of books sold for each genre
select b.genre, sum(o.quantity) as total_books_sold from books b join orders o on b.book_id = o.book_id group by b.genre;

-- 21. find the average price of books in the "fantasy" genre
select avg(price) as avg_fantasy_price  from books where genre = 'Fantasy';

-- 22. list customers who have placed at least 5 orders
select c.customer_id, c.name, count(o.order_id) as total_orders from customers c join orders o on c.customer_id = o.customer_i
 group by c.customer_id, c.name having count(o.order_id) >= 5;

-- 23. find the most frequently ordered book
select b.title, sum(o.quantity) as total_ordered from books b join orders o on b.book_id = o.book_id
group by b.book_id, b.title order by total_ordered desc limit 1;

-- 24. show the top 3 most expensive books of 'fantasy' genre
select title, price  from books  where genre = 'Fantasy'  order by price desc  limit 3;

-- 25. retrieve the total quantity of books sold by each author
select b.author, sum(o.quantity) as total_sold from books b  join orders o on b.book_id = o.book_id group by b.author;

-- 26. list the cities where customers who spent over $30 are located
select c.city, sum(o.total_amount) as total_spent from customers c  join orders o on c.customer_id = o.customer_id group by c.city having sum(o.total_amount) > 30;

-- 27. find the customer who spent the most on orders
select c.name, sum(o.total_amount) as total_spent from customers c  join orders o on c.customer_id = o.customer_id group by c.name order by total_spent desc limit 1;

-- 28. customers with total orders > $50
select c.name, sum(o.total_amount) as total_spent from customers c join orders o on c.customer_id = o.customer_id having total_spent > 50;

-- 29. average quantity ordered per customer
select c.name, avg(o.quantity) as avg_quantity from customers c  join orders o on c.customer_id = o.customer_id group by c.customer_id;

-- 30. top 5 books by total quantity sold
select b.title, sum(o.quantity) as total_sold from books b  join orders o on b.book_id = o.book_id group by b.book_id order by total_sold desc limit 5;

-- 31. total revenue per month for 2023
select date_format(order_date,'%Y-%m') as month, sum(total_amount) as revenue from orders where year(order_date)=2023 group by month;

-- 32. books not sold at all
select b.title  from books b  left join orders o on b.book_id = o.book_id where o.order_id is null;

-- 33. customers who ordered all books by 'j.k. rowling'
select distinct c.name from customers c join orders o on c.customer_id = o.customer_i join books b on o.book_id = b.book_id where b.author = 'J.K. Rowling';

-- 34. number of orders per city
select c.city, count(o.order_id) as orders_count from customers c join orders o on c.customer_id = o.customer_id group by c.city;

-- 35. average price per genre
select genre, avg(price) as avg_price from books group by genre;

-- ADVANCED QUERIES 

-- 36. calculate the stock remaining after fulfilling all orders
select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as ordered, (b.stock - coalesce(sum(o.quantity),0)) as remaining_stock from books b
left join orders o on b.book_id = o.book_id group by b.book_id, b.title, b.stock order by b.book_id;

-- 37. customer lifetime value (total spend by each customer)
select c.customer_id, c.name, sum(o.total_amount) as lifetime_value from customers c  join orders o on c.customer_id = o.customer_id
 group by c.customer_id, c.name order by lifetime_value desc;

-- 38. monthly revenue trend
select date_format(order_date, '%Y-%m') as month, sum(total_amount) as total_revenue from orders group by month order by month;

-- 39. most popular genre
select b.genre, sum(o.quantity) as total_sold from books b  join orders o on b.book_id = o.book_id group by b.genre order by total_sold desc;

-- 40. top 3 authors by revenue
select b.author, sum(o.total_amount) as revenue from books b  join orders o on b.book_id = o.book_id group by b.author order by revenue desc limit 3;

-- 41. average order value (aov)
select avg(total_amount) as avg_order_value from orders;

-- 42. inactive customers (placed only 1 order)
select c.customer_id, c.name, count(o.order_id) as total_orders from customers c  join orders o on c.customer_id = o.customer_id group by c.customer_id, c.name having count(o.order_id) = 1;

-- 43. top cities by revenue
select c.city, sum(o.total_amount) as total_revenue from customers c  join orders o on c.customer_id = o.customer_id group by c.city order by total_revenue desc;

-- 44. orders without customers (data quality check)
select o.order_id, o.customer_id from orders o left join customers c on o.customer_id = c.customer_id where c.customer_id is null;

-- 45. revenue per author for books priced above $15
select b.author, sum(o.total_amount) as revenue from books b  join orders o on b.book_id = o.book_id where b.price > 15 group by b.author order by revenue desc;

-- 46. customers who never ordered 'fiction' books
select c.name from customers c where c.customer_id not in 
(select o.customer_id from orders o join books b on o.book_id = b.book_id where b.genre = 'Fiction');

-- 47. month with highest revenue
select date_format(order_date,'%Y-%m') as month, sum(total_amount) as revenue from orders group by month order by revenue desc limit 1;

-- 48. top 3 customers by number of orders in november 2023
select c.name, count(o.order_id) as orders_count from customers c join orders o on c.customer_id = o.customer_id where month(o.order_date)=11 and year(o.order_date)=2023
 group by c.customer_id order by orders_count desc limit 3;

-- 49. authors who have sold more than 50 books
select b.author, sum(o.quantity) as total_sold from books b  join orders o on b.book_id = o.book_id group by b.author having total_sold > 50;

-- 50. average revenue per customer
select avg(total_spent) as avg_customer_revenue from 
(select c.customer_id, sum(o.total_amount) as total_spent from customers c join orders o on c.customer_id = o.customer_id group by c.customer_id) as customer_revenue;
