CREATE OR REPLACE FUNCTION get_catalog(
	author_name text, 
	book_title text, 
	in_stock boolean)

RETURNS TABLE (
	book_id integer, 
	display_name text, 
	onhand_qty integer)

LANGUAGE sql STABLE

BEGIN ATOMIC
SELECT 
	c.book_id, 
	c.display_name, 
	c.onhand_qty

FROM catalog_v c
WHERE (author_name IS NULL OR author_name = '' OR c.authors ILIKE '%' || author_name || '%')
AND (book_title  IS NULL OR book_title  = '' OR c.title  ILIKE '%' || book_title  || '%')
AND (in_stock IS NOT TRUE OR c.onhand_qty > 0);
END;