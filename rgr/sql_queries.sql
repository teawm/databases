-- -- Вывести марки, модели и государственные номера автомобилей, принадлежащих клиентам с фамилией, начинающейся на "У".
SELECT
    c.brand,
    c.model,
    c.plate_number
FROM cars c
JOIN clients cl ON c.client_id = cl.client_id
WHERE cl.last_name LIKE 'У%';


-- -- Вывести фамилии всех клиентов и количество автомобилей, у которых зарегистрировано не более двух автомобилей.
SELECT 
    cl.last_name, 
    COUNT(c.car_id) AS cars_count 
FROM clients cl 
LEFT JOIN cars c ON cl.client_id = c.client_id 
GROUP BY cl.client_id, cl.last_name, cl.first_name 
HAVING COUNT(c.car_id) < 2;


-- -- Вывести информацию о всех заказах: номер заказа, дату заказа, ФИО клиента, марку и модель автомобиля, статус заказа.
SELECT
    o.order_number,
    o.order_date,
    cl.last_name || ' ' || cl.first_name AS client_name,
    c.brand,
    c.model,
    o.status
FROM orders o
JOIN clients cl ON o.client_id = cl.client_id
JOIN cars c ON o.car_id = c.car_id
ORDER BY o.order_date;


-- -- Вывести услуги, выполненные в заказе с номером ORD-003: номер заказа, дату заказа, название услуги, цену и количество.
SELECT
    o.order_number,
    o.order_date,
    s.service_name,
    os.price,
    os.quantity
FROM orders o
JOIN order_services os ON o.order_id = os.order_id
JOIN services s ON os.service_id = s.service_id
WHERE o.order_number = 'ORD-003'
ORDER BY s.service_name;


-- -- Создать представление "Сводка по заказам", содержащее номер заказа, дату, ФИО клиента, автомобиль, статус и сумму заказа.
CREATE VIEW order_summary AS
SELECT
    o.order_number,
    o.order_date,
    cl.last_name || ' ' || cl.first_name AS client_name,
    c.brand,
    c.model,
    o.status,
    o.total_amount
FROM orders o
JOIN clients cl ON o.client_id = cl.client_id
JOIN cars c ON o.car_id = c.car_id;

SELECT * FROM order_summary;


-- -- Создать представление "Крупные заказы", в которое попадут заказы, сумма которых превышает среднюю сумму всех заказов.
CREATE VIEW large_orders AS
SELECT
    o.order_number,
    o.order_date,
    cl.last_name || ' ' || cl.first_name AS client_name,
    c.brand,
    c.model,
    o.total_amount
FROM orders o
JOIN clients cl ON o.client_id = cl.client_id
JOIN cars c ON o.car_id = c.car_id
WHERE o.total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);

SELECT * FROM large_orders;

