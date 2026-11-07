-- P3 Task 3.
INSERT INTO books (book_id, title) VALUES
(1, 'Мёртвые туши'),
(2, 'Война и пир'),
(3, 'Онегий Евгенин'),
(4, 'Мастак и Маргарет'),
(5, 'Сказка о царе Сметане');

INSERT INTO authors (first_name, middle_name, last_name) VALUES
('Василий', 'Николаевич', 'Гугл'),
('Тигр', 'Николаевич', 'Стройной'),
('Александр', 'Сергеевич', 'Дуэлькин'),
('Иванов', 'Иван', 'Иванович'),
('Агния', '', 'Барто');

INSERT INTO authorship (book_id, author_id, seq_num) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(5, 3, 1),
(5, 5, 2);

INSERT INTO operations (book_id, qty_change) VALUES
(1, 21), (2, 23), (3, 17), (4, 16), (5, 10),
(1, -6), (3, -3), (2, -3), (4, -1);
