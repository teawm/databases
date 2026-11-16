

CREATE OR REPLACE FUNCTION author_name(last_name text, first_name text, middle_name text)
RETURNS text
LANGUAGE sql IMMUTABLE AS
$$
SELECT concat_ws(' ', 
    nullif(trim(last_name), ''), 
    concat(left(nullif(trim(first_name), ''), 1), '.'),
    nullif(concat(left(nullif(trim(middle_name), ''), 1), '.'), '.')
);
$$;


CREATE OR REPLACE FUNCTION book_name(book_id integer, title text)
RETURNS text
LANGUAGE sql STABLE AS
$$
SELECT concat_ws(' -- ',
    nullif(trim(title), ''),
    (
        SELECT string_agg(author_name(a.last_name, a.first_name, a.middle_name), ', ' ORDER BY asp.seq_num)
        FROM authorship AS asp
        INNER JOIN authors AS a 
            ON a.author_id = asp.author_id
        WHERE asp.book_id = book_name.book_id
    )
);
$$;
