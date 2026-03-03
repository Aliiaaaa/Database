CREATE DATABASE travel_agency;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,         
    full_name VARCHAR(100) NOT NULL, 
    email VARCHAR(100) UNIQUE,             
    phone VARCHAR(20),               
    registration_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE tours (
    tour_id SERIAL PRIMARY KEY,
    tour_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    location VARCHAR(100)                 
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,      
    customer_id INTEGER NOT NULL,
    tour_id INTEGER NOT NULL,
    booking_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(50) DEFAULT 'Confirmed', 
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    service_name VARCHAR(100),
    price DECIMAL(10,2),                     
    order_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (full_name, email, phone) VALUES
('Azamat Isaev', 'azamat@example.com', '+996700123456'),
('Aiperi Kasymova', 'aiperi@example.com', '+996700654321'),
('Bakyt Mamatov', 'bakyt@example.com', '+996700111222');

INSERT INTO tours (tour_name, price, start_date, end_date, location) VALUES
('Karakol', 12000.00, '2026-06-01', '2026-06-10', 'Kyrgyzstan'),
('Uzbekistan', 9000.00, '2026-07-15', '2026-07-25', 'Uzbekistan'),
('Issyk-Kul', 15000.00, '2026-08-01', '2026-08-10', 'Kyrgyzstan'),
('Samarkand', 11000.00, '2026-09-05', '2026-09-15', 'Uzbekistan');

INSERT INTO bookings (customer_id, tour_id, status) VALUES
(1, 1, 'Confirmed'),
(1, 2, 'Pending'),
(2, 1, 'Confirmed');

INSERT INTO orders (customer_id, service_name, price) VALUES
(1, 'Airport Pickup', 500.00),
(2, 'Hotel Upgrade', 1000.00);

SELECT c.full_name, t.tour_name, t.price
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
JOIN tours t ON b.tour_id = t.tour_id
WHERE t.price > (SELECT AVG(price) FROM tours);

WITH customer_orders AS (
    SELECT customer_id, COUNT(*) AS total_orders, SUM(price) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT c.full_name, co.total_orders, co.total_spent
FROM customers c
LEFT JOIN customer_orders co ON c.customer_id = co.customer_id
ORDER BY total_spent DESC;

SELECT 
    c.full_name,
    SUM(o.price) OVER (PARTITION BY c.customer_id) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.price) OVER (PARTITION BY c.customer_id) DESC) AS spending_rank
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT tour_name FROM tours WHERE tour_id IN (SELECT tour_id FROM bookings)
UNION
SELECT service_name FROM orders;