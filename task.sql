-- Part 1: Movie Database Tables

CREATE DATABASE MovieDB;
GO
USE MovieDB;
GO

-- Actor table
CREATE TABLE actor (
    act_id INT PRIMARY KEY,
    act_fname CHAR(20),
    act_lname CHAR(20),
    act_gender CHAR(1)
);

-- Director table
CREATE TABLE director (
    dir_id INT PRIMARY KEY,
    dir_fname CHAR(20),
    dir_lname CHAR(20)
);

-- Genres table
CREATE TABLE genres (
    gen_id INT PRIMARY KEY,
    gen_title CHAR(20)
);

-- Reviewer table
CREATE TABLE reviewer (
    rev_id INT PRIMARY KEY,
    rev_name CHAR(30)
);

-- Movie table
CREATE TABLE movie (
    mov_id INT PRIMARY KEY,
    mov_title CHAR(50),
    mov_year INT,
    mov_time INT,
    mov_lang CHAR(50),
    mov_dt_rel DATE,
    mov_rel_country CHAR(5)
);

-- Movie cast table
CREATE TABLE movie_cast (
    act_id INT,
    mov_id INT,
    role CHAR(30),
    PRIMARY KEY (act_id, mov_id),
    FOREIGN KEY (act_id) REFERENCES actor(act_id),
    FOREIGN KEY (mov_id) REFERENCES movie(mov_id)
);

-- Movie direction table
CREATE TABLE movie_direction (
    dir_id INT,
    mov_id INT,
    PRIMARY KEY (dir_id, mov_id),
    FOREIGN KEY (dir_id) REFERENCES director(dir_id),
    FOREIGN KEY (mov_id) REFERENCES movie(mov_id)
);

-- Movie genres table
CREATE TABLE movie_genres (
    mov_id INT,
    gen_id INT,
    PRIMARY KEY (mov_id, gen_id),
    FOREIGN KEY (mov_id) REFERENCES movie(mov_id),
    FOREIGN KEY (gen_id) REFERENCES genres(gen_id)
);

-- Rating table
CREATE TABLE rating (
    mov_id INT,
    rev_id INT,
    rev_stars INT,
    num_o_ratings INT,
    PRIMARY KEY (mov_id, rev_id),
    FOREIGN KEY (mov_id) REFERENCES movie(mov_id),
    FOREIGN KEY (rev_id) REFERENCES reviewer(rev_id)
);
GO


-- Part 2: Data Definition Questions (DDL)

-- 1. Create a table named "Employees" with columns for ID (integer), Name (varchar), and Salary (decimal).
CREATE TABLE Employees (
    ID INT NOT NULL,
    Name VARCHAR(100),
    Salary DECIMAL(10, 2)
);

-- 2. Add a new column named "Department" to the "Employees" table with data type varchar(50).
ALTER TABLE Employees
ADD Department VARCHAR(50);

-- 3. Remove the "Salary" column from the "Employees" table.
ALTER TABLE Employees
DROP COLUMN Salary;

-- 4. Rename the "Department" column in the "Employees" table to "DeptName".
EXEC sp_rename 'Employees.Department', 'DeptName', 'COLUMN';

-- 5. Create a new table called "Projects" with columns for ProjectID (integer) and ProjectName (varchar).
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100)
);

-- 6. Add a primary key constraint to the "Employees" table for the "ID" column.
ALTER TABLE Employees
ADD CONSTRAINT PK_Employees PRIMARY KEY (ID);

-- 7. Create a foreign key relationship between the "Employees" table (referencing "ID") and the "Projects" table (referencing "ProjectID").
ALTER TABLE Projects
ADD CONSTRAINT FK_Projects_Employees FOREIGN KEY (ProjectID) REFERENCES Employees(ID);

-- 8. Remove the foreign key relationship between "Employees" and "Projects."
ALTER TABLE Projects
DROP CONSTRAINT FK_Projects_Employees;

-- 9. Add a unique constraint to the "Name" column in the "Employees" table.
ALTER TABLE Employees
ADD CONSTRAINT UQ_Employees_Name UNIQUE (Name);

-- 10. Create a table named "Customers" with columns for CustomerID (integer), FirstName (varchar), LastName (varchar), and Email (varchar), and Status (varchar).
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Status VARCHAR(20)
);

-- 11. Add a unique constraint to the combination of "FirstName" and "LastName" columns in the "Customers" table.
ALTER TABLE Customers
ADD CONSTRAINT UQ_Customers_FullName UNIQUE (FirstName, LastName);

-- 12. Add a default value of 'Active' for the "Status" column in the "Customers" table, where the default value should be applied when a new record is inserted.
ALTER TABLE Customers
ADD CONSTRAINT DF_Customers_Status DEFAULT 'Active' FOR Status;

-- 13. Create a table named "Orders" with columns for OrderID (integer), CustomerID (integer), OrderDate (datetime), and TotalAmount (decimal).
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(10, 2)
);

-- 14. Add a check constraint to the "TotalAmount" column in the "Orders" table to ensure that it is greater than zero.
ALTER TABLE Orders
ADD CONSTRAINT CHK_Orders_TotalAmount CHECK (TotalAmount > 0);

-- 15. Create a schema named "Sales" and move the "Orders" table into this schema.
GO
CREATE SCHEMA Sales;
GO
ALTER SCHEMA Sales TRANSFER dbo.Orders;

-- 16. Rename the "Orders" table to "SalesOrders."
EXEC sp_rename 'Sales.Orders', 'SalesOrders';
GO


-- Part 3: Data Manipulation Questions (DML)

-- 1. Select all columns from the "Employees" table.
SELECT * FROM Employees;

-- 2. Select only the "Name" and "Salary" columns from the "Employees" table.
SELECT Name, Salary FROM Employees;

-- 3. Select distinct values of the "DeptName" column from the "Employees" table.
SELECT DISTINCT DeptName FROM Employees;

-- 4. Select the top 5 records from the "Employees" table.
SELECT TOP 5 * FROM Employees;

-- 5. Select all records from the "Employees" table, ordered by the "Salary" column in descending order.
SELECT * FROM Employees
ORDER BY Salary DESC;

-- 6. Select the first 10 records from the "Employees" table, starting from the third record.
SELECT * FROM Employees
ORDER BY ID
OFFSET 3 ROWS FETCH NEXT 10 ROWS ONLY;

-- 7. Select the average salary from the "Employees" table.
SELECT AVG(Salary) AS AverageSalary FROM Employees;

-- 8. Select the maximum and minimum salaries from the "Employees" table.
SELECT MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary FROM Employees;

-- 9. Select the top 3 highest salaries from the "Employees" table.
SELECT TOP 3 Salary FROM Employees
ORDER BY Salary DESC;

-- 10. Select all records from the "Employees" table, ordered by "Name" in ascending order.
SELECT * FROM Employees
ORDER BY Name;

-- 11. Select the first 5 records from the "Employees" table, starting from the second record, ordered by "Salary" in descending order.
SELECT * FROM Employees
ORDER BY Salary DESC
OFFSET 1 ROW FETCH NEXT 5 ROWS ONLY;

-- 12. Select the sum of all salaries from the "Employees" table.
SELECT SUM(Salary) AS TotalSalaries FROM Employees;

-- 13. Select records from the "Employees" table where the "Salary" is between 40000 and 60000, ordered by "Salary" in ascending order.
SELECT * FROM Employees
WHERE Salary > 40000 AND Salary < 60000
ORDER BY Salary ASC;