-- Direct SQL fix for the missing allergies column
-- Run this in your MySQL client or command line

-- Connect to the database
USE doctor_appointment;

-- Add the allergies column if it doesn't exist
ALTER TABLE patients ADD COLUMN IF NOT EXISTS allergies TEXT;

-- Verify the column was added
DESCRIBE patients;
