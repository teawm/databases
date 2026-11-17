CREATE OR REPLACE PROCEDURE remove_duplicate_authors()
LANGUAGE sql
BEGIN ATOMIC
DELETE FROM authorship asp
WHERE EXISTS (
	SELECT 1
	FROM authors cur
	JOIN authors kep
	ON (kep.last_name, kep.first_name, COALESCE(kep.middle_name, '')) =
		(cur.last_name, cur.first_name, COALESCE(cur.middle_name, ''))
		AND kep.author_id < cur.author_id
	WHERE cur.author_id = asp.author_id
	AND EXISTS (SELECT 1 FROM authorship x
		WHERE x.book_id = asp.book_id 
		AND x.author_id = kep.author_id));

UPDATE authorship asp
SET author_id = (SELECT min(k.author_id) FROM authors k
WHERE (k.last_name, k.first_name, COALESCE(k.middle_name, '')) =
(SELECT cur.last_name, cur.first_name, COALESCE(cur.middle_name, '')
	FROM authors cur
	WHERE cur.author_id = asp.author_id))
	WHERE asp.author_id <> (SELECT min(k.author_id) 
	FROM authors k
	WHERE (k.last_name, k.first_name, COALESCE(k.middle_name, '')) =
	(SELECT cur.last_name, cur.first_name, COALESCE(cur.middle_name, '')
		FROM authors cur 
		WHERE cur.author_id = asp.author_id));

DELETE FROM authors a
WHERE a.author_id <> (SELECT min(k.author_id) 
			FROM authors k
WHERE (k.last_name, k.first_name, COALESCE(k.middle_name, '')) =
	(a.last_name, a.first_name, COALESCE(a.middle_name, '')));
END;