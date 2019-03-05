USE [master]
GO
/****** Object:  StoredProcedure [dbo].[Build_db_library]    
Script Date: 3/27/2017 9:27:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Build_db_library]
AS
BEGIN

	/******************************************************
	 * The following prevents any errors from occuring
	 * if the database or tables already exist.
	 * This code will close all active connections to the 
	 * database and then drop it
	 ******************************************************/

	WHILE EXISTS(select * from sys.databases where name='db_library')
	BEGIN
		DECLARE @SQL varchar(max)
		SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
		FROM MASTER.sys.sysprocesses
		WHERE DBId = DB_ID(N'db_library') AND SPId <> @@SPId
		EXEC(@SQL)
		DROP DATABASE [db_library]
	END
	/******************************************************
	 * The following demonstrates a stored proceedure to 
	 * build the database, tables and then populate the 
	 * tables with data.
	 ******************************************************/

	CREATE DATABASE db_library

END

GO

/*USE PROCEDURE TO BUILD DB*/
USE master
GO
EXEC [dbo].[Build_db_library]


/*START BUILDING TABLES*/

USE [db_library]
GO
/****** Object:  StoredProcedure [dbo].[Populate_db_library]    Script Date: 3/27/2017 9:37:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Populate_db_library]
AS
BEGIN
		
	/******************************************************
	 * Build our database tables and define their schema
	 ******************************************************/
	CREATE TABLE tbl_branch (
		branch_id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
		branch_name VARCHAR(50) NOT NULL,
		branch_address VARCHAR(50) NOT NULL
	);

	CREATE TABLE tbl_book_copies (
		book_copies_book_id INT NOT NULL CONSTRAINT fk_book_copies_id FOREIGN KEY REFERENCES tbl_books(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
		book_copies_branch_id INT NOT NULL CONSTRAINT fk_branch_id FOREIGN KEY REFERENCES tbl_branch(branch_id) ON UPDATE CASCADE ON DELETE CASCADE,
		book_copies_number_of_copies INT NOT NULL
	);
	
	CREATE TABLE tbl_publisher (
		publisher_name VARCHAR(50) PRIMARY KEY NOT NULL,
		publisher_address VARCHAR(60) NOT NULL,
		publisher_phone VARCHAR(10) NOT NULL
	);

		CREATE TABLE tbl_borrower (
		borrower_cardNo INT PRIMARY KEY NOT NULL IDENTITY (1000,1),
		borrower_name VARCHAR(50) NOT NULL,
		borrower_address VARCHAR(50) NOT NULL,
		borrower_phone VARCHAR (10) NOT NULL
	);

	CREATE TABLE tbl_book_loans (
		book_loans_book_id INT NOT NULL CONSTRAINT fk_book_id FOREIGN KEY REFERENCES tbl_books(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
		book_loans_branch_id INT NOT NULL CONSTRAINT fk_branch_loan_id FOREIGN KEY REFERENCES tbl_branch(branch_id) ON UPDATE CASCADE ON DELETE CASCADE,
		book_loans_cardNo INT NOT NULL CONSTRAINT fk_borrower_cardNo FOREIGN KEY REFERENCES tbl_borrower(borrower_cardNo) ON UPDATE CASCADE ON DELETE CASCADE,
		book_loans_date_out VARCHAR (10) NOT NULL,
		book_loans_date_due VARCHAR (10) NOT NULL
	);

	CREATE TABLE tbl_books (
		book_id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
		book_title VARCHAR(50) NOT NULL,
		book_publisher_name VARCHAR(50) NOT NULL CONSTRAINT fk_publisher_name FOREIGN KEY REFERENCES tbl_publisher(publisher_name) ON UPDATE CASCADE ON DELETE CASCADE,
	);

	CREATE TABLE tbl_book_authors (
		book_id INT NOT NULL CONSTRAINT fk_author_book_id FOREIGN KEY REFERENCES tbl_books(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
		author_name VARCHAR(50) NOT NULL
	);
	END

	/* Populate DB Library */

	USE db_library
	GO

	EXEC Populate_db_library

	/******************************************************
	 * Now that the tables are built, we populate them
	 ******************************************************/
	INSERT INTO tbl_branch
		(branch_name, branch_address)
		VALUES 
		('Sharpstown', '123 Fake St'),
		('Central', '21 Gimlay Dr'),
		('Dogtown', '4579 Soggy Way'),
		('West', '1 Nile Dr')
	;
	SELECT * FROM tbl_branch;

	INSERT INTO tbl_book_copies
		(book_copies_book_id, book_copies_branch_id, book_copies_number_of_copies)
		VALUES 
		(4, 2, 8),
		(4, 1, 8),
		(4, 3, 8),
		(4, 4, 8),
		(5, 2, 8),
		(5, 1, 8),
		(5, 3, 8),
		(5, 4, 8),
		(6, 2, 8),
		(6, 1, 8),
		(6, 3, 8),
		(6, 4, 8),
		(7, 2, 8),
		(7, 1, 8),
		(7, 3, 8),
		(7, 4, 8),
		(8, 2, 8),
		(8, 1, 8),
		(8, 3, 8),
		(8, 4, 8),
		(9, 2, 8),
		(9, 1, 8),
		(9, 3, 8),
		(9, 4, 8),
		(10, 2, 8),
		(10, 1, 8),
		(10, 3, 8),
		(10, 4, 8),
		(11, 2, 8),
		(11, 1, 8),
		(11, 3, 8),
		(11, 4, 8)
	;
	SELECT * FROM tbl_book_copies;

	INSERT INTO tbl_publisher
		(publisher_name, publisher_address, publisher_phone)
		VALUES 
		('Penguin', '342 Ageless Ave', '555-0120'),
		('Stalwrt', '12 Grundle St', '555-0167')
	;
	SELECT * FROM tbl_publisher;

	INSERT INTO tbl_books
		(book_title, book_publisher_name)
		VALUES 
		('The Lost Tribe', 'Penguin'),
		('IT', 'Stalwert'),
		('Darn Kids', 'Penguin'),
		('Welbys Death', 'Stalwert'),
		('Along Came A Waffle', 'Penguin'),
		('Satans Shadow', 'Stalwert'),
		('Walk With Me', 'Penguin'),
		('A League To Remember', 'Stalwert'),
		('Grandma and the Shotgun', 'Penguin'),
		('The Glorious Road', 'Stalwert'),
		('Zippy', 'Penguin'),
		('Tag', 'Stalwert'),
		('The Crimson Sparrow', 'Penguin'),
		('Happy DeathDay', 'Stalwert'),
		('Computers for Idiots', 'Penguin'),
		('The R Word', 'Stalwert'),
		('Skittles for Her', 'Penguin'),
		('The Sandwich Diaries', 'Stalwert'),
		('Landscaping and You', 'Penguin'),
		('History of the World Pt 2', 'Stalwert')
	;
	SELECT * FROM tbl_books;

	INSERT INTO tbl_borrower
		(borrower_name, borrower_address, borrower_phone)
		VALUES 
		('Steve', '485 Bonny Ln', '555-0001'),
		('Hurk', 'PO Box 456', '555-0002'),
		('Lenny', '85 Slank Dr', '555-0003'),
		('Abra', '4956 Ward Rd', '555-0004'),
		('Golem', '4 S Lane Ln', '555-0005'),
		('Botti', 'PO Box 953', '555-0006'),
		('Svenka', '23 Senders Way', '555-0007'),
		('Irma', '45 Bud Rd', '555-0008')
	;
	SELECT * FROM tbl_borrower;

	INSERT INTO tbl_book_authors
		(book_id, author_name)
		VALUES 
		(4, 'Steven King'),
		(5, 'Lomba Tinkta'),
		(6, 'Wanda Sykes'),
		(7, 'Tran Sawyer'),
		(8, 'JDilla'),
		(9, 'Dan Brown'),
		(10, 'Sanders Kane'),
		(11, 'Eloise Cole')
	;
	SELECT * FROM tbl_book_authors;

	INSERT INTO tbl_book_loans
		(book_loans_book_id, book_loans_branch_id, book_loans_cardNo, book_loans_date_out, book_loans_date_due)
		VALUES 
		(4, 1, 1001, '7/7/19', '8/7/19'),
		(4, 2, 1000, '7/7/19', '8/7/19'),
		(6, 1, 1001, '7/7/19', '8/7/19'),
		(4, 2, 1000, '7/7/19', '8/7/19'),
		(7, 4, 1001, '7/7/19', '8/7/19'),
		(8, 3, 1004, '7/7/19', '8/7/19'),
		(6, 2, 1003, '7/7/19', '8/7/19'),
		(4, 2, 1000, '7/7/19', '8/7/19'),
		(8, 1, 1002, '7/7/19', '8/7/19'),
		(9, 3, 1000, '7/7/19', '8/7/19'),
		(6, 4, 1001, '7/7/19', '8/7/19'),
		(4, 2, 1000, '7/7/19', '8/7/19'),
		(7, 4, 1006, '7/7/19', '8/7/19'),
		(8, 3, 1004, '7/7/19', '8/7/19'),
		(6, 2, 1003, '7/7/19', '8/7/19'),
		(4, 2, 1001, '7/7/19', '8/7/19'),
		(4, 1, 1001, '7/7/19', '8/7/19'),
		(4, 2, 1000, '7/7/19', '8/7/19'),
		(6, 3, 1001, '7/7/19', '8/7/19'),
		(4, 3, 1000, '7/7/19', '8/7/19'),
		(11, 4, 1001, '7/7/19', '8/7/19'),
		(10, 3, 1004, '7/7/19', '8/7/19'),
		(6, 2, 1003, '7/7/19', '8/7/19'),
		(9, 2, 1000, '7/7/19', '8/7/19'),
		(4, 1, 1002, '7/7/19', '8/7/19'),
		(9, 3, 1003, '7/7/19', '8/7/19'),
		(6, 4, 1001, '7/5/19', '8/5/19'),
		(4, 3, 1000, '7/7/19', '8/7/19'),
		(7, 4, 1006, '7/7/19', '8/7/19'),
		(8, 3, 1004, '7/7/19', '8/7/19'),
		(6, 3, 1003, '7/9/19', '8/9/19'),
		(4, 2, 1001, '7/7/19', '8/7/19'),
		(4, 1, 1001, '7/7/19', '8/7/19'),
		(4, 2, 1000, '7/7/19', '8/7/19'),
		(6, 3, 1001, '7/7/19', '8/7/19'),
		(4, 3, 1000, '7/7/19', '8/7/19'),
		(10, 4, 1001, '7/7/19', '8/7/19'),
		(19, 3, 1004, '7/7/19', '8/7/19'),
		(6, 2, 1003, '7/7/19', '8/7/19'),
		(9, 2, 1000, '7/7/19', '8/7/19'),
		(5, 4, 1002, '7/9/19', '8/9/19'),
		(9, 3, 1002, '7/7/19', '8/7/19'),
		(6, 4, 1001, '7/7/19', '8/7/19'),
		(4, 3, 1000, '7/7/19', '8/7/19'),
		(7, 4, 1006, '7/7/19', '8/7/19'),
		(8, 3, 1004, '7/7/19', '8/7/19'),
		(6, 3, 1003, '7/7/19', '8/7/19'),
		(4, 4, 1001, '7/7/19', '8/7/19')
	;
	SELECT * FROM tbl_book_loans;

	/* SELECT STATEMENTS */

	--1
	SELECT book_title, branch_name, book_copies_number_of_copies
	FROM tbl_book_copies 
	INNER JOIN [dbo].[tbl_books] a1 ON book_copies_book_id = book_id
	INNER JOIN [dbo].[tbl_branch] a2 ON book_copies_branch_id = branch_id
	WHERE book_title = 'The Lost Tribe' AND branch_name = 'Central'
	;

	--2
	SELECT book_title, branch_name, book_copies_number_of_copies
	FROM tbl_book_copies 
	INNER JOIN [dbo].[tbl_books] a1 ON book_copies_book_id = book_id
	INNER JOIN [dbo].[tbl_branch] a2 ON book_copies_branch_id = branch_id
	WHERE book_title = 'The Lost Tribe'
	;

	--3
	SELECT [borrower_name], [book_loans_date_out]
	FROM [tbl_borrower]
	INNER JOIN [dbo].[tbl_book_loans] a1 ON [book_loans_cardNo] = [borrower_cardNo]
	WHERE [book_loans_date_out] = NULL
	; 

	--4 Today is 8/7/19 in this scenario
	SELECT [book_title], [borrower_name], [borrower_address]
	FROM [dbo].[tbl_book_loans]
	INNER JOIN [dbo].[tbl_borrower] a1 ON [book_loans_cardNo] = [borrower_cardNo]
	INNER JOIN [dbo].[tbl_books] a2 ON [book_id] = [book_loans_book_id]
	WHERE [book_loans_date_due] = '8/7/19' AND [book_loans_branch_id] = 2
	;

	--5
	SELECT branch_name, COUNT([book_loans_cardNo])
	FROM [dbo].[tbl_book_loans]
	INNER JOIN [dbo].[tbl_branch] a1 ON [book_loans_branch_id] = [branch_id]
	INNER JOIN [dbo].[tbl_books] a2 ON [book_id] = [book_loans_book_id]
	--WHERE branch_name = 'Central'
	GROUP BY branch_name
	;

	--6
	SELECT [borrower_name], [borrower_address], COUNT([book_loans_cardNo])
	FROM [tbl_borrower]
	INNER JOIN [dbo].[tbl_book_loans] a1 ON [book_loans_cardNo] = [borrower_cardNo]
	GROUP BY [borrower_name],[borrower_address]
	HAVING COUNT([book_loans_cardNo]) > 5

	; 

	--7
	SELECT [book_title], [book_copies_number_of_copies]
	FROM [dbo].[tbl_book_authors] a3
	INNER JOIN [dbo].[tbl_book_loans] a1 ON [book_loans_book_id] = [book_id]
	INNER JOIN [dbo].[tbl_books] a2 ON a2.[book_id] = a3.[book_id]
	INNER JOIN [dbo].[tbl_book_copies] a4 ON [book_copies_book_id] = a2.[book_id]
	WHERE [author_name] = 'Steven King' AND book_copies_branch_id = 2
	;