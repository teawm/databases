-- Лабораторная 2

SET search_path TO my_schema;

-- LIKE
-- 1.	Вывести названия городов продавцов, которые начинаются на букву m и заканчиваются на букву w.
SELECT city FROM sal WHERE city ILIKE 'm%w';  

-- 2.	Вывести имена покупателей, в которых буква o стоит на предпоследнем месте, отсортированные в обратном порядке.
SELECT name FROM cust WHERE name LIKE '%o_' ORDER BY name DESC;


-- Строковые функции
-- 3.	Вывести в верхнем регистре все названия продуктов, имеющие длину не более 7 символов. Все названия менее 7 символов должны быть дополнены до 7 знаков символом точки.
SELECT RPAD(UPPER(name), 7, '.') from prod WHERE LENGTH(name) <= 7;

-- 4.	Вывести в одном столбце вес продуктов, соединенный со словом «GRAMS» и названием в верхнем регистре, в формате: ‘MONITOR: 2000 GRAMS’, только для тех продуктов, название которых содержит подстроку ‘ri’.
SELECT CONCAT(UPPER(name), ': ', weight, ' GRAMS') from prod WHERE name LIKE '%ri%';


-- Функции работы с датами
-- 5.	Вывести число секунд в момент выполнения лабораторной работы.
SELECT EXTRACT(SECOND FROM CURRENT_TIME);

-- 6.	Вывести для каждой уникальной даты заказа запись. состоящую из двух столбцов: дата в формате «dd.mm» и отдельно год заказа.
SELECT DISTINCT TO_CHAR(ord_date, 'DD.MM') AS ord_ddmm, EXTRACT(YEAR FROM ord_date) AS ord_year FROM ord;


-- Регулярные выражения
-- 7.	Вывести имена продавцов, начинающиеся с букв A-I и заканчивающиеся на букву a или на комбинацию ‘nk’.
SELECT name FROM sal WHERE name ~* '^[A-I].*a$' OR name ~* '^[A-I].*nk$';

-- 8.	Вывести имена продавцов, в которых содержится две или более подряд идущих согласных.
SELECT name FROM sal WHERE name ~* '[bcdfghjklmnpqrstvwxyz]{2,}';
