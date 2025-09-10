--- Library Management Systeam Project 

CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);
-- Branches
INSERT INTO branch (branch_id, manager_id, branch_address, contact_no)
VALUES 
('B001', 'M001', 'Main Street, New York', '1234567890'),
('B002', 'M002', 'Park Avenue, Chicago', '9876543210');

-- Employees
INSERT INTO employees (emp_id, emp_name, position, salary, branch_id)
VALUES 
('E001', 'John Doe', 'Manager', 60000, 'B001'),
('E002', 'Sarah Lee', 'Librarian', 40000, 'B001'),
('E003', 'David Kim', 'Assistant', 35000, 'B002');

-- Books
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('ISBN001', 'SQL for Beginners', 'Tech', 15.99, 'Available', 'Jane Smith', 'TechPress'),
('ISBN002', 'Data Analytics Handbook', 'Tech', 20.50, 'Available', 'Mark Lee', 'DataWorld'),
('ISBN003', 'Pride and Prejudice', 'Fiction', 10.00, 'Issued', 'Jane Austen', 'ClassicPub');

-- Members
INSERT INTO members (member_id, member_name, member_address, reg_date)
VALUES
('M001', 'Alice Brown', '12 River St, New York', '2023-05-10'),
('M002', 'Michael Green', '45 Lake Rd, Chicago', '2023-06-15');

-- Issued Status
INSERT INTO issued_status (issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('I001', 'M001', 'Pride and Prejudice', '2023-07-01', 'ISBN003', 'E002');

-- Return Status
INSERT INTO return_status (return_id, issued_id, return_book_name, return_date, return_book_isbn)
VALUES
('R001', 'I001', 'Pride and Prejudice', '2023-07-20', 'ISBN003');

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM members;
SELECT * FROM return_status;


--- PROJECT TASK 
--- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
select * from books;
INSERT INTO books(isbn,book_title,category,rental_price,status,author,publisher)
VALUES 
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

--- Task 2: Update an Existing Member's Address
SELECT * FROM members;
UPDATE members
set member_address = '125 main st'
WHERE member_id = 'C 101';
SELECT * FROM members;

--- Task 3:  Retrieve All Books in a Specific Category
SELECT * FROM books
WHERE category = 'Classic';

--- Task 4 Find Total Rental Income by Category
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;

--- Task 5 List Members Who Registered in the Last 180 Days
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY;
 
 --- Task 6 List Employees with Their Branch Manager's Name and their branch details
 SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;

--- Task 7 Create a Table of Books with Rental Price Above a Certain Threshold 7 USD.
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

--- Task 8 Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;