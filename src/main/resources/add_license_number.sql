-- Add license_number column to doctors table
ALTER TABLE doctors ADD COLUMN license_number VARCHAR(100) DEFAULT NULL;

-- Update the schema version if you have a version tracking table
-- UPDATE schema_version SET version = version + 1 WHERE id = 1;
