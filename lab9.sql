CREATE SCHEMA student;
CREATE SCHEMA app;

CREATE TABLE student.clients (
	client_id serial PRIMARY KEY,
	name text NOT NULL
);

CREATE TABLE student.orders (
	order_id serial PRIMARY KEY,
	client_id int REFERENCES student.clients(client_id),
	total numeric(10,2)
);

CREATE TABLE app.products (
	product_id serial PRIMARY KEY,
	title text NOT NULL,
	price numeric(10,2) CHECK (price > 0)
);

CREATE TABLE app.categories (
	category_id serial PRIMARY KEY,
	name text NOT NULL
);

CREATE TABLE student.drinks (
	id serial PRIMARY KEY,
	name text NOT NULL,
	cost numeric(10,2)
);

CREATE TABLE app.drinks (
	id serial PRIMARY KEY,
	name text NOT NULL,
	cost numeric(10,2)
);