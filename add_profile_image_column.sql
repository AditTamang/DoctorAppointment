-- SQL script to add profile_image column to patients table if it doesn't exist
-- This is a safe script that can be run multiple times without causing errors

-- Check if profile_image column exists in patients table
SET @columnExists = 0;
SELECT COUNT(*) INTO @columnExists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'doctor_appointment' 
AND TABLE_NAME = 'patients' 
AND COLUMN_NAME = 'profile_image';

-- Add the column if it doesn't exist
SET @sql = IF(@columnExists = 0, 
    'ALTER TABLE patients ADD COLUMN profile_image VARCHAR(255) DEFAULT "/assets/images/patients/default.jpg"',
    'SELECT "Profile image column already exists in patients table"');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verify the column was added
SELECT 'Verification of profile_image column:' AS Message;
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_DEFAULT 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'doctor_appointment' 
AND TABLE_NAME = 'patients' 
AND COLUMN_NAME = 'profile_image';
