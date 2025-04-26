-- Sample data for doctor_appointment database
-- Admin users are now in admin_data.sql

-- Insert sample doctor users if not exists
-- Password is 'password' for all test accounts
INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
VALUES ('doctor1', 'doctor1@example.com', 'cGFzc3dvcmQ=', 'John', 'Smith', '1234567891', 'DOCTOR', 'Male', '123 Doctor St')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
VALUES ('doctor2', 'doctor2@example.com', 'cGFzc3dvcmQ=', 'Sarah', 'Johnson', '1234567892', 'DOCTOR', 'Female', '456 Doctor Ave')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
VALUES ('doctor3', 'doctor3@example.com', 'cGFzc3dvcmQ=', 'Michael', 'Brown', '1234567893', 'DOCTOR', 'Male', '789 Doctor Blvd')
ON DUPLICATE KEY UPDATE username = username;

-- Insert sample patient users if not exists
INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
VALUES ('patient1', 'patient1@example.com', 'cGFzc3dvcmQ=', 'John', 'Doe', '1234567894', 'PATIENT', 'Male', '123 Patient St')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
VALUES ('patient2', 'patient2@example.com', 'cGFzc3dvcmQ=', 'Jane', 'Doe', '1234567895', 'PATIENT', 'Female', '456 Patient Ave')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
VALUES ('patient3', 'patient3@example.com', 'cGFzc3dvcmQ=', 'Bob', 'Smith', '1234567896', 'PATIENT', 'Male', '789 Patient Blvd')
ON DUPLICATE KEY UPDATE username = username;

-- Insert sample doctors if not exists
INSERT IGNORE INTO doctors (user_id, specialization, qualification, experience, consultation_fee, bio, rating, patient_count)
SELECT id, 'Cardiology', 'MD, Cardiology', '10 years', '100.00', 'Specializes in heart conditions', 4.5, 50
FROM users WHERE username = 'doctor1';

INSERT IGNORE INTO doctors (user_id, specialization, qualification, experience, consultation_fee, bio, rating, patient_count)
SELECT id, 'Dermatology', 'MD, Dermatology', '8 years', '90.00', 'Specializes in skin conditions', 4.7, 45
FROM users WHERE username = 'doctor2';

INSERT IGNORE INTO doctors (user_id, specialization, qualification, experience, consultation_fee, bio, rating, patient_count)
SELECT id, 'Neurology', 'MD, Neurology', '12 years', '120.00', 'Specializes in neurological disorders', 4.8, 60
FROM users WHERE username = 'doctor3';

-- Insert sample patients if not exists
INSERT IGNORE INTO patients (user_id, blood_group, allergies)
SELECT id, 'A+', 'None'
FROM users WHERE username = 'patient1';

INSERT IGNORE INTO patients (user_id, blood_group, allergies)
SELECT id, 'B-', 'Penicillin'
FROM users WHERE username = 'patient2';

INSERT IGNORE INTO patients (user_id, blood_group, allergies)
SELECT id, 'O+', 'Peanuts'
FROM users WHERE username = 'patient3';

-- Insert doctor schedules if not exists
INSERT IGNORE INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, slot_duration)
SELECT d.id, 'Monday', '09:00:00', '17:00:00', 30
FROM doctors d
JOIN users u ON d.user_id = u.id
WHERE u.username = 'doctor1';

INSERT IGNORE INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, slot_duration)
SELECT d.id, 'Tuesday', '09:00:00', '17:00:00', 30
FROM doctors d
JOIN users u ON d.user_id = u.id
WHERE u.username = 'doctor1';

INSERT IGNORE INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, slot_duration)
SELECT d.id, 'Monday', '09:00:00', '17:00:00', 30
FROM doctors d
JOIN users u ON d.user_id = u.id
WHERE u.username = 'doctor2';

INSERT IGNORE INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, slot_duration)
SELECT d.id, 'Wednesday', '09:00:00', '17:00:00', 30
FROM doctors d
JOIN users u ON d.user_id = u.id
WHERE u.username = 'doctor2';

INSERT IGNORE INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, slot_duration)
SELECT d.id, 'Monday', '09:00:00', '17:00:00', 30
FROM doctors d
JOIN users u ON d.user_id = u.id
WHERE u.username = 'doctor3';

INSERT IGNORE INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, slot_duration)
SELECT d.id, 'Thursday', '09:00:00', '17:00:00', 30
FROM doctors d
JOIN users u ON d.user_id = u.id
WHERE u.username = 'doctor3';
