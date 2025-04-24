-- Optimized Database Schema for Doctor Appointment System

CREATE DATABASE IF NOT EXISTS doctor_appointment;
USE doctor_appointment;

-- Drop tables if they exist (in correct order to respect foreign key constraints)
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS doctor_schedules;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS announcements;
DROP TABLE IF EXISTS contact_messages;
DROP TABLE IF EXISTS users;


-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    role ENUM('ADMIN', 'DOCTOR', 'PATIENT') NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    address TEXT,
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
    specialization VARCHAR(100) NOT NULL,
    qualification VARCHAR(255) NOT NULL,
    experience INT DEFAULT 0,
    consultation_fee DECIMAL(10, 2) DEFAULT 0.00,
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
    blood_group VARCHAR(10),
    allergies TEXT,
    medical_history TEXT,
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
    slot_duration INT DEFAULT 30, -- Duration in minutes
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
    schedule_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    reason VARCHAR(255),
    symptoms TEXT,
    notes TEXT,
    diagnosis TEXT,
    treatment TEXT,
    fee DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES doctor_schedules(id) ON DELETE CASCADE
);

-- Create prescriptions table
CREATE TABLE prescriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
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
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
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

-- Create contact_messages table
CREATE TABLE contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, email, password, first_name, last_name, role)
VALUES ('admin', 'admin@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', 'Admin', 'User', 'ADMIN');

-- Insert sample departments
INSERT INTO departments (name, description) VALUES
('Cardiology', 'Department specializing in diagnosing and treating heart conditions'),
('Neurology', 'Department specializing in disorders of the nervous system'),
('Orthopedics', 'Department specializing in musculoskeletal system'),
('Pediatrics', 'Department specializing in medical care of infants, children, and adolescents'),
('Dermatology', 'Department specializing in skin related conditions');

-- Insert sample doctors (users first, then doctor profiles)
INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address) VALUES
('drsmith', 'john.smith@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', 'John', 'Smith', '1234567890', 'DOCTOR', 'Male', '123 Medical Center, New York'),
('drjohnson', 'sarah.johnson@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', 'Sarah', 'Johnson', '2345678901', 'DOCTOR', 'Female', '456 Health Avenue, Boston'),
('drbrown', 'michael.brown@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', 'Michael', 'Brown', '3456789012', 'DOCTOR', 'Male', '789 Hospital Road, Chicago');

INSERT INTO doctors (user_id, specialization, qualification, experience, consultation_fee, department_id, rating, patient_count, success_rate) VALUES
(2, 'Cardiology', 'MD, FACC', 15, 150.00, 1, 4.8, 1200, 95),
(3, 'Neurology', 'MD, PhD', 10, 180.00, 2, 4.7, 950, 92),
(4, 'Orthopedics', 'MD, FAAOS', 12, 160.00, 3, 4.5, 1050, 90);

-- Insert sample patients (users first, then patient profiles)
INSERT INTO users (username, email, password, first_name, last_name, phone, role, date_of_birth, gender, address) VALUES
('alice', 'alice.williams@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', 'Alice', 'Williams', '4567890123', 'PATIENT', '1985-06-15', 'Female', '321 Residential St, New York'),
('bob', 'bob.miller@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', 'Bob', 'Miller', '5678901234', 'PATIENT', '1978-09-22', 'Male', '654 Home Ave, Boston'),
('carol', 'carol.davis@example.com', '$2a$10$xLXQDZVWur5aDvzpjQAkH.MZnhUa.yWUcxIrksRMfLcIZ5HaZ7FPu', 'Carol', 'Davis', '6789012345', 'PATIENT', '1990-03-10', 'Female', '987 Living Rd, Chicago');

INSERT INTO patients (user_id, blood_group, allergies) VALUES
(5, 'A+', 'None'),
(6, 'O-', 'Penicillin'),
(7, 'B+', 'Pollen, Dust');

-- Insert sample doctor schedules
INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, break_start_time, break_end_time, slot_duration) VALUES
(1, 'Monday', '09:00:00', '17:00:00', '12:00:00', '13:00:00', 30),
(1, 'Wednesday', '09:00:00', '17:00:00', '12:00:00', '13:00:00', 30),
(1, 'Friday', '09:00:00', '17:00:00', '12:00:00', '13:00:00', 30),
(2, 'Tuesday', '10:00:00', '18:00:00', '13:00:00', '14:00:00', 45),
(2, 'Thursday', '10:00:00', '18:00:00', '13:00:00', '14:00:00', 45),
(3, 'Monday', '08:00:00', '16:00:00', '12:00:00', '13:00:00', 30),
(3, 'Tuesday', '08:00:00', '16:00:00', '12:00:00', '13:00:00', 30),
(3, 'Thursday', '08:00:00', '16:00:00', '12:00:00', '13:00:00', 30);

-- Insert sample appointments
INSERT INTO appointments (patient_id, doctor_id, schedule_id, appointment_date, appointment_time, status, reason, symptoms, fee) VALUES
(1, 1, 1, CURDATE() + INTERVAL 1 DAY, '10:00:00', 'CONFIRMED', 'Regular checkup', 'Chest pain, shortness of breath', 150.00),
(2, 2, 4, CURDATE() + INTERVAL 2 DAY, '11:30:00', 'PENDING', 'Headache consultation', 'Severe headaches, dizziness', 180.00),
(3, 3, 6, CURDATE() + INTERVAL 3 DAY, '09:15:00', 'CONFIRMED', 'Knee pain', 'Pain when walking, swelling', 160.00),
(1, 2, 5, CURDATE() - INTERVAL 5 DAY, '14:00:00', 'COMPLETED', 'Neurological exam', 'Numbness in hands', 180.00);

-- Insert sample prescriptions
INSERT INTO prescriptions (appointment_id, patient_id, doctor_id, prescription_date, medication_name, dosage, frequency, duration, instructions) VALUES
(4, 1, 2, CURDATE() - INTERVAL 5 DAY, 'Gabapentin', '300mg', 'Twice daily', '30 days', 'Take with food, may cause drowsiness'),
(4, 1, 2, CURDATE() - INTERVAL 5 DAY, 'Vitamin B12', '1000mcg', 'Once daily', '60 days', 'Take in the morning');

-- Insert sample announcements
INSERT INTO announcements (title, content, start_date, end_date, created_by, is_active) VALUES
('New Cardiology Department Hours', 'The Cardiology Department will now be open from 8:00 AM to 6:00 PM on weekdays.', CURDATE(), CURDATE() + INTERVAL 30 DAY, 1, TRUE),
('Flu Vaccination Drive', 'Annual flu vaccinations will be available starting next week. Please schedule your appointment.', CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 25 DAY, 1, TRUE),
('System Maintenance', 'The online appointment system will be down for maintenance on Sunday from 2:00 AM to 4:00 AM.', CURDATE() + INTERVAL 3 DAY, CURDATE() + INTERVAL 4 DAY, 1, TRUE);
