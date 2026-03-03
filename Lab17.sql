CREATE DATABASE travel_agency;

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS tour_guides;
DROP TABLE IF EXISTS hotels;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS managers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,         
    full_name VARCHAR(100) NOT NULL, 
    email VARCHAR(100) UNIQUE,             
    phone VARCHAR(20),               
    registration_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE managers (
    manager_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE tours (
    tour_id SERIAL PRIMARY KEY,
    tour_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    location VARCHAR(100),
    manager_id INTEGER,
    FOREIGN KEY (manager_id) REFERENCES managers(manager_id)
);

CREATE TABLE hotels (
    hotel_id SERIAL PRIMARY KEY,
    hotel_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    rating DECIMAL(2,1)
);

CREATE TABLE tour_guides (
    guide_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    tour_id INTEGER,
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
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

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INTEGER,
    amount DECIMAL(10,2),
    payment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    tour_id INTEGER,
    seat_number VARCHAR(10),
    price DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    tour_id INTEGER,
    rating INT CHECK (rating >=1 AND rating <=5),
    comment TEXT,
    review_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
);

INSERT INTO managers (full_name, email, phone) VALUES
('Nurlan Bektemirov', 'nurlan@example.com', '+996700101010'),
('Aida Omurbekova', 'aida@example.com', '+996700202020');

INSERT INTO customers (full_name, email, phone) VALUES
('Azamat Isaev', 'azamat@example.com', '+996700123456'),
('Aiperi Kasymova', 'aiperii@example.com', '+996700654321'),
('Bakyt Mamatov', 'bakyte@example.com', '+996700111222'),
('Dana Bektemirova', 'danaa@example.com', '+996700333444');

INSERT INTO tours (tour_name, price, start_date, end_date, location, manager_id) VALUES
('Karakol', 12000.00, '2026-06-01', '2026-06-10', 'Kyrgyzstan', 1),
('Uzbekistan', 9000.00, '2026-07-15', '2026-07-25', 'Uzbekistan', 2),
('Issyk-Kul', 15000.00, '2026-08-01', '2026-08-10', 'Kyrgyzstan', 1),
('Samarkand', 11000.00, '2026-09-05', '2026-09-15', 'Uzbekistan', 2);

INSERT INTO hotels (hotel_name, location, rating) VALUES
('Karakol Hotel', 'Karakol', 4.5),
('Uzbek Palace', 'Tashkent', 4.0),
('Issyk-Kul Resort', 'Bokonbaevo', 4.8);

INSERT INTO tour_guides (full_name, phone, tour_id) VALUES
('Erbol Tursunov', '+996700888777', 1),
('Aijan Karimova', '+996700555444', 2),
('Bakyt Mamatov', '+996700111222', 3);

INSERT INTO bookings (customer_id, tour_id, status) VALUES
(1, 1, 'Confirmed'),
(1, 2, 'Pending'),
(2, 1, 'Confirmed'),
(3, 3, 'Confirmed'),
(4, 4, 'Confirmed');

INSERT INTO orders (customer_id, service_name, price) VALUES
(1, 'Airport Pickup', 500.00),
(2, 'Hotel Upgrade', 1000.00),
(3, 'Guided Tour', 750.00),
(4, 'Extra Luggage', 200.00);

INSERT INTO payments (booking_id, amount) VALUES
(1, 12000.00),
(2, 9000.00),
(3, 15000.00);

INSERT INTO tickets (customer_id, tour_id, seat_number, price) VALUES
(1, 1, 'A1', 12000.00),
(2, 1, 'A2', 12000.00),
(3, 3, 'B1', 15000.00);

INSERT INTO reviews (customer_id, tour_id, rating, comment) VALUES
(1, 1, 5, 'Amazing experience!'),
(2, 1, 4, 'Very good tour'),
(3, 3, 5, 'Loved it!');

SELECT c.full_name, b.status, t.tour_name, t.price
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
JOIN tours t ON b.tour_id = t.tour_id;

SELECT c.full_name, SUM(o.price) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;