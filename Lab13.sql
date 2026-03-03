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

INSERT INTO customers (full_name, email, phone) VALUES
('Azamat Isaev', 'azamat@example.com', '+996700123456'),
('Aiperi Kasymova', 'aiperi@example.com', '+996700654321');

CREATE TABLE tours (
    tour_id SERIAL PRIMARY KEY,
    tour_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    location VARCHAR(100)                 
);

INSERT INTO tours (tour_name, price, start_date, end_date, location) VALUES
('Karakol', 12000.00, '2026-06-01', '2026-06-10', 'Kyrgyzstan'),
('Uzbekistan', 9000.00, '2026-07-15', '2026-07-25', 'Uzbekistan');

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,      
    customer_id INTEGER NOT NULL,
    tour_id INTEGER NOT NULL,
    booking_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(50) DEFAULT 'Confirmed', 
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
);

INSERT INTO bookings (customer_id, tour_id, status) VALUES
(1, 1, 'Confirmed'),
(1, 2, 'Pending'),
(2, 1, 'Confirmed');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    service_name VARCHAR(100),
    price DECIMAL(10,2),                     
    order_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (customer_id, service_name, price) VALUES
(1, 'Airport Pickup', 500.00),
(2, 'Hotel Upgrade', 1000.00);

INSERT INTO customers (full_name, email, phone) VALUES
('Bakyt Mamatov', 'bakyt@example.com', '+996700111222'),
('Gulzat Sultanova', 'gulzat@example.com', '+996700333444');

INSERT INTO tours (tour_name, price, start_date, end_date, location) VALUES
('Issyk-Kul', 15000.00, '2026-08-01', '2026-08-10', 'Kyrgyzstan'),
('Samarkand', 11000.00, '2026-09-05', '2026-09-15', 'Uzbekistan');

UPDATE customers
SET email = 'azamat_new@example.com'
WHERE full_name = 'Azamat Isaev';

UPDATE bookings
SET status = 'Cancelled'
WHERE booking_id = 2;

DELETE FROM customers
WHERE full_name = 'Gulzat Sultanova';

DELETE FROM orders
WHERE order_id IN (1, 2);

SELECT c.full_name, t.tour_name, t.location
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
JOIN tours t ON b.tour_id = t.tour_id
WHERE t.location = 'Kyrgyzstan';

SELECT 
    c.full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.price) AS total_spent,
    AVG(o.price) AS avg_order_price
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY total_spent DESC;

SELECT 
    t.tour_name,
    COUNT(b.booking_id) AS total_bookings,
    AVG(t.price) AS avg_tour_price,
    MIN(t.price) AS min_price,
    MAX(t.price) AS max_price
FROM tours t
LEFT JOIN bookings b ON t.tour_id = b.tour_id
GROUP BY t.tour_name
HAVING COUNT(b.booking_id) > 0
ORDER BY total_bookings DESC;

SELECT 
    status,
    COUNT(*) AS count_per_status
FROM bookings
GROUP BY status;

SELECT 
    COUNT(*) AS total_customers,
    COUNT(email) AS customers_with_email,
    COUNT(*) - COUNT(email) AS customers_without_email
FROM customers;

SELECT * FROM customers;
SELECT * FROM tours;
SELECT * FROM bookings;
SELECT * FROM orders;