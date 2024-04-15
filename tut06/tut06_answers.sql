-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- Create the database
CREATE DATABASE IF NOT EXISTS university;

-- Use the created database
USE university;

-- Create the students table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    city VARCHAR(50)
);

-- Create the instructors table
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

-- Create the courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

-- Create the enrollments table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insert data into students table
INSERT INTO `students` (`student_id`,`first_name`,`last_name`,`age`,`city`)
VALUES
(1,'Rahul','Kumar',20,'Delhi'),
(2,'Neha','Sharma',22,'Mumbai'),
(3,'Krishna','Singh',21,'Bangalore'),
(4,'Pooja','Verma',23,'Kolkata'),
(5,'Rohan','Gupta',22,'Hyderabad');


-- Insert data into instructors table
INSERT INTO `instructors` (`instructor_id`,`first_name`,`last_name`)
VALUES
(1,'Dr. Akhil','Singh'),
(2,'Dr. Neha','Agarwal'),
(3,'Dr. Nitin','Warrier');


-- Insert data into courses table
INSERT INTO `courses` (`course_id`,`course_name`,`instructor_id`)
VALUES
(101,'Mathematics',1),
(102,'Physics',2),
(103,'History',3),
(104,'Chemistry',1),
(105,'Computer Science',2);


-- Insert data into enrollments table
INSERT INTO `enrollments` (`enrollment_id`,`student_id`,`course_id`,`grade`)
VALUES
(1,1,101,'A'),
(2,2,102,'B+'),
(3,3,104,'A-'),
(4,4,103,'B'),
(5,5,105,'A');

-- Select student names and enrolled courses
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;


-- Select course names and grades
SELECT c.course_name, e.grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id;


-- Select student names, enrolled courses, and instructors
SELECT s.first_name, s.last_name, c.course_name, CONCAT(i.first_name, ' ', i.last_name) AS instructor_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id;


-- Select students enrolled in Mathematics from Bangalore
SELECT s.first_name, s.last_name, s.age, s.city
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';


-- Select course names and instructors
SELECT c.course_name, CONCAT(i.first_name, ' ', i.last_name) AS instructor_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id;


-- Select student names, grades, and courses
SELECT s.first_name, s.last_name, e.grade, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;


-- Select students who are enrolled in more than one course
SELECT s.first_name, s.last_name, s.age
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 1;


-- Count the number of students enrolled in each course
SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;


-- Select students who are not enrolled in any course
SELECT s.first_name, s.last_name, s.age
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;


-- Calculate the average grade for each course
SELECT c.course_name, AVG(grade) AS average_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;


-- Select students with grades higher than 'B'
SELECT s.first_name, s.last_name, e.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade > 'B';


-- Select courses taught by instructors whose last name starts with 'S'
SELECT c.course_name, CONCAT(i.first_name, ' ', i.last_name) AS instructor_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.last_name LIKE 'S%';


-- Select students taught by Dr. Akhil
SELECT s.first_name, s.last_name, s.age
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE CONCAT(i.first_name, ' ', i.last_name) = 'Dr. Akhil';


-- Select the highest grade for each course
SELECT c.course_name, MAX(e.grade) AS max_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;


-- Select student names, ages, and enrolled courses, ordered by course name
SELECT s.first_name, s.last_name, s.age, c.course
