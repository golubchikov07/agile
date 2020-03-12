CREATE DATABASE JoinsDB
GO

USE JoinsDB
GO

CREATE TABLE dbo.Authors
(
    Id int NOT NULL IDENTITY,
    Name varchar(50) NULL
);

CREATE TABLE dbo.Books
(
    Id int NOT NULL IDENTITY,
    AuthorId int NULL,
	Title varchar(50) NULL
);

INSERT Authors VALUES
('Leo Tolstoy'),
('Ayn Rand'),
('Stanislav Zuiko')

INSERT Books VALUES
(1,'War and Peace'),
(1,'Anna Karenina'),
(2,'Atlas Shrugged'),
(NULL,'Bible')

-- INNER JOIN
SELECT * FROM Authors
SELECT * FROM Books

Select * from Authors a
Join Books b 
on a.Id = b.AuthorId 

Select * from Books b
Join Authors a
on b.AuthorId = a.Id

-- LEFT OUTER JOIN
SELECT * FROM Authors a
	LEFT JOIN Books b
	ON a.Id = b.AuthorId

SELECT * FROM Books b
	LEFT JOIN Authors a
	ON a.Id = b.AuthorId

SELECT * FROM Authors a
	LEFT JOIN Books b
	ON a.Id = b.AuthorId
	WHERE b.AuthorId IS NULL

-- RIGHT OUTER JOIN
SELECT * FROM Authors a
	RIGHT JOIN Books b
	ON a.Id = b.AuthorId

SELECT * FROM Books b
	RIGHT JOIN Authors a
	ON a.Id = b.AuthorId


--FULL OUTER JOIN
SELECT * FROM Authors a
	FULL JOIN Books b
	ON a.Id = b.AuthorId

SELECT * FROM Authors a
	FULL JOIN Books b
	ON a.Id = b.AuthorId
	WHERE b.AuthorId IS NULL
		OR a.Id IS NULL