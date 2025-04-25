package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.Date;
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
        String query = "INSERT INTO doctor_registration_requests (username, email, password, first_name, last_name, " +
                "phone, date_of_birth, gender, address, specialization, qualification, experience, bio, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            // Hash the password
            String hashedPassword = PasswordHasher.hashPassword(request.getPassword());

            pstmt.setString(1, request.getUsername());
            pstmt.setString(2, request.getEmail());
            pstmt.setString(3, hashedPassword);
            pstmt.setString(4, request.getFirstName());
            pstmt.setString(5, request.getLastName());
            pstmt.setString(6, request.getPhone());

            // Handle date_of_birth (DATE type in database)
            if (request.getDateOfBirth() != null && !request.getDateOfBirth().isEmpty()) {
                try {
                    java.sql.Date sqlDate = java.sql.Date.valueOf(request.getDateOfBirth());
                    pstmt.setDate(7, sqlDate);
                } catch (IllegalArgumentException e) {
                    // If date format is invalid, set it to null
                    pstmt.setNull(7, java.sql.Types.DATE);
                }
            } else {
                pstmt.setNull(7, java.sql.Types.DATE);
            }

            pstmt.setString(8, request.getGender());
            pstmt.setString(9, request.getAddress());
            pstmt.setString(10, request.getSpecialization());
            pstmt.setString(11, request.getQualification());
            pstmt.setString(12, request.getExperience());
            pstmt.setString(13, request.getBio());

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
     * Approve a doctor registration request and create the user and doctor records
     * Then delete the request from doctor_registration_requests table
     * @param id The ID of the request
     * @param adminNotes Admin notes about the approval
     * @return true if the approval was successful, false otherwise
     */
    public boolean approveRequest(int id, String adminNotes) {
        // Get the request
        DoctorRegistrationRequest request = getRequestById(id);
        if (request == null) {
            return false;
        }

        Connection conn = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Create user record
            User user = new User();
            user.setUsername(request.getUsername());
            user.setEmail(request.getEmail());
            user.setPassword(request.getPassword()); // Already hashed in the request
            user.setPhone(request.getPhone());
            user.setRole("DOCTOR");
            user.setFirstName(request.getFirstName());
            user.setLastName(request.getLastName());
            user.setDateOfBirth(request.getDateOfBirth());
            user.setGender(request.getGender());
            user.setAddress(request.getAddress());

            int userId = createUser(conn, user);
            if (userId <= 0) {
                throw new SQLException("Failed to create user record");
            }

            // Create doctor record
            String doctorQuery = "INSERT INTO doctors (user_id, specialization, qualification, experience, bio) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(doctorQuery)) {
                pstmt.setInt(1, userId);
                pstmt.setString(2, request.getSpecialization());
                pstmt.setString(3, request.getQualification());
                pstmt.setString(4, request.getExperience());
                pstmt.setString(5, request.getBio());
                pstmt.executeUpdate();
            }

            // Delete the request from doctor_registration_requests table
            String deleteQuery = "DELETE FROM doctor_registration_requests WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(deleteQuery)) {
                pstmt.setInt(1, id);
                pstmt.executeUpdate();
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

    /**
     * Reject a doctor registration request and delete it from the database
     * @param id The ID of the request
     * @param adminNotes Admin notes about the rejection (not used since the request is deleted)
     * @return true if the rejection was successful, false otherwise
     */
    public boolean rejectRequest(int id, String adminNotes) {
        // Get the request to make sure it exists
        DoctorRegistrationRequest request = getRequestById(id);
        if (request == null) {
            return false;
        }

        // Delete the request directly
        String deleteQuery = "DELETE FROM doctor_registration_requests WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(deleteQuery)) {

            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
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
        String query = "INSERT INTO users (username, email, password, phone, role, first_name, last_name, date_of_birth, gender, address) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword()); // Already hashed
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getRole());
            pstmt.setString(6, user.getFirstName());
            pstmt.setString(7, user.getLastName());

            // Handle date_of_birth (DATE type in database)
            if (user.getDateOfBirth() != null && !user.getDateOfBirth().isEmpty()) {
                try {
                    java.sql.Date sqlDate = java.sql.Date.valueOf(user.getDateOfBirth());
                    pstmt.setDate(8, sqlDate);
                } catch (IllegalArgumentException e) {
                    // If date format is invalid, set it to null
                    pstmt.setNull(8, java.sql.Types.DATE);
                }
            } else {
                pstmt.setNull(8, java.sql.Types.DATE);
            }

            pstmt.setString(9, user.getGender());
            pstmt.setString(10, user.getAddress());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        }

        return -1;
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
        request.setUsername(rs.getString("username"));
        request.setEmail(rs.getString("email"));
        request.setPassword(rs.getString("password"));
        request.setFirstName(rs.getString("first_name"));
        request.setLastName(rs.getString("last_name"));
        request.setPhone(rs.getString("phone"));

        // Handle date_of_birth (DATE type in database)
        Date dateOfBirth = rs.getDate("date_of_birth");
        if (dateOfBirth != null) {
            request.setDateOfBirth(dateOfBirth.toString());
        }

        request.setGender(rs.getString("gender"));
        request.setAddress(rs.getString("address"));
        request.setSpecialization(rs.getString("specialization"));
        request.setQualification(rs.getString("qualification"));
        request.setExperience(rs.getString("experience"));
        request.setBio(rs.getString("bio"));
        request.setStatus(rs.getString("status"));
        request.setAdminNotes(rs.getString("admin_notes"));
        request.setCreatedAt(rs.getTimestamp("created_at"));
        request.setUpdatedAt(rs.getTimestamp("updated_at"));
        return request;
    }
}
