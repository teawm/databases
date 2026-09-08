CREATE TABLE prod (
    pnum int PRIMARY KEY,
    name varchar(20) NOT NULL,
    weight int NOT NULL,
    city varchar(20) NOT NULL
);

CREATE TABLE cust (
    cnum int PRIMARY KEY,
    name varchar(20) NOT NULL,
    rating int NOT NULL,
    city varchar(20) NOT NULL
);

CREATE TABLE sal (
    snum int PRIMARY KEY,
    name varchar(20) NOT NULL,
    comm numeric(7,2) NOT NULL,
    city varchar(20) NOT NULL
);

CREATE TABLE ord (
    onum int PRIMARY KEY,
    pnum int NOT NULL,
    cnum int NOT NULL,
    snum int NOT NULL,
    amt int NOT NULL,
    FOREIGN KEY (pnum) REFERENCES prod(pnum),
    FOREIGN KEY (cnum) REFERENCES cust(cnum),
    FOREIGN KEY (snum) REFERENCES sal(snum)
);
