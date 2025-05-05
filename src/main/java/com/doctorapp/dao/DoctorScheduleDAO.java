package com.doctorapp.dao;

import com.doctorapp.model.DoctorSchedule;
import com.doctorapp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for doctor schedules
 */
public class DoctorScheduleDAO {

    /**
     * Add a new schedule for a doctor
     * @param schedule The schedule to add
     * @return true if successful, false otherwise
     */
    public boolean addSchedule(DoctorSchedule schedule) {
        String query = "INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, " +
                "break_start_time, break_end_time, max_appointments) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, schedule.getDoctorId());
            pstmt.setString(2, schedule.getDayOfWeek());
            pstmt.setTime(3, schedule.getStartTime());
            pstmt.setTime(4, schedule.getEndTime());
            pstmt.setTime(5, schedule.getBreakStartTime());
            pstmt.setTime(6, schedule.getBreakEndTime());
            pstmt.setInt(7, schedule.getMaxAppointments());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update an existing doctor schedule
     * @param schedule The schedule to update
     * @return true if successful, false otherwise
     */
    public boolean updateSchedule(DoctorSchedule schedule) {
        String query = "UPDATE doctor_schedules SET day_of_week = ?, start_time = ?, end_time = ?, " +
                "break_start_time = ?, break_end_time = ?, max_appointments = ? " +
                "WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, schedule.getDayOfWeek());
            pstmt.setTime(2, schedule.getStartTime());
            pstmt.setTime(3, schedule.getEndTime());
            pstmt.setTime(4, schedule.getBreakStartTime());
            pstmt.setTime(5, schedule.getBreakEndTime());
            pstmt.setInt(6, schedule.getMaxAppointments());
            pstmt.setInt(7, schedule.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a doctor schedule
     * @param scheduleId The ID of the schedule to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteSchedule(int scheduleId) {
        String query = "DELETE FROM doctor_schedules WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, scheduleId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get a doctor schedule by ID
     * @param scheduleId The ID of the schedule to retrieve
     * @return The schedule if found, null otherwise
     */
    public DoctorSchedule getScheduleById(int scheduleId) {
        String query = "SELECT * FROM doctor_schedules WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, scheduleId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSchedule(rs);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get all schedules for a doctor
     * @param doctorId The ID of the doctor
     * @return List of schedules for the doctor
     */
    public List<DoctorSchedule> getSchedulesByDoctorId(int doctorId) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String query = "SELECT * FROM doctor_schedules WHERE doctor_id = ? ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, doctorId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapResultSetToSchedule(rs));
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return schedules;
    }

    /**
     * Check if a doctor has a schedule for a specific day
     * @param doctorId The ID of the doctor
     * @param dayOfWeek The day of the week
     * @return true if a schedule exists, false otherwise
     */
    public boolean hasScheduleForDay(int doctorId, String dayOfWeek) {
        String query = "SELECT COUNT(*) FROM doctor_schedules WHERE doctor_id = ? AND day_of_week = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, doctorId);
            pstmt.setString(2, dayOfWeek);

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
     * Get a doctor's schedule for a specific day
     * @param doctorId The ID of the doctor
     * @param dayOfWeek The day of the week
     * @return The schedule if found, null otherwise
     */
    public DoctorSchedule getScheduleForDay(int doctorId, String dayOfWeek) {
        String query = "SELECT * FROM doctor_schedules WHERE doctor_id = ? AND day_of_week = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, doctorId);
            pstmt.setString(2, dayOfWeek);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSchedule(rs);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Map a ResultSet to a DoctorSchedule object
     * @param rs The ResultSet to map
     * @return The mapped DoctorSchedule object
     * @throws SQLException If an error occurs while accessing the ResultSet
     */
    private DoctorSchedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        DoctorSchedule schedule = new DoctorSchedule();
        schedule.setId(rs.getInt("id"));
        schedule.setDoctorId(rs.getInt("doctor_id"));
        schedule.setDayOfWeek(rs.getString("day_of_week"));
        schedule.setStartTime(rs.getTime("start_time"));
        schedule.setEndTime(rs.getTime("end_time"));
        schedule.setBreakStartTime(rs.getTime("break_start_time"));
        schedule.setBreakEndTime(rs.getTime("break_end_time"));
        schedule.setMaxAppointments(rs.getInt("max_appointments"));
        
        // Set created_at and updated_at if they exist in the ResultSet
        try {
            schedule.setCreatedAt(rs.getTimestamp("created_at"));
            schedule.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) {
            // Ignore if these columns don't exist
        }
        
        return schedule;
    }
}
