-- P3 Task 1.
CREATE DATABASE bookstore;
\c bookstore
CREATE SCHEMA bookstore;
ALTER DATABASE bookstore SET search_path = bookstore, public;


-- P3 Task 2.
CREATE TABLE books (
	book_id serial PRIMARY KEY,
	title text NOT NULL
);

CREATE TABLE authors (
	author_id serial PRIMARY KEY,
	last_name text NOT NULL,
	first_name text NOT NULL,
	middle_name text
);

CREATE TABLE authorship (
	book_id int NOT NULL REFERENCES books(book_id) ON DELETE CASCADE,
	author_id int NOT NULL REFERENCES authors(author_id) ON DELETE CASCADE,
	seq_num int NOT NULL check (seq_num > 0),
	PRIMARY KEY (book_id, author_id),
	UNIQUE (book_id, seq_num)
);

CREATE TABLE operations (
	operation_id serial PRIMARY KEY,
	book_id int NOT NULL REFERENCES books(book_id),
	qty_change int NOT NULL CHECK (qty_change <> 0),
	date_created timestamp NOT NULL DEFAULT now()
);