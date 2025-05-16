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
             // Use a simpler query without the name column to avoid errors
             String doctorQuery = "INSERT INTO doctors (user_id, specialization, qualification, experience, email, phone, address, " +
                                "consultation_fee, available_days, available_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

             try (PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery)) {
                 doctorStmt.setInt(1, userId);
                 doctorStmt.setString(2, doctor.getSpecialization());
                 doctorStmt.setString(3, doctor.getQualification());
                 doctorStmt.setString(4, doctor.getExperience());
                 doctorStmt.setString(5, doctor.getEmail());
                 doctorStmt.setString(6, doctor.getPhone());
                 doctorStmt.setString(7, doctor.getAddress());
                 doctorStmt.setString(8, doctor.getConsultationFee());
                 doctorStmt.setString(9, doctor.getAvailableDays());
                 doctorStmt.setString(10, doctor.getAvailableTime());

                 doctorStmt.executeUpdate();

                 // Try to update the name and image_url separately if needed
                 try {
                     if (doctor.getName() != null && !doctor.getName().isEmpty()) {
                         String updateNameQuery = "UPDATE doctors SET name = ? WHERE user_id = ?";
                         try (PreparedStatement updateStmt = conn.prepareStatement(updateNameQuery)) {
                             updateStmt.setString(1, doctor.getName());
                             updateStmt.setInt(2, userId);
                             updateStmt.executeUpdate();
                         }
                     }
                 } catch (SQLException e) {
                     // Name column might not exist, ignore
                     System.out.println("Could not update name column: " + e.getMessage());
                 }

                 try {
                     if (doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty()) {
                         String updateImageQuery = "UPDATE doctors SET image_url = ? WHERE user_id = ?";
                         try (PreparedStatement updateStmt = conn.prepareStatement(updateImageQuery)) {
                             updateStmt.setString(1, doctor.getImageUrl());
                             updateStmt.setInt(2, userId);
                             updateStmt.executeUpdate();
                         }
                     }
                 } catch (SQLException e) {
                     // image_url column might not exist, ignore
                     System.out.println("Could not update image_url column: " + e.getMessage());
                 }
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
                     String name = null;
                     try {
                         name = rs.getString("name");
                     } catch (SQLException e) {
                         // Column might not exist yet, ignore
                     }

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

                     // Set status to ACTIVE by default since the column might not exist
                     try {
                         String status = rs.getString("status");
                         if (status == null || status.isEmpty()) {
                             status = "ACTIVE";
                         }
                         doctor.setStatus(status);
                     } catch (SQLException e) {
                         // Status column doesn't exist, set default value
                         doctor.setStatus("ACTIVE");
                         System.out.println("Status column not found in getDoctorById, using default ACTIVE status");
                     }

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
                     String name = null;
                     try {
                         name = rs.getString("name");
                     } catch (SQLException e) {
                         // Column might not exist yet, ignore
                     }

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

                     // Set status to ACTIVE by default since the column might not exist
                     try {
                         String status = rs.getString("status");
                         if (status == null || status.isEmpty()) {
                             status = "ACTIVE";
                         }
                         doctor.setStatus(status);
                     } catch (SQLException e) {
                         // Status column doesn't exist, set default value
                         doctor.setStatus("ACTIVE");
                         System.out.println("Status column not found in getDoctorByUserId, using default ACTIVE status");
                     }

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
                 String name = null;
                 try {
                     name = rs.getString("name");
                 } catch (SQLException e) {
                     // Column might not exist yet, ignore
                 }

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

                 // Set status to ACTIVE by default since the column might not exist
                 try {
                     String status = rs.getString("status");
                     if (status == null || status.isEmpty()) {
                         status = "ACTIVE";
                     }
                     doctor.setStatus(status);
                 } catch (SQLException e) {
                     // Status column doesn't exist, set default value
                     doctor.setStatus("ACTIVE");
                 }

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
                       "WHERE (d.email LIKE ? OR u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ?) " +
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
                     String name = null;
                     try {
                         name = rs.getString("name");
                     } catch (SQLException e) {
                         // Column might not exist yet, ignore
                     }

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

                     // Set status to ACTIVE by default since the column might not exist
                     try {
                         String status = rs.getString("status");
                         if (status == null || status.isEmpty()) {
                             status = "ACTIVE";
                         }
                         doctor.setStatus(status);
                     } catch (SQLException e) {
                         // Status column doesn't exist, set default value
                         doctor.setStatus("ACTIVE");
                     }

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
                     String name = null;
                     try {
                         name = rs.getString("name");
                     } catch (SQLException e) {
                         // Column might not exist yet, ignore
                     }

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
                     String name = null;
                     try {
                         name = rs.getString("name");
                     } catch (SQLException e) {
                         // Column might not exist yet, ignore
                     }

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
         System.out.println("Getting doctor ID for user ID: " + userId);

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, userId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     int doctorId = rs.getInt("id");
                     System.out.println("Found doctor ID: " + doctorId + " for user ID: " + userId);
                     return doctorId;
                 } else {
                     System.out.println("No doctor found for user ID: " + userId + " using direct query");
                 }
             }
         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error in primary query for doctor ID: " + e.getMessage());
             e.printStackTrace();

             // Try a fallback query with a join to users table
             try {
                 String fallbackQuery = "SELECT d.id FROM doctors d JOIN users u ON d.user_id = u.id WHERE u.id = ? AND u.role = 'DOCTOR'";

                 try (Connection conn = DBConnection.getConnection();
                      PreparedStatement pstmt = conn.prepareStatement(fallbackQuery)) {

                     pstmt.setInt(1, userId);

                     try (ResultSet rs = pstmt.executeQuery()) {
                         if (rs.next()) {
                             int doctorId = rs.getInt("id");
                             System.out.println("Fallback: Found doctor ID: " + doctorId + " for user ID: " + userId);
                             return doctorId;
                         }
                     }
                 }
             } catch (SQLException | ClassNotFoundException fallbackEx) {
                 System.err.println("Error in fallback query for doctor ID: " + fallbackEx.getMessage());
             }
         }

         // If we get here, no doctor ID was found
         System.out.println("No doctor ID found for user ID: " + userId + ", returning 0");
         return 0;
     }

     // Get total patients by doctor
     public int getTotalPatientsByDoctor(int doctorId) {
         String query = "SELECT COUNT(DISTINCT patient_id) FROM appointments WHERE doctor_id = ?";
         System.out.println("Getting total patients for doctor ID: " + doctorId);

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     int count = rs.getInt(1);
                     System.out.println("Found " + count + " total patients for doctor ID: " + doctorId);
                     return count;
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting total patients by doctor ID: " + doctorId);
             e.printStackTrace();
         }

         return 0;
     }

     // Get pending reports by doctor
     public int getPendingReportsByDoctor(int doctorId) {
         String query = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND status = 'COMPLETED' AND medical_report IS NULL";
         System.out.println("Getting pending reports for doctor ID: " + doctorId);

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     int count = rs.getInt(1);
                     System.out.println("Found " + count + " pending reports for doctor ID: " + doctorId);
                     return count;
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting pending reports by doctor ID: " + doctorId);
             e.printStackTrace();

             // Try a fallback query without the medical_report column in case it doesn't exist
             try {
                 String fallbackQuery = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND status = 'COMPLETED'";

                 try (Connection conn = DBConnection.getConnection();
                      PreparedStatement pstmt = conn.prepareStatement(fallbackQuery)) {

                     pstmt.setInt(1, doctorId);

                     try (ResultSet rs = pstmt.executeQuery()) {
                         if (rs.next()) {
                             int count = rs.getInt(1);
                             System.out.println("Fallback: Found " + count + " completed appointments for doctor ID: " + doctorId);
                             return count;
                         }
                     }
                 }
             } catch (SQLException | ClassNotFoundException fallbackEx) {
                 System.err.println("Error in fallback query for pending reports: " + fallbackEx.getMessage());
             }
         }

         return 0;
     }

     // Get average rating by doctor
     public double getAverageRatingByDoctor(int doctorId) {
         String query = "SELECT AVG(rating) FROM doctor_ratings WHERE doctor_id = ?";
         System.out.println("Getting average rating for doctor ID: " + doctorId);

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     double rating = rs.getDouble(1);
                     System.out.println("Found average rating " + rating + " for doctor ID: " + doctorId);
                     return rating;
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting average rating by doctor ID: " + doctorId);
             System.err.println("Error message: " + e.getMessage());

             // Try a fallback - check if the doctor has a rating field directly
             try {
                 String fallbackQuery = "SELECT rating FROM doctors WHERE id = ?";

                 try (Connection conn = DBConnection.getConnection();
                      PreparedStatement pstmt = conn.prepareStatement(fallbackQuery)) {

                     pstmt.setInt(1, doctorId);

                     try (ResultSet rs = pstmt.executeQuery()) {
                         if (rs.next()) {
                             double rating = rs.getDouble("rating");
                             System.out.println("Fallback: Found rating " + rating + " directly in doctors table for ID: " + doctorId);
                             return rating;
                         }
                     }
                 }
             } catch (SQLException | ClassNotFoundException fallbackEx) {
                 System.err.println("Error in fallback query for doctor rating: " + fallbackEx.getMessage());
             }
         }

         // Return a default rating if no rating found
         return 4.0;
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
                 String name = null;
                 try {
                     name = rs.getString("name");
                 } catch (SQLException e) {
                     // Column might not exist yet, ignore
                 }

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
                     String name = null;
                     try {
                         name = rs.getString("name");
                     } catch (SQLException e) {
                         // Column might not exist yet, ignore
                     }

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
                     String name = null;
                     try {
                         name = rs.getString("name");
                     } catch (SQLException e) {
                         // Column might not exist yet, ignore
                     }

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

         try {
             // Try the most compatible query first
             String query = "SELECT d.*, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
                           "FROM doctors d " +
                           "JOIN users u ON d.user_id = u.id " +
                           "WHERE u.role = 'DOCTOR' " +
                           "ORDER BY d.rating DESC, d.patient_count DESC " +
                           "LIMIT ?";

             try (Connection conn = DBConnection.getConnection();
                  PreparedStatement pstmt = conn.prepareStatement(query)) {

                 pstmt.setInt(1, limit);

                 try (ResultSet rs = pstmt.executeQuery()) {
                     while (rs.next()) {
                         Doctor doctor = new Doctor();
                         doctor.setId(rs.getInt("id"));
                         doctor.setUserId(rs.getInt("user_id"));

                         // Use name from doctors table directly
                         String name = null;
                         try {
                             name = rs.getString("name");
                         } catch (SQLException e) {
                             // Column might not exist yet, ignore
                         }

                         if (name == null || name.isEmpty()) {
                             // If name is not available, use a default name
                             name = "Dr. " + rs.getInt("id");
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

                         // Use profile_image or image_url for imageUrl if available
                         String profileImage = null;
                         String imageUrl = null;

                         try {
                             profileImage = rs.getString("profile_image");
                         } catch (SQLException e) {
                             // Column might not exist yet, ignore
                         }

                         try {
                             imageUrl = rs.getString("image_url");
                         } catch (SQLException e) {
                             // Column might not exist yet, ignore
                         }

                         if (profileImage != null && !profileImage.isEmpty()) {
                             doctor.setProfileImage(profileImage);
                             doctor.setImageUrl(profileImage);
                         } else if (imageUrl != null && !imageUrl.isEmpty()) {
                             doctor.setImageUrl(imageUrl);
                             doctor.setProfileImage(imageUrl);
                         } else {
                             doctor.setImageUrl("/assets/images/doctors/default-doctor.png");
                             doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
                         }

                         // Get rating and patient count, set defaults if null
                         double rating = 0.0;
                         int patientCount = 0;

                         try {
                             rating = rs.getDouble("rating");
                         } catch (SQLException e) {
                             // Column might not exist yet, use default
                         }

                         try {
                             patientCount = rs.getInt("patient_count");
                         } catch (SQLException e) {
                             // Column might not exist yet, use default
                         }

                         doctor.setRating(rating);
                         doctor.setPatientCount(patientCount);
                         doctor.setSuccessRate(90); // Default value for now

                         doctors.add(doctor);
                     }
                 }
             }
         } catch (SQLException | ClassNotFoundException e) {
             System.out.println("Error getting top doctors: " + e.getMessage());

             // Try a simpler fallback query
             try {
                 String fallbackQuery = "SELECT d.id, d.user_id, d.specialization, d.qualification, " +
                                      "d.experience, d.consultation_fee " +
                                      "FROM doctors d " +
                                      "JOIN users u ON d.user_id = u.id " +
                                      "WHERE u.role = 'DOCTOR' " +
                                      "LIMIT ?";

                 try (Connection conn = DBConnection.getConnection();
                      PreparedStatement pstmt = conn.prepareStatement(fallbackQuery)) {

                     pstmt.setInt(1, limit);

                     try (ResultSet rs = pstmt.executeQuery()) {
                         while (rs.next()) {
                             Doctor doctor = new Doctor();
                             doctor.setId(rs.getInt("id"));
                             doctor.setUserId(rs.getInt("user_id"));
                             doctor.setName("Dr. " + rs.getInt("id")); // Default name
                             doctor.setSpecialization(rs.getString("specialization"));
                             doctor.setQualification(rs.getString("qualification"));
                             doctor.setExperience(rs.getString("experience"));

                             // Set default values for other fields
                             doctor.setEmail("doctor" + rs.getInt("id") + "@example.com");
                             doctor.setPhone("N/A");
                             doctor.setAddress("N/A");

                             String consultationFee = rs.getString("consultation_fee");
                             if (consultationFee == null || consultationFee.isEmpty()) {
                                 consultationFee = "1000";
                             }
                             doctor.setConsultationFee(consultationFee);

                             doctor.setAvailableDays("Monday,Tuesday,Wednesday,Thursday,Friday");
                             doctor.setAvailableTime("09:00 AM - 05:00 PM");
                             doctor.setImageUrl("/assets/images/doctors/default-doctor.png");
                             doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
                             doctor.setRating(0.0);
                             doctor.setPatientCount(0);
                             doctor.setSuccessRate(90);

                             doctors.add(doctor);
                         }
                     }
                 }
             } catch (SQLException | ClassNotFoundException fallbackEx) {
                 System.out.println("Error in fallback query: " + fallbackEx.getMessage());
                 fallbackEx.printStackTrace();
             }

             // If all queries failed, return an empty list rather than null
             if (doctors.isEmpty()) {
                 System.out.println("Returning empty list of doctors due to error");
             }
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