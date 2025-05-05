-- Test data for Doctor Appointment System
USE doctor_appointment;

-- Insert test users if they don't exist
INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
SELECT 'admin', 'admin@example.com', '$2a$10$hKDVYxLefVHV/vtuPhWD3OigtRyOykRLDdUAp80Z1crSoS1lFqaFS', 'Admin', 'User', '1234567890', 'ADMIN', 'Male', '123 Admin St'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');

INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
SELECT 'doctor1', 'doctor1@example.com', '$2a$10$hKDVYxLefVHV/vtuPhWD3OigtRyOykRLDdUAp80Z1crSoS1lFqaFS', 'John', 'Doe', '1234567890', 'DOCTOR', 'Male', '123 Doctor St'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'doctor1');

INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
SELECT 'patient1', 'patient1@example.com', '$2a$10$hKDVYxLefVHV/vtuPhWD3OigtRyOykRLDdUAp80Z1crSoS1lFqaFS', 'Jane', 'Smith', '9876543210', 'PATIENT', 'Female', '456 Patient St'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'patient1');

-- Insert test departments if they don't exist
INSERT INTO departments (name, description)
SELECT 'Cardiology', 'Department for heart-related issues'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE name = 'Cardiology');

INSERT INTO departments (name, description)
SELECT 'Neurology', 'Department for brain and nervous system'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE name = 'Neurology');

-- Insert test doctors if they don't exist
INSERT INTO doctors (user_id, name, specialization, qualification, experience, phone, email, consultation_fee, available_days, available_time, department_id)
SELECT 
    (SELECT id FROM users WHERE username = 'doctor1'),
    'Dr. John Doe',
    'Cardiologist',
    'MD, Cardiology',
    5,
    '1234567890',
    'doctor1@example.com',
    100.00,
    'Monday-Friday',
    '09:00 AM - 05:00 PM',
    (SELECT id FROM departments WHERE name = 'Cardiology')
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM doctors WHERE name = 'Dr. John Doe');

-- Insert test patients if they don't exist
INSERT INTO patients (user_id, blood_group)
SELECT 
    (SELECT id FROM users WHERE username = 'patient1'),
    'O+'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM patients WHERE user_id = (SELECT id FROM users WHERE username = 'patient1'));

-- Insert test appointments if they don't exist
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason, symptoms, notes, fee)
SELECT 
    (SELECT id FROM patients WHERE user_id = (SELECT id FROM users WHERE username = 'patient1')),
    (SELECT id FROM doctors WHERE name = 'Dr. John Doe'),
    CURDATE(),
    '10:00 AM',
    'PENDING',
    'Regular checkup',
    'None',
    'First appointment',
    100.00
FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM appointments 
    WHERE patient_id = (SELECT id FROM patients WHERE user_id = (SELECT id FROM users WHERE username = 'patient1'))
    AND doctor_id = (SELECT id FROM doctors WHERE name = 'Dr. John Doe')
    AND appointment_date = CURDATE()
    AND appointment_time = '10:00 AM'
);
