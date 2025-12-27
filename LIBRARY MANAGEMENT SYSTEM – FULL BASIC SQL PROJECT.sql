-- 1️⃣ Create Database
CREATE DATABASE LibraryDB;
GO
USE LibraryDB;
GO

-- 2️⃣ Create Tables

-- Table: Authors
CREATE TABLE Authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

-- Table: Books
CREATE TABLE Book (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    publisher VARCHAR(100),
    published_year INT,
    category VARCHAR(50),
    total_copies INT,
    available_copies INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Table: Members
CREATE TABLE Member (
    member_id INT IDENTITY(1,1) PRIMARY KEY,
    member_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255)
);

-- Table: Borrow
CREATE TABLE Borrow (
    borrow_id INT IDENTITY(1,1) PRIMARY KEY,
    member_id INT,
    book_id INT,
    issue_date DATE,
    due_date DATE,
    return_date DATE NULL,
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);


-- 3️⃣ Insert Sample Data

-- Insert Authors
INSERT INTO Authors (author_name)
VALUES 
('J.K. Rowling'),
('George Orwell'),
('Agatha Christie'),
('Chetan Bhagat'),
('Paulo Coelho');

-- Insert Books
INSERT INTO Book (title, author_id, publisher, published_year, category, total_copies, available_copies)
VALUES 
('Harry Potter and the Philosopher''s Stone', 1, 'Bloomsbury', 1997, 'Fantasy', 10, 8),
('1984', 2, 'Secker & Warburg', 1949, 'Dystopian', 6, 5),
('Murder on the Orient Express', 3, 'Collins Crime Club', 1934, 'Mystery', 5, 4),
('2 States', 4, 'Rupa Publications', 2009, 'Romance', 7, 6),
('The Alchemist', 5, 'HarperCollins', 1988, 'Adventure', 8, 7);

-- Insert Members
INSERT INTO Member (member_name, email, phone, address)
VALUES 
('Amit Sharma', 'amit@example.com', '9876543210', 'Delhi'),
('Priya Singh', 'priya@example.com', '9998877665', 'Mumbai'),
('Ravi Kumar', 'ravi@example.com', '8887766554', 'Bangalore'),
('Sneha Patel', 'sneha@example.com', '7776655443', 'Pune');

-- Insert Borrow Records
INSERT INTO Borrow (member_id, book_id, issue_date, due_date, return_date)
VALUES 
(1, 1, '2025-10-10', '2025-10-25', NULL),
(2, 3, '2025-10-12', '2025-10-27', '2025-10-20'),
(3, 2, '2025-10-15', '2025-10-30', NULL),
(4, 5, '2025-10-18', '2025-11-02', NULL);

-- 4️⃣ Basic SELECT Queries

-- Show all authors
SELECT * FROM Authors;

-- Show all books
SELECT * FROM Books;

-- Show all members
SELECT * FROM Members;

-- Show all borrow transactions
SELECT * FROM Borrow;

-- Show which member borrowed which book
SELECT 
    B.borrow_id,
    M.member_name,
    BK.title AS book_title,
    B.issue_date,
    B.due_date,
    B.return_date
FROM Borrow B
JOIN Member M ON B.member_id = M.member_id
JOIN Book BK ON B.book_id = BK.book_id;

-- Find all available books
SELECT title, available_copies
FROM Book
WHERE available_copies > 0;

-- Find books of a specific author (example: George Orwell)
SELECT B.title, A.author_name
FROM Book B
JOIN Authors A ON B.author_id = A.author_id
WHERE A.author_name = 'George Orwell';

-- Count how many books each author has written
SELECT A.author_name, COUNT(B.book_id) AS total_book
FROM Authors A
LEFT JOIN Book B ON A.author_id = B.author_id
GROUP BY A.author_name;


-- 5️⃣ Basic INSERT, UPDATE, DELETE Examples

-- Add a new member
INSERT INTO Member (member_name, email, phone, address)
VALUES ('Rahul Mehta', 'rahul@example.com', '9876501234', 'Chandigarh');

-- Add a new book
INSERT INTO Book (title, author_id, publisher, published_year, category, total_copies, available_copies)
VALUES ('The Monk Who Sold His Ferrari', 5, 'HarperCollins', 1997, 'Motivational', 6, 6);

-- Issue a new book (borrow)
INSERT INTO Borrow (member_id, book_id, issue_date, due_date)
VALUES (1, 2, GETDATE(), DATEADD(DAY, 15, GETDATE()));

-- Return a book
UPDATE Borrow
SET return_date = GETDATE()
WHERE borrow_id = 1;

-- Update available copies when a book is returned
UPDATE Book
SET available_copies = available_copies + 1
WHERE book_id = 1;

-- Decrease available copies when book is issued
UPDATE Book
SET available_copies = available_copies - 1
WHERE book_id = 2;

-- Delete a borrow record (if created by mistake)
DELETE FROM Borrow
WHERE borrow_id = 4;

-- Delete a member (if no borrowed books)
DELETE FROM Member
WHERE member_id = 4;


-- 6️⃣ Reports & Analytics Queries

-- Total books in library
SELECT SUM(total_copies) AS Total_Book FROM Book;

-- Total members
SELECT COUNT(*) AS Total_Member FROM Member;

-- Total currently borrowed books
SELECT COUNT(*) AS Borrowed_Book
FROM Borrow
WHERE return_date IS NULL;

-- List overdue books (due_date < today and not returned)
SELECT 
    M.member_name,
    BK.title,
    B.due_date
FROM Borrow B
JOIN Member M ON B.member_id = M.member_id
JOIN Book BK ON B.book_id = BK.book_id
WHERE B.return_date IS NULL AND B.due_date < GETDATE();
