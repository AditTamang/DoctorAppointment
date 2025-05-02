package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.doctorapp.model.User;
import com.doctorapp.util.DBConnection;
import com.doctorapp.util.PasswordHasher;

public class UserDAO {

    // Check if email already exists
    public boolean emailExists(String email) {
        String query = "SELECT COUNT(*) FROM users WHERE email = ?";

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

    // Register a new user
    public boolean registerUser(User user) {
        // First check if email already exists
        if (emailExists(user.getEmail())) {
            // Email already exists, return false
            return false;
        }

        String query = "INSERT INTO users (username, email, password, phone, role, first_name, last_name, date_of_birth, gender, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            // Hash the password
            String hashedPassword = PasswordHasher.hashPassword(user.getPassword());

            // Split username into first and last name if not provided
            if ((user.getFirstName() == null || user.getFirstName().isEmpty()) &&
                (user.getLastName() == null || user.getLastName().isEmpty())) {
                String[] nameParts = user.getUsername().split(" ", 2);
                user.setFirstName(nameParts[0]);
                user.setLastName(nameParts.length > 1 ? nameParts[1] : "");
            }

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, hashedPassword);
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

            // Handle gender (ENUM type in database)
            pstmt.setString(9, user.getGender());

            // Handle address
            pstmt.setString(10, user.getAddress());

            int rowsAffected = pstmt.executeUpdate();

            // Get the generated user ID
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                    }
                }
            }

            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Authenticate user
    public User login(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // Get the stored hash
                String storedHash = rs.getString("password");

                // Verify the password
                if (PasswordHasher.verifyPassword(password, storedHash)) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    // Don't set the password in the user object for security
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    // Get optional fields if they exist
                    try {
                        user.setDateOfBirth(rs.getString("date_of_birth"));
                        user.setGender(rs.getString("gender"));
                        user.setAddress(rs.getString("address"));
                    } catch (SQLException e) {
                        // These fields might not be available in all queries
                    }

                    return user;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get user by email
    public User getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                // Don't set the password in the user object for security
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                // Get optional fields if they exist
                try {
                    user.setDateOfBirth(rs.getString("date_of_birth"));
                    user.setGender(rs.getString("gender"));
                    user.setAddress(rs.getString("address"));
                } catch (SQLException e) {
                    // These fields might not be available in all queries
                }

                return user;
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get user by ID
    public User getUserById(int id) {
        String query = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                // Don't set the password in the user object for security
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                // Get optional fields if they exist
                try {
                    user.setDateOfBirth(rs.getString("date_of_birth"));
                    user.setGender(rs.getString("gender"));
                    user.setAddress(rs.getString("address"));
                } catch (SQLException e) {
                    // These fields might not be available in all queries
                }

                return user;
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                // Don't set the password in the user object for security
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                // Get optional fields if they exist
                try {
                    user.setDateOfBirth(rs.getString("date_of_birth"));
                    user.setGender(rs.getString("gender"));
                    user.setAddress(rs.getString("address"));
                } catch (SQLException e) {
                    // These fields might not be available in all queries
                }

                users.add(user);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return users;
    }

    // Update user
    public boolean updateUser(User user) {
        // Check if password is being updated
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            String query = "UPDATE users SET username = ?, email = ?, password = ?, phone = ?, role = ?, first_name = ?, last_name = ? WHERE id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                // Hash the password
                String hashedPassword = PasswordHasher.hashPassword(user.getPassword());

                pstmt.setString(1, user.getUsername());
                pstmt.setString(2, user.getEmail());
                pstmt.setString(3, hashedPassword);
                pstmt.setString(4, user.getPhone());
                pstmt.setString(5, user.getRole());
                pstmt.setString(6, user.getFirstName());
                pstmt.setString(7, user.getLastName());
                pstmt.setInt(8, user.getId());

                int rowsAffected = pstmt.executeUpdate();
                return rowsAffected > 0;

            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                return false;
            }
        } else {
            // Update without changing password
            String query = "UPDATE users SET username = ?, email = ?, phone = ?, role = ?, first_name = ?, last_name = ? WHERE id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                pstmt.setString(1, user.getUsername());
                pstmt.setString(2, user.getEmail());
                pstmt.setString(3, user.getPhone());
                pstmt.setString(4, user.getRole());
                pstmt.setString(5, user.getFirstName());
                pstmt.setString(6, user.getLastName());
                pstmt.setInt(7, user.getId());

                int rowsAffected = pstmt.executeUpdate();
                return rowsAffected > 0;

            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    // Save patient details
    public boolean savePatientDetails(int userId, String dateOfBirth, String gender, String address, String bloodGroup, String allergies) {
        // First get the user
        User user = getUserById(userId);
        if (user == null) {
            System.out.println("User not found with ID: " + userId);
            return false;
        }

        Connection conn = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // First update the user table with date_of_birth, gender, and address
            String updateUserQuery = "UPDATE users SET date_of_birth = ?, gender = ?, address = ? WHERE id = ?";

            try (PreparedStatement pstmt = conn.prepareStatement(updateUserQuery)) {
                // Convert dateOfBirth string to SQL Date if not null or empty
                if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                    try {
                        java.sql.Date sqlDate = java.sql.Date.valueOf(dateOfBirth);
                        pstmt.setDate(1, sqlDate);
                    } catch (IllegalArgumentException e) {
                        // If date format is invalid, set it to null
                        pstmt.setNull(1, java.sql.Types.DATE);
                    }
                } else {
                    pstmt.setNull(1, java.sql.Types.DATE);
                }

                pstmt.setString(2, gender);
                pstmt.setString(3, address);
                pstmt.setInt(4, userId);

                int userUpdateResult = pstmt.executeUpdate();
                System.out.println("User update result: " + userUpdateResult);
            }

            // Check if patient record already exists
            boolean patientExists = false;
            try (PreparedStatement checkStmt = conn.prepareStatement("SELECT COUNT(*) FROM patients WHERE user_id = ?")) {
                checkStmt.setInt(1, userId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        patientExists = rs.getInt(1) > 0;
                    }
                }
            }

            int patientResult;
            if (patientExists) {
                // Update existing patient record
                String updateQuery = "UPDATE patients SET blood_group = ?, allergies = ? WHERE user_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
                    pstmt.setString(1, bloodGroup);
                    pstmt.setString(2, allergies);
                    pstmt.setInt(3, userId);
                    patientResult = pstmt.executeUpdate();
                }
            } else {
                // Insert new patient record
                String insertQuery = "INSERT INTO patients (user_id, blood_group, allergies) VALUES (?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertQuery)) {
                    pstmt.setInt(1, userId);
                    pstmt.setString(2, bloodGroup);
                    pstmt.setString(3, allergies);
                    patientResult = pstmt.executeUpdate();
                }
            }

            System.out.println("Patient record " + (patientExists ? "update" : "insert") + " result: " + patientResult);

            // Commit the transaction
            conn.commit();
            success = true;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error saving patient details: " + e.getMessage());
            e.printStackTrace();

            // Rollback the transaction on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("Error rolling back transaction: " + rollbackEx.getMessage());
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
                    System.err.println("Error closing connection: " + closeEx.getMessage());
                    closeEx.printStackTrace();
                }
            }
        }

        return success;
    }

    // Save doctor details
    public boolean saveDoctorDetails(int userId, String specialization, String qualification, String experience, String address, String bio) {
        // First get the user
        User user = getUserById(userId);
        if (user == null) {
            System.out.println("User not found with ID: " + userId);
            return false;
        }

        Connection conn = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // First update the user table with address
            String updateUserQuery = "UPDATE users SET address = ? WHERE id = ?";

            try (PreparedStatement pstmt = conn.prepareStatement(updateUserQuery)) {
                pstmt.setString(1, address);
                pstmt.setInt(2, userId);

                int userUpdateResult = pstmt.executeUpdate();
                System.out.println("User update result: " + userUpdateResult);
            }

            // Check if doctor record already exists
            boolean doctorExists = false;
            try (PreparedStatement checkStmt = conn.prepareStatement("SELECT COUNT(*) FROM doctors WHERE user_id = ?")) {
                checkStmt.setInt(1, userId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        doctorExists = rs.getInt(1) > 0;
                    }
                }
            }

            int doctorResult;
            int experienceInt = 0;
            try {
                experienceInt = Integer.parseInt(experience);
            } catch (NumberFormatException e) {
                System.err.println("Invalid experience value: " + experience + ". Using 0 instead.");
            }

            if (doctorExists) {
                // Update existing doctor record
                String updateQuery = "UPDATE doctors SET specialization = ?, qualification = ?, experience = ?, bio = ? WHERE user_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
                    pstmt.setString(1, specialization);
                    pstmt.setString(2, qualification);
                    pstmt.setInt(3, experienceInt);
                    pstmt.setString(4, bio);
                    pstmt.setInt(5, userId);
                    doctorResult = pstmt.executeUpdate();
                }
            } else {
                // Insert new doctor record
                String insertQuery = "INSERT INTO doctors (user_id, specialization, qualification, experience, bio) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertQuery)) {
                    pstmt.setInt(1, userId);
                    pstmt.setString(2, specialization);
                    pstmt.setString(3, qualification);
                    pstmt.setInt(4, experienceInt);
                    pstmt.setString(5, bio);
                    doctorResult = pstmt.executeUpdate();
                }
            }

            System.out.println("Doctor record " + (doctorExists ? "update" : "insert") + " result: " + doctorResult);

            // Commit the transaction
            conn.commit();
            success = true;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error saving doctor details: " + e.getMessage());
            e.printStackTrace();

            // Rollback the transaction on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("Error rolling back transaction: " + rollbackEx.getMessage());
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
                    System.err.println("Error closing connection: " + closeEx.getMessage());
                    closeEx.printStackTrace();
                }
            }
        }

        return success;
    }

    // Delete user
    public boolean deleteUser(int id) {
        String query = "DELETE FROM users WHERE id = ?";

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

    /**
     * Check if a doctor is approved
     * @param userId The user ID of the doctor
     * @return true if the doctor is approved, false otherwise
     */
    public boolean isDoctorApproved(int userId) {
        if (userId <= 0) {
            System.out.println("Invalid user ID provided for doctor approval check: " + userId);
            return false;
        }

        try {
            // First check if the user exists and is a doctor
            User user = getUserById(userId);
            if (user == null) {
                System.out.println("User not found with ID: " + userId);
                return false;
            }

            if (!"DOCTOR".equals(user.getRole())) {
                System.out.println("User is not a doctor. User ID: " + userId + ", Role: " + user.getRole());
                return false;
            }

            // Simply check if the doctor record exists in the doctors table
            // If it exists, the doctor is considered approved
            String checkQuery = "SELECT 1 FROM doctors WHERE user_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {

                checkStmt.setInt(1, userId);
                try (ResultSet checkRs = checkStmt.executeQuery()) {
                    boolean exists = checkRs.next();
                    System.out.println("Doctor record exists for user ID " + userId + ": " + exists);
                    return exists;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error checking doctor approval status: " + e.getMessage());
            e.printStackTrace();
            // In case of error, default to not approved for safety
            return false;
        } catch (Exception e) {
            System.err.println("Unexpected error checking doctor approval status: " + e.getMessage());
            e.printStackTrace();
            // In case of any other error, default to not approved for safety
            return false;
        }
    }
}
