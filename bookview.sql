CREATE VIEW catalog_v AS
SELECT b.book_id,
       b.title,
       (SELECT string_agg(a.last_name || ' ' || left(a.first_name, 1) || '.' ||
                          COALESCE(left(a.middle_name, 1) || '.', ''),
                          ', ' ORDER BY asp.seq_num)
          FROM authorship asp JOIN authors a ON a.author_id = asp.author_id
         WHERE asp.book_id = b.book_id) AS authors,
       (SELECT COALESCE(SUM(o.qty_change), 0)
          FROM operations o WHERE o.book_id = b.book_id) AS qty
FROM books b;

CREATE VIEW authors_v AS
SELECT a.author_id,
       a.last_name, a.first_name, a.middle_name,
       (SELECT string_agg(b.title, ', ' ORDER BY b.title)
          FROM authorship asp JOIN books b ON b.book_id = asp.book_id
         WHERE asp.author_id = a.author_id) AS books
FROM authors a;

CREATE VIEW operations_v AS
SELECT o.operation_id,
       o.date_created,
       b.title AS book,
       o.qty_change
FROM operations o JOIN books b ON b.book_id = o.book_id;		
