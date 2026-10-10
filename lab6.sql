SET search_path TO public;

-- -- 1.	Вывести список существующих индексов в БД. Являются ли индексы кластеризованными? Какую структуру в памяти они имеют?
SELECT *
FROM pg_indexes
WHERE schemaname = 'my_schema';

-- -- 2.	Создать индекс для ускорения сортировки таблицы покупателей по городу. Проверьте, используется ли созданный индекс при сортировке.
CREATE INDEX idx_cust_city ON cust(city);
EXPLAIN SELECT * FROM cust ORDER BY city;
-- -- Изначально - не использовалось

-- -- 3.	Добавьте в таблицу покупателей 1000 новых записей, например, используя команду, формирующую последовательности:
-- -- insert into cust 
-- -- values ( generate_series(1, 1000), 'test_name', 100, 'test_city' );
INSERT INTO cust (cnum, name, rating, city)
VALUES (generate_series(1, 1000), 'test_name', 100, 'test_city');
-- -- Проверьте, используется ли теперь созданный индекс при сортировке?
EXPLAIN SELECT * FROM cust ORDER BY city;
-- -- После INSERT'а - используется


-- -- В заданиях 4-7 необходимо выполнить одинаковый запрос, сохраняя его содержимое в различных структурах. Полученную (сохраненную) выборку вывести на экран. В чем отличие этих структур?

-- -- Вывести полную информацию о заказе, его продавце, его продукте и его покупателе, только если:
-- --        - количество товара (amt) в этом заказе больше, чем среднее по таблице,
-- --        - товар не из Санкт-Петербурга, 
-- --        - продавец совершил не более 10 заказов за все время,
-- --        - рейтинг покупателя не ниже, чем хотя бы у одного покупателя из Москвы.  


-- -- 4.	Сохранить результат как новую таблицу и вывести ее содержимое.
-- -- Физически на диске
-- -- Статична, не обновляется сама
-- -- Подлежит редактированию в отличие от остальных трех
CREATE TABLE ord_full_info AS
SELECT 
    o.*, 
    s.name AS seller_name, 
    p.name AS product_name, 
    c.name AS customer_name
FROM ord o
JOIN sal s ON o.snum = s.snum
JOIN prod p ON o.pnum = p.pnum
JOIN cust c ON o.cnum = c.cnum
WHERE o.amt > (SELECT AVG(amt) FROM ord)
  AND p.city <> 'Saint Petersburg'
  AND o.snum IN (SELECT snum FROM ord GROUP BY snum HAVING COUNT(*) <= 10)
  AND c.rating >= (SELECT MIN(rating) FROM cust WHERE city = 'Moscow');

SELECT * FROM ord_full_info;


-- -- 5.	Сохранить результат как представление и вывести его содержимое.
-- -- Не хранится, это - сохраненный запрос
-- -- Запрос выполняется при каждом обращении
CREATE VIEW v_ord_full_info AS
SELECT 
    o.*, 
    s.name AS seller_name, 
    p.name AS product_name, 
    c.name AS customer_name
FROM ord o
JOIN sal s ON o.snum = s.snum
JOIN prod p ON o.pnum = p.pnum
JOIN cust c ON o.cnum = c.cnum
WHERE o.amt > (SELECT AVG(amt) FROM ord)
  AND p.city <> 'Saint Petersburg'
  AND o.snum IN (SELECT snum FROM ord GROUP BY snum HAVING COUNT(*) <= 10)
  AND c.rating >= (SELECT MIN(rating) FROM cust WHERE city = 'Moscow');

SELECT * FROM v_ord_full_info;

-- -- 6.	Сохранить результат как материализованное представление и вывести его содержимое.
-- -- Физически на диске
-- -- Не обновляется при изменении исходных таблиц, нужен REFRESH
CREATE MATERIALIZED VIEW mv_ord_full_info AS
SELECT 
    o.*, 
    s.name AS seller_name, 
    p.name AS product_name, 
    c.name AS customer_name
FROM ord o
JOIN sal s ON o.snum = s.snum
JOIN prod p ON o.pnum = p.pnum
JOIN cust c ON o.cnum = c.cnum
WHERE o.amt > (SELECT AVG(amt) FROM ord)
  AND p.city <> 'Saint Petersburg'
  AND o.snum IN (SELECT snum FROM ord GROUP BY snum HAVING COUNT(*) <= 10)
  AND c.rating >= (SELECT MIN(rating) FROM cust WHERE city = 'Moscow');

SELECT * FROM mv_ord_full_info;
REFRESH MATERIALIZED VIEW mv_ord_full_info;

-- -- 7.	Использовать для запроса блок оператора WITH и вывести результат.
-- -- В оперативной памяти, только в рамках одного запроса
-- -- Актуально в момент выполнения
WITH full_info AS (
    SELECT 
        o.*, 
        s.name AS seller_name, 
        p.name AS product_name, 
        c.name AS customer_name
    FROM ord o
    JOIN sal s ON o.snum = s.snum
    JOIN prod p ON o.pnum = p.pnum
    JOIN cust c ON o.cnum = c.cnum
    WHERE o.amt > (SELECT AVG(amt) FROM ord)
      AND p.city <> 'Saint Petersburg'
      AND o.snum IN (SELECT snum FROM ord GROUP BY snum HAVING COUNT(*) <= 10)
      AND c.rating >= (SELECT MIN(rating) FROM cust WHERE city = 'Moscow')
)
SELECT * FROM full_info;
