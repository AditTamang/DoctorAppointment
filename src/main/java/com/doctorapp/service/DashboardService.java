package com.doctorapp.service;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.Patient;
import com.doctorapp.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

// Gets data for the dashboard
public class DashboardService {
    private static final Logger LOGGER = Logger.getLogger(DashboardService.class.getName());

    // Counts how many doctors are in the system
    public int getDoctorCount() {
        String sql = "SELECT COUNT(*) FROM doctors";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting doctor count: " + e.getMessage(), e);
        }
        return 0;
    }

    // Counts how many patients are in the system
    public int getPatientCount() {
        String sql = "SELECT COUNT(*) FROM patients";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting patient count: " + e.getMessage(), e);
        }
        return 0;
    }

    // Counts pending appointment requests
    public int getNewBookingCount() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting new booking count: " + e.getMessage(), e);
        }
        return 0;
    }

    // Counts appointments scheduled for today
    public int getTodaySessionCount() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE appointment_date = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting today's session count: " + e.getMessage(), e);
        }
        return 0;
    }

    // Gets appointments scheduled for the next 7 days
    public List<Appointment> getUpcomingAppointments() {
        List<Appointment> appointments = new ArrayList<>();

        // Get current date and next Friday
        LocalDate today = LocalDate.now();
        LocalDate nextFriday = today.plusDays(7);

        String sql = "SELECT a.id, a.appointment_date, a.appointment_time, a.status, " +
                     "p.id as patient_id, CONCAT(u_p.first_name, ' ', u_p.last_name) as patient_name, " +
                     "d.id as doctor_id, CONCAT(u_d.first_name, ' ', u_d.last_name) as doctor_name " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.id " +
                     "JOIN users u_p ON p.user_id = u_p.id " +
                     "JOIN doctors d ON a.doctor_id = d.id " +
                     "JOIN users u_d ON d.user_id = u_d.id " +
                     "WHERE a.appointment_date BETWEEN ? AND ? " +
                     "ORDER BY a.appointment_date, a.appointment_time " +
                     "LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, java.sql.Date.valueOf(today));
            stmt.setDate(2, java.sql.Date.valueOf(nextFriday));

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDoctorName(rs.getString("doctor_name"));

                appointments.add(appointment);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting upcoming appointments: " + e.getMessage(), e);
        }

        return appointments;
    }

    // Gets the 5 most recently added doctors
    public List<Doctor> getRecentDoctors() {
        List<Doctor> doctors = new ArrayList<>();

        String sql = "SELECT d.id, d.specialization, d.qualification, d.experience, " +
                     "d.consultation_fee, d.profile_image, d.rating, " +
                     "CONCAT(u.first_name, ' ', u.last_name) as name, u.email " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.id " +
                     "ORDER BY d.id DESC LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setName(rs.getString("name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setQualification(rs.getString("qualification"));
                doctor.setExperience(rs.getString("experience"));
                doctor.setConsultationFee(rs.getString("consultation_fee"));
                doctor.setProfileImage(rs.getString("profile_image"));
                doctor.setRating(rs.getDouble("rating"));
                doctor.setEmail(rs.getString("email"));

                doctors.add(doctor);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent doctors: " + e.getMessage(), e);
        }

        return doctors;
    }

    // Gets the 5 most recent patient appointments
    public List<Appointment> getRecentPatientAppointments() {
        List<Appointment> patientAppointments = new ArrayList<>();

        String sql = "SELECT a.id, a.appointment_date, a.status, " +
                     "p.id as patient_id, CONCAT(u_p.first_name, ' ', u_p.last_name) as patient_name, " +
                     "d.id as doctor_id, CONCAT(u_d.first_name, ' ', u_d.last_name) as doctor_name " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.id " +
                     "JOIN users u_p ON p.user_id = u_p.id " +
                     "JOIN doctors d ON a.doctor_id = d.id " +
                     "JOIN users u_d ON d.user_id = u_d.id " +
                     "ORDER BY a.appointment_date DESC " +
                     "LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setStatus(rs.getString("status"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDoctorName(rs.getString("doctor_name"));

                patientAppointments.add(appointment);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent patient appointments: " + e.getMessage(), e);
        }

        return patientAppointments;
    }
}
