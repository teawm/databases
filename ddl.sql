CREATE TABLE IF NOT EXISTS drinks (
	id serial PRIMARY KEY,
	name text NOT NULL,
	price numeric(10, 2)
)
