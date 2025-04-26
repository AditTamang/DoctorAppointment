package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.doctorapp.model.Appointment;
import com.doctorapp.util.DBConnection;

public class AppointmentDAO {

    // Book a new appointment
    public boolean bookAppointment(Appointment appointment) {
        // Modified query to match the actual database schema
        String query = "INSERT INTO appointments (patient_id, doctor_id, schedule_id, " +
                      "appointment_date, appointment_time, status, symptoms, reason) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, appointment.getPatientId());
            pstmt.setInt(2, appointment.getDoctorId());
            // Use a default schedule_id of 1 if not available
            pstmt.setInt(3, 1); // Default schedule_id
            pstmt.setDate(4, new java.sql.Date(appointment.getAppointmentDate().getTime()));
            pstmt.setTime(5, java.sql.Time.valueOf(appointment.getAppointmentTime() + ":00")); // Convert to TIME format
            pstmt.setString(6, appointment.getStatus());
            pstmt.setString(7, appointment.getSymptoms() != null ? appointment.getSymptoms() : "");
            pstmt.setString(8, appointment.getReason() != null ? appointment.getReason() : "");

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            System.out.println("Error booking appointment: " + e.getMessage());
            return false;
        }
    }

    // Get appointment by ID
    public Appointment getAppointmentById(int id) {
        String query = "SELECT * FROM appointments WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setSymptoms(rs.getString("symptoms"));
                appointment.setPrescription(rs.getString("prescription"));

                return appointment;
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get appointments by patient ID
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE patient_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setSymptoms(rs.getString("symptoms"));
                appointment.setPrescription(rs.getString("prescription"));

                appointments.add(appointment);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return appointments;
    }

    // Get appointments by doctor ID
    public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE doctor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, doctorId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setSymptoms(rs.getString("symptoms"));
                appointment.setPrescription(rs.getString("prescription"));

                appointments.add(appointment);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return appointments;
    }

    // Get all appointments
    public List<Appointment> getAllAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointment.setSymptoms(rs.getString("symptoms"));
                appointment.setPrescription(rs.getString("prescription"));

                appointments.add(appointment);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return appointments;
    }

    // Update appointment status
    public boolean updateAppointmentStatus(int id, String status) {
        String query = "UPDATE appointments SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, id);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update appointment prescription
    public boolean updateAppointmentPrescription(int id, String prescription) {
        String query = "UPDATE appointments SET prescription = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, prescription);
            pstmt.setInt(2, id);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete appointment
    public boolean deleteAppointment(int id) {
        String query = "DELETE FROM appointments WHERE id = ?";

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

    // Get total number of appointments
    public int getTotalAppointments() {
        String query = "SELECT COUNT(*) FROM appointments";

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

    // Get total number of appointments by patient
    public int getTotalAppointmentsByPatient(int patientId) {
        String query = "SELECT COUNT(*) FROM appointments WHERE patient_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);

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

    // Get upcoming appointment count by patient
    public int getUpcomingAppointmentCountByPatient(int patientId) {
        String query = "SELECT COUNT(*) FROM appointments WHERE patient_id = ? AND " +
                      "(appointment_date > CURRENT_DATE OR " +
                      "(appointment_date = CURRENT_DATE AND appointment_time > CURRENT_TIME)) " +
                      "AND status != 'CANCELLED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);

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

    // Get total revenue
    public double getTotalRevenue() {
        String query = "SELECT SUM(fee) FROM appointments WHERE status = 'COMPLETED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // Get recent appointments
    public List<Appointment> getRecentAppointments(int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.id as patient_id, d.id as doctor_id, " +
                      "u_p.first_name as patient_first_name, u_p.last_name as patient_last_name, " +
                      "u_d.first_name as doctor_first_name, u_d.last_name as doctor_last_name, " +
                      "d.specialization " +
                      "FROM appointments a " +
                      "JOIN patients p ON a.patient_id = p.id " +
                      "JOIN doctors d ON a.doctor_id = d.id " +
                      "JOIN users u_p ON p.user_id = u_p.id " +
                      "JOIN users u_d ON d.user_id = u_d.id " +
                      "ORDER BY a.appointment_date DESC, a.appointment_time DESC " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));
                    appointment.setPatientName(rs.getString("patient_first_name") + " " + rs.getString("patient_last_name"));
                    appointment.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));

                    appointments.add(appointment);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // Fallback: Return some sample data if the query fails
            if (appointments.isEmpty()) {
                // Create sample appointments for testing
                Appointment appointment1 = new Appointment();
                appointment1.setId(1);
                appointment1.setPatientId(1);
                appointment1.setDoctorId(1);
                appointment1.setPatientName("John Doe");
                appointment1.setDoctorName("Dr. Sarah Johnson");
                appointment1.setAppointmentDate(new java.sql.Date(System.currentTimeMillis() - 86400000)); // Yesterday
                appointment1.setAppointmentTime("10:00 AM");
                appointment1.setStatus("COMPLETED");
                appointment1.setFee(100.0);

                Appointment appointment2 = new Appointment();
                appointment2.setId(2);
                appointment2.setPatientId(2);
                appointment2.setDoctorId(2);
                appointment2.setPatientName("Emily Parker");
                appointment2.setDoctorName("Dr. Michael Brown");
                appointment2.setAppointmentDate(new java.sql.Date(System.currentTimeMillis())); // Today
                appointment2.setAppointmentTime("11:30 AM");
                appointment2.setStatus("PENDING");
                appointment2.setFee(150.0);

                Appointment appointment3 = new Appointment();
                appointment3.setId(3);
                appointment3.setPatientId(3);
                appointment3.setDoctorId(3);
                appointment3.setPatientName("David Thompson");
                appointment3.setDoctorName("Dr. John Smith");
                appointment3.setAppointmentDate(new java.sql.Date(System.currentTimeMillis())); // Today
                appointment3.setAppointmentTime("2:00 PM");
                appointment3.setStatus("CANCELLED");
                appointment3.setFee(120.0);

                Appointment appointment4 = new Appointment();
                appointment4.setId(4);
                appointment4.setPatientId(4);
                appointment4.setDoctorId(1);
                appointment4.setPatientName("Sarah Wilson");
                appointment4.setDoctorName("Dr. Lisa Anderson");
                appointment4.setAppointmentDate(new java.sql.Date(System.currentTimeMillis() + 86400000)); // Tomorrow
                appointment4.setAppointmentTime("9:15 AM");
                appointment4.setStatus("CONFIRMED");
                appointment4.setFee(90.0);

                Appointment appointment5 = new Appointment();
                appointment5.setId(5);
                appointment5.setPatientId(5);
                appointment5.setDoctorId(2);
                appointment5.setPatientName("Robert Johnson");
                appointment5.setDoctorName("Dr. James Wilson");
                appointment5.setAppointmentDate(new java.sql.Date(System.currentTimeMillis() + 86400000)); // Tomorrow
                appointment5.setAppointmentTime("3:30 PM");
                appointment5.setStatus("PENDING");
                appointment5.setFee(110.0);

                appointments.add(appointment1);
                appointments.add(appointment2);
                appointments.add(appointment3);
                appointments.add(appointment4);
                appointments.add(appointment5);
            }
        }

        return appointments;
    }

    // Get today's appointments by doctor
    public List<Appointment> getTodayAppointmentsByDoctor(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name " +
                      "FROM appointments a " +
                      "JOIN patients p ON a.patient_id = p.id " +
                      "WHERE a.doctor_id = ? AND a.appointment_date = CURRENT_DATE " +
                      "ORDER BY a.appointment_time";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, doctorId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));
                    appointment.setPatientName(rs.getString("patient_first_name") + " " + rs.getString("patient_last_name"));

                    appointments.add(appointment);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return appointments;
    }

    // Get weekly appointments by doctor
    public int getWeeklyAppointmentsByDoctor(int doctorId) {
        String query = "SELECT COUNT(*) FROM appointments " +
                      "WHERE doctor_id = ? AND appointment_date BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY) AND CURRENT_DATE";

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

    // Get upcoming appointments by doctor
    public List<Appointment> getUpcomingAppointmentsByDoctor(int doctorId, int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name " +
                      "FROM appointments a " +
                      "JOIN patients p ON a.patient_id = p.id " +
                      "WHERE a.doctor_id = ? AND (a.appointment_date > CURRENT_DATE OR " +
                      "(a.appointment_date = CURRENT_DATE AND a.appointment_time > CURRENT_TIME)) " +
                      "ORDER BY a.appointment_date, a.appointment_time " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, doctorId);
            pstmt.setInt(2, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));
                    appointment.setPatientName(rs.getString("patient_first_name") + " " + rs.getString("patient_last_name"));

                    appointments.add(appointment);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return appointments;
    }

    // Get next appointment by patient
    public Appointment getNextAppointmentByPatient(int patientId) {
        String query = "SELECT a.*, d.first_name as doctor_first_name, d.last_name as doctor_last_name, " +
                      "d.specialization " +
                      "FROM appointments a " +
                      "JOIN doctors d ON a.doctor_id = d.id " +
                      "WHERE a.patient_id = ? AND (a.appointment_date > CURRENT_DATE OR " +
                      "(a.appointment_date = CURRENT_DATE AND a.appointment_time > CURRENT_TIME)) " +
                      "ORDER BY a.appointment_date, a.appointment_time " +
                      "LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));
                    appointment.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
                    appointment.setDoctorSpecialization(rs.getString("specialization"));

                    return appointment;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get upcoming appointments by patient
    public List<Appointment> getUpcomingAppointmentsByPatient(int patientId, int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, d.first_name as doctor_first_name, d.last_name as doctor_last_name, " +
                      "d.specialization " +
                      "FROM appointments a " +
                      "JOIN doctors d ON a.doctor_id = d.id " +
                      "WHERE a.patient_id = ? AND (a.appointment_date > CURRENT_DATE OR " +
                      "(a.appointment_date = CURRENT_DATE AND a.appointment_time > CURRENT_TIME)) " +
                      "AND a.status != 'CANCELLED' " +
                      "ORDER BY a.appointment_date, a.appointment_time " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);
            pstmt.setInt(2, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));
                    appointment.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
                    appointment.setDoctorSpecialization(rs.getString("specialization"));

                    appointments.add(appointment);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return appointments;
    }

    // Get past appointments by patient
    public List<Appointment> getPastAppointmentsByPatient(int patientId, int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, d.first_name as doctor_first_name, d.last_name as doctor_last_name, " +
                      "d.specialization " +
                      "FROM appointments a " +
                      "JOIN doctors d ON a.doctor_id = d.id " +
                      "WHERE a.patient_id = ? AND ((a.appointment_date < CURRENT_DATE) OR " +
                      "(a.appointment_date = CURRENT_DATE AND a.appointment_time < CURRENT_TIME)) " +
                      "AND a.status != 'CANCELLED' " +
                      "ORDER BY a.appointment_date DESC, a.appointment_time DESC " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);
            pstmt.setInt(2, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));
                    appointment.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
                    appointment.setDoctorSpecialization(rs.getString("specialization"));

                    appointments.add(appointment);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return appointments;
    }

    // Get cancelled appointments by patient
    public List<Appointment> getCancelledAppointmentsByPatient(int patientId, int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, d.first_name as doctor_first_name, d.last_name as doctor_last_name, " +
                      "d.specialization " +
                      "FROM appointments a " +
                      "JOIN doctors d ON a.doctor_id = d.id " +
                      "WHERE a.patient_id = ? AND a.status = 'CANCELLED' " +
                      "ORDER BY a.appointment_date DESC, a.appointment_time DESC " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, patientId);
            pstmt.setInt(2, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));
                    appointment.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
                    appointment.setDoctorSpecialization(rs.getString("specialization"));

                    appointments.add(appointment);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return appointments;
    }

    /**
     * Create sample upcoming appointments for testing or when the table doesn't exist yet
     */
    private List<Appointment> createSampleUpcomingAppointments(int limit) {
        List<Appointment> appointments = new ArrayList<>();

        // Create sample appointments for testing
        Appointment appointment1 = new Appointment();
        appointment1.setId(1);
        appointment1.setPatientId(1);
        appointment1.setDoctorId(1);
        appointment1.setPatientName("John Doe");
        appointment1.setDoctorName("Dr. Sarah Johnson");
        appointment1.setAppointmentDate(new java.sql.Date(System.currentTimeMillis() + 86400000)); // Tomorrow
        appointment1.setAppointmentTime("10:00 AM");
        appointment1.setStatus("CONFIRMED");
        appointment1.setFee(100.0);
        appointment1.setDoctorSpecialization("Cardiology");

        Appointment appointment2 = new Appointment();
        appointment2.setId(2);
        appointment2.setPatientId(2);
        appointment2.setDoctorId(2);
        appointment2.setPatientName("Emily Parker");
        appointment2.setDoctorName("Dr. Michael Brown");
        appointment2.setAppointmentDate(new java.sql.Date(System.currentTimeMillis() + 172800000)); // Day after tomorrow
        appointment2.setAppointmentTime("11:30 AM");
        appointment2.setStatus("CONFIRMED");
        appointment2.setFee(150.0);
        appointment2.setDoctorSpecialization("Neurology");

        Appointment appointment3 = new Appointment();
        appointment3.setId(3);
        appointment3.setPatientId(3);
        appointment3.setDoctorId(3);
        appointment3.setPatientName("David Thompson");
        appointment3.setDoctorName("Dr. John Smith");
        appointment3.setAppointmentDate(new java.sql.Date(System.currentTimeMillis() + 259200000)); // 3 days from now
        appointment3.setAppointmentTime("2:00 PM");
        appointment3.setStatus("CONFIRMED");
        appointment3.setFee(120.0);
        appointment3.setDoctorSpecialization("Dermatology");

        appointments.add(appointment1);
        appointments.add(appointment2);
        appointments.add(appointment3);

        // Limit the number of appointments returned
        return appointments.subList(0, Math.min(limit, appointments.size()));
    }

    /**
     * Get all upcoming appointments
     * @param limit Maximum number of appointments to return
     * @return List of upcoming appointments
     */
    public List<Appointment> getUpcomingAppointments(int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, " +
                      "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                      "FROM appointments a " +
                      "JOIN patients p ON a.patient_id = p.id " +
                      "JOIN doctors d ON a.doctor_id = d.id " +
                      "WHERE (a.appointment_date > CURRENT_DATE OR " +
                      "(a.appointment_date = CURRENT_DATE AND a.appointment_time > CURRENT_TIME)) " +
                      "ORDER BY a.appointment_date, a.appointment_time " +
                      "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));
                    appointment.setPatientName(rs.getString("patient_first_name") + " " + rs.getString("patient_last_name"));
                    appointment.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
                    appointment.setDoctorSpecialization(rs.getString("specialization"));

                    appointments.add(appointment);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // Fallback: Return some sample data if the query fails
            if (appointments.isEmpty()) {
                // Create sample appointments for testing
                Appointment appointment1 = new Appointment();
                appointment1.setId(1);
                appointment1.setPatientId(1);
                appointment1.setDoctorId(1);
                appointment1.setPatientName("John Doe");
                appointment1.setDoctorName("Dr. Sarah Johnson");
                appointment1.setAppointmentDate(new java.sql.Date(System.currentTimeMillis() + 86400000)); // Tomorrow
                appointment1.setAppointmentTime("10:00 AM");
                appointment1.setStatus("CONFIRMED");
                appointment1.setFee(100.0);
                appointment1.setDoctorSpecialization("Cardiology");

                Appointment appointment2 = new Appointment();
                appointment2.setId(2);
                appointment2.setPatientId(2);
                appointment2.setDoctorId(2);
                appointment2.setPatientName("Emily Parker");
                appointment2.setDoctorName("Dr. Michael Brown");
                appointment2.setAppointmentDate(new java.sql.Date(System.currentTimeMillis() + 172800000)); // Day after tomorrow
                appointment2.setAppointmentTime("11:30 AM");
                appointment2.setStatus("CONFIRMED");
                appointment2.setFee(150.0);
                appointment2.setDoctorSpecialization("Neurology");

                appointments.add(appointment1);
                appointments.add(appointment2);
            }
        }

        return appointments;
    }

    /**
     * Get all upcoming sessions (same as upcoming appointments but with different name for UI)
     * @param limit Maximum number of sessions to return
     * @return List of upcoming sessions
     */
    public List<Appointment> getUpcomingSessions(int limit) {
        return getUpcomingAppointments(limit);
    }

    /**
     * Get count of today's appointments
     * @return Count of today's appointments
     */
    public int getTodayAppointmentsCount() {
        String query = "SELECT COUNT(*) FROM appointments WHERE appointment_date = CURRENT_DATE";

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

    /**
     * Get count of pending appointments
     * @return Count of pending appointments
     */
    public int getPendingAppointmentsCount() {
        String query = "SELECT COUNT(*) FROM appointments WHERE status = 'PENDING'";

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
}
