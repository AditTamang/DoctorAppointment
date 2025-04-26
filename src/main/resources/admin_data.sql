-- Admin user data for doctor_appointment database

-- Insert admin user directly (without ON DUPLICATE KEY UPDATE)
INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
VALUES ('admin', 'admin@example.com', 'YWRtaW4=', 'Admin', 'User', '1234567890', 'ADMIN', 'Male', 'Admin Address');

-- Insert another admin user with simple credentials
INSERT INTO users (username, email, password, first_name, last_name, phone, role, gender, address)
VALUES ('test', 'test@gmail.com', 'cGFzc3dvcmQ=', 'Test', 'User', '1234567899', 'ADMIN', 'Male', 'Test Address');
