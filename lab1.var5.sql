-- Вариант 5 --

-- 1.  Вывести все строки из таблицы Заказов, для которых номер продавца не равен 3005.
SELECT * FROM ord WHERE snum <> 3005;

-- 2.  Вывести записи о продуктах с весом строго больше 500 со столбцами в следующем порядке: city, name, pnum, weight.
SELECT city, name, pnum, weight 
FROM prod 
WHERE weight > 500;

-- 3.  Вывести без повторений номера всех продавцов, которые поставляли продукты с номерами не более 1001.
SELECT DISTINCT snum 
FROM ord 
WHERE pnum <= 1001;

-- 4.  Вывести данные о всех продавцах с комиссионными менее или равным 0.13, если они не находятся в Екатеринбурге.
SELECT * FROM sal 
WHERE comm <= 0.13 AND city <> 'Yekaterinburg';

-- 5.  Вывести тремя различными способами все заказы покупателей с номерами 2005, 2005, 2007.
-- 1 способ                                      ^ 2006 ?
SELECT * FROM ord WHERE cnum IN (2005, 2006, 2007);
-- 2 способ
SELECT * FROM ord 
WHERE cnum = 2005 OR cnum = 2006 OR cnum = 2007;
-- 3 способ
SELECT * FROM ord WHERE cnum BETWEEN 2005 AND 2007;
