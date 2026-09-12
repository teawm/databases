- --- Лабораторная работа 3 ---

-- 1.	Вывести количество продавцов из городов, начинающихся на буквы I-N.
SELECT COUNT(*) AS sellers_count
FROM sal
WHERE LEFT(city, 1) BETWEEN 'I' AND 'N';

-- 2.	Вывести наименьший и наибольший вес из таблицы продуктов.
SELECT 
	MIN(weight) AS min_weight, 
	MAX(weight) AS max_weight 
FROM prod;

-- 3.	Вывести для каждого продукта наименьший номер продавца, у которого этот продукт продавался.
SELECT 
    prod.pnum, 
    prod.name, 
    MIN(ord.snum) AS min_snum 
FROM 
    prod
JOIN 
    ord ON prod.pnum = ord.pnum
GROUP BY 
    prod.pnum, 
    prod.name;

-- 4.	Вывести число уникальных продавцов, которые продавали товары покупателям с номерами 2005 и 2004. 
SELECT COUNT(DISTINCT snum) AS unique_sellers
FROM ord
WHERE cnum IN (2005, 2004);

-- 5.	Вывести для каждого покупателя его номер и общее количество проданных продуктов, если это количество не меньше, чем 15.
SELECT cnum, SUM(amt) AS total_amt
FROM ord
GROUP BY cnum
HAVING SUM(amt) >= 15;

-- 6.	Вывести количество заказов для всех уникальных пар продавец-продукт, между которыми осуществлялись заказы.
SELECT 
    sal.name AS seller,
    prod.name AS product,
    COUNT(*) AS orders
FROM ord
JOIN sal ON ord.snum = sal.snum
JOIN prod ON ord.pnum = prod.pnum
GROUP BY 
    sal.name,
    prod.name;

-- 7.	Вывести все даты, в которые в заказах участвовали ровно 3 покупателя и 1 продукт.
SELECT ord_date
FROM ord
GROUP BY ord_date
HAVING COUNT(DISTINCT cnum) = 3 AND COUNT(DISTINCT pnum) = 1;