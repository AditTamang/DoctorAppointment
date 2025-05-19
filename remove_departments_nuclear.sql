-- Nuclear option script to remove departments table and department_id column
-- This script recreates the doctors table without the department_id column

-- Use the doctor_appointment database
USE doctor_appointment;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Step 1: Create a backup of the doctors table
CREATE TABLE doctors_backup AS SELECT * FROM doctors;
SELECT 'Backup created as doctors_backup' AS Status;

-- Step 2: Drop the original doctors table
DROP TABLE doctors;
SELECT 'Original doctors table dropped' AS Status;

-- Step 3: Create a new doctors table without the department_id column
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
SELECT 'New doctors table created without department_id' AS Status;

-- Step 4: Copy data from backup to new table
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
SELECT 'Data copied from backup to new table' AS Status;

-- Step 5: Drop the departments table if it exists
DROP TABLE IF EXISTS departments;
SELECT 'Departments table dropped' AS Status;

-- Step 6: Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;
SELECT 'Foreign key checks re-enabled' AS Status;

-- Verify the changes
DESCRIBE doctors;
SHOW TABLES;

-- Optional: Drop the backup table if everything is successful
-- Uncomment the line below if you want to automatically drop the backup
-- DROP TABLE doctors_backup;
