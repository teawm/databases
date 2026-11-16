CREATE OR REPLACE PROCEDURE remove_duplicate_authors()
LANGUAGE sql AS

$$
WITH author_mapping AS (
    SELECT 
        author_id AS old_id,
        MIN(author_id) OVER(
            PARTITION BY last_name, first_name, middle_name
        ) AS new_id
    FROM authors
),

updated_authorship AS (
    UPDATE authorship AS asp
    SET author_id = am.new_id
    FROM author_mapping AS am
    WHERE asp.author_id = am.old_id AND am.old_id <> am.new_id
    RETURNING asp.book_id, asp.author_id
)

DELETE FROM authorship
WHERE ctid IN (
    SELECT ctid 
    FROM (
        SELECT ctid, ROW_NUMBER() OVER (PARTITION BY book_id, author_id ORDER BY seq_num) AS rn
        FROM authorship
    ) AS s
    WHERE s.rn > 1
);

DELETE FROM authors AS a
WHERE EXISTS (
    SELECT 1 
    FROM authors AS kep
    WHERE kep.last_name IS NOT DISTINCT FROM a.last_name
      AND kep.first_name IS NOT DISTINCT FROM a.first_name
      AND kep.middle_name IS NOT DISTINCT FROM a.middle_name
      AND kep.author_id < a.author_id
);
$$;
