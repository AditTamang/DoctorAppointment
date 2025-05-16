package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error checking column names: " + e.getMessage());
        }

        // If columns don't exist, add them
        if (!hasCamelCase && !hasSnakeCase) {
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {

                // Try to add columns with camelCase naming
                try {
                    stmt.executeUpdate("ALTER TABLE doctors ADD COLUMN availableDays VARCHAR(255)");
                    stmt.executeUpdate("ALTER TABLE doctors ADD COLUMN availableTime VARCHAR(255)");
                    hasCamelCase = true;
                    System.out.println("Added camelCase columns to doctors table");
                } catch (SQLException e) {
                    System.err.println("Error adding camelCase columns: " + e.getMessage());

                    // Try with snake_case
                    try {
                        stmt.executeUpdate("ALTER TABLE doctors ADD COLUMN available_days VARCHAR(255)");
                        stmt.executeUpdate("ALTER TABLE doctors ADD COLUMN available_time VARCHAR(255)");
                        hasSnakeCase = true;
                        System.out.println("Added snake_case columns to doctors table");
                    } catch (SQLException innerE) {
                        System.err.println("Error adding snake_case columns: " + innerE.getMessage());
                    }
                }

            } catch (SQLException | ClassNotFoundException e) {
                System.err.println("Error altering doctors table: " + e.getMessage());
            }
        }

        // Now update the columns based on what naming convention is used
        boolean updateSuccess = false;

        if (hasCamelCase) {
            String query = "UPDATE doctors SET availableDays = ?, availableTime = ? WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                pstmt.setString(1, availableDays);
                pstmt.setString(2, availableTime);
                pstmt.setInt(3, doctorId);

                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Rows affected (camelCase): " + rowsAffected);
                updateSuccess = rowsAffected > 0;

            } catch (SQLException | ClassNotFoundException e) {
                System.err.println("Error updating with camelCase: " + e.getMessage());
            }
        }

        if (!updateSuccess && hasSnakeCase) {
            String query = "UPDATE doctors SET available_days = ?, available_time = ? WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {

                pstmt.setString(1, availableDays);
                pstmt.setString(2, availableTime);
                pstmt.setInt(3, doctorId);

                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Rows affected (snake_case): " + rowsAffected);
                updateSuccess = rowsAffected > 0;

            } catch (SQLException | ClassNotFoundException e) {
                System.err.println("Error updating with snake_case: " + e.getMessage());
            }
        }

        // If all else fails, try a direct SQL approach
        if (!updateSuccess) {
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {

                String directQuery;
                if (hasCamelCase) {
                    directQuery = "UPDATE doctors SET availableDays = '" + availableDays +
                                 "', availableTime = '" + availableTime +
                                 "' WHERE id = " + doctorId;
                } else {
                    directQuery = "UPDATE doctors SET available_days = '" + availableDays +
                                 "', available_time = '" + availableTime +
                                 "' WHERE id = " + doctorId;
                }

                int rowsAffected = stmt.executeUpdate(directQuery);
                System.out.println("Rows affected (direct SQL): " + rowsAffected);
                updateSuccess = rowsAffected > 0;

            } catch (SQLException | ClassNotFoundException e) {
                System.err.println("Error with direct SQL update: " + e.getMessage());
            }
        }

        return updateSuccess;
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

            // Toggle the status
            String newStatus = "ACTIVE".equals(currentStatus) ? "INACTIVE" : "ACTIVE";

            // Update the status
            String updateQuery = "UPDATE doctors SET status = ? WHERE id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                updateStmt.setString(1, newStatus);
                updateStmt.setInt(2, doctorId);

                int rowsAffected = updateStmt.executeUpdate();
                if (rowsAffected > 0) {
                    return newStatus;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error toggling doctor status: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
}
