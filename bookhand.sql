CREATE OR REPLACE FUNCTION onhand_qty(book books)
RETURNS integer
LANGUAGE sql STABLE AS

$$
SELECT COALESCE(SUM(o.qty_change), 0)::integer
FROM operations o
WHERE o.book_id = book.book_id;
$$;
