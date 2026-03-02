--Lab04 
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    registration_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO customers (full_name, email, registration_date) VALUES
('Alikhan Abdykerimov', 'alikhan@example.com', '2026-01-10'),
('Aliya Sultanova', 'aliya@example.com', '2026-02-15'),
('Bektur Samatov', 'bektur@example.com', '2026-02-20'),
('Gulnaz Nurmatova', 'gulnaz@example.com', '2026-03-01');

SELECT * FROM customers;
SELECT full_name, email FROM customers;

SELECT full_name, registration_date
FROM customers
WHERE registration_date > '2026-02-01';

SELECT full_name, registration_date
FROM customers
ORDER BY registration_date DESC;

SELECT full_name, registration_date
FROM customers
ORDER BY registration_date DESC
LIMIT 2;