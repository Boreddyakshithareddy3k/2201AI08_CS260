-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- Create the database
CREATE DATABASE IF NOT EXISTS tut5;

-- Use the created database
USE tut5;

-- Create the employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT
);

-- Insert data into the employees table
INSERT INTO employees (emp_id, first_name, last_name, salary, department_id)
VALUES
    (1, 'Rahul', 'Kumar', 60000, 1),
    (2, 'Neha', 'Sharma', 55000, 2),
    (3, 'Krishna', 'Singh', 62000, 1),
    (4, 'Pooja', 'Verma', 58000, 3),
    (5, 'Rohan', 'Gupta', 59000, 2);

-- Select all records from the employees table
SELECT * FROM employees;

-- Create the departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50),
    manager_id INT
);

-- Insert data into the departments table
INSERT INTO departments (department_id, department_name, location, manager_id)
VALUES
    (1, 'Engineering', 'New Delhi', 3),
    (2, 'Sales', 'Mumbai', 5),
    (3, 'Finance', 'Kolkata', 4);

-- Add foreign key constraint to employees table
ALTER TABLE employees
ADD CONSTRAINT fk_department_id
FOREIGN KEY (department_id)
REFERENCES departments(department_id);

-- Add foreign key constraint to departments table
ALTER TABLE departments
ADD CONSTRAINT fk_emp_id
FOREIGN KEY (manager_id)
REFERENCES employees(emp_id);

-- Create the projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    budget DECIMAL(12, 2),
    start_date DATE,
    end_date DATE
);

-- Insert data into the projects table
INSERT INTO projects (project_id, project_name, budget, start_date, end_date)
VALUES
    (101, 'ProjectA', 100000, '2023-01-01', '2023-06-30'),
    (102, 'ProjectB', 80000, '2023-02-15', '2023-08-15'),
    (103, 'ProjectC', 120000, '2023-03-20', '2023-09-30');

-- Select employees from the Engineering department
SELECT * 
FROM employees 
JOIN departments ON employees.department_id = departments.department_id 
WHERE departments.department_name = 'Engineering';

-- Select first name and salary from employees
SELECT first_name, salary FROM employees;

-- Select employees who are managers
SELECT * FROM employees WHERE emp_id IN (SELECT manager_id FROM departments);

-- Select employees with salary greater than 60000
SELECT * FROM employees WHERE salary > 60000;

-- Select employees with their departments
SELECT * FROM employees JOIN departments ON employees.department_id = departments.department_id;

-- Select Cartesian product of employees and projects
SELECT * FROM employees, projects;

-- Select employees who are not managers
SELECT * FROM employees WHERE emp_id NOT IN (SELECT manager_id FROM departments);

-- Select natural join of departments and projects
SELECT * FROM departments NATURAL JOIN projects;

-- Select department names and locations
SELECT department_name, location FROM departments;

-- Select projects with budget greater than 100000
SELECT * FROM projects WHERE budget > 100000;

-- Select employees who manage the Sales department
SELECT * FROM employees WHERE emp_id IN (SELECT manager_id FROM departments WHERE department_name = 'Sales');

-- Select employees from Engineering or Finance departments
SELECT * FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Engineering')
UNION
SELECT * FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Finance');

-- Select employees who are not assigned to any project
SELECT * FROM employees WHERE emp_id NOT IN (SELECT emp_id FROM projects);

-- Select left join of employees and projects
SELECT * FROM employees LEFT JOIN projects ON employees.emp_id = projects.project_id;

-- Select employees with salary less than 50000 or greater than 70000
SELECT * FROM employees WHERE salary < 50000 OR salary > 70000;
