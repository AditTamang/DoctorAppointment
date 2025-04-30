-- SQL script to add allergies column to patients table if it doesn't exist
-- This is a safe script that can be run multiple times without causing errors

-- Check if allergies column exists in patients table
SET @columnExists = 0;
SELECT COUNT(*) INTO @columnExists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'doctor_appointment' 
AND TABLE_NAME = 'patients' 
AND COLUMN_NAME = 'allergies';

-- Add the column if it doesn't exist
SET @sql = IF(@columnExists = 0, 
    'ALTER TABLE patients ADD COLUMN allergies TEXT',
    'SELECT "Allergies column already exists in patients table"');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
