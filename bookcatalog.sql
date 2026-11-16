CREATE OR REPLACE FUNCTION get_catalog(
    p_author_name text, 
    p_book_title text, 
    p_in_stock boolean
)

RETURNS TABLE (
    book_id integer, 
    display_name text, 
    onhand_qty integer
)

LANGUAGE sql 

STABLE
PARALLEL SAFE
AS

$$
SELECT 
    c.book_id, 
    c.display_name, 
    c.onhand_qty
FROM catalog_v AS c
WHERE c.authors ILIKE concat('%', nullif(trim(p_author_name), ''), '%')
  AND c.title ILIKE concat('%', nullif(trim(p_book_title), ''), '%')
  -- Если p_in_stock = true, строго проверяем > 0. Если false или null — условие всегда true
  AND (NOT coalesce(p_in_stock, false) OR c.onhand_qty > 0);
$$;
