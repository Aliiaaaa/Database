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

BEGIN;

INSERT INTO customers (full_name, email, phone) 
VALUES ('Alice Smith', 'alice@example.com', '+996700999888');

SAVEPOINT after_customer;

INSERT INTO bookings (customer_id, tour_id, status)
VALUES (currval('customers_customer_id_seq'), 1, 'Confirmed');

INSERT INTO orders (customer_id, service_name, price)
VALUES (currval('customers_customer_id_seq'), 'Hotel Pickup', 300.00);

DO $$
BEGIN
    IF (SELECT price FROM orders WHERE order_id = currval('orders_order_id_seq')) > 1000 THEN
        ROLLBACK TO SAVEPOINT after_customer;
        RAISE NOTICE 'Order too expensive, rolled back to after customer insert';
    END IF;
END $$;

COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

UPDATE tours SET price = price * 1.05 WHERE tour_id = 1;

COMMIT;

SELECT c.full_name, b.status, t.tour_name, t.price
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
JOIN tours t ON b.tour_id = t.tour_id;

SELECT c.full_name, SUM(o.price) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;