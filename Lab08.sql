CREATE DATABASE travel_agency;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    registration_date DATE DEFAULT CURRENT_DATE
);
INSERT INTO customers (full_name, email) VALUES
('Azamat Isaev', 'azamat@example.com'),
('Aiperi Kasymova', 'aiperi@example.com');

CREATE TABLE tours (
    tour_id SERIAL PRIMARY KEY,
    tour_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    start_date DATE,
    end_date DATE
);

INSERT INTO tours (tour_name, price, start_date, end_date) VALUES
('Karakol', 12000.00, '2026-06-01', '2026-06-10'),
('Uzbekistan', 9000.00, '2026-07-15', '2026-07-25');

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,      
    customer_id INTEGER NOT NULL,
    tour_id INTEGER NOT NULL,
    booking_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
);

INSERT INTO bookings (customer_id, tour_id) VALUES
(1, 1),
(1, 2),
(2, 1);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    service_name VARCHAR(100),
    order_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (customer_id, service_name) VALUES
(1, 'Airport Pickup'),
(2, 'Hotel Upgrade');

SELECT * FROM customers;
SELECT * FROM tours;
SELECT * FROM bookings;
SELECT * FROM orders;