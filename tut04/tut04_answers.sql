-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- Create the database
CREATE DATABASE IF NOT EXISTS company;

-- Use the created database
USE company;

-- Create the departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

-- Create the employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create the projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    budget DECIMAL(12, 2),
    start_date DATE,
    end_date DATE
);

-- Insert data into departments table
INSERT INTO `departments` (`department_id`,`department_name`,`location`)
VALUES
(1,'Engineering','New Delhi'),
(2,'Sales','Mumbai'),
(3,'Finance','Kolkata');

-- Insert data into employees table
INSERT INTO `employees` (`emp_id`,`first_name`,`last_name`,`salary`,`department_id`)
VALUES
(1,'Rahul','Kumar',60000,1),
(2,'Neha','Sharma',55000,2),
(3,'Krishna','Singh',62000,1),
(4,'Pooja','Verma',58000,3),
(5,'Rohan','Gupta',59000,2);

-- Insert data into projects table
INSERT INTO `projects` (`project_id`,`project_name`,`budget`,`start_date`,`end_date`)
VALUES
(101,'ProjectA',100000,'2023-01-01','2023-06-30'),
(102,'ProjectB',80000,'2023-02-15','2023-08-15'),
(103,'ProjectC',120000,'2023-03-20','2023-09-30');

-- Select first name and last name from employees
SELECT first_name, last_name FROM employees;

-- Select department name and location from departments
SELECT department_name, location FROM departments;

-- Select project name and budget from projects
SELECT project_name, budget FROM projects;

-- Select employees from the Engineering department
SELECT e.first_name, e.last_name, e.salary 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
WHERE d.department_name = 'Engineering';

-- Select project name and start date from projects
SELECT project_name, start_date FROM projects;

-- Select employees with their department names
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id;

-- Select projects with budgets greater than 90000
SELECT project_name FROM projects WHERE budget > 90000;

-- Calculate the total budget of all projects
SELECT SUM(budget) AS total_budget FROM projects;

-- Select project name and end date from projects
SELECT project_name, end_date FROM projects;

-- Select department name and location from departments in North India
SELECT department_name, location 
FROM departments 
WHERE location LIKE 'North India';

-- Calculate the average salary of all employees
SELECT AVG(salary) AS average_salary FROM employees;

-- Select employees from the Finance department
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
WHERE d.department_name = 'Finance';

-- Select projects with budgets between 70000 and 100000
SELECT project_name FROM projects WHERE budget BETWEEN 70000 AND 100000;

-- Count the number of employees in each department
SELECT d.department_name, COUNT(e.emp_id) AS employee_count 
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_name;
