-- Таблица "Клиенты"
CREATE TABLE IF NOT EXISTS clients (
    client_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    birth_date DATE NOT NULL,
    reg_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT chk_clients_age CHECK (reg_date >= birth_date + INTERVAL '18 years')
);


-- Таблица "Автомобили"
CREATE TABLE IF NOT EXISTS cars (
    car_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    vin VARCHAR(17) NOT NULL UNIQUE,
    plate_number VARCHAR(15) NOT NULL UNIQUE,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    mileage INT,
    CONSTRAINT chk_cars_year CHECK (year BETWEEN 1950 AND 2026),
    CONSTRAINT chk_cars_mileage CHECK (mileage IS NULL OR mileage >= 0)
);


-- Таблица "Сотрудники"
CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    position VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT chk_employees_age CHECK (hire_date >= birth_date + INTERVAL '18 years')
);


-- Таблица "Услуги"
CREATE TABLE IF NOT EXISTS services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    duration_minutes INT NOT NULL,
    CONSTRAINT chk_services_price CHECK (price > 0),
    CONSTRAINT chk_services_duration CHECK (duration_minutes > 0)
);


-- Таблица "Заказы"
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    order_number VARCHAR(20) NOT NULL UNIQUE,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    client_id INT NOT NULL REFERENCES clients(client_id),
    car_id INT NOT NULL REFERENCES cars(car_id),
    employee_id INT NOT NULL REFERENCES employees(employee_id),
    status VARCHAR(30) NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    close_date DATE,
    CONSTRAINT chk_orders_status CHECK (
        status IN ('Открыт', 'В работе', 'Завершен', 'Отменен')
    ),
    CONSTRAINT chk_orders_total CHECK (total_amount >= 0),
    CONSTRAINT chk_orders_close_date CHECK (
        close_date IS NULL OR close_date >= order_date
    )
);


-- Таблица "Позиции заказов"
CREATE TABLE IF NOT EXISTS order_services (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    service_id INT NOT NULL REFERENCES services(service_id),
    quantity INT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    CONSTRAINT chk_order_services_qty CHECK (quantity > 0),
    CONSTRAINT chk_order_services_price CHECK (price >= 0)
);