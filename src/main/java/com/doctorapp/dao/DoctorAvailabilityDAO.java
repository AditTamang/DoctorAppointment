package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.doctorapp.model.Doctor;
import com.doctorapp.util.DBConnection;

/**
 * Data Access Object for doctor availability
 */
public class DoctorAvailabilityDAO {

    /**
     * Update doctor availability
     * @param doctorId The doctor ID
     * @param availableDays The available days (comma-separated)
     * @param availableTime The available time range
     * @return true if the update was successful, false otherwise
     */
    public boolean updateDoctorAvailability(int doctorId, String availableDays, String availableTime) {
        System.out.println("Updating availability for doctor ID: " + doctorId);
        System.out.println("Available days: " + availableDays);
        System.out.println("Available time: " + availableTime);

        // Validate input parameters
        if (doctorId <= 0) {
            System.err.println("Invalid doctor ID: " + doctorId);
            return false;
        }

        if (availableDays == null || availableDays.trim().isEmpty()) {
            System.err.println("Available days cannot be empty");
            return false;
        }

        if (availableTime == null || availableTime.trim().isEmpty()) {
            System.err.println("Available time cannot be empty");
            return false;
        }

        // First, check if the doctor exists
        boolean doctorExists = checkDoctorExists(doctorId);
        if (!doctorExists) {
            System.err.println("Doctor with ID " + doctorId + " does not exist");
            return false;
        }

        // First, check if the columns exist and what naming convention is used
        String columnNamingQuery = "SHOW COLUMNS FROM doctors";
        boolean hasCamelCase = false;
        boolean hasSnakeCase = false;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(columnNamingQuery);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String columnName = rs.getString("Field");
                if ("availableDays".equalsIgnoreCase(columnName) || "availableTime".equalsIgnoreCase(columnName)) {
                    hasCamelCase = true;
                }
                if ("available_days".equalsIgnoreCase(columnName) || "available_time".equalsIgnoreCase(columnName)) {
                    hasSnakeCase = true;
                }
            }

            System.out.println("Column check - hasCamelCase: " + hasCamelCase + ", hasSnakeCase: " + hasSnakeCase);

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error checking column names: " + e.getMessage());
            e.printStackTrace();
        }

        // If columns don't exist, add them
        if (!hasCamelCase && !hasSnakeCase) {
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {

                // Try to add columns with snake_case naming (more standard)
                try {
                    stmt.executeUpdate("ALTER TABLE doctors ADD COLUMN available_days VARCHAR(255)");
                    stmt.executeUpdate("ALTER TABLE doctors ADD COLUMN available_time VARCHAR(255)");
                    hasSnakeCase = true;
                    System.out.println("Added snake_case columns to doctors table");
                } catch (SQLException e) {
                    System.err.println("Error adding snake_case columns: " + e.getMessage());
                    e.printStackTrace();

                    // Try with camelCase
                    try {
                        stmt.executeUpdate("ALTER TABLE doctors ADD COLUMN availableDays VARCHAR(255)");
                        stmt.executeUpdate("ALTER TABLE doctors ADD COLUMN availableTime VARCHAR(255)");
                        hasCamelCase = true;
                        System.out.println("Added camelCase columns to doctors table");
                    } catch (SQLException innerE) {
                        System.err.println("Error adding camelCase columns: " + innerE.getMessage());
                        innerE.printStackTrace();
                    }
                }

            } catch (SQLException | ClassNotFoundException e) {
                System.err.println("Error altering doctors table: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // Now update the columns based on what naming convention is used
        boolean updateSuccess = false;

        // Try to update both column types regardless of what we detected
        // This ensures we update the right columns even if our detection was wrong

        // Try snake_case first (more common in SQL)
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("UPDATE doctors SET available_days = ?, available_time = ? WHERE id = ?")) {

            pstmt.setString(1, availableDays);
            pstmt.setString(2, availableTime);
            pstmt.setInt(3, doctorId);

            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Rows affected (snake_case): " + rowsAffected);
            if (rowsAffected > 0) {
                updateSuccess = true;
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error updating with snake_case: " + e.getMessage());
            // Continue to try camelCase
        }

        // Try camelCase if snake_case failed
        if (!updateSuccess) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement("UPDATE doctors SET availableDays = ?, availableTime = ? WHERE id = ?")) {

                pstmt.setString(1, availableDays);
                pstmt.setString(2, availableTime);
                pstmt.setInt(3, doctorId);

                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Rows affected (camelCase): " + rowsAffected);
                if (rowsAffected > 0) {
                    updateSuccess = true;
                }

            } catch (SQLException | ClassNotFoundException e) {
                System.err.println("Error updating with camelCase: " + e.getMessage());
                // Continue to try individual field updates
            }
        }

        // If both approaches failed, try updating individual fields
        if (!updateSuccess) {
            updateSuccess = updateIndividualFields(doctorId, availableDays, availableTime);
        }

        // If all else fails, try a direct SQL approach as a last resort
        if (!updateSuccess) {
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {

                // Try both naming conventions
                try {
                    String snakeCaseQuery = "UPDATE doctors SET available_days = '" + availableDays +
                                 "', available_time = '" + availableTime +
                                 "' WHERE id = " + doctorId;
                    int rowsAffected = stmt.executeUpdate(snakeCaseQuery);
                    System.out.println("Rows affected (direct SQL snake_case): " + rowsAffected);
                    if (rowsAffected > 0) {
                        updateSuccess = true;
                    }
                } catch (SQLException e) {
                    System.err.println("Error with direct SQL snake_case update: " + e.getMessage());
                }

                if (!updateSuccess) {
                    try {
                        String camelCaseQuery = "UPDATE doctors SET availableDays = '" + availableDays +
                                     "', availableTime = '" + availableTime +
                                     "' WHERE id = " + doctorId;
                        int rowsAffected = stmt.executeUpdate(camelCaseQuery);
                        System.out.println("Rows affected (direct SQL camelCase): " + rowsAffected);
                        if (rowsAffected > 0) {
                            updateSuccess = true;
                        }
                    } catch (SQLException e) {
                        System.err.println("Error with direct SQL camelCase update: " + e.getMessage());
                    }
                }

            } catch (SQLException | ClassNotFoundException e) {
                System.err.println("Error with direct SQL update: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // Update the Doctor object in the session if the update was successful
        if (updateSuccess) {
            System.out.println("Successfully updated doctor availability");
            // Also update the doctor in DoctorDAO to ensure consistency
            try {
                DoctorDAO doctorDAO = new DoctorDAO();
                Doctor doctor = doctorDAO.getDoctorById(doctorId);
                if (doctor != null) {
                    doctor.setAvailableDays(availableDays);
                    doctor.setAvailableTime(availableTime);
                    doctorDAO.updateDoctor(doctor);
                }
            } catch (Exception e) {
                System.err.println("Error updating doctor in DoctorDAO: " + e.getMessage());
                // Don't fail the operation if this fails
            }
        } else {
            System.err.println("Failed to update doctor availability");
        }

        return updateSuccess;
    }

    /**
     * Check if a doctor exists in the database
     * @param doctorId The doctor ID
     * @return true if the doctor exists, false otherwise
     */
    private boolean checkDoctorExists(int doctorId) {
        String query = "SELECT COUNT(*) FROM doctors WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, doctorId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error checking if doctor exists: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Update individual fields for doctor availability
     * @param doctorId The doctor ID
     * @param availableDays The available days
     * @param availableTime The available time
     * @return true if at least one field was updated successfully
     */
    private boolean updateIndividualFields(int doctorId, String availableDays, String availableTime) {
        boolean success = false;

        try (Connection conn = DBConnection.getConnection()) {
            // Try to update available_days (snake_case)
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE doctors SET available_days = ? WHERE id = ?");
                pstmt.setString(1, availableDays);
                pstmt.setInt(2, doctorId);
                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Updated available_days: " + rowsAffected + " rows affected");
                if (rowsAffected > 0) success = true;
            } catch (SQLException e) {
                System.err.println("Error updating available_days: " + e.getMessage());
            }

            // Try to update availableDays (camelCase)
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE doctors SET availableDays = ? WHERE id = ?");
                pstmt.setString(1, availableDays);
                pstmt.setInt(2, doctorId);
                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Updated availableDays: " + rowsAffected + " rows affected");
                if (rowsAffected > 0) success = true;
            } catch (SQLException e) {
                System.err.println("Error updating availableDays: " + e.getMessage());
            }

            // Try to update available_time (snake_case)
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE doctors SET available_time = ? WHERE id = ?");
                pstmt.setString(1, availableTime);
                pstmt.setInt(2, doctorId);
                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Updated available_time: " + rowsAffected + " rows affected");
                if (rowsAffected > 0) success = true;
            } catch (SQLException e) {
                System.err.println("Error updating available_time: " + e.getMessage());
            }

            // Try to update availableTime (camelCase)
            try {
                PreparedStatement pstmt = conn.prepareStatement("UPDATE doctors SET availableTime = ? WHERE id = ?");
                pstmt.setString(1, availableTime);
                pstmt.setInt(2, doctorId);
                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Updated availableTime: " + rowsAffected + " rows affected");
                if (rowsAffected > 0) success = true;
            } catch (SQLException e) {
                System.err.println("Error updating availableTime: " + e.getMessage());
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error in updateIndividualFields: " + e.getMessage());
            e.printStackTrace();
        }

        return success;
    }

    /**
     * Toggle doctor status (ACTIVE/INACTIVE)
     * @param doctorId The doctor ID
     * @return The new status or null if the update failed
     */
    public String toggleDoctorStatus(int doctorId) {
        // First, get the current status
        String currentStatus = null;
        String getStatusQuery = "SELECT status FROM doctors WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(getStatusQuery)) {

            pstmt.setInt(1, doctorId);

            try (var rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    currentStatus = rs.getString("status");
                }
            }

            if (currentStatus == null) {
                currentStatus = "ACTIVE"; // Default status
            }

            System.out.println("Current doctor status: " + currentStatus);

            // Toggle the status
            String newStatus = "ACTIVE".equals(currentStatus) ? "INACTIVE" : "ACTIVE";
            System.out.println("New doctor status will be: " + newStatus);

            // Update the status
            String updateQuery = "UPDATE doctors SET status = ? WHERE id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                updateStmt.setString(1, newStatus);
                updateStmt.setInt(2, doctorId);

                int rowsAffected = updateStmt.executeUpdate();
                System.out.println("Status update affected " + rowsAffected + " rows");

                if (rowsAffected > 0) {
                    // Also update the doctor in DoctorDAO to ensure consistency
                    try {
                        DoctorDAO doctorDAO = new DoctorDAO();
                        var doctor = doctorDAO.getDoctorById(doctorId);
                        if (doctor != null) {
                            doctor.setStatus(newStatus);
                            boolean updated = doctorDAO.updateDoctor(doctor);
                            System.out.println("Updated doctor status in DoctorDAO: " + updated);
                        }
                    } catch (Exception e) {
                        System.err.println("Error updating doctor status in DoctorDAO: " + e.getMessage());
                        // Don't fail the operation if this fails
                    }

                    return newStatus;
                }
            }

            // If the standard update fails, try a direct SQL approach
            if (currentStatus != null) {
                try (Statement stmt = conn.createStatement()) {
                    String directSql = "UPDATE doctors SET status = '" + newStatus + "' WHERE id = " + doctorId;
                    int directRowsAffected = stmt.executeUpdate(directSql);
                    System.out.println("Direct SQL status update affected " + directRowsAffected + " rows");

                    if (directRowsAffected > 0) {
                        return newStatus;
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error toggling doctor status: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
}
