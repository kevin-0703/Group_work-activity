

CREATE OR REPLACE PROCEDURE calculate_attendance_stats (
    p_month IN NUMBER,
    p_year IN NUMBER
) AS
    -- Variables for holding employee information and attendance counts
    v_employee_id employees.employee_id%TYPE;
    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_total_presents NUMBER := 0;
    v_total_absents NUMBER := 0;
    v_total_days_in_month NUMBER;
    v_attendance_percentage NUMBER;
    
    -- Cursor to loop through each employee
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, last_name
        FROM employees;

BEGIN
    -- Determine the total number of days in the specified month
    SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_year || '-' || p_month || '-01', 'YYYY-MM-DD')), 'DD'))
    INTO v_total_days_in_month
    FROM dual;

    -- Loop through each employee using the cursor
    FOR emp_record IN emp_cursor LOOP
        v_employee_id := emp_record.employee_id;
        v_first_name := emp_record.first_name;
        v_last_name := emp_record.last_name;
        v_total_presents := 0;
        v_total_absents := 0;

        -- Check if there are any attendance records for the specified month and year
        DECLARE
            v_no_records EXCEPTION;
            PRAGMA EXCEPTION_INIT(v_no_records, -1403); -- Handle no data found
            CURSOR att_cursor IS
                SELECT status
                FROM attendance
                WHERE employee_id = v_employee_id
                  AND EXTRACT(MONTH FROM attendance_date) = p_month
                  AND EXTRACT(YEAR FROM attendance_date) = p_year;
        BEGIN
            OPEN att_cursor;

            -- Loop through attendance records to count 'Present' and 'Absent' days
            LOOP
                FETCH att_cursor INTO v_status;
                EXIT WHEN att_cursor%NOTFOUND;

                IF v_status = 'Present' THEN
                    v_total_presents := v_total_presents + 1;
                ELSIF v_status = 'Absent' THEN
                    v_total_absents := v_total_absents + 1;
                END IF;
            END LOOP;
            CLOSE att_cursor;

            -- Calculate attendance percentage
            v_attendance_percentage := (v_total_presents / v_total_days_in_month) * 100;

            -- Display results
            DBMS_OUTPUT.PUT_LINE('Employee: ' || v_first_name || ' ' || v_last_name);
            DBMS_OUTPUT.PUT_LINE('Total Presents: ' || v_total_presents);
            DBMS_OUTPUT.PUT_LINE('Total Absents: ' || v_total_absents);
            DBMS_OUTPUT.PUT_LINE('Attendance Percentage: ' || ROUND(v_attendance_percentage, 2) || '%');
            DBMS_OUTPUT.PUT_LINE('--------------------------');
        
        EXCEPTION
            WHEN v_no_records THEN
                -- If no attendance records found for the employee in the specified month
                DBMS_OUTPUT.PUT_LINE('Employee: ' || v_first_name || ' ' || v_last_name);
                DBMS_OUTPUT.PUT_LINE('No attendance records found for the specified month.');
                DBMS_OUTPUT.PUT_LINE('--------------------------');
        END;
    END LOOP;
END calculate_attendance_stats;
/
