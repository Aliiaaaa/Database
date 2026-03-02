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

SELECT * FROM customers;