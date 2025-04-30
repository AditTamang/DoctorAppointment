package com.doctorapp.dao;

 import java.sql.Connection;
 import java.sql.PreparedStatement;
 import java.sql.ResultSet;
 import java.sql.SQLException;
 import java.util.ArrayList;
 import java.util.List;

 import com.doctorapp.model.Doctor;
 import com.doctorapp.util.DBConnection;
 import com.doctorapp.util.PasswordHasher;

 public class DoctorDAO {

     // Add a new doctor
     public boolean addDoctor(Doctor doctor) {
         Connection conn = null;
         boolean success = false;

         try {
             conn = DBConnection.getConnection();
             conn.setAutoCommit(false); // Start transaction

             // First, check if email already exists in users table
             String checkEmailQuery = "SELECT COUNT(*) FROM users WHERE email = ?";
             try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailQuery)) {
                 checkStmt.setString(1, doctor.getEmail());
                 ResultSet rs = checkStmt.executeQuery();
                 if (rs.next() && rs.getInt(1) > 0) {
                     // Email already exists
                     return false;
                 }
             }

             // Create user record first
             String userQuery = "INSERT INTO users (username, email, password, phone, role, first_name, last_name, address) " +
                               "VALUES (?, ?, ?, ?, 'DOCTOR', ?, ?, ?)";

             int userId;
             try (PreparedStatement userStmt = conn.prepareStatement(userQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {
                 // Generate username from name (first part of email)
                 String username = doctor.getEmail().split("@")[0];
                 // Generate a random password
                 String password = PasswordHasher.hashPassword("doctor123"); // Default password

                 String[] nameParts = doctor.getName().split(" ", 2);
                 String firstName = nameParts[0];
                 String lastName = nameParts.length > 1 ? nameParts[1] : "";

                 userStmt.setString(1, username);
                 userStmt.setString(2, doctor.getEmail());
                 userStmt.setString(3, password);
                 userStmt.setString(4, doctor.getPhone());
                 userStmt.setString(5, firstName);
                 userStmt.setString(6, lastName);
                 userStmt.setString(7, doctor.getAddress());

                 userStmt.executeUpdate();

                 // Get the generated user ID
                 ResultSet generatedKeys = userStmt.getGeneratedKeys();
                 if (generatedKeys.next()) {
                     userId = generatedKeys.getInt(1);
                 } else {
                     throw new SQLException("Creating user failed, no ID obtained.");
                 }
             }

             // Now create the doctor record
             String doctorQuery = "INSERT INTO doctors (user_id, department_id, name, specialization, qualification, experience, email, phone, address, " +
                                "consultation_fee, available_days, available_time, image_url, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

             try (PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery)) {
                 doctorStmt.setInt(1, userId);
                 doctorStmt.setInt(2, doctor.getDepartmentId() > 0 ? doctor.getDepartmentId() : 1); // Default to first department if not specified
                 doctorStmt.setString(3, doctor.getName());
                 doctorStmt.setString(4, doctor.getSpecialization());
                 doctorStmt.setString(5, doctor.getQualification());
                 doctorStmt.setString(6, doctor.getExperience());
                 doctorStmt.setString(7, doctor.getEmail());
                 doctorStmt.setString(8, doctor.getPhone());
                 doctorStmt.setString(9, doctor.getAddress());
                 doctorStmt.setString(10, doctor.getConsultationFee());
                 doctorStmt.setString(11, doctor.getAvailableDays());
                 doctorStmt.setString(12, doctor.getAvailableTime());
                 doctorStmt.setString(13, doctor.getImageUrl());
                 doctorStmt.setString(14, doctor.getStatus() != null ? doctor.getStatus() : "ACTIVE");

                 doctorStmt.executeUpdate();
             }

             // Commit the transaction
             conn.commit();
             success = true;

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
             // Rollback the transaction on error
             if (conn != null) {
                 try {
                     conn.rollback();
                 } catch (SQLException rollbackEx) {
                     rollbackEx.printStackTrace();
                 }
             }
         } finally {
             // Restore auto-commit
             if (conn != null) {
                 try {
                     conn.setAutoCommit(true);
                     conn.close();
                 } catch (SQLException closeEx) {
                     closeEx.printStackTrace();
                 }
             }
         }

         return success;
     }

     // Get doctor by ID
     public Doctor getDoctorById(int id) {
         // Join with users table to get more information about the doctor
         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE d.id = ? AND u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, id);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     Doctor doctor = new Doctor();
                     doctor.setId(rs.getInt("id"));
                     doctor.setUserId(rs.getInt("user_id"));
                     doctor.setDepartmentId(rs.getInt("department_id"));

                     // Use name from doctors table, or construct from first_name and last_name if null
                     String name = rs.getString("name");
                     if (name == null || name.isEmpty()) {
                         String firstName = rs.getString("first_name");
                         String lastName = rs.getString("last_name");
                         name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                         name = name.trim();
                     }
                     doctor.setName(name);

                     doctor.setSpecialization(rs.getString("specialization"));
                     doctor.setQualification(rs.getString("qualification"));
                     doctor.setExperience(rs.getString("experience"));
                     doctor.setStatus(rs.getString("status"));

                     // Get email from doctors table or users table
                     String email = rs.getString("email");
                     if (email == null || email.isEmpty()) {
                         email = rs.getString("user_email");
                     }
                     doctor.setEmail(email);

                     // Get phone from doctors table or users table
                     String phone = rs.getString("phone");
                     if (phone == null || phone.isEmpty()) {
                         phone = rs.getString("user_phone");
                     }
                     doctor.setPhone(phone);

                     // Get address from doctors table or users table
                     String address = rs.getString("address");
                     if (address == null || address.isEmpty()) {
                         address = rs.getString("user_address");
                     }
                     doctor.setAddress(address);

                     // Get consultation fee, set default if null
                     String consultationFee = rs.getString("consultation_fee");
                     if (consultationFee == null || consultationFee.isEmpty()) {
                         consultationFee = "1000";
                     }
                     doctor.setConsultationFee(consultationFee);

                     // Get available days, set default if null
                     String availableDays = rs.getString("available_days");
                     if (availableDays == null || availableDays.isEmpty()) {
                         availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                     }
                     doctor.setAvailableDays(availableDays);

                     // Get available time, set default if null
                     String availableTime = rs.getString("available_time");
                     if (availableTime == null || availableTime.isEmpty()) {
                         availableTime = "09:00 AM - 05:00 PM";
                     }
                     doctor.setAvailableTime(availableTime);

                     // Get image URL, set default if null
                     String imageUrl = rs.getString("image_url");
                     if (imageUrl == null || imageUrl.isEmpty()) {
                         imageUrl = "/assets/images/doctors/default-doctor.png";
                     }
                     doctor.setImageUrl(imageUrl);

                     return doctor;
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return null;
     }

     // Get doctor by user ID
     public Doctor getDoctorByUserId(int userId) {
         // Join with users table to get more information about the doctor
         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE d.user_id = ? AND u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, userId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     Doctor doctor = new Doctor();
                     doctor.setId(rs.getInt("id"));
                     doctor.setUserId(rs.getInt("user_id"));
                     doctor.setDepartmentId(rs.getInt("department_id"));

                     // Use name from doctors table, or construct from first_name and last_name if null
                     String name = rs.getString("name");
                     if (name == null || name.isEmpty()) {
                         String firstName = rs.getString("first_name");
                         String lastName = rs.getString("last_name");
                         name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                         name = name.trim();
                     }
                     doctor.setName(name);

                     doctor.setSpecialization(rs.getString("specialization"));
                     doctor.setQualification(rs.getString("qualification"));
                     doctor.setExperience(rs.getString("experience"));
                     doctor.setStatus(rs.getString("status"));

                     // Get email from doctors table or users table
                     String email = rs.getString("email");
                     if (email == null || email.isEmpty()) {
                         email = rs.getString("user_email");
                     }
                     doctor.setEmail(email);

                     // Get phone from doctors table or users table
                     String phone = rs.getString("phone");
                     if (phone == null || phone.isEmpty()) {
                         phone = rs.getString("user_phone");
                     }
                     doctor.setPhone(phone);

                     // Get address from doctors table or users table
                     String address = rs.getString("address");
                     if (address == null || address.isEmpty()) {
                         address = rs.getString("user_address");
                     }
                     doctor.setAddress(address);

                     // Get consultation fee, set default if null
                     String consultationFee = rs.getString("consultation_fee");
                     if (consultationFee == null || consultationFee.isEmpty()) {
                         consultationFee = "1000";
                     }
                     doctor.setConsultationFee(consultationFee);

                     // Get available days, set default if null
                     String availableDays = rs.getString("available_days");
                     if (availableDays == null || availableDays.isEmpty()) {
                         availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                     }
                     doctor.setAvailableDays(availableDays);

                     // Get available time, set default if null
                     String availableTime = rs.getString("available_time");
                     if (availableTime == null || availableTime.isEmpty()) {
                         availableTime = "09:00 AM - 05:00 PM";
                     }
                     doctor.setAvailableTime(availableTime);

                     // Get image URL, set default if null
                     String imageUrl = rs.getString("image_url");
                     if (imageUrl == null || imageUrl.isEmpty()) {
                         imageUrl = "/assets/images/doctors/default-doctor.png";
                     }
                     doctor.setImageUrl(imageUrl);

                     return doctor;
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return null;
     }

     // Get all doctors (for admin use)
     public List<Doctor> getAllDoctors() {
         List<Doctor> doctors = new ArrayList<>();

         // Simplified query to get all doctors with their information
         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query);
              ResultSet rs = pstmt.executeQuery()) {

             while (rs.next()) {
                 Doctor doctor = new Doctor();
                 doctor.setId(rs.getInt("id"));
                 doctor.setUserId(rs.getInt("user_id"));
                 doctor.setDepartmentId(rs.getInt("department_id"));

                 // Use name from doctors table, or construct from first_name and last_name if null
                 String name = rs.getString("name");
                 if (name == null || name.isEmpty()) {
                     String firstName = rs.getString("first_name");
                     String lastName = rs.getString("last_name");
                     name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                     name = name.trim();
                 }
                 doctor.setName(name);

                 doctor.setSpecialization(rs.getString("specialization"));
                 doctor.setQualification(rs.getString("qualification"));
                 doctor.setExperience(rs.getString("experience"));
                 doctor.setStatus(rs.getString("status"));

                 // Get email from doctors table or users table
                 String email = rs.getString("email");
                 if (email == null || email.isEmpty()) {
                     email = rs.getString("user_email");
                 }
                 doctor.setEmail(email);

                 // Get phone from doctors table or users table
                 String phone = rs.getString("phone");
                 if (phone == null || phone.isEmpty()) {
                     phone = rs.getString("user_phone");
                 }
                 doctor.setPhone(phone);

                 // Get address from doctors table or users table
                 String address = rs.getString("address");
                 if (address == null || address.isEmpty()) {
                     address = rs.getString("user_address");
                 }
                 doctor.setAddress(address);

                 // Get consultation fee, set default if null
                 String consultationFee = rs.getString("consultation_fee");
                 if (consultationFee == null || consultationFee.isEmpty()) {
                     consultationFee = "1000";
                 }
                 doctor.setConsultationFee(consultationFee);

                 // Get available days, set default if null
                 String availableDays = rs.getString("available_days");
                 if (availableDays == null || availableDays.isEmpty()) {
                     availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                 }
                 doctor.setAvailableDays(availableDays);

                 // Get available time, set default if null
                 String availableTime = rs.getString("available_time");
                 if (availableTime == null || availableTime.isEmpty()) {
                     availableTime = "09:00 AM - 05:00 PM";
                 }
                 doctor.setAvailableTime(availableTime);

                 // Get image URL, set default if null
                 String imageUrl = rs.getString("image_url");
                 if (imageUrl == null || imageUrl.isEmpty()) {
                     imageUrl = "/assets/images/doctors/default-doctor.png";
                 }
                 doctor.setImageUrl(imageUrl);

                 // Only add doctors with valid information
                 if (name != null && !name.isEmpty() &&
                     doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                     doctors.add(doctor);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return doctors;
     }

     // Search doctors by name or email
     public List<Doctor> searchDoctors(String searchTerm) {
         List<Doctor> doctors = new ArrayList<>();

         // Join with users table to get more information about the doctor
         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE (d.name LIKE ? OR d.email LIKE ? OR u.first_name LIKE ? OR u.last_name LIKE ?) " +
                       "AND u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             String searchPattern = "%" + searchTerm + "%";
             pstmt.setString(1, searchPattern);
             pstmt.setString(2, searchPattern);
             pstmt.setString(3, searchPattern);
             pstmt.setString(4, searchPattern);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Doctor doctor = new Doctor();
                     doctor.setId(rs.getInt("id"));
                     doctor.setUserId(rs.getInt("user_id"));
                     doctor.setDepartmentId(rs.getInt("department_id"));

                     // Use name from doctors table, or construct from first_name and last_name if null
                     String name = rs.getString("name");
                     if (name == null || name.isEmpty()) {
                         String firstName = rs.getString("first_name");
                         String lastName = rs.getString("last_name");
                         name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                         name = name.trim();
                     }
                     doctor.setName(name);

                     doctor.setSpecialization(rs.getString("specialization"));
                     doctor.setQualification(rs.getString("qualification"));
                     doctor.setExperience(rs.getString("experience"));
                     doctor.setStatus(rs.getString("status"));

                     // Get email from doctors table or users table
                     String email = rs.getString("email");
                     if (email == null || email.isEmpty()) {
                         email = rs.getString("user_email");
                     }
                     doctor.setEmail(email);

                     // Get phone from doctors table or users table
                     String phone = rs.getString("phone");
                     if (phone == null || phone.isEmpty()) {
                         phone = rs.getString("user_phone");
                     }
                     doctor.setPhone(phone);

                     // Get address from doctors table or users table
                     String address = rs.getString("address");
                     if (address == null || address.isEmpty()) {
                         address = rs.getString("user_address");
                     }
                     doctor.setAddress(address);

                     // Get consultation fee, set default if null
                     String consultationFee = rs.getString("consultation_fee");
                     if (consultationFee == null || consultationFee.isEmpty()) {
                         consultationFee = "1000";
                     }
                     doctor.setConsultationFee(consultationFee);

                     // Get available days, set default if null
                     String availableDays = rs.getString("available_days");
                     if (availableDays == null || availableDays.isEmpty()) {
                         availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                     }
                     doctor.setAvailableDays(availableDays);

                     // Get available time, set default if null
                     String availableTime = rs.getString("available_time");
                     if (availableTime == null || availableTime.isEmpty()) {
                         availableTime = "09:00 AM - 05:00 PM";
                     }
                     doctor.setAvailableTime(availableTime);

                     // Get image URL, set default if null
                     String imageUrl = rs.getString("image_url");
                     if (imageUrl == null || imageUrl.isEmpty()) {
                         imageUrl = "/assets/images/doctors/default-doctor.png";
                     }
                     doctor.setImageUrl(imageUrl);

                     // Only add doctors with valid information
                     if (name != null && !name.isEmpty() &&
                         doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                         doctors.add(doctor);
                     }
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return doctors;
     }

     // Get doctors by specialization
     public List<Doctor> getDoctorsBySpecialization(String specialization) {
         List<Doctor> doctors = new ArrayList<>();

         // Join with users table to get more information about the doctor
         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE d.specialization = ? AND u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setString(1, specialization);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Doctor doctor = new Doctor();
                     doctor.setId(rs.getInt("id"));

                     // Use name from doctors table, or construct from first_name and last_name if null
                     String name = rs.getString("name");
                     if (name == null || name.isEmpty()) {
                         String firstName = rs.getString("first_name");
                         String lastName = rs.getString("last_name");
                         name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                         name = name.trim();
                     }
                     doctor.setName(name);

                     doctor.setSpecialization(rs.getString("specialization"));
                     doctor.setQualification(rs.getString("qualification"));
                     doctor.setExperience(rs.getString("experience"));

                     // Get email from doctors table or users table
                     String email = rs.getString("email");
                     if (email == null || email.isEmpty()) {
                         email = rs.getString("user_email");
                     }
                     doctor.setEmail(email);

                     // Get phone from doctors table or users table
                     String phone = rs.getString("phone");
                     if (phone == null || phone.isEmpty()) {
                         phone = rs.getString("user_phone");
                     }
                     doctor.setPhone(phone);

                     // Get address from doctors table or users table
                     String address = rs.getString("address");
                     if (address == null || address.isEmpty()) {
                         address = rs.getString("user_address");
                     }
                     doctor.setAddress(address);

                     // Get consultation fee, set default if null
                     String consultationFee = rs.getString("consultation_fee");
                     if (consultationFee == null || consultationFee.isEmpty()) {
                         consultationFee = "1000";
                     }
                     doctor.setConsultationFee(consultationFee);

                     // Get available days, set default if null
                     String availableDays = rs.getString("available_days");
                     if (availableDays == null || availableDays.isEmpty()) {
                         availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                     }
                     doctor.setAvailableDays(availableDays);

                     // Get available time, set default if null
                     String availableTime = rs.getString("available_time");
                     if (availableTime == null || availableTime.isEmpty()) {
                         availableTime = "09:00 AM - 05:00 PM";
                     }
                     doctor.setAvailableTime(availableTime);

                     // Get image URL, set default if null
                     String imageUrl = rs.getString("image_url");
                     if (imageUrl == null || imageUrl.isEmpty()) {
                         imageUrl = "/assets/images/doctors/default-doctor.png";
                     }
                     doctor.setImageUrl(imageUrl);

                     // Only add doctors with valid information
                     if (name != null && !name.isEmpty() &&
                         doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                         doctors.add(doctor);
                     }
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return doctors;
     }

     // Update doctor
     public boolean updateDoctor(Doctor doctor) {
         String query = "UPDATE doctors SET name = ?, department_id = ?, specialization = ?, qualification = ?, experience = ?, " +
                       "email = ?, phone = ?, address = ?, consultation_fee = ?, available_days = ?, " +
                       "available_time = ?, image_url = ?, status = ? WHERE id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setString(1, doctor.getName());
             pstmt.setInt(2, doctor.getDepartmentId() > 0 ? doctor.getDepartmentId() : 1); // Default to first department if not specified
             pstmt.setString(3, doctor.getSpecialization());
             pstmt.setString(4, doctor.getQualification());
             pstmt.setString(5, doctor.getExperience());
             pstmt.setString(6, doctor.getEmail());
             pstmt.setString(7, doctor.getPhone());
             pstmt.setString(8, doctor.getAddress());
             pstmt.setString(9, doctor.getConsultationFee());
             pstmt.setString(10, doctor.getAvailableDays());
             pstmt.setString(11, doctor.getAvailableTime());
             pstmt.setString(12, doctor.getImageUrl());
             pstmt.setString(13, doctor.getStatus() != null ? doctor.getStatus() : "ACTIVE");
             pstmt.setInt(14, doctor.getId());

             int rowsAffected = pstmt.executeUpdate();
             return rowsAffected > 0;

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
             return false;
         }
     }

     // Delete doctor
     public boolean deleteDoctor(int id) {
         String query = "DELETE FROM doctors WHERE id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, id);

             int rowsAffected = pstmt.executeUpdate();
             return rowsAffected > 0;

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
             return false;
         }
     }

     // Get total number of doctors
     public int getTotalDoctors() {
         String query = "SELECT COUNT(*) FROM doctors";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query);
              ResultSet rs = pstmt.executeQuery()) {

             if (rs.next()) {
                 return rs.getInt(1);
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return 0;
     }

     // Get recent doctors
     public List<Doctor> getRecentDoctors(int limit) {
         List<Doctor> doctors = new ArrayList<>();

         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE u.role = 'DOCTOR' " +
                       "ORDER BY d.id DESC " +
                       "LIMIT ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, limit);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Doctor doctor = new Doctor();
                     doctor.setId(rs.getInt("id"));

                     // Use name from doctors table, or construct from first_name and last_name if null
                     String name = rs.getString("name");
                     if (name == null || name.isEmpty()) {
                         String firstName = rs.getString("first_name");
                         String lastName = rs.getString("last_name");
                         name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                         name = name.trim();
                     }
                     doctor.setName(name);

                     doctor.setSpecialization(rs.getString("specialization"));
                     doctor.setQualification(rs.getString("qualification"));
                     doctor.setExperience(rs.getString("experience"));

                     // Get email from doctors table or users table
                     String email = rs.getString("email");
                     if (email == null || email.isEmpty()) {
                         email = rs.getString("user_email");
                     }
                     doctor.setEmail(email);

                     // Get phone from doctors table or users table
                     String phone = rs.getString("phone");
                     if (phone == null || phone.isEmpty()) {
                         phone = rs.getString("user_phone");
                     }
                     doctor.setPhone(phone);

                     // Get address from doctors table or users table
                     String address = rs.getString("address");
                     if (address == null || address.isEmpty()) {
                         address = rs.getString("user_address");
                     }
                     doctor.setAddress(address);

                     // Get consultation fee, set default if null
                     String consultationFee = rs.getString("consultation_fee");
                     if (consultationFee == null || consultationFee.isEmpty()) {
                         consultationFee = "1000";
                     }
                     doctor.setConsultationFee(consultationFee);

                     // Get available days, set default if null
                     String availableDays = rs.getString("available_days");
                     if (availableDays == null || availableDays.isEmpty()) {
                         availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                     }
                     doctor.setAvailableDays(availableDays);

                     // Get available time, set default if null
                     String availableTime = rs.getString("available_time");
                     if (availableTime == null || availableTime.isEmpty()) {
                         availableTime = "09:00 AM - 05:00 PM";
                     }
                     doctor.setAvailableTime(availableTime);

                     // Get image URL, set default if null
                     String imageUrl = rs.getString("image_url");
                     if (imageUrl == null || imageUrl.isEmpty()) {
                         imageUrl = "/assets/images/doctors/default-doctor.png";
                     }
                     doctor.setImageUrl(imageUrl);

                     // Only add doctors with valid information
                     if (name != null && !name.isEmpty() &&
                         doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                         doctors.add(doctor);
                     }
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return doctors;
     }

     // Get doctor ID by user ID
     public int getDoctorIdByUserId(int userId) {
         String query = "SELECT id FROM doctors WHERE user_id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, userId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     return rs.getInt("id");
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return 0;
     }

     // Get total patients by doctor
     public int getTotalPatientsByDoctor(int doctorId) {
         String query = "SELECT COUNT(DISTINCT patient_id) FROM appointments WHERE doctor_id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     return rs.getInt(1);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return 0;
     }

     // Get pending reports by doctor
     public int getPendingReportsByDoctor(int doctorId) {
         String query = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND status = 'COMPLETED' AND medical_report IS NULL";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     return rs.getInt(1);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return 0;
     }

     // Get average rating by doctor
     public double getAverageRatingByDoctor(int doctorId) {
         String query = "SELECT rating FROM doctors WHERE id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     return rs.getDouble(1);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return 0.0;
     }

     // Get only approved doctors (for public display)
     public List<Doctor> getApprovedDoctors() {
         List<Doctor> doctors = new ArrayList<>();

         // Query to get only doctors that have been approved by admin
         // These are doctors that exist in the doctors table after being moved from doctor_registration_requests
         // Since all doctors in the doctors table are approved, we just need to make sure they have the DOCTOR role
         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query);
              ResultSet rs = pstmt.executeQuery()) {

             while (rs.next()) {
                 Doctor doctor = new Doctor();
                 doctor.setId(rs.getInt("id"));

                 // Use name from doctors table, or construct from first_name and last_name if null
                 String name = rs.getString("name");
                 if (name == null || name.isEmpty()) {
                     String firstName = rs.getString("first_name");
                     String lastName = rs.getString("last_name");
                     name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                     name = name.trim();
                 }
                 doctor.setName(name);

                 doctor.setSpecialization(rs.getString("specialization"));
                 doctor.setQualification(rs.getString("qualification"));
                 doctor.setExperience(rs.getString("experience"));

                 // Get email from doctors table or users table
                 String email = rs.getString("email");
                 if (email == null || email.isEmpty()) {
                     email = rs.getString("user_email");
                 }
                 doctor.setEmail(email);

                 // Get phone from doctors table or users table
                 String phone = rs.getString("phone");
                 if (phone == null || phone.isEmpty()) {
                     phone = rs.getString("user_phone");
                 }
                 doctor.setPhone(phone);

                 // Get address from doctors table or users table
                 String address = rs.getString("address");
                 if (address == null || address.isEmpty()) {
                     address = rs.getString("user_address");
                 }
                 doctor.setAddress(address);

                 // Get consultation fee, set default if null
                 String consultationFee = rs.getString("consultation_fee");
                 if (consultationFee == null || consultationFee.isEmpty()) {
                     consultationFee = "1000";
                 }
                 doctor.setConsultationFee(consultationFee);

                 // Get available days, set default if null
                 String availableDays = rs.getString("available_days");
                 if (availableDays == null || availableDays.isEmpty()) {
                     availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                 }
                 doctor.setAvailableDays(availableDays);

                 // Get available time, set default if null
                 String availableTime = rs.getString("available_time");
                 if (availableTime == null || availableTime.isEmpty()) {
                     availableTime = "09:00 AM - 05:00 PM";
                 }
                 doctor.setAvailableTime(availableTime);

                 // Get image URL, set default if null
                 String imageUrl = rs.getString("image_url");
                 if (imageUrl == null || imageUrl.isEmpty()) {
                     imageUrl = "/assets/images/doctors/default-doctor.png";
                 }
                 doctor.setImageUrl(imageUrl);

                 // Set profile image if available
                 String profileImage = rs.getString("profile_image");
                 if (profileImage != null && !profileImage.isEmpty()) {
                     doctor.setProfileImage(profileImage);
                 } else {
                     doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
                 }

                 // Set bio if available
                 String bio = rs.getString("bio");
                 if (bio != null) {
                     doctor.setBio(bio);
                 }

                 // Set rating and patient count
                 doctor.setRating(rs.getDouble("rating"));
                 doctor.setPatientCount(rs.getInt("patient_count"));
                 doctor.setSuccessRate(90); // Default value

                 // Only add doctors with valid information
                 if (name != null && !name.isEmpty() &&
                     doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                     doctors.add(doctor);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.out.println("Error getting approved doctors: " + e.getMessage());
             e.printStackTrace();
         }

         return doctors;
     }

     // Get approved doctors by specialization (for public display)
     public List<Doctor> getApprovedDoctorsBySpecialization(String specialization) {
         List<Doctor> doctors = new ArrayList<>();

         // Query to get only doctors that have been approved by admin with the specified specialization
         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE d.specialization = ? AND u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setString(1, specialization);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Doctor doctor = new Doctor();
                     doctor.setId(rs.getInt("id"));

                     // Use name from doctors table, or construct from first_name and last_name if null
                     String name = rs.getString("name");
                     if (name == null || name.isEmpty()) {
                         String firstName = rs.getString("first_name");
                         String lastName = rs.getString("last_name");
                         name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                         name = name.trim();
                     }
                     doctor.setName(name);

                     doctor.setSpecialization(rs.getString("specialization"));
                     doctor.setQualification(rs.getString("qualification"));
                     doctor.setExperience(rs.getString("experience"));

                     // Get email from doctors table or users table
                     String email = rs.getString("email");
                     if (email == null || email.isEmpty()) {
                         email = rs.getString("user_email");
                     }
                     doctor.setEmail(email);

                     // Get phone from doctors table or users table
                     String phone = rs.getString("phone");
                     if (phone == null || phone.isEmpty()) {
                         phone = rs.getString("user_phone");
                     }
                     doctor.setPhone(phone);

                     // Get address from doctors table or users table
                     String address = rs.getString("address");
                     if (address == null || address.isEmpty()) {
                         address = rs.getString("user_address");
                     }
                     doctor.setAddress(address);

                     // Get consultation fee, set default if null
                     String consultationFee = rs.getString("consultation_fee");
                     if (consultationFee == null || consultationFee.isEmpty()) {
                         consultationFee = "1000";
                     }
                     doctor.setConsultationFee(consultationFee);

                     // Get available days, set default if null
                     String availableDays = rs.getString("available_days");
                     if (availableDays == null || availableDays.isEmpty()) {
                         availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                     }
                     doctor.setAvailableDays(availableDays);

                     // Get available time, set default if null
                     String availableTime = rs.getString("available_time");
                     if (availableTime == null || availableTime.isEmpty()) {
                         availableTime = "09:00 AM - 05:00 PM";
                     }
                     doctor.setAvailableTime(availableTime);

                     // Get image URL, set default if null
                     String imageUrl = rs.getString("image_url");
                     if (imageUrl == null || imageUrl.isEmpty()) {
                         imageUrl = "/assets/images/doctors/default-doctor.png";
                     }
                     doctor.setImageUrl(imageUrl);

                     // Set profile image if available
                     String profileImage = rs.getString("profile_image");
                     if (profileImage != null && !profileImage.isEmpty()) {
                         doctor.setProfileImage(profileImage);
                     } else {
                         doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
                     }

                     // Set bio if available
                     String bio = rs.getString("bio");
                     if (bio != null) {
                         doctor.setBio(bio);
                     }

                     // Set rating and patient count
                     doctor.setRating(rs.getDouble("rating"));
                     doctor.setPatientCount(rs.getInt("patient_count"));
                     doctor.setSuccessRate(90); // Default value

                     // Only add doctors with valid information
                     if (name != null && !name.isEmpty() &&
                         doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                         doctors.add(doctor);
                     }
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.out.println("Error getting approved doctors by specialization: " + e.getMessage());
             e.printStackTrace();
         }

         return doctors;
     }

     // Get approved doctors by search term (for public display)
     public List<Doctor> searchApprovedDoctors(String searchTerm) {
         List<Doctor> doctors = new ArrayList<>();

         // Query to get only doctors that have been approved by admin matching the search term
         String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "WHERE (d.specialization LIKE ? OR u.first_name LIKE ? OR u.last_name LIKE ?) " +
                       "AND u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             String searchPattern = "%" + searchTerm + "%";
             pstmt.setString(1, searchPattern);
             pstmt.setString(2, searchPattern);
             pstmt.setString(3, searchPattern);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Doctor doctor = new Doctor();
                     doctor.setId(rs.getInt("id"));

                     // Use name from doctors table, or construct from first_name and last_name if null
                     String name = rs.getString("name");
                     if (name == null || name.isEmpty()) {
                         String firstName = rs.getString("first_name");
                         String lastName = rs.getString("last_name");
                         name = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                         name = name.trim();
                     }
                     doctor.setName(name);

                     doctor.setSpecialization(rs.getString("specialization"));
                     doctor.setQualification(rs.getString("qualification"));
                     doctor.setExperience(rs.getString("experience"));

                     // Get email from doctors table or users table
                     String email = rs.getString("email");
                     if (email == null || email.isEmpty()) {
                         email = rs.getString("user_email");
                     }
                     doctor.setEmail(email);

                     // Get phone from doctors table or users table
                     String phone = rs.getString("phone");
                     if (phone == null || phone.isEmpty()) {
                         phone = rs.getString("user_phone");
                     }
                     doctor.setPhone(phone);

                     // Get address from doctors table or users table
                     String address = rs.getString("address");
                     if (address == null || address.isEmpty()) {
                         address = rs.getString("user_address");
                     }
                     doctor.setAddress(address);

                     // Get consultation fee, set default if null
                     String consultationFee = rs.getString("consultation_fee");
                     if (consultationFee == null || consultationFee.isEmpty()) {
                         consultationFee = "1000";
                     }
                     doctor.setConsultationFee(consultationFee);

                     // Get available days, set default if null
                     String availableDays = rs.getString("available_days");
                     if (availableDays == null || availableDays.isEmpty()) {
                         availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday";
                     }
                     doctor.setAvailableDays(availableDays);

                     // Get available time, set default if null
                     String availableTime = rs.getString("available_time");
                     if (availableTime == null || availableTime.isEmpty()) {
                         availableTime = "09:00 AM - 05:00 PM";
                     }
                     doctor.setAvailableTime(availableTime);

                     // Get image URL, set default if null
                     String imageUrl = rs.getString("image_url");
                     if (imageUrl == null || imageUrl.isEmpty()) {
                         imageUrl = "/assets/images/doctors/default-doctor.png";
                     }
                     doctor.setImageUrl(imageUrl);

                     // Set profile image if available
                     String profileImage = rs.getString("profile_image");
                     if (profileImage != null && !profileImage.isEmpty()) {
                         doctor.setProfileImage(profileImage);
                     } else {
                         doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
                     }

                     // Set bio if available
                     String bio = rs.getString("bio");
                     if (bio != null) {
                         doctor.setBio(bio);
                     }

                     // Set rating and patient count
                     doctor.setRating(rs.getDouble("rating"));
                     doctor.setPatientCount(rs.getInt("patient_count"));
                     doctor.setSuccessRate(90); // Default value

                     // Only add doctors with valid information
                     if (name != null && !name.isEmpty() &&
                         doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                         doctors.add(doctor);
                     }
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.out.println("Error searching approved doctors: " + e.getMessage());
             e.printStackTrace();
         }

         return doctors;
     }

     // Get top doctors
     public List<Doctor> getTopDoctors(int limit) {
         List<Doctor> doctors = new ArrayList<>();

         // Modified query to handle the case where doctor_ratings table might not exist yet
         // or when there are no ratings
         String query = "SELECT d.id, u.first_name, u.last_name, d.specialization, d.qualification, " +
                       "d.experience, u.email, u.phone, u.address, d.consultation_fee, " +
                       "d.profile_image, d.rating, d.patient_count " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "ORDER BY d.rating DESC, d.patient_count DESC " +
                       "LIMIT ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, limit);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Doctor doctor = new Doctor();
                     doctor.setId(rs.getInt("id"));

                     // Combine first and last name from users table
                     String firstName = rs.getString("first_name");
                     String lastName = rs.getString("last_name");
                     String fullName = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                     fullName = fullName.trim();
                     doctor.setName(fullName);

                     doctor.setSpecialization(rs.getString("specialization"));
                     doctor.setQualification(rs.getString("qualification"));
                     doctor.setExperience(rs.getString("experience"));
                     doctor.setEmail(rs.getString("email"));
                     doctor.setPhone(rs.getString("phone"));
                     doctor.setAddress(rs.getString("address"));

                     // Get consultation fee, set default if null
                     String consultationFee = rs.getString("consultation_fee");
                     if (consultationFee == null || consultationFee.isEmpty()) {
                         consultationFee = "1000";
                     }
                     doctor.setConsultationFee(consultationFee);

                     // Set default values for fields that might not exist in the database
                     doctor.setAvailableDays("Monday,Tuesday,Wednesday,Thursday,Friday");
                     doctor.setAvailableTime("09:00 AM - 05:00 PM");

                     // Use profile_image for imageUrl if available
                     String profileImage = rs.getString("profile_image");
                     if (profileImage != null && !profileImage.isEmpty()) {
                         doctor.setImageUrl(profileImage);
                         doctor.setProfileImage(profileImage);
                     } else {
                         doctor.setImageUrl("/assets/images/doctors/default-doctor.png");
                         doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
                     }

                     doctor.setRating(rs.getDouble("rating"));
                     doctor.setPatientCount(rs.getInt("patient_count"));
                     doctor.setSuccessRate(90); // Default value for now

                     doctors.add(doctor);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.out.println("Error getting top doctors: " + e.getMessage());
             e.printStackTrace();

         }

         System.out.println("Returning " + doctors.size() + " top doctors from database");

         return doctors;
     }

     /**
      * Get the count of approved doctors
      * @return The count of approved doctors
      */
     public int getApprovedDoctorsCount() {
         String query = "SELECT COUNT(*) FROM doctors d JOIN users u ON d.user_id = u.id WHERE u.role = 'DOCTOR'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query);
              ResultSet rs = pstmt.executeQuery()) {

             if (rs.next()) {
                 return rs.getInt(1);
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting approved doctors count: " + e.getMessage());
             e.printStackTrace();
         }

         return 0;
     }

     /**
      * Get the count of rejected doctor requests
      * @return The count of rejected doctor requests
      */
     public int getRejectedDoctorsCount() {
         String query = "SELECT COUNT(*) FROM doctor_registration_requests WHERE status = 'REJECTED'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query);
              ResultSet rs = pstmt.executeQuery()) {

             if (rs.next()) {
                 return rs.getInt(1);
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting rejected doctors count: " + e.getMessage());
             e.printStackTrace();
         }

         return 0;
     }

     /**
      * Get the count of pending doctor requests
      * @return The count of pending doctor requests
      */
     public int getPendingDoctorsCount() {
         String query = "SELECT COUNT(*) FROM doctor_registration_requests WHERE status = 'PENDING'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query);
              ResultSet rs = pstmt.executeQuery()) {

             if (rs.next()) {
                 return rs.getInt(1);
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting pending doctors count: " + e.getMessage());
             e.printStackTrace();
         }

         return 0;
     }
 }