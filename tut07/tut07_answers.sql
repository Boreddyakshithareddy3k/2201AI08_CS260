-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- Create the database
CREATE DATABASE IF NOT EXISTS company_database;

-- Use the newly created database
USE company_database;

-- Create the employees table
CREATE TABLE IF NOT EXISTS employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT
);

-- Create the departments table
CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Create the projects table
CREATE TABLE IF NOT EXISTS projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100),
    budget DECIMAL(15, 2),
    start_date DATE,
    end_date DATE
);

-- Insert data into the employees table
INSERT INTO employees (first_name, last_name, salary, department_id)
VALUES
    ('Rahul', 'Kumar', 60000, 1),
    ('Neha', 'Sharma', 55000, 2),
    ('Krishna', 'Singh', 62000, 1),
    ('Pooja', 'Verma', 58000, 3),
    ('Rohan', 'Gupta', 59000, 2);

-- Insert data into the departments table
INSERT INTO departments (department_name, location, manager_id)
VALUES
    ('Engineering', 'New Delhi', 3),
    ('Sales', 'Mumbai', 5),
    ('Finance', 'Kolkata', 4);


INSERT INTO `projects` (`project_id`,`project_name`,`budget`,`start_date`,`end_date`)
VALUES
(101,'ProjectA',100000,'2023-01-01','2023-06-30'),
(102,'ProjectB',80000,'2023-02-15','2023-08-15'),
(103,'ProjectC',120000,'2023-03-20','2023-09-30');

DELIMITER //
CREATE PROCEDURE calculate_avg_salary_in_department(IN dept_id INT)
BEGIN
    SELECT AVG(salary) AS average_salary
    FROM employees
    WHERE department_id = dept_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE update_salary_by_percentage(IN emp_id INT, IN percentage DECIMAL)
BEGIN
    UPDATE employees
    SET salary = salary * (1 + percentage/100)
    WHERE emp_id = emp_id;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE list_employees_in_department(IN dept_id INT)
BEGIN
    SELECT *
    FROM employees
    WHERE department_id = dept_id;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE calculate_total_budget_for_project(IN proj_id INT)
BEGIN
    SELECT SUM(budget) AS total_budget
    FROM projects
    WHERE project_id = proj_id;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE find_employee_highest_salary_in_department(IN dept_id INT)
BEGIN
    SELECT *
    FROM employees
    WHERE department_id = dept_id
    ORDER BY salary DESC
    LIMIT 1;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE list_projects_ending_within_days(IN num_days INT)
BEGIN
    SELECT *
    FROM projects
    WHERE end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL num_days DAY);
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE calculate_total_salary_expenditure_for_department(IN dept_id INT)
BEGIN
    SELECT SUM(salary) AS total_salary_expenditure
    FROM employees
    WHERE department_id = dept_id;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE generate_employee_report()
BEGIN
    SELECT e.emp_id, e.first_name, e.last_name, d.department_name, e.salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE find_project_highest_budget()
BEGIN
    SELECT *
    FROM projects
    ORDER BY budget DESC
    LIMIT 1;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE calculate_avg_salary_across_departments()
BEGIN
    SELECT AVG(salary) AS average_salary
    FROM employees;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE assign_new_manager_to_department(IN dept_id INT, IN new_manager_id INT)
BEGIN
    UPDATE departments
    SET manager_id = new_manager_id
    WHERE department_id = dept_id;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE calculate_remaining_budget_for_project(IN proj_id INT)
BEGIN
    DECLARE total_budget DECIMAL;
    DECLARE total_expense DECIMAL;
    SELECT budget INTO total_budget FROM projects WHERE project_id = proj_id;
    SELECT SUM(salary) INTO total_expense FROM employees;
    SELECT total_budget - total_expense AS remaining_budget;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE generate_employee_report_specific_year(IN year INT)
BEGIN
    SELECT *
    FROM employees
    WHERE YEAR(join_date) = year;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE update_project_end_date(IN proj_id INT, IN duration INT)
BEGIN
    UPDATE projects
    SET end_date = DATE_ADD(start_date, INTERVAL duration DAY)
    WHERE project_id = proj_id;
END//
DELIMITER ;




