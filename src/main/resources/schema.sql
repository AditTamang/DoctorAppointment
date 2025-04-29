-- Database Schema for Doctor Appointment System

-- Drop tables if they exist
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS medical_records;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS doctor_schedules;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS announcements;

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('ADMIN', 'DOCTOR', 'PATIENT') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create departments table
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create doctors table
CREATE TABLE doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
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
    bio TEXT,
    department_id INT,
    rating DECIMAL(3, 1) DEFAULT 0.0,
    patient_count INT DEFAULT 0,
    success_rate INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- Create patients table
CREATE TABLE patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    blood_group VARCHAR(10),
    allergies TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create doctor_schedules table
CREATE TABLE doctor_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    break_start_time TIME,
    break_end_time TIME,
    max_appointments INT DEFAULT 20,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- Create appointments table
CREATE TABLE appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR(20) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    reason VARCHAR(255),
    symptoms TEXT,
    notes TEXT,
    prescription TEXT,
    medical_report TEXT,
    fee DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- Create medical_records table
CREATE TABLE medical_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    record_date DATE NOT NULL,
    diagnosis TEXT NOT NULL,
    treatment TEXT,
    prescription TEXT,
    notes TEXT,
    attachments VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- Create prescriptions table
CREATE TABLE prescriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    medical_record_id INT,
    appointment_id INT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    prescription_date DATE NOT NULL,
    medication_name VARCHAR(255) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    duration VARCHAR(100) NOT NULL,
    instructions TEXT,
    status ENUM('ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (medical_record_id) REFERENCES medical_records(id) ON DELETE SET NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- Create announcements table
CREATE TABLE announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    start_date DATE,
    end_date DATE,
    created_by INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, email, password, role) 
VALUES ('Admin User', 'admin@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', 'ADMIN');

-- Insert sample departments
INSERT INTO departments (name, description) VALUES 
('Cardiology', 'Department specializing in diagnosing and treating heart conditions'),
('Neurology', 'Department specializing in disorders of the nervous system'),
('Orthopedics', 'Department specializing in musculoskeletal system'),
('Pediatrics', 'Department specializing in medical care of infants, children, and adolescents'),
('Dermatology', 'Department specializing in skin related conditions');

-- Insert sample doctors
INSERT INTO users (username, email, password, phone, role) VALUES 
('Dr. John Smith', 'john.smith@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', '1234567890', 'DOCTOR'),
('Dr. Sarah Johnson', 'sarah.johnson@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', '2345678901', 'DOCTOR'),
('Dr. Michael Brown', 'michael.brown@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', '3456789012', 'DOCTOR');

INSERT INTO doctors (user_id, first_name, last_name, specialization, qualification, experience, phone, email, address, consultation_fee, department_id, rating, patient_count, success_rate) VALUES 
(2, 'John', 'Smith', 'Cardiology', 'MD, FACC', 15, '1234567890', 'john.smith@example.com', '123 Medical Center, New York', 150.00, 1, 4.8, 1200, 95),
(3, 'Sarah', 'Johnson', 'Neurology', 'MD, PhD', 10, '2345678901', 'sarah.johnson@example.com', '456 Health Avenue, Boston', 180.00, 2, 4.7, 950, 92),
(4, 'Michael', 'Brown', 'Orthopedics', 'MD, FAAOS', 12, '3456789012', 'michael.brown@example.com', '789 Hospital Road, Chicago', 160.00, 3, 4.5, 1050, 90);

-- Insert sample patients
INSERT INTO users (username, email, password, phone, role) VALUES 
('Alice Williams', 'alice.williams@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', '4567890123', 'PATIENT'),
('Bob Miller', 'bob.miller@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', '5678901234', 'PATIENT'),
('Carol Davis', 'carol.davis@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', '6789012345', 'PATIENT');

INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, phone, email, address, blood_group) VALUES 
(5, 'Alice', 'Williams', '1985-06-15', 'Female', '4567890123', 'alice.williams@example.com', '321 Residential St, New York', 'A+'),
(6, 'Bob', 'Miller', '1978-09-22', 'Male', '5678901234', 'bob.miller@example.com', '654 Home Ave, Boston', 'O-'),
(7, 'Carol', 'Davis', '1990-03-10', 'Female', '6789012345', 'carol.davis@example.com', '987 Living Rd, Chicago', 'B+');

-- Insert sample doctor schedules
INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, break_start_time, break_end_time) VALUES 
(1, 'Monday', '09:00:00', '17:00:00', '12:00:00', '13:00:00'),
(1, 'Wednesday', '09:00:00', '17:00:00', '12:00:00', '13:00:00'),
(1, 'Friday', '09:00:00', '17:00:00', '12:00:00', '13:00:00'),
(2, 'Tuesday', '10:00:00', '18:00:00', '13:00:00', '14:00:00'),
(2, 'Thursday', '10:00:00', '18:00:00', '13:00:00', '14:00:00'),
(3, 'Monday', '08:00:00', '16:00:00', '12:00:00', '13:00:00'),
(3, 'Tuesday', '08:00:00', '16:00:00', '12:00:00', '13:00:00'),
(3, 'Thursday', '08:00:00', '16:00:00', '12:00:00', '13:00:00');

-- Insert sample appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason, symptoms, fee) VALUES 
(1, 1, CURDATE() + INTERVAL 1 DAY, '10:00 AM', 'CONFIRMED', 'Regular checkup', 'Chest pain, shortness of breath', 150.00),
(2, 2, CURDATE() + INTERVAL 2 DAY, '11:30 AM', 'PENDING', 'Headache consultation', 'Severe headaches, dizziness', 180.00),
(3, 3, CURDATE() + INTERVAL 3 DAY, '09:15 AM', 'CONFIRMED', 'Knee pain', 'Pain when walking, swelling', 160.00),
(1, 2, CURDATE() - INTERVAL 5 DAY, '02:00 PM', 'COMPLETED', 'Neurological exam', 'Numbness in hands', 180.00);

-- Insert sample medical records
INSERT INTO medical_records (patient_id, doctor_id, record_date, diagnosis, treatment, prescription, notes) VALUES 
(1, 1, CURDATE() - INTERVAL 30 DAY, 'Hypertension', 'Prescribed medication and lifestyle changes', 'Lisinopril 10mg daily', 'Patient advised to reduce salt intake and exercise regularly'),
(2, 2, CURDATE() - INTERVAL 45 DAY, 'Migraine', 'Prescribed medication', 'Sumatriptan 50mg as needed', 'Patient advised to keep a headache diary'),
(3, 3, CURDATE() - INTERVAL 60 DAY, 'Osteoarthritis', 'Physical therapy and medication', 'Ibuprofen 400mg as needed', 'Patient referred to physical therapy twice weekly');

-- Insert sample prescriptions
INSERT INTO prescriptions (medical_record_id, patient_id, doctor_id, prescription_date, medication_name, dosage, frequency, duration, instructions) VALUES 
(1, 1, 1, CURDATE() - INTERVAL 30 DAY, 'Lisinopril', '10mg', 'Once daily', '30 days', 'Take in the morning with food'),
(2, 2, 2, CURDATE() - INTERVAL 45 DAY, 'Sumatriptan', '50mg', 'As needed', '30 days', 'Take at onset of migraine, max 2 tablets per day'),
(3, 3, 3, CURDATE() - INTERVAL 60 DAY, 'Ibuprofen', '400mg', 'Three times daily', '14 days', 'Take with food to avoid stomach upset');

-- Insert sample announcements
INSERT INTO announcements (title, content, start_date, end_date, created_by, is_active) VALUES 
('New Cardiology Department Hours', 'The Cardiology Department will now be open from 8:00 AM to 6:00 PM on weekdays.', CURDATE(), CURDATE() + INTERVAL 30 DAY, 1, TRUE),
('Flu Vaccination Drive', 'Annual flu vaccinations will be available starting next week. Please schedule your appointment.', CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 25 DAY, 1, TRUE),
('System Maintenance', 'The online appointment system will be down for maintenance on Sunday from 2:00 AM to 4:00 AM.', CURDATE() + INTERVAL 3 DAY, CURDATE() + INTERVAL 4 DAY, 1, TRUE);
