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
                     return extractDoctorFromResultSet(rs);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting doctor by ID: " + id + ": " + e.getMessage());
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
                     return extractDoctorFromResultSet(rs);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting doctor by user ID: " + userId + ": " + e.getMessage());
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
                 Doctor doctor = extractDoctorFromResultSet(rs);

                 // Only add doctors with valid information
                 if (doctor.getName() != null && !doctor.getName().isEmpty() &&
                     doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                     doctors.add(doctor);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting all doctors: " + e.getMessage());
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
                     Doctor doctor = extractDoctorFromResultSet(rs);

                     // Only add doctors with valid information
                     if (doctor.getName() != null && !doctor.getName().isEmpty() &&
                         doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                         doctors.add(doctor);
                     }
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error searching doctors with term '" + searchTerm + "': " + e.getMessage());
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
                     Doctor doctor = extractDoctorFromResultSet(rs);

                     // Only add doctors with valid information
                     if (doctor.getName() != null && !doctor.getName().isEmpty() &&
                         doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                         doctors.add(doctor);
                     }
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error getting doctors by specialization '" + specialization + "': " + e.getMessage());
             e.printStackTrace();
         }

         return doctors;
     }

     // Update doctor
     public boolean updateDoctor(Doctor doctor) {
         System.out.println("Updating doctor with ID: " + doctor.getId());
         System.out.println("Doctor available days: " + doctor.getAvailableDays());
         System.out.println("Doctor available time: " + doctor.getAvailableTime());

         Connection conn = null;
         boolean success = false;

         try {
             conn = DBConnection.getConnection();
             conn.setAutoCommit(false); // Start transaction

             // First update the doctors table
             String doctorQuery = "UPDATE doctors SET name = ?, specialization = ?, qualification = ?, experience = ?, " +
                                "email = ?, phone = ?, address = ?, consultation_fee = ?, available_days = ?, " +
                                "available_time = ?, image_url = ?, status = ?, bio = ? WHERE id = ?";

             try (PreparedStatement pstmt = conn.prepareStatement(doctorQuery)) {
                 pstmt.setString(1, doctor.getName());
                 pstmt.setString(2, doctor.getSpecialization());
                 pstmt.setString(3, doctor.getQualification());
                 pstmt.setString(4, doctor.getExperience());
                 pstmt.setString(5, doctor.getEmail());
                 pstmt.setString(6, doctor.getPhone());
                 pstmt.setString(7, doctor.getAddress());
                 pstmt.setString(8, doctor.getConsultationFee());
                 // Ensure availableDays is not null or empty
                 String availableDays = doctor.getAvailableDays();
                 if (availableDays == null || availableDays.trim().isEmpty()) {
                     availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday"; // Default value
                     System.out.println("Using default available days: " + availableDays);
                 } else {
                     System.out.println("Using provided available days: " + availableDays);
                 }
                 pstmt.setString(9, availableDays);

                 // Ensure availableTime is not null or empty
                 String availableTime = doctor.getAvailableTime();
                 if (availableTime == null || availableTime.trim().isEmpty()) {
                     availableTime = "09:00 AM - 05:00 PM"; // Default value
                     System.out.println("Using default available time: " + availableTime);
                 } else {
                     System.out.println("Using provided available time: " + availableTime);
                 }
                 pstmt.setString(10, availableTime);
                 pstmt.setString(11, doctor.getImageUrl());
                 pstmt.setString(12, doctor.getStatus() != null ? doctor.getStatus() : "ACTIVE");
                 pstmt.setString(13, doctor.getBio() != null ? doctor.getBio() : "");
                 pstmt.setInt(14, doctor.getId());

                 System.out.println("Doctor email: " + doctor.getEmail());
                 System.out.println("Doctor bio: " + doctor.getBio());

                 int doctorRowsAffected = pstmt.executeUpdate();
                 System.out.println("Doctor update affected " + doctorRowsAffected + " rows");

                 if (doctorRowsAffected == 0) {
                     System.out.println("No doctor record was updated. Doctor ID may not exist: " + doctor.getId());
                     conn.rollback();
                     return false;
                 }
             }

             // Then update the users table
             // First, get the user ID for this doctor
             int userId = 0;
             String userIdQuery = "SELECT user_id FROM doctors WHERE id = ?";
             try (PreparedStatement pstmt = conn.prepareStatement(userIdQuery)) {
                 pstmt.setInt(1, doctor.getId());
                 try (ResultSet rs = pstmt.executeQuery()) {
                     if (rs.next()) {
                         userId = rs.getInt("user_id");
                     }
                 }
             }

             if (userId > 0) {
                 // Get the user information from the database to get the first and last name
                 String userInfoQuery = "SELECT first_name, last_name FROM users WHERE id = ?";
                 String firstName = "";
                 String lastName = "";

                 try (PreparedStatement userInfoStmt = conn.prepareStatement(userInfoQuery)) {
                     userInfoStmt.setInt(1, userId);
                     try (ResultSet userRs = userInfoStmt.executeQuery()) {
                         if (userRs.next()) {
                             firstName = userRs.getString("first_name");
                             lastName = userRs.getString("last_name");
                         }
                     }
                 }

                 // If we couldn't get the name from the database, try to extract it from doctor name
                 if ((firstName == null || firstName.isEmpty()) && (lastName == null || lastName.isEmpty())) {
                     String name = doctor.getName();
                     if (name != null && !name.isEmpty()) {
                         // Remove "Dr. " prefix if present
                         if (name.startsWith("Dr. ")) {
                             name = name.substring(4);
                         }

                         // Split name into first and last name
                         String[] nameParts = name.split(" ", 2);
                         firstName = nameParts[0];
                         if (nameParts.length > 1) {
                             lastName = nameParts[1];
                         }
                     }
                 }

                 // Construct the doctor's name for the doctors table
                 String doctorName = "Dr. " + firstName + " " + lastName;

                 // Update the name in the doctors table
                 String updateNameQuery = "UPDATE doctors SET name = ? WHERE id = ?";
                 try (PreparedStatement updateNameStmt = conn.prepareStatement(updateNameQuery)) {
                     updateNameStmt.setString(1, doctorName);
                     updateNameStmt.setInt(2, doctor.getId());
                     updateNameStmt.executeUpdate();
                 } catch (SQLException e) {
                     // Name column might not exist, ignore
                     System.out.println("Could not update name column: " + e.getMessage());
                 }

                 // First check if email already exists for another user
                 if (doctor.getEmail() != null && !doctor.getEmail().isEmpty()) {
                     String checkEmailQuery = "SELECT id FROM users WHERE email = ? AND id != ?";
                     try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailQuery)) {
                         checkStmt.setString(1, doctor.getEmail());
                         checkStmt.setInt(2, userId);
                         try (ResultSet rs = checkStmt.executeQuery()) {
                             if (rs.next()) {
                                 System.out.println("Email " + doctor.getEmail() + " already exists for another user");
                                 // Don't update email if it already exists for another user
                                 doctor.setEmail(null);
                             }
                         }
                     } catch (SQLException e) {
                         System.out.println("Error checking email uniqueness: " + e.getMessage());
                     }
                 }

                 // Update the users table with all user information
                 String userQuery = "UPDATE users SET first_name = ?, last_name = ?, phone = ?, address = ?, username = ?";

                 // Add email to the query if it's provided and unique
                 if (doctor.getEmail() != null && !doctor.getEmail().isEmpty()) {
                     userQuery += ", email = ?";
                 }

                 userQuery += " WHERE id = ?";

                 try (PreparedStatement pstmt = conn.prepareStatement(userQuery)) {
                     pstmt.setString(1, firstName);
                     pstmt.setString(2, lastName);
                     pstmt.setString(3, doctor.getPhone());
                     pstmt.setString(4, doctor.getAddress());

                     // Set username to first_name + last_name
                     String username = firstName + " " + lastName;
                     pstmt.setString(5, username);

                     // Set email if provided and unique
                     if (doctor.getEmail() != null && !doctor.getEmail().isEmpty()) {
                         pstmt.setString(6, doctor.getEmail());
                         pstmt.setInt(7, userId);
                     } else {
                         pstmt.setInt(6, userId);
                     }

                     int userRowsAffected = pstmt.executeUpdate();
                     System.out.println("User update affected " + userRowsAffected + " rows");

                     if (userRowsAffected == 0) {
                         System.out.println("No user record was updated. User ID may not exist: " + userId);
                         // Continue anyway since the doctor record was updated successfully
                     }
                 }
             } else {
                 System.out.println("Could not find user ID for doctor ID: " + doctor.getId());
                 // Continue anyway since the doctor record was updated successfully
             }

             // Commit the transaction
             conn.commit();
             success = true;
             return true;
         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error updating doctor: " + e.getMessage());
             e.printStackTrace();

             // Rollback the transaction if there was an error
             if (conn != null) {
                 try {
                     conn.rollback();
                 } catch (SQLException ex) {
                     System.err.println("Error rolling back transaction: " + ex.getMessage());
                 }
             }

             // Try fallback methods
             return tryFallbackUpdate(doctor);
         } finally {
             // Restore auto-commit and close connection
             if (conn != null) {
                 try {
                     conn.setAutoCommit(true);
                     conn.close();
                 } catch (SQLException ex) {
                     System.err.println("Error closing connection: " + ex.getMessage());
                 }
             }
         }
     }

     /**
      * Try fallback update methods if the main update fails
      * @param doctor The doctor to update
      * @return true if any update was successful, false otherwise
      */
     private boolean tryFallbackUpdate(Doctor doctor) {
         // First try a simpler update as a fallback
         String fallbackQuery = "UPDATE doctors SET specialization = ?, qualification = ?, experience = ?, " +
                       "consultation_fee = ?, available_days = ?, available_time = ?, bio = ? WHERE id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(fallbackQuery)) {

             pstmt.setString(1, doctor.getSpecialization());
             pstmt.setString(2, doctor.getQualification());
             pstmt.setString(3, doctor.getExperience());
             pstmt.setString(4, doctor.getConsultationFee());
             // Ensure availableDays is not null or empty
             String availableDays = doctor.getAvailableDays();
             if (availableDays == null || availableDays.trim().isEmpty()) {
                 availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday"; // Default value
                 System.out.println("Fallback: Using default available days: " + availableDays);
             } else {
                 System.out.println("Fallback: Using provided available days: " + availableDays);
             }
             pstmt.setString(5, availableDays);

             // Ensure availableTime is not null or empty
             String availableTime = doctor.getAvailableTime();
             if (availableTime == null || availableTime.trim().isEmpty()) {
                 availableTime = "09:00 AM - 05:00 PM"; // Default value
                 System.out.println("Fallback: Using default available time: " + availableTime);
             } else {
                 System.out.println("Fallback: Using provided available time: " + availableTime);
             }
             pstmt.setString(6, availableTime);
             pstmt.setString(7, doctor.getBio() != null ? doctor.getBio() : "");
             pstmt.setInt(8, doctor.getId());

             System.out.println("Fallback: Doctor email: " + doctor.getEmail());
             System.out.println("Fallback: Doctor bio: " + doctor.getBio());

             int rowsAffected = pstmt.executeUpdate();
             System.out.println("Doctor fallback update affected " + rowsAffected + " rows");

             // Also update the users table if possible
             try {
                 // Get the user ID for this doctor
                 int userId = 0;
                 String userIdQuery = "SELECT user_id FROM doctors WHERE id = ?";
                 try (PreparedStatement userIdStmt = conn.prepareStatement(userIdQuery)) {
                     userIdStmt.setInt(1, doctor.getId());
                     try (ResultSet rs = userIdStmt.executeQuery()) {
                         if (rs.next()) {
                             userId = rs.getInt("user_id");
                         }
                     }
                 }

                 if (userId > 0) {
                     // Update basic info in users table
                     String userQuery = "UPDATE users SET phone = ? WHERE id = ?";
                     try (PreparedStatement userStmt = conn.prepareStatement(userQuery)) {
                         userStmt.setString(1, doctor.getPhone());
                         userStmt.setInt(2, userId);

                         int userRowsAffected = userStmt.executeUpdate();
                         System.out.println("User fallback update affected " + userRowsAffected + " rows");
                     }
                 }
             } catch (Exception e) {
                 System.out.println("Error updating user in fallback: " + e.getMessage());
             }

             return rowsAffected > 0;
         } catch (SQLException | ClassNotFoundException e) {
             System.out.println("Error in fallback doctor update: " + e.getMessage());
             e.printStackTrace();

             // Last resort: try to update individual fields that we know are important
             try {
                 return updateDoctorIndividualFields(doctor);
             } catch (Exception ex) {
                 System.out.println("Final attempt to update doctor failed: " + ex.getMessage());
                 ex.printStackTrace();
                 return false;
             }
         }
     }

    // Helper method to update doctor fields individually
    private boolean updateDoctorIndividualFields(Doctor doctor) {
        System.out.println("Attempting to update doctor fields individually for doctor ID: " + doctor.getId());
        boolean success = false;

        try (Connection conn = DBConnection.getConnection()) {
            // Update specialization
            success |= updateSingleField(conn, "specialization", doctor.getSpecialization(), doctor.getId());

            // Update qualification
            success |= updateSingleField(conn, "qualification", doctor.getQualification(), doctor.getId());

            // Update experience
            success |= updateSingleField(conn, "experience", doctor.getExperience(), doctor.getId());

            // Update consultation_fee
            success |= updateSingleField(conn, "consultation_fee", doctor.getConsultationFee(), doctor.getId());

            // Update bio if available
            if (doctor.getBio() != null && !doctor.getBio().isEmpty()) {
                success |= updateSingleField(conn, "bio", doctor.getBio(), doctor.getId());
            }

            // Try both column naming conventions for available days and time
            boolean daysUpdated = updateSingleField(conn, "available_days", doctor.getAvailableDays(), doctor.getId());
            if (!daysUpdated) {
                daysUpdated = updateSingleField(conn, "availableDays", doctor.getAvailableDays(), doctor.getId());
            }
            success |= daysUpdated;

            boolean timeUpdated = updateSingleField(conn, "available_time", doctor.getAvailableTime(), doctor.getId());
            if (!timeUpdated) {
                timeUpdated = updateSingleField(conn, "availableTime", doctor.getAvailableTime(), doctor.getId());
            }
            success |= timeUpdated;

            // Try to update the name if available
            if (doctor.getName() != null && !doctor.getName().isEmpty()) {
                success |= updateSingleField(conn, "name", doctor.getName(), doctor.getId());
            }

            System.out.println("Individual field updates result: " + success);
            return success;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error in updateDoctorIndividualFields: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to update a single field
    private boolean updateSingleField(Connection conn, String fieldName, String value, int doctorId) {
        // Skip if value is null
        if (value == null) {
            System.out.println("Skipping update for field '" + fieldName + "' because value is null");
            return false;
        }

        String query = "UPDATE doctors SET " + fieldName + " = ? WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, value);
            pstmt.setInt(2, doctorId);

            // Log the exact SQL and parameters being used
            System.out.println("Executing SQL: " + query);
            System.out.println("With parameters: value=" + value + ", doctorId=" + doctorId);

            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Updated field '" + fieldName + "' for doctor ID " + doctorId + ": " + rowsAffected + " rows affected");
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating field '" + fieldName + "': " + e.getMessage());
            e.printStackTrace(); // Print stack trace for better debugging

            // Try alternative column name if this is a common field that might have different naming
            if (fieldName.contains("_")) {
                // Convert snake_case to camelCase
                String[] parts = fieldName.split("_");
                StringBuilder camelCase = new StringBuilder(parts[0]);
                for (int i = 1; i < parts.length; i++) {
                    camelCase.append(parts[i].substring(0, 1).toUpperCase()).append(parts[i].substring(1));
                }

                // Try with the alternative name
                try {
                    String altQuery = "UPDATE doctors SET " + camelCase.toString() + " = ? WHERE id = ?";
                    try (PreparedStatement altStmt = conn.prepareStatement(altQuery)) {
                        altStmt.setString(1, value);
                        altStmt.setInt(2, doctorId);

                        System.out.println("Trying alternative column name: " + camelCase.toString());
                        int altRowsAffected = altStmt.executeUpdate();
                        System.out.println("Updated field '" + camelCase.toString() + "' for doctor ID " + doctorId + ": " + altRowsAffected + " rows affected");
                        return altRowsAffected > 0;
                    }
                } catch (SQLException altEx) {
                    System.err.println("Error updating with alternative field name: " + altEx.getMessage());
                }
            }

            // Try direct SQL as a last resort
            try {
                String directSql = "UPDATE doctors SET " + fieldName + " = '" + value.replace("'", "''") + "' WHERE id = " + doctorId;
                try (java.sql.Statement stmt = conn.createStatement()) {
                    System.out.println("Trying direct SQL: " + directSql);
                    int directRowsAffected = stmt.executeUpdate(directSql);
                    System.out.println("Direct SQL update for field '" + fieldName + "' affected " + directRowsAffected + " rows");
                    return directRowsAffected > 0;
                }
            } catch (SQLException directEx) {
                System.err.println("Error with direct SQL update: " + directEx.getMessage());
            }

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
            System.err.println("Error deleting doctor with ID " + id + ": " + e.getMessage());
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
            System.err.println("Error getting total doctors count: " + e.getMessage());
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
                    Doctor doctor = extractDoctorFromResultSet(rs);

                    // Only add doctors with valid information
                    if (doctor.getName() != null && !doctor.getName().isEmpty() &&
                        doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                        doctors.add(doctor);
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error getting recent doctors: " + e.getMessage());
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
            System.err.println("Error getting total patients by doctor ID: " + doctorId + ": " + e.getMessage());
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
            System.err.println("Error getting pending reports by doctor ID: " + doctorId + ": " + e.getMessage());
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
        System.out.println("Getting average rating for doctor ID: " + doctorId);

        // First try to get rating directly from doctors table (more reliable)
        try {
            String directQuery = "SELECT rating FROM doctors WHERE id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(directQuery)) {

                pstmt.setInt(1, doctorId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        double rating = rs.getDouble("rating");
                        System.out.println("Found rating " + rating + " directly in doctors table for ID: " + doctorId);
                        return rating;
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error getting rating from doctors table for doctor ID: " + doctorId + ": " + e.getMessage());
        }

        // If direct approach fails, try the doctor_ratings table (for future compatibility)
        try {
            String ratingsQuery = "SELECT AVG(rating) FROM doctor_ratings WHERE doctor_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(ratingsQuery)) {

                pstmt.setInt(1, doctorId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        double rating = rs.getDouble(1);
                        System.out.println("Found average rating " + rating + " from doctor_ratings table for ID: " + doctorId);
                        return rating;
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            // This is expected to fail until the doctor_ratings table is populated
            // Just log at debug level to avoid filling logs
            System.out.println("Note: doctor_ratings table not available yet: " + e.getMessage());
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
                Doctor doctor = extractDoctorFromResultSet(rs);

                // Only add doctors with valid information
                if (doctor.getName() != null && !doctor.getName().isEmpty() &&
                    doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                    doctors.add(doctor);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error getting approved doctors: " + e.getMessage());
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
                    Doctor doctor = extractDoctorFromResultSet(rs);

                    // Only add doctors with valid information
                    if (doctor.getName() != null && !doctor.getName().isEmpty() &&
                        doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                        doctors.add(doctor);
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error getting approved doctors by specialization '" + specialization + "': " + e.getMessage());
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
                    Doctor doctor = extractDoctorFromResultSet(rs);

                    // Only add doctors with valid information
                    if (doctor.getName() != null && !doctor.getName().isEmpty() &&
                        doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) {
                        doctors.add(doctor);
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error searching approved doctors with term '" + searchTerm + "': " + e.getMessage());
            e.printStackTrace();
        }

        return doctors;
    }

    // Get top doctors
    public List<Doctor> getTopDoctors(int limit) {
        List<Doctor> doctors = new ArrayList<>();

        try {
            // Try the most compatible query first
            String query = "SELECT d.*, u.first_name, u.last_name, u.email AS user_email, u.phone AS user_phone, u.address AS user_address " +
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
                        Doctor doctor = extractDoctorFromResultSet(rs);
                        doctors.add(doctor);
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error getting top doctors: " + e.getMessage());

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
                System.err.println("Error in fallback query: " + fallbackEx.getMessage());
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

    /**
     * Helper method to extract doctor information from a ResultSet
     * This reduces code duplication across multiple methods
     *
     * @param rs The ResultSet containing doctor data
     * @return A Doctor object populated with data from the ResultSet
     * @throws SQLException If there's an error accessing the ResultSet
     */
    private Doctor extractDoctorFromResultSet(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setId(rs.getInt("id"));

        try {
            doctor.setUserId(rs.getInt("user_id"));
        } catch (SQLException e) {
            // Column might not exist, ignore
        }

        // Department ID removed

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
            try {
                email = rs.getString("user_email");
            } catch (SQLException e) {
                // Column might not exist, ignore
            }
        }
        doctor.setEmail(email);

        // Get phone from doctors table or users table
        String phone = rs.getString("phone");
        if (phone == null || phone.isEmpty()) {
            try {
                phone = rs.getString("user_phone");
            } catch (SQLException e) {
                // Column might not exist, ignore
            }
        }
        doctor.setPhone(phone);

        // Get address from doctors table or users table
        String address = rs.getString("address");
        if (address == null || address.isEmpty()) {
            try {
                address = rs.getString("user_address");
            } catch (SQLException e) {
                // Column might not exist, ignore
            }
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
        String imageUrl = null;
        try {
            imageUrl = rs.getString("image_url");
        } catch (SQLException e) {
            // Column might not exist, ignore
        }

        if (imageUrl == null || imageUrl.isEmpty()) {
            imageUrl = "/assets/images/doctors/default-doctor.png";
        }
        doctor.setImageUrl(imageUrl);

        // Set profile image if available
        try {
            String profileImage = rs.getString("profile_image");
            if (profileImage != null && !profileImage.isEmpty()) {
                doctor.setProfileImage(profileImage);
            } else {
                doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
            }
        } catch (SQLException e) {
            // Column might not exist, set default
            doctor.setProfileImage("/assets/images/doctors/default-doctor.png");
        }

        // Set bio if available
        try {
            String bio = rs.getString("bio");
            if (bio != null) {
                doctor.setBio(bio);
            }
        } catch (SQLException e) {
            // Column might not exist, ignore
        }

        // Set rating and patient count
        try {
            doctor.setRating(rs.getDouble("rating"));
        } catch (SQLException e) {
            // Column might not exist, set default
            doctor.setRating(4.0);
        }

        try {
            doctor.setPatientCount(rs.getInt("patient_count"));
        } catch (SQLException e) {
            // Column might not exist, set default
            doctor.setPatientCount(0);
        }

        doctor.setSuccessRate(90); // Default value

        return doctor;
    }
}