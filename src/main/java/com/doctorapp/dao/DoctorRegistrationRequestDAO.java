package com.doctorapp.dao;

 import java.sql.Connection;
 import java.sql.PreparedStatement;
 import java.sql.ResultSet;
 import java.sql.SQLException;
 import java.sql.Statement;
 import java.util.ArrayList;
 import java.util.List;

 import com.doctorapp.model.DoctorRegistrationRequest;
 import com.doctorapp.model.User;
 import com.doctorapp.util.DBConnection;
 import com.doctorapp.util.PasswordHasher;

 /**
  * DAO class for doctor registration requests
  */
 public class DoctorRegistrationRequestDAO {

     /**
      * Create a new doctor registration request
      * @param request The doctor registration request to create
      * @return true if the request was created successfully, false otherwise
      */
     public boolean createRequest(DoctorRegistrationRequest request) {
         // Include username field in the query
         String query = "INSERT INTO doctor_registration_requests (username, email, password, phone, " +
                 "first_name, last_name, specialization, qualification, experience, address, status) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

             // Hash the password
             String hashedPassword = PasswordHasher.hashPassword(request.getPassword());

             // Generate username from email if not provided
             String username = request.getUsername();
             if (username == null || username.isEmpty()) {
                 username = request.getEmail().split("@")[0];
             }

             pstmt.setString(1, username);
             pstmt.setString(2, request.getEmail());
             pstmt.setString(3, hashedPassword);
             pstmt.setString(4, request.getPhone());
             pstmt.setString(5, request.getFirstName() != null ? request.getFirstName() : "");
             pstmt.setString(6, request.getLastName() != null ? request.getLastName() : "");
             pstmt.setString(7, request.getSpecialization());
             pstmt.setString(8, request.getQualification());
             pstmt.setString(9, request.getExperience());
             pstmt.setString(10, request.getAddress());

             int rowsAffected = pstmt.executeUpdate();

             // Get the generated ID
             if (rowsAffected > 0) {
                 try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                     if (generatedKeys.next()) {
                         request.setId(generatedKeys.getInt(1));
                     }
                 }
             }

             return rowsAffected > 0;

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
             return false;
         }
     }

     /**
      * Get all doctor registration requests
      * @return List of all doctor registration requests
      */
     public List<DoctorRegistrationRequest> getAllRequests() {
         // Since approved and rejected requests are now deleted,
         // this method will only return pending requests
         List<DoctorRegistrationRequest> requests = new ArrayList<>();
         String query = "SELECT * FROM doctor_registration_requests ORDER BY created_at DESC";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query);
              ResultSet rs = pstmt.executeQuery()) {

             while (rs.next()) {
                 DoctorRegistrationRequest request = mapResultSetToRequest(rs);
                 requests.add(request);
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return requests;
     }

     /**
      * Get all pending doctor registration requests
      * @return List of pending doctor registration requests
      */
     public List<DoctorRegistrationRequest> getPendingRequests() {
         List<DoctorRegistrationRequest> requests = new ArrayList<>();
         String query = "SELECT * FROM doctor_registration_requests WHERE status = 'PENDING' ORDER BY created_at DESC";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query);
              ResultSet rs = pstmt.executeQuery()) {

             while (rs.next()) {
                 DoctorRegistrationRequest request = mapResultSetToRequest(rs);
                 requests.add(request);
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return requests;
     }

     /**
      * Get a doctor registration request by ID
      * @param id The ID of the request
      * @return The doctor registration request, or null if not found
      */
     public DoctorRegistrationRequest getRequestById(int id) {
         String query = "SELECT * FROM doctor_registration_requests WHERE id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, id);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     return mapResultSetToRequest(rs);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return null;
     }

     /**
      * Check if an email already exists in the doctor registration requests
      * @param email The email to check
      * @return true if the email exists, false otherwise
      */
     public boolean emailExists(String email) {
         String query = "SELECT COUNT(*) FROM doctor_registration_requests WHERE email = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setString(1, email);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     return rs.getInt(1) > 0;
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
         }

         return false;
     }

     /**
      * Update the status of a doctor registration request
      * @param id The ID of the request
      * @param status The new status (APPROVED or REJECTED)
      * @param adminNotes Admin notes about the decision
      * @return true if the update was successful, false otherwise
      */
     public boolean updateRequestStatus(int id, String status, String adminNotes) {
         String query = "UPDATE doctor_registration_requests SET status = ?, admin_notes = ? WHERE id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setString(1, status);
             pstmt.setString(2, adminNotes);
             pstmt.setInt(3, id);

             int rowsAffected = pstmt.executeUpdate();
             return rowsAffected > 0;

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
             return false;
         }
     }

     /**
      * Approve a doctor registration request, create the user and doctor records,
      * and delete the request from doctor_registration_requests table
      * @param id The ID of the request
      * @param adminNotes Admin notes about the approval
      * @return true if the approval was successful, false otherwise
      */
     public boolean approveRequest(int id, String adminNotes) {
         // Get the request
         DoctorRegistrationRequest request = getRequestById(id);
         if (request == null) {
             System.err.println("Doctor registration request not found with ID: " + id);
             return false;
         }

         // Check if the request is already approved or rejected
         if (!"PENDING".equals(request.getStatus())) {
             System.err.println("Cannot approve request with status: " + request.getStatus());
             return false;
         }

         Connection conn = null;
         boolean success = false;

         try {
             // Get connection and start transaction
             System.out.println("Starting transaction for approving doctor request ID: " + id);
             conn = DBConnection.getConnection();
             conn.setAutoCommit(false);

             // Check if email already exists in users table before proceeding
             String checkEmailQuery = "SELECT COUNT(*) FROM users WHERE email = ?";
             try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailQuery)) {
                 checkStmt.setString(1, request.getEmail());
                 try (ResultSet rs = checkStmt.executeQuery()) {
                     if (rs.next() && rs.getInt(1) > 0) {
                         System.err.println("Email already exists in users table: " + request.getEmail());
                         throw new SQLException("Email already exists in the system: " + request.getEmail());
                     }
                 }
             }

             // Create user record
             User user = new User();
             user.setUsername(request.getUsername() != null ? request.getUsername() : request.getEmail());
             user.setEmail(request.getEmail());
             user.setPassword(request.getPassword()); // Already hashed in the request
             user.setPhone(request.getPhone());
             user.setRole("DOCTOR");
             user.setFirstName(request.getFirstName());
             user.setLastName(request.getLastName());

             // These fields might not be available in the new schema
             if (request.getDateOfBirth() != null) {
                 user.setDateOfBirth(request.getDateOfBirth());
             }

             // Gender might not be available in the new schema
             if (request.getGender() != null) {
                 user.setGender(standardizeGender(request.getGender()));
             }

             user.setAddress(request.getAddress());

             System.out.println("Creating user with email: " + user.getEmail() + " and username: " + user.getUsername());

             // Create user and get the generated ID
             int userId = createUser(conn, user);
             if (userId <= 0) {
                 throw new SQLException("Failed to create user record");
             }

             System.out.println("User created successfully with ID: " + userId);

             // Create doctor record with all required fields
             System.out.println("Creating doctor record for user ID: " + userId);

             try {
                 // Simplify the approach - don't try to modify the table structure
                 // Just insert the basic doctor record with the required fields
                 System.out.println("Creating doctor record with basic fields only");

                 // Use a simple query with only the essential fields
                 String basicDoctorQuery = "INSERT INTO doctors (user_id, specialization, qualification, experience) VALUES (?, ?, ?, ?)";

                 try (PreparedStatement pstmt = conn.prepareStatement(basicDoctorQuery)) {
                     pstmt.setInt(1, userId);
                     pstmt.setString(2, request.getSpecialization() != null ? request.getSpecialization() : "General");
                     pstmt.setString(3, request.getQualification() != null ? request.getQualification() : "MBBS");
                     pstmt.setString(4, request.getExperience() != null ? request.getExperience() : "0 years");

                     System.out.println("Executing basic doctor insert SQL with parameters: " +
                                      userId + ", " + request.getSpecialization() + ", " +
                                      request.getQualification() + ", " + request.getExperience());

                     int rowsAffected = pstmt.executeUpdate();
                     System.out.println("Doctor record created successfully. Rows affected: " + rowsAffected);

                     if (rowsAffected <= 0) {
                         throw new SQLException("Failed to insert doctor record. No rows affected.");
                     }
                 }

                 // Now try to update additional fields one by one
                 System.out.println("Updating additional doctor fields...");

                 // Try to update email
                 safeUpdateDoctorField(conn, userId, "email", request.getEmail() != null ? request.getEmail() : "");

                 // Try to update phone
                 safeUpdateDoctorField(conn, userId, "phone", request.getPhone() != null ? request.getPhone() : "");

                 // Try to update address
                 safeUpdateDoctorField(conn, userId, "address", request.getAddress() != null ? request.getAddress() : "");

                 // Try to update status - this might fail if the column doesn't exist, but that's okay
                 try {
                     safeUpdateDoctorField(conn, userId, "status", "APPROVED");
                 } catch (Exception e) {
                     System.out.println("Could not update status field: " + e.getMessage());
                     System.out.println("This is not critical - the doctor record was created successfully");
                 }

                 // Now update the other fields one by one to handle potential schema differences
                 try {
                     // Try to update each field, but don't fail if a field doesn't exist
                     safeUpdateDoctorField(conn, userId, "consultation_fee", "1000");
                     safeUpdateDoctorField(conn, userId, "available_days", "Monday,Tuesday,Wednesday,Thursday,Friday");
                     safeUpdateDoctorField(conn, userId, "available_time", "09:00 AM - 05:00 PM");
                     safeUpdateDoctorField(conn, userId, "bio", request.getBio() != null ? request.getBio() : "");
                     safeUpdateDoctorField(conn, userId, "image_url", "/assets/images/doctors/default-doctor.png");
                 } catch (Exception e) {
                     System.out.println("Could not update some doctor fields: " + e.getMessage());
                     System.out.println("This is not critical - the doctor record was created successfully");
                 }

                 // After successful doctor creation, update the name field separately
                 // This is to handle the case where the name column might be added later
                 try {
                     String firstName = request.getFirstName() != null ? request.getFirstName() : "";
                     String lastName = request.getLastName() != null ? request.getLastName() : "";
                     String fullName = "Dr. " + firstName + " " + lastName;

                     // Check if the name column exists before trying to update it
                     boolean hasNameColumn = false;
                     try {
                         java.sql.DatabaseMetaData dbmd = conn.getMetaData();
                         try (ResultSet columns = dbmd.getColumns(null, null, "doctors", "name")) {
                             if (columns.next()) {
                                 hasNameColumn = true;
                                 System.out.println("Found name column in doctors table");
                             }
                         }
                     } catch (SQLException e) {
                         System.out.println("Warning: Could not check if name column exists: " + e.getMessage());
                     }

                     if (hasNameColumn) {
                         safeUpdateDoctorField(conn, userId, "name", fullName.trim());
                     } else {
                         System.out.println("Note: name column does not exist in doctors table, skipping update");
                     }
                 } catch (Exception e) {
                     // If this fails, it's not critical - the doctor record was still created
                     System.out.println("Note: Could not update doctor name field: " + e.getMessage());
                 }
             } catch (SQLException e) {
                 System.err.println("Error creating doctor record: " + e.getMessage());
                 e.printStackTrace();
                 throw e; // Re-throw to be handled by the caller
             }

             // Delete the request after approval
             System.out.println("Deleting doctor registration request with ID: " + id + " after approval");

             // Delete the request
             String deleteQuery = "DELETE FROM doctor_registration_requests WHERE id = ?";
             try (PreparedStatement pstmt = conn.prepareStatement(deleteQuery)) {
                 pstmt.setInt(1, id);
                 int rowsAffected = pstmt.executeUpdate();
                 System.out.println("Doctor registration request deleted after approval. Rows affected: " + rowsAffected);

                 if (rowsAffected <= 0) {
                     System.err.println("Warning: Failed to delete request after approval, but user and doctor records were created successfully.");
                     // Don't throw exception here, as the approval was successful
                 }
             }

             // Now we can safely commit the transaction
             conn.commit();
             success = true;
             System.out.println("Transaction committed successfully for doctor approval ID: " + id);

         } catch (SQLException | ClassNotFoundException e) {
             e.printStackTrace();
             System.err.println("Error approving doctor registration request: " + e.getMessage());

             // Print more detailed error information
             if (e instanceof SQLException) {
                 SQLException sqlEx = (SQLException) e;
                 System.err.println("SQL State: " + sqlEx.getSQLState());
                 System.err.println("Error Code: " + sqlEx.getErrorCode());

                 // Print the full stack trace of nested exceptions
                 Throwable cause = sqlEx.getCause();
                 while (cause != null) {
                     System.err.println("Caused by: " + cause.getMessage());
                     cause = cause.getCause();
                 }
             }

             // Rollback the transaction on error
             if (conn != null) {
                 try {
                     conn.rollback();
                     System.err.println("Transaction rolled back successfully");
                 } catch (SQLException rollbackEx) {
                     rollbackEx.printStackTrace();
                     System.err.println("Failed to rollback transaction: " + rollbackEx.getMessage());
                 }
             }
         } finally {
             // Restore auto-commit and close connection
             if (conn != null) {
                 try {
                     conn.setAutoCommit(true);
                     conn.close();
                     System.out.println("Connection closed successfully");
                 } catch (SQLException closeEx) {
                     closeEx.printStackTrace();
                     System.err.println("Error closing connection: " + closeEx.getMessage());
                 }
             }
         }

         return success;
     }

     /**
      * Reject a doctor registration request and delete it from the database
      * This completely removes the request from the doctor_registration_requests table
      * @param id The ID of the request
      * @param adminNotes Admin notes about the rejection (reason for rejection)
      * @return true if the rejection was successful, false otherwise
      */
     public boolean rejectRequest(int id, String adminNotes) {
         // Get the request to make sure it exists
         DoctorRegistrationRequest request = getRequestById(id);
         if (request == null) {
             System.err.println("Doctor registration request not found with ID: " + id);
             return false;
         }

         // Check if the request is already approved or rejected
         if (!"PENDING".equals(request.getStatus())) {
             System.err.println("Cannot reject request with status: " + request.getStatus());
             return false;
         }

         // Delete the request after rejection
         String deleteQuery = "DELETE FROM doctor_registration_requests WHERE id = ?";

         try (Connection conn = DBConnection.getConnection()) {
             // Start transaction
             conn.setAutoCommit(false);

             try {
                 // Log the rejection reason
                 System.out.println("Rejecting doctor registration request with ID: " + id +
                                   ", Reason: " + (adminNotes != null ? adminNotes : "Rejected by admin"));

                 // Delete the request
                 try (PreparedStatement pstmt = conn.prepareStatement(deleteQuery)) {
                     pstmt.setInt(1, id);
                     int rowsAffected = pstmt.executeUpdate();

                     if (rowsAffected > 0) {
                         // Commit the transaction
                         conn.commit();
                         System.out.println("Doctor registration request with ID: " + id + " rejected and deleted successfully");
                         return true;
                     } else {
                         // Rollback if no rows affected
                         conn.rollback();
                         System.err.println("Failed to delete rejected request. No rows affected.");
                         return false;
                     }
                 }
             } catch (SQLException e) {
                 // Rollback on error
                 conn.rollback();
                 System.err.println("Error during request rejection: " + e.getMessage());
                 e.printStackTrace();
                 return false;
             } finally {
                 // Restore auto-commit
                 conn.setAutoCommit(true);
             }
         } catch (SQLException | ClassNotFoundException e) {
             System.err.println("Error rejecting doctor registration request: " + e.getMessage());
             e.printStackTrace();
             return false;
         }
     }

     /**
      * Create a user record in a transaction
      * @param conn The database connection
      * @param user The user to create
      * @return The ID of the created user, or -1 if creation failed
      * @throws SQLException If a database error occurs
      */
     private int createUser(Connection conn, User user) throws SQLException {
         try {
             // Validate required fields
             if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                 throw new SQLException("Email is required for user creation");
             }

             if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                 // Generate a username from email if not provided
                 String emailUsername = user.getEmail().split("@")[0];
                 user.setUsername(emailUsername);
                 System.out.println("Generated username from email: " + user.getUsername());
             }

             if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                 throw new SQLException("Password is required for user creation");
             }

             // First check if the email already exists in the users table
             String checkQuery = "SELECT id FROM users WHERE email = ?";
             try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                 checkStmt.setString(1, user.getEmail());
                 try (ResultSet rs = checkStmt.executeQuery()) {
                     if (rs.next()) {
                         // Email already exists, throw an exception
                         throw new SQLException("Email already exists in the users table: " + user.getEmail());
                     }
                 }
             }

             // Check if username already exists and make it unique if needed
             boolean usernameUnique = false;
             int attempts = 0;
             String originalUsername = user.getUsername();

             while (!usernameUnique && attempts < 5) {
                 String checkUsernameQuery = "SELECT id FROM users WHERE username = ?";
                 try (PreparedStatement checkStmt = conn.prepareStatement(checkUsernameQuery)) {
                     checkStmt.setString(1, user.getUsername());
                     try (ResultSet rs = checkStmt.executeQuery()) {
                         if (!rs.next()) {
                             // Username is unique
                             usernameUnique = true;
                         } else {
                             // Username already exists, make it unique by adding a timestamp or random number
                             user.setUsername(originalUsername + System.currentTimeMillis() + attempts);
                             System.out.println("Username already exists, changed to: " + user.getUsername());
                             attempts++;
                         }
                     }
                 }
             }

             if (!usernameUnique) {
                 throw new SQLException("Could not generate a unique username after multiple attempts");
             }

             // Now insert the user
             String query = "INSERT INTO users (username, email, password, phone, role, first_name, last_name, date_of_birth, gender, address) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

             try (PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
                 pstmt.setString(1, user.getUsername());
                 pstmt.setString(2, user.getEmail());
                 pstmt.setString(3, user.getPassword()); // Already hashed
                 pstmt.setString(4, user.getPhone() != null ? user.getPhone() : "");
                 pstmt.setString(5, user.getRole() != null ? user.getRole() : "DOCTOR");
                 pstmt.setString(6, user.getFirstName() != null ? user.getFirstName() : "");
                 pstmt.setString(7, user.getLastName() != null ? user.getLastName() : "");

                 // Handle date_of_birth
                 if (user.getDateOfBirth() != null && !user.getDateOfBirth().isEmpty()) {
                     try {
                         java.sql.Date sqlDate = java.sql.Date.valueOf(user.getDateOfBirth());
                         pstmt.setDate(8, sqlDate);
                     } catch (IllegalArgumentException e) {
                         System.err.println("Invalid date format for date_of_birth: " + user.getDateOfBirth());
                         pstmt.setNull(8, java.sql.Types.DATE);
                     }
                 } else {
                     pstmt.setNull(8, java.sql.Types.DATE);
                 }

                 // Handle gender (ENUM type in database with values 'Male', 'Female', 'Other')
                 String standardizedGender = standardizeGender(user.getGender());
                 if (standardizedGender != null) {
                     pstmt.setString(9, standardizedGender);
                 } else {
                     pstmt.setNull(9, java.sql.Types.VARCHAR);
                 }
                 pstmt.setString(10, user.getAddress() != null ? user.getAddress() : "");

                 System.out.println("Executing SQL: " + query);
                 System.out.println("With parameters: " + user.getUsername() + ", " + user.getEmail() + ", [PASSWORD], " +
                                   user.getPhone() + ", " + user.getRole() + ", " + user.getFirstName() + ", " +
                                   user.getLastName() + ", " + user.getDateOfBirth() + ", " +
                                   (user.getGender() != null ? user.getGender() : "NULL") + ", " +
                                   (user.getAddress() != null ? user.getAddress() : "NULL"));

                 int rowsAffected = pstmt.executeUpdate();
                 System.out.println("User insert rows affected: " + rowsAffected);

                 if (rowsAffected > 0) {
                     try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                         if (generatedKeys.next()) {
                             int userId = generatedKeys.getInt(1);
                             System.out.println("Generated user ID: " + userId);
                             return userId;
                         }
                     }
                 }

                 System.err.println("Failed to create user: No rows affected or no generated keys");
                 return -1;
             }
         } catch (SQLException e) {
             System.err.println("Error creating user: " + e.getMessage());
             e.printStackTrace();
             throw e; // Re-throw to be handled by the caller
         }
     }

     /**
      * Helper method to standardize gender values to match database ENUM
      * @param gender The gender value to standardize
      * @return Standardized gender value or null if invalid
      */
     private String standardizeGender(String gender) {
         if (gender != null && !gender.isEmpty()) {
             if (gender.equalsIgnoreCase("male") || gender.equalsIgnoreCase("m")) {
                 return "Male";
             } else if (gender.equalsIgnoreCase("female") || gender.equalsIgnoreCase("f")) {
                 return "Female";
             } else if (gender.equalsIgnoreCase("other") || gender.equalsIgnoreCase("o")) {
                 return "Other";
             } else if (gender.equalsIgnoreCase("MALE")) {
                 return "Male";
             } else if (gender.equalsIgnoreCase("FEMALE")) {
                 return "Female";
             } else if (gender.equalsIgnoreCase("OTHER")) {
                 return "Other";
             } else {
                 System.out.println("Invalid gender value: " + gender + ". Setting to NULL.");
                 return null;
             }
         }
         return null;
     }

     /**
      * Helper method to update a single field in the doctors table
      * @param conn The database connection
      * @param userId The user ID of the doctor
      * @param fieldName The name of the field to update
      * @param fieldValue The value to set
      * @throws SQLException If a database error occurs
      */
     private void updateDoctorField(Connection conn, int userId, String fieldName, String fieldValue) throws SQLException {
         // Validate inputs to prevent SQL injection
         if (!isValidColumnName(fieldName)) {
             throw new SQLException("Invalid column name: " + fieldName);
         }

         String updateQuery = "UPDATE doctors SET " + fieldName + " = ? WHERE user_id = ?";
         try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
             pstmt.setString(1, fieldValue);
             pstmt.setInt(2, userId);
             int rowsAffected = pstmt.executeUpdate();
             System.out.println("Updated doctor field: " + fieldName + " = " + fieldValue + ", rows affected: " + rowsAffected);

             if (rowsAffected <= 0) {
                 System.out.println("Warning: No rows affected when updating doctor field: " + fieldName);
             }
         } catch (SQLException e) {
             System.out.println("Failed to update doctor field " + fieldName + ": " + e.getMessage());
             throw e;
         }
     }

     /**
      * Helper method to validate a column name to prevent SQL injection
      * @param columnName The column name to validate
      * @return true if the column name is valid, false otherwise
      */
     private boolean isValidColumnName(String columnName) {
         // Only allow alphanumeric characters and underscores
         return columnName != null && columnName.matches("^[a-zA-Z0-9_]+$");
     }

     /**
      * Helper method to safely update a single field in the doctors table
      * This method doesn't throw an exception if the update fails
      * @param conn The database connection
      * @param userId The user ID of the doctor
      * @param fieldName The name of the field to update
      * @param fieldValue The value to set
      */
     private void safeUpdateDoctorField(Connection conn, int userId, String fieldName, String fieldValue) {
         // Validate the field name first to prevent SQL injection
         if (!isValidColumnName(fieldName)) {
             System.out.println("Warning: Invalid column name: " + fieldName + ", skipping update");
             return;
         }

         // First check if the field exists in the doctors table
         boolean fieldExists = false;
         try {
             // Check if the column exists in the table
             java.sql.DatabaseMetaData dbmd = conn.getMetaData();
             try (ResultSet columns = dbmd.getColumns(null, null, "doctors", fieldName)) {
                 fieldExists = columns.next(); // Will be true if the column exists
             }

             if (fieldExists) {
                 // Field exists, try to update it
                 try {
                     updateDoctorField(conn, userId, fieldName, fieldValue);
                 } catch (SQLException e) {
                     System.out.println("Note: Could not update doctor field " + fieldName + ": " + e.getMessage());
                     // Ignore the exception - this is expected for fields that don't exist
                 }
             } else {
                 System.out.println("Note: Field '" + fieldName + "' does not exist in doctors table, skipping update");
             }
         } catch (SQLException e) {
             System.out.println("Warning: Could not check if field '" + fieldName + "' exists: " + e.getMessage());
             // Try the update anyway as a fallback
             try {
                 updateDoctorField(conn, userId, fieldName, fieldValue);
             } catch (SQLException updateEx) {
                 System.out.println("Note: Could not update doctor field " + fieldName + ": " + updateEx.getMessage());
                 // Ignore the exception - this is expected for fields that don't exist
             }
         }
     }

     /**
      * Map a ResultSet to a DoctorRegistrationRequest object
      * @param rs The ResultSet to map
      * @return The mapped DoctorRegistrationRequest
      * @throws SQLException If a database error occurs
      */
     private DoctorRegistrationRequest mapResultSetToRequest(ResultSet rs) throws SQLException {
         DoctorRegistrationRequest request = new DoctorRegistrationRequest();
         request.setId(rs.getInt("id"));

         // Get username directly from the database
         try {
             String username = rs.getString("username");
             if (username != null && !username.isEmpty()) {
                 request.setUsername(username);
             }
         } catch (SQLException e) {
             // Username field might not exist in older records
             System.out.println("Note: username field not found in result set");
         }

         // Get first_name and last_name directly
         try {
             String firstName = rs.getString("first_name");
             if (firstName != null && !firstName.isEmpty()) {
                 request.setFirstName(firstName);
             }
         } catch (SQLException e) {
             // first_name field might not exist in older records
         }

         try {
             String lastName = rs.getString("last_name");
             if (lastName != null && !lastName.isEmpty()) {
                 request.setLastName(lastName);
             }
         } catch (SQLException e) {
             // last_name field might not exist in older records
         }

         // If we don't have a username yet, use email as a fallback
         if (request.getUsername() == null || request.getUsername().isEmpty()) {
             String email = rs.getString("email");
             if (email != null && !email.isEmpty()) {
                 request.setUsername(email.split("@")[0]);
             }
         }

         request.setEmail(rs.getString("email"));
         request.setPassword(rs.getString("password"));
         request.setPhone(rs.getString("phone"));
         request.setAddress(rs.getString("address"));
         request.setSpecialization(rs.getString("specialization"));
         request.setQualification(rs.getString("qualification"));
         request.setExperience(rs.getString("experience"));
         request.setStatus(rs.getString("status"));

         // These fields might not exist in the table, so handle them safely
         try {
             request.setAdminNotes(rs.getString("admin_notes"));
         } catch (SQLException e) {
             // Ignore - field might not exist
         }

         request.setCreatedAt(rs.getTimestamp("created_at"));
         request.setUpdatedAt(rs.getTimestamp("updated_at"));
         return request;
     }
 }