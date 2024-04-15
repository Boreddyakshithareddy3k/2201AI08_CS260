-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

CREATE DATABASE tut8;
USE tut8;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (emp_id, first_name, last_name, salary, department_id)
VALUES
    (1, 'Rahul', 'Kumar', 60000, 1),
    (2, 'Neha', 'Sharma', 55000, 2),
    (3, 'Krishna', 'Singh', 62000, 1),
    (4, 'Pooja', 'Verma', 58000, 3),
    (5, 'Rohan', 'Gupta', 59000, 2);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50),
    manager_id INT
);

INSERT INTO departments (department_id, department_name, location, manager_id)
VALUES
    (1, 'Engineering', 'New Delhi', 3),
    (2, 'Sales', 'Mumbai', 5),
    (3, 'Finance', 'Kolkata', 4);

ALTER TABLE employees
ADD CONSTRAINT fk_department_id
FOREIGN KEY (department_id)
REFERENCES departments(department_id);

ALTER TABLE departments
ADD CONSTRAINT fk_emp_id
FOREIGN KEY (manager_id)
REFERENCES employees(emp_id);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    budget DECIMAL(12, 2),
    start_date DATE,
    end_date DATE
);

INSERT INTO projects (project_id, project_name, budget, start_date, end_date)
VALUES
    (101, 'ProjectA', 100000, '2023-01-01', '2023-06-30'),
    (102, 'ProjectB', 80000, '2023-02-15', '2023-08-15'),
    (103, 'ProjectC', 120000, '2023-03-20', '2023-09-30');

CREATE TABLE works_on (
    emp_id INT,
    project_id INT,
    hours_worked INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO works_on (emp_id, project_id, hours_worked)
VALUES
    (1, 101, 120),
    (2, 102, 80),
    (3, 101, 100),
    (4, 103, 140),
    (5, 102, 90);

-- 1

DELIMITER //
CREATE TRIGGER increase_salary_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 60000 THEN
        SET NEW.salary = NEW.salary * 1.1;
    END IF;
END;
//
DELIMITER ;

-- 2

DELIMITER //
CREATE TRIGGER prevent_delete_trigger
BEFORE DELETE ON departments
FOR EACH ROW
BEGIN
    DECLARE employee_count INT;
    SELECT COUNT(*) INTO employee_count FROM employees WHERE department_id = OLD.department_id;
    IF employee_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete department with assigned employees';
    END IF;
END;
//
DELIMITER ;

-- 3

DELIMITER //
CREATE TRIGGER salary_audit_trigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_audit (emp_id, old_salary, new_salary, employee_name)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary, CONCAT(OLD.first_name, ' ', OLD.last_name));
END;
//
DELIMITER ;

-- 4

DELIMITER //
CREATE TRIGGER assign_department_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 60000 THEN
        SET NEW.department_id = 3; -- Assuming department_id 3 is for salaries <= 60000
    END IF;
END;
//
DELIMITER ;

-- 5

DELIMITER //
CREATE TRIGGER update_manager_salary_trigger
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    UPDATE employees e
    JOIN (
        SELECT emp_id
        FROM employees
        WHERE department_id = NEW.department_id
        ORDER BY salary DESC
        LIMIT 1
    ) AS m ON e.emp_id = m.emp_id
    SET e.salary = NEW.salary;
END;
//
DELIMITER ;

-- 6

DELIMITER //
CREATE TRIGGER prevent_department_update_trigger
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE project_count INT;
    SELECT COUNT(*) INTO project_count FROM works_on WHERE emp_id = OLD.emp_id;
    IF project_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update department_id for employees with assigned projects';
    END IF;
END;
//
DELIMITER ;

-- 7

DELIMITER //
CREATE TRIGGER update_average_salary_trigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    UPDATE departments d
    SET d.average_salary = (
        SELECT AVG(e.salary)
        FROM employees e
        WHERE e.department_id = d.department_id
    );
END;
//
DELIMITER ;

-- 8

DELIMITER //
CREATE TRIGGER delete_works_on_trigger
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    DELETE FROM works_on WHERE emp_id = OLD.emp_id;
END;
//
DELIMITER ;

-- 9

DELIMITER //
CREATE TRIGGER prevent_salary_insert_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE min_salary DECIMAL(10, 2);
    SELECT MIN(salary) INTO min_salary FROM departments WHERE department_id = NEW.department_id;
    IF NEW.salary < min_salary THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee salary cannot be less than the minimum salary for the department';
    END IF;
END;
//
DELIMITER ;

-- 10

DELIMITER //
CREATE TRIGGER update_salary_budget_trigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    UPDATE departments d
    SET d.total_salary_budget = (
        SELECT SUM(e.salary)
        FROM employees e
        WHERE e.department_id = d.department_id
    );
END;
//
DELIMITER ;

-- 11 

DELIMITER //
CREATE PROCEDURE send_email_to_hr(IN employee_name VARCHAR(100))
BEGIN
    DECLARE subject VARCHAR(100);
    DECLARE body VARCHAR(500);
    
    SET subject = 'New Employee Hired';
    SET body = CONCAT('A new employee has been hired: ', employee_name);
    
    -- Execute a script or command to send the email
    -- For example, you can use the MySQL extension 'sys_exec' to execute a shell command
    -- This command should be configured to send an email using an external email service
    -- For security reasons, you should ensure that proper authentication and authorization mechanisms are in place
    -- This example assumes that 'sys_exec' extension is installed and configured
    
    -- sys_exec('/usr/sbin/sendmail -t < email.txt');
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER email_notification_trigger
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE employee_name VARCHAR(100);
    SET employee_name = CONCAT(NEW.first_name, ' ', NEW.last_name);
    
    CALL send_email_to_hr(employee_name);
END;
//
DELIMITER ;



-- 12 

DELIMITER //
CREATE TRIGGER prevent_insert_department_trigger
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    IF NEW.location IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Location must be specified for a new department';
    END IF;
END;
//
DELIMITER ;

-- 13

DELIMITER //
CREATE TRIGGER update_department_name_trigger
AFTER UPDATE ON departments
FOR EACH ROW
BEGIN
    UPDATE employees SET department_name = NEW.department_name WHERE department_id = NEW.department_id;
END;
//
DELIMITER ;

-- 14

CREATE TABLE employee_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE'),
    emp_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER employee_audit_trigger
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit (action_type, emp_id, first_name, last_name)
    VALUES ('INSERT', NEW.emp_id, NEW.first_name, NEW.last_name);
END;
//
CREATE TRIGGER employee_audit_update_trigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit (action_type, emp_id, first_name, last_name)
    VALUES ('UPDATE', OLD.emp_id, OLD.first_name, OLD.last_name);
END;
//
CREATE TRIGGER employee_audit_delete_trigger
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit (action_type, emp_id, first_name, last_name)
    VALUES ('DELETE', OLD.emp_id, OLD.first_name, OLD.last_name);
END;
//
DELIMITER ;

-- 15

DELIMITER //
CREATE TRIGGER generate_emp_id_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE max_emp_id INT;
    SELECT MAX(emp_id) INTO max_emp_id FROM employees;
    IF max_emp_id IS NULL THEN
        SET NEW.emp_id = 1;
    ELSE
        SET NEW.emp_id = max_emp_id + 1;
    END IF;
END;
//
DELIMITER ;





