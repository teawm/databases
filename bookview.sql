DROP VIEW IF EXISTS catalog_v, authors_v, operations_v;

DROP VIEW IF EXISTS catalog_v;
CREATE VIEW catalog_v AS
SELECT b.book_id,
       book_name(b.book_id, b.title) AS display_name,
       onhand_qty(b)                 AS onhand_qty,
       b.title,
       (SELECT string_agg(a.last_name || ' ' || a.first_name ||
                          COALESCE(' ' || a.middle_name, ''),
                          ', ' ORDER BY asp.seq_num)
          FROM authorship asp JOIN authors a ON a.author_id = asp.author_id
         WHERE asp.book_id = b.book_id) AS authors
FROM books b;


CREATE VIEW authors_v AS
SELECT 
	author_id,
	CONCAT (last_name, ' ', first_name, ' ', middle_name) AS display_name
FROM authors;


CREATE VIEW operations_v AS
SELECT
	book_id,
	CASE
		WHEN qty_change > 0 THEN 'Пополнение'
		ELSE 'Продажа'
	END 
	AS op_type,
	abs(qty_change) AS qty_change,
	TO_CHAR(date_created, 'DD.MM.YYYY') AS date_created
FROM operations;
