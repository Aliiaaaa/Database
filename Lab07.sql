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
