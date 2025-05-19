-- SQL Script to safely remove departments table and references
-- Run this script in phpMyAdmin or MySQL command line

-- Use the doctor_appointment database
USE doctor_appointment;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Step 1: Check if the foreign key constraint exists and drop it
-- First, get the constraint name
SELECT CONSTRAINT_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'doctor_appointment' 
AND TABLE_NAME = 'doctors' 
AND REFERENCED_TABLE_NAME = 'departments';

-- Drop the foreign key constraint (replace 'constraint_name' with the actual name from the query above)
-- If you can't determine the name, try this alternative approach:
ALTER TABLE doctors DROP FOREIGN KEY doctors_ibfk_2;
-- If that doesn't work, try:
-- ALTER TABLE doctors DROP FOREIGN KEY doctors_department_id_fk;
-- If that doesn't work either, try:
-- ALTER TABLE doctors DROP FOREIGN KEY fk_doctors_departments;

-- Step 2: Remove the department_id column from doctors table
ALTER TABLE doctors DROP COLUMN department_id;

-- Step 3: Drop the departments table if it exists
DROP TABLE IF EXISTS departments;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Verify the changes
DESCRIBE doctors;
SHOW TABLES;

-- Output a success message
SELECT 'Departments table and references successfully removed' AS Result;
