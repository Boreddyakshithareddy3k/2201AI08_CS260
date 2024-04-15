-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- Create the database
CREATE DATABASE IF NOT EXISTS CS260_Assignments;

-- Use the created database
USE CS260_Assignments;

-- Create the students table
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    city VARCHAR(50),
    state VARCHAR(50)
);

-- Create the instructors table
CREATE TABLE IF NOT EXISTS instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- Create the courses table
CREATE TABLE IF NOT EXISTS courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

-- Create the enrollments table
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


-- Insert data into students table
INSERT INTO students (first_name,last_name,age,city,state)
	VALUES
			('Rahul','Sharma',21,'Delhi','Delhi'),
			('Pooja','Patel',20,'Mumbai','Maharashtra'),
			('Krishna','Singh',22,'Lucknow','Uttar Pradesh'),
			('Anjali','Reddy',23,'Hyderabad','Telangana'),
			('Suresh','Kumar',21,'Bangalore','Karnataka'),
			('Riya','Gupta',22,'Kolkata','West Bengal'),
			('Rajesh','Mehta',20,'Ahmedabad','Gujarat'),
			('Kavita','Desai',21,'Pune','Maharashtra'),
			('Arjun','Mishra',22,'Jaipur','Rajasthan'),
			('Divya','Choudhary',20,'Chandigarh','Punjab'),
			('Akash','Bansal',21,'Indore','Madhya Pradesh'),
			('Mohit','Verma',22,'Ludhiana','Punjab'),
			('Jyoti','Chauhan',20,'Nagpur','Maharashtra'),
			('Varun','Rao',23,'Visakhapatnam','Andhra Pradesh'),
			('Nisha','Tiwari',21,'Patna','Bihar');

-- Insert data into instructors table
INSERT INTO instructors (first_name,last_name,email)
	VALUES
		('Dr. Akhil','Singh','drsingh@example.com'),
		('Dr. Neha','Agarwal','dragarwal@example.com'),
		('Dr. Nitin','Warrier','drwarrier@example.com');
        
-- Insert data into courses table
INSERT INTO courses (course_id,course_name,credit_hours,instructor_id)
	VALUES
		(101,'Mathematics',3,1),
		(102,'Physics',4,2),
		(103,'History',3,3),
		(104,'Chemistry',4,1),
		(105,'Computer Science',3,2);

-- Insert data into enrollments table
INSERT INTO enrollments (student_id,course_id,enrollment_date,grade)
	VALUES
		(1,101,'2022-09-01','A'),
		(2,102,'2022-09-03','B+'),
		(3,104,'2022-09-05','A-'),
		(4,103,'2022-09-07','B'),
		(5,105,'2022-09-10','A');


-- Select first name and last name from students
SELECT first_name, last_name FROM students;

-- Select course name and credit hours from courses
SELECT course_name, credit_hours FROM courses;

-- Select first name, last name, and email from instructors
SELECT first_name, last_name, email FROM instructors;

-- Select course name and grade from enrollments
SELECT c.course_name, e.grade
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id;

-- Select first name, last name, and city from students
SELECT first_name, last_name, city FROM students;

-- Select course name and instructor name from courses and instructors
SELECT c.course_name, CONCAT(i.first_name, ' ', i.last_name) AS instructor_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id;


-- Select first name, last name, and age from students
SELECT first_name, last_name, age FROM students;


-- Select course name and enrollment date from enrollments and courses
SELECT c.course_name, e.enrollment_date
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id;


-- Select first name, last name, and email from instructors
SELECT first_name, last_name, email FROM instructors;


-- Select course name and credit hours from courses
SELECT course_name, credit_hours FROM courses;


-- Select first name, last name, and email from instructors
SELECT i.first_name, i.last_name, i.email
FROM instructors i
JOIN courses c ON i.instructor_id = c.instructor_id
WHERE c.course_name = 'Mathematics';


-- Select course name and grade from enrollments and courses
SELECT c.course_name, e.grade
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
WHERE e.grade = 'A';


-- Select first name, last name, and state from students
SELECT s.first_name, s.last_name, s.state
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Computer Science';


-- Select course name and enrollment date from enrollments and courses
SELECT c.course_name, e.enrollment_date
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
WHERE e.grade = 'B+';


-- Select first name, last name, and email from instructors
SELECT i.first_name, i.last_name, i.email
FROM instructors i
JOIN courses c ON i.instructor_id = c.instructor_id
WHERE c.credit_hours > 3;
