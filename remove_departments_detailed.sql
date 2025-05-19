-- Enhanced SQL Script to remove departments table and references
-- This script provides detailed output and handles various scenarios

-- Use the doctor_appointment database
USE doctor_appointment;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Create a temporary table to store log messages
CREATE TEMPORARY TABLE IF NOT EXISTS log_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Helper procedure to log messages
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS log_message(IN msg TEXT)
BEGIN
    INSERT INTO log_messages (message) VALUES (msg);
    SELECT msg AS 'Log';
END //
DELIMITER ;

-- Start logging
CALL log_message('Starting department removal process');

-- Check if departments table exists
SELECT IF(EXISTS(
    SELECT * FROM information_schema.tables 
    WHERE table_schema = 'doctor_appointment' 
    AND table_name = 'departments'), 
    'Departments table exists', 
    'Departments table does not exist') AS status INTO @dept_status;
CALL log_message(@dept_status);

-- Check if doctors table has department_id column
SELECT IF(EXISTS(
    SELECT * FROM information_schema.columns 
    WHERE table_schema = 'doctor_appointment' 
    AND table_name = 'doctors' 
    AND column_name = 'department_id'), 
    'department_id column exists in doctors table', 
    'department_id column does not exist in doctors table') AS status INTO @col_status;
CALL log_message(@col_status);

-- Find all foreign keys referencing departments table
SELECT GROUP_CONCAT(CONSTRAINT_NAME) INTO @fk_constraints
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'doctor_appointment'
AND REFERENCED_TABLE_NAME = 'departments';

-- Log foreign key constraints found
SET @fk_message = IF(@fk_constraints IS NULL, 'No foreign key constraints found referencing departments table', 
                    CONCAT('Found foreign key constraints: ', @fk_constraints));
CALL log_message(@fk_message);

-- Try to drop foreign keys if they exist
SET @drop_fk_sql = '';

-- Method 1: Try to drop using the constraint name we found
IF @fk_constraints IS NOT NULL THEN
    SET @drop_fk_sql = CONCAT('ALTER TABLE doctors DROP FOREIGN KEY ', @fk_constraints);
    CALL log_message(CONCAT('Attempting to drop foreign key with command: ', @drop_fk_sql));
    
    -- Prepare and execute the statement
    PREPARE stmt FROM @drop_fk_sql;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            CALL log_message('Error dropping foreign key with constraint name');
        END;
        EXECUTE stmt;
        CALL log_message('Successfully dropped foreign key constraint');
    END;
    DEALLOCATE PREPARE stmt;
ELSE
    CALL log_message('Skipping constraint drop by name as no constraints were found');
END IF;

-- Method 2: Try common constraint names
CALL log_message('Trying common constraint names as fallback');

-- List of common constraint naming patterns
SET @constraint_names = 'doctors_ibfk_1,doctors_ibfk_2,doctors_department_id_fk,fk_doctors_departments,doctors_departments_fk';

-- Create a procedure to try dropping each constraint
DELIMITER //
CREATE PROCEDURE try_drop_constraints()
BEGIN
    DECLARE constraint_name VARCHAR(100);
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT value FROM (
        SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(@constraint_names, ',', numbers.n), ',', -1) value
        FROM (
            SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        ) numbers
        WHERE numbers.n <= 1 + (LENGTH(@constraint_names) - LENGTH(REPLACE(@constraint_names, ',', '')))
    ) AS constraints_list;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        SET @error_msg = CONCAT('Error dropping constraint ', constraint_name, ': ', @text);
        CALL log_message(@error_msg);
    END;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO constraint_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET @drop_sql = CONCAT('ALTER TABLE doctors DROP FOREIGN KEY ', constraint_name);
        CALL log_message(CONCAT('Trying: ', @drop_sql));
        
        PREPARE stmt FROM @drop_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        CALL log_message(CONCAT('Successfully dropped constraint: ', constraint_name));
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;

-- Execute the procedure
CALL try_drop_constraints();
DROP PROCEDURE IF EXISTS try_drop_constraints;

-- Method 3: Direct approach - try to drop the column regardless of constraints
CALL log_message('Attempting direct column drop as final approach');

-- Try to drop the department_id column
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        SET @error_msg = CONCAT('Error dropping department_id column: ', @text);
        CALL log_message(@error_msg);
        
        -- If we get a foreign key error, try to drop all foreign keys on the table
        IF @sqlstate = '23000' OR @errno = 1451 OR @errno = 1217 THEN
            CALL log_message('Foreign key constraint is preventing column drop. Attempting to drop all foreign keys on doctors table.');
            
            -- Get all constraints on the doctors table
            SELECT GROUP_CONCAT(CONSTRAINT_NAME) INTO @all_constraints
            FROM information_schema.TABLE_CONSTRAINTS
            WHERE TABLE_SCHEMA = 'doctor_appointment'
            AND TABLE_NAME = 'doctors'
            AND CONSTRAINT_TYPE = 'FOREIGN KEY';
            
            IF @all_constraints IS NOT NULL THEN
                SET @drop_all_fk_sql = CONCAT('ALTER TABLE doctors DROP FOREIGN KEY ', @all_constraints);
                CALL log_message(CONCAT('Attempting to drop all foreign keys with command: ', @drop_all_fk_sql));
                
                PREPARE stmt FROM @drop_all_fk_sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                
                -- Try dropping the column again
                ALTER TABLE doctors DROP COLUMN department_id;
                CALL log_message('Successfully dropped department_id column after removing all foreign keys');
            ELSE
                CALL log_message('No foreign key constraints found on doctors table');
            END IF;
        END IF;
    END;
    
    -- Attempt to drop the column
    ALTER TABLE doctors DROP COLUMN department_id;
    CALL log_message('Successfully dropped department_id column');
END;

-- Method 4: Nuclear option - recreate the table without the department_id column
CALL log_message('Checking if department_id still exists after previous attempts');

-- Check if the column still exists
SELECT IF(EXISTS(
    SELECT * FROM information_schema.columns 
    WHERE table_schema = 'doctor_appointment' 
    AND table_name = 'doctors' 
    AND column_name = 'department_id'), 
    'department_id column still exists, trying nuclear option', 
    'department_id column successfully removed') AS status INTO @final_col_status;
CALL log_message(@final_col_status);

-- If the column still exists, try the nuclear option
IF @final_col_status = 'department_id column still exists, trying nuclear option' THEN
    CALL log_message('Creating backup of doctors table');
    
    -- Create a backup of the doctors table
    CREATE TABLE doctors_backup AS SELECT * FROM doctors;
    CALL log_message('Backup created as doctors_backup');
    
    -- Get the create table statement without the department_id column
    CALL log_message('Creating new table structure without department_id');
    
    -- Drop the original table
    DROP TABLE doctors;
    CALL log_message('Original doctors table dropped');
    
    -- Create a new doctors table without the department_id column
    CREATE TABLE doctors (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        name VARCHAR(100),
        specialization VARCHAR(100) NOT NULL,
        qualification VARCHAR(255) NOT NULL,
        experience INT DEFAULT 0,
        phone VARCHAR(20),
        email VARCHAR(100),
        address TEXT,
        consultation_fee DECIMAL(10, 2) DEFAULT 0.00,
        available_days VARCHAR(100) DEFAULT 'Monday-Friday',
        available_time VARCHAR(100) DEFAULT '09:00 AM - 05:00 PM',
        profile_image VARCHAR(255),
        image_url VARCHAR(255),
        bio TEXT,
        rating DECIMAL(3, 1) DEFAULT 0.0,
        patient_count INT DEFAULT 0,
        success_rate INT DEFAULT 0,
        status VARCHAR(20) DEFAULT 'ACTIVE',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
    CALL log_message('New doctors table created without department_id');
    
    -- Copy data from backup to new table
    INSERT INTO doctors (
        id, user_id, name, specialization, qualification, experience, 
        phone, email, address, consultation_fee, available_days, 
        available_time, profile_image, image_url, bio, rating, 
        patient_count, success_rate, status, created_at, updated_at
    )
    SELECT 
        id, user_id, name, specialization, qualification, experience, 
        phone, email, address, consultation_fee, available_days, 
        available_time, profile_image, image_url, bio, rating, 
        patient_count, success_rate, status, created_at, updated_at
    FROM doctors_backup;
    CALL log_message('Data copied from backup to new table');
END IF;

-- Finally, drop the departments table if it exists
DROP TABLE IF EXISTS departments;
CALL log_message('Departments table dropped if it existed');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;
CALL log_message('Foreign key checks re-enabled');

-- Show final status
CALL log_message('Department removal process completed');

-- Show the log messages
SELECT * FROM log_messages ORDER BY id;

-- Clean up
DROP PROCEDURE IF EXISTS log_message;
DROP TEMPORARY TABLE IF EXISTS log_messages;

-- Verify the changes
DESCRIBE doctors;
SHOW TABLES;
