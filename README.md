# Group_work
# Employee Attendance Analysis Procedure

This repository contains a PL/SQL procedure, calculate_attendance_stats, that analyzes and displays attendance statistics for employees within a specified month and year. The procedure loops through employee attendance records, calculates the number of 'Present' and 'Absent' days, and displays the results, including the attendance percentage.

## Table of Contents

1. Overview

2. Database Structure

3. Procedure Details

4. Usage

5. Sample Output

6. Error Handling

7. Testing

8. Conclusion
---
## 1.Overview

### The calculate_attendance_stats procedure:

Accepts a month and year as input.

Retrieves and analyzes attendance records for each employee in the specified month.

Displays each employee's full name, total 'Present' and 'Absent' days, and their attendance percentage.

Handles cases where an employee has no attendance records for the specified month.


This procedure provides a helpful utility for database developers to generate monthly attendance reports.


---
## 2.Database Structure

To use this procedure, two tables are required in our database: Employees and Attendance. Below are the table structures:

sql
CREATE TABLE Employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50)
);

CREATE TABLE Attendance (
    attendance_id NUMBER PRIMARY KEY,
    employee_id NUMBER REFERENCES Employees(employee_id),
    attendance_date DATE,
    status VARCHAR2(10) CHECK (status IN ('Present', 'Absent'))
);

Employees Table: Stores employee information, including employee_id, first_name, and last_name.

Attendance Table: Stores attendance records with an employee_id (foreign key) and status indicating if the employee was 'Present' or 'Absent' on that date.

---
