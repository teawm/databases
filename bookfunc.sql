

CREATE OR REPLACE FUNCTION author_name(last_name text, first_name text, middle_name text)
RETURNS text
LANGUAGE sql IMMUTABLE AS
$$
SELECT last_name || ' ' || left(first_name, 1) || '.' ||
       COALESCE(' ' || left(NULLIF(trim(middle_name), ''), 1) || '.', '');
$$;


CREATE OR REPLACE FUNCTION book_name(book_id integer, title text)
RETURNS text
LANGUAGE sql STABLE AS
$$
SELECT book_name.title ||
       COALESCE(' -- ' ||
                (SELECT string_agg(author_name(a.last_name, a.first_name, a.middle_name),
                                   ', ' ORDER BY asp.seq_num)
                   FROM authorship asp
                   JOIN authors a ON a.author_id = asp.author_id
                  WHERE asp.book_id = book_name.book_id),
                '');
$$;