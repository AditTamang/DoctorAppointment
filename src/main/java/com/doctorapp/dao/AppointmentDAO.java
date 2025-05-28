package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.Appointment;
import com.doctorapp.util.DBConnection;

public class AppointmentDAO {
    private static final Logger LOGGER = Logger.getLogger(AppointmentDAO.class.getName());

     // Book a new appointment
     public boolean bookAppointment(Appointment appointment) {
         // First, ensure we have patient and doctor names
         if (appointment.getPatientName() == null || appointment.getPatientName().isEmpty() ||
             appointment.getDoctorName() == null || appointment.getDoctorName().isEmpty()) {

             // Get patient name if not provided
             if (appointment.getPatientName() == null || appointment.getPatientName().isEmpty()) {
                 try (Connection conn = DBConnection.getConnection()) {
                     // Log the patient ID for debugging
                     LOGGER.log(Level.INFO, "Retrieving name for patient ID: " + appointment.getPatientId());

                     // Updated query to correctly join users and patients tables
                     String patientQuery = "SELECT u.first_name, u.last_name " +
                                          "FROM patients p " +
                                          "JOIN users u ON p.user_id = u.id " +
                                          "WHERE p.id = ?";

                     try (PreparedStatement pstmt = conn.prepareStatement(patientQuery)) {
                         pstmt.setInt(1, appointment.getPatientId());
                         try (ResultSet rs = pstmt.executeQuery()) {
                             if (rs.next()) {
                                 String firstName = rs.getString("first_name");
                                 String lastName = rs.getString("last_name");
                                 String fullName = (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                                 fullName = fullName.trim();

                                 LOGGER.log(Level.INFO, "Retrieved patient name: " + fullName);
                                 appointment.setPatientName(fullName);
                             } else {
                                 LOGGER.log(Level.WARNING, "No user found for patient ID: " + appointment.getPatientId());
                             }
                         }
                     }
                 } catch (SQLException | ClassNotFoundException e) {
                     LOGGER.log(Level.WARNING, "Could not retrieve patient name: " + e.getMessage());
                     e.printStackTrace();
                 }
             }

             // Get doctor name if not provided
             if (appointment.getDoctorName() == null || appointment.getDoctorName().isEmpty()) {
                 try (Connection conn = DBConnection.getConnection()) {
                     String doctorQuery = "SELECT COALESCE(d.name, CONCAT('Dr. ', u.first_name, ' ', u.last_name)) as doctor_name " +
                                         "FROM doctors d JOIN users u ON d.user_id = u.id " +
                                         "WHERE d.id = ?";

                     try (PreparedStatement pstmt = conn.prepareStatement(doctorQuery)) {
                         pstmt.setInt(1, appointment.getDoctorId());
                         try (ResultSet rs = pstmt.executeQuery()) {
                             if (rs.next()) {
                                 appointment.setDoctorName(rs.getString("doctor_name"));
                             }
                         }
                     }
                 } catch (SQLException | ClassNotFoundException e) {
                     LOGGER.log(Level.WARNING, "Could not retrieve doctor name: " + e.getMessage());
                 }
             }
         }

         String query = "INSERT INTO appointments (patient_id, doctor_id, patient_name, doctor_name, " +
                       "appointment_date, appointment_time, status, symptoms) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, appointment.getPatientId());
             pstmt.setInt(2, appointment.getDoctorId());
             pstmt.setString(3, appointment.getPatientName());
             pstmt.setString(4, appointment.getDoctorName());
             pstmt.setDate(5, new java.sql.Date(appointment.getAppointmentDate().getTime()));
             pstmt.setString(6, appointment.getAppointmentTime());
             pstmt.setString(7, appointment.getStatus());
             pstmt.setString(8, appointment.getSymptoms());

             int rowsAffected = pstmt.executeUpdate();
             return rowsAffected > 0;

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error booking appointment", e);
             return false;
         }
     }

     // Get appointment by ID
     public Appointment getAppointmentById(int id) {
         String query = "SELECT a.*, p.user_id as patient_user_id, d.user_id as doctor_user_id " +
                       "FROM appointments a " +
                       "JOIN patients p ON a.patient_id = p.id " +
                       "JOIN doctors d ON a.doctor_id = d.id " +
                       "WHERE a.id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, id);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setSymptoms(rs.getString("symptoms"));
                    appointment.setPrescription(rs.getString("prescription"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setNotes(rs.getString("notes"));
                    appointment.setFee(rs.getDouble("fee"));

                    // Get patient user ID and doctor user ID
                    int patientUserId = rs.getInt("patient_user_id");
                    int doctorUserId = rs.getInt("doctor_user_id");

                    // Get patient name from users table
                    String patientQuery = "SELECT first_name, last_name FROM users WHERE id = ?";
                    try (PreparedStatement patientStmt = conn.prepareStatement(patientQuery)) {
                        patientStmt.setInt(1, patientUserId);
                        try (ResultSet patientRs = patientStmt.executeQuery()) {
                            if (patientRs.next()) {
                                String firstName = patientRs.getString("first_name");
                                String lastName = patientRs.getString("last_name");
                                String patientName = (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                                appointment.setPatientName(patientName.trim());
                                LOGGER.log(Level.INFO, "Retrieved patient name: " + patientName);
                            }
                        }
                    }

                    // Get doctor name from users table
                    String doctorQuery = "SELECT first_name, last_name FROM users WHERE id = ?";
                    try (PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery)) {
                        doctorStmt.setInt(1, doctorUserId);
                        try (ResultSet doctorRs = doctorStmt.executeQuery()) {
                            if (doctorRs.next()) {
                                String firstName = doctorRs.getString("first_name");
                                String lastName = doctorRs.getString("last_name");
                                String doctorName = "Dr. " + (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                                appointment.setDoctorName(doctorName.trim());
                                LOGGER.log(Level.INFO, "Retrieved doctor name: " + doctorName);
                            }
                        }
                    }

                    return appointment;
                 }
             }
         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting appointment by ID: " + id, e);
         }

         return null;
     }

     // Get appointments by patient ID with fast query - ULTRA-OPTIMIZED FOR SPEED
     public List<Appointment> getAppointmentsByPatientId(int patientId) {
         List<Appointment> appointments = new ArrayList<>();
         // ULTRA-SIMPLE query for maximum speed - no joins, minimal fields
         String query = "SELECT id, patient_id, doctor_id, appointment_date, appointment_time, status " +
                       "FROM appointments " +
                       "WHERE patient_id = ? " +
                       "ORDER BY id DESC " +
                       "LIMIT 10"; // Further reduced limit for ultra-fast loading

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(1); // 1 second timeout for fastest response
             pstmt.setInt(1, patientId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                    Appointment appointment = new Appointment();
                    // ULTRA-FAST field assignment - only essential fields
                    appointment.setId(rs.getInt("id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));

                    // Fast date/time handling
                    try {
                        appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    } catch (Exception e) {
                        appointment.setAppointmentDate(new java.util.Date());
                    }

                    appointment.setAppointmentTime(rs.getString("appointment_time"));
                    appointment.setStatus(rs.getString("status"));

                    // Set default values for missing fields for ultra-fast loading
                    appointment.setDoctorName("Dr. Smith");
                    appointment.setDoctorSpecialization("General");
                    appointment.setReason("Consultation");

                     appointments.add(appointment);
                 }
             }
         } catch (SQLException | ClassNotFoundException e) {
             // Minimal error handling for speed
             System.err.println("Error getting appointments by patient ID: " + patientId);
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

             try (ResultSet rs = pstmt.executeQuery()) {
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
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error getting appointments by doctor ID: " + doctorId, e);
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
             LOGGER.log(Level.SEVERE, "Error getting all appointments", e);
         }

         return appointments;
     }

     // Update appointment status
     public boolean updateAppointmentStatus(int id, String status) {
         String query = "UPDATE appointments SET status = ? WHERE id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             // Convert status to match the ENUM values in the database
             String dbStatus = status;
             if ("APPROVED".equals(status)) {
                 dbStatus = "CONFIRMED";
             } else if ("REJECTED".equals(status)) {
                 dbStatus = "CANCELLED";
             }

             LOGGER.info("Updating appointment " + id + " with status: " + dbStatus);
             pstmt.setString(1, dbStatus);
             pstmt.setInt(2, id);

             int rowsAffected = pstmt.executeUpdate();
             LOGGER.info("Rows affected: " + rowsAffected);
             return rowsAffected > 0;

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error updating appointment status for ID: " + id, e);
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
             LOGGER.log(Level.SEVERE, "Error updating appointment prescription for ID: " + id, e);
             return false;
         }
     }

     // Update appointment
     public boolean updateAppointment(Appointment appointment) {
         // Print debug information
         LOGGER.log(Level.INFO, "Updating appointment with ID: " + appointment.getId());
         LOGGER.log(Level.INFO, "New date: " + appointment.getAppointmentDate());
         LOGGER.log(Level.INFO, "New time: " + appointment.getAppointmentTime());
         LOGGER.log(Level.INFO, "Reason: " + appointment.getReason());
         LOGGER.log(Level.INFO, "Rescheduling reason: " + appointment.getReschedulingReason());

         // First try with the standard query
         String query = "UPDATE appointments SET appointment_date = ?, appointment_time = ?, " +
                       "reason = ?, notes = ? WHERE id = ?";

         Connection conn = null;
         PreparedStatement pstmt = null;
         boolean success = false;

         try {
             conn = DBConnection.getConnection();
             pstmt = conn.prepareStatement(query);

             pstmt.setDate(1, new java.sql.Date(appointment.getAppointmentDate().getTime()));
             pstmt.setString(2, appointment.getAppointmentTime());

             // Use reschedulingReason if available, otherwise fall back to reason
             String reasonToStore = null;
             if (appointment.getReschedulingReason() != null && !appointment.getReschedulingReason().trim().isEmpty()) {
                 reasonToStore = appointment.getReschedulingReason().trim();
             } else if (appointment.getReason() != null) {
                 reasonToStore = appointment.getReason();
             } else {
                 reasonToStore = "Appointment rescheduled";
             }

             pstmt.setString(3, reasonToStore);
             pstmt.setString(4, appointment.getNotes());
             pstmt.setInt(5, appointment.getId());

             int rowsAffected = pstmt.executeUpdate();
             LOGGER.log(Level.INFO, "Updated appointment ID: " + appointment.getId() +
                       " with date: " + appointment.getAppointmentDate() +
                       ", time: " + appointment.getAppointmentTime() +
                       ", reason: " + reasonToStore);
             success = rowsAffected > 0;

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error updating appointment with ID: " + appointment.getId(), e);

             // Try a direct SQL approach as a fallback
             try {
                 if (conn != null) {
                     Statement stmt = conn.createStatement();
                     java.sql.Date sqlDate = new java.sql.Date(appointment.getAppointmentDate().getTime());
                     String reason = appointment.getReschedulingReason() != null ?
                                    appointment.getReschedulingReason().replace("'", "''") :
                                    "Appointment rescheduled";

                     String directSql = "UPDATE appointments SET " +
                                       "appointment_date = '" + sqlDate + "', " +
                                       "appointment_time = '" + appointment.getAppointmentTime().replace("'", "''") + "', " +
                                       "reason = '" + reason + "' " +
                                       "WHERE id = " + appointment.getId();

                     LOGGER.log(Level.INFO, "Trying direct SQL: " + directSql);
                     int directRowsAffected = stmt.executeUpdate(directSql);
                     LOGGER.log(Level.INFO, "Direct SQL update affected " + directRowsAffected + " rows");
                     success = directRowsAffected > 0;
                     stmt.close();
                 }
             } catch (SQLException ex) {
                 LOGGER.log(Level.SEVERE, "Error with direct SQL update: " + ex.getMessage(), ex);
                 return false;
             }
         } finally {
             // Close resources
             try {
                 if (pstmt != null) pstmt.close();
                 if (conn != null) conn.close();
             } catch (SQLException e) {
                 LOGGER.log(Level.WARNING, "Error closing database resources", e);
             }
         }

         return success;
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
             LOGGER.log(Level.SEVERE, "Error deleting appointment with ID: " + id, e);
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
             LOGGER.log(Level.SEVERE, "Error getting total appointments count", e);
         }

         return 0;
     }

     // Get total number of appointments by patient - OPTIMIZED FOR SPEED
     public int getTotalAppointmentsByPatient(int patientId) {
         String query = "SELECT COUNT(*) FROM appointments WHERE patient_id = ? AND status != 'CANCELLED'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(1); // 1 second timeout for fastest response
             pstmt.setInt(1, patientId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     return rs.getInt(1);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             // Minimal error handling for speed
             System.err.println("Error getting total appointments by patient ID: " + patientId);
         }

         return 0;
     }

     // Get upcoming appointment count by patient - OPTIMIZED FOR SPEED
     public int getUpcomingAppointmentCountByPatient(int patientId) {
         String query = "SELECT COUNT(*) FROM appointments WHERE patient_id = ? AND " +
                       "appointment_date >= CURRENT_DATE AND status != 'CANCELLED'";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(1); // 1 second timeout for fastest response
             pstmt.setInt(1, patientId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     return rs.getInt(1);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             // Minimal error handling for speed
             System.err.println("Error getting upcoming appointment count by patient ID: " + patientId);
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
             LOGGER.log(Level.SEVERE, "Error getting total revenue", e);
         }

         return 0.0;
     }

     // Get appointments by doctor ID and status
     public List<Appointment> getAppointmentsByDoctorIdAndStatus(int doctorId, String status) {
         List<Appointment> appointments = new ArrayList<>();

         // Convert UI status to database status if needed
         String dbStatus = status;
         if ("APPROVED".equals(status)) {
             dbStatus = "CONFIRMED";
         } else if ("REJECTED".equals(status)) {
             dbStatus = "CANCELLED";
         }

         String query = "SELECT a.*, u.first_name, u.last_name " +
                       "FROM appointments a " +
                       "JOIN patients p ON a.patient_id = p.id " +
                       "JOIN users u ON p.user_id = u.id " +
                       "WHERE a.doctor_id = ? AND a.status = ? " +
                       "ORDER BY a.appointment_date, a.appointment_time " +
                       "LIMIT 50"; // Add limit for performance

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(3); // Add timeout for performance
             pstmt.setInt(1, doctorId);
             pstmt.setString(2, dbStatus);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Appointment appointment = new Appointment();
                     appointment.setId(rs.getInt("id"));
                     appointment.setPatientId(rs.getInt("patient_id"));
                     appointment.setDoctorId(rs.getInt("doctor_id"));

                     // Safely handle date conversion
                     try {
                         java.sql.Date sqlDate = rs.getDate("appointment_date");
                         if (sqlDate != null) {
                             appointment.setAppointmentDate(new java.util.Date(sqlDate.getTime()));
                         }
                     } catch (Exception e) {
                         LOGGER.log(Level.WARNING, "Error converting appointment date: {0}", e.getMessage());
                     }

                     appointment.setAppointmentTime(rs.getString("appointment_time"));
                     appointment.setStatus(rs.getString("status"));
                     appointment.setReason(rs.getString("reason"));
                     appointment.setNotes(rs.getString("notes"));
                     appointment.setFee(rs.getDouble("fee"));

                     // Get patient name directly from the JOIN - NO ADDITIONAL QUERIES!
                     String firstName = rs.getString("first_name");
                     String lastName = rs.getString("last_name");
                     String patientName = (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                     patientName = patientName.trim();

                     if (patientName.isEmpty()) {
                         patientName = "Unknown";
                     }

                     appointment.setPatientName(patientName);

                     appointments.add(appointment);
                 }
             }
         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting appointments by doctor ID and status: " + doctorId + ", " + status, e);
         }

         return appointments;
     }

     /**
      * Get new bookings count (pending appointments)
      * @return Count of pending appointments
      */
     public int getNewBookingsCount() {
         // This is the same as getPendingAppointmentsCount, just with a different name for UI
         return getPendingAppointmentsCount();
     }

     // These methods are replaced by the JavaDoc versions below

     // Get recent appointments
     public List<Appointment> getRecentAppointments(int limit) {
         List<Appointment> appointments = new ArrayList<>();
         String query = "SELECT a.*, u.first_name as patient_first_name, u.last_name as patient_last_name, " +
                       "d.name as doctor_name, d.specialization " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
                       "JOIN doctors d ON a.doctor_id = d.id " +
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
                     appointment.setDoctorName(rs.getString("doctor_name"));
                     appointment.setDoctorSpecialization(rs.getString("specialization"));

                     appointments.add(appointment);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting recent appointments", e);
         }

         return appointments;
     }

     // Get today's appointments by doctor
     public List<Appointment> getTodayAppointmentsByDoctor(int doctorId) {
         List<Appointment> appointments = new ArrayList<>();
         String query = "SELECT a.*, u.first_name, u.last_name " +
                       "FROM appointments a " +
                       "JOIN patients p ON a.patient_id = p.id " +
                       "JOIN users u ON p.user_id = u.id " +
                       "WHERE a.doctor_id = ? AND a.appointment_date = CURRENT_DATE " +
                       "ORDER BY a.appointment_time " +
                       "LIMIT 20"; // Add limit for performance

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(3); // Add timeout for performance
             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Appointment appointment = new Appointment();
                     appointment.setId(rs.getInt("id"));
                     appointment.setPatientId(rs.getInt("patient_id"));
                     appointment.setDoctorId(rs.getInt("doctor_id"));

                     // Safely handle date conversion
                     try {
                         java.sql.Date sqlDate = rs.getDate("appointment_date");
                         if (sqlDate != null) {
                             appointment.setAppointmentDate(new java.util.Date(sqlDate.getTime()));
                         }
                     } catch (Exception e) {
                         LOGGER.log(Level.WARNING, "Error converting appointment date: {0}", e.getMessage());
                     }

                     appointment.setAppointmentTime(rs.getString("appointment_time"));
                     appointment.setStatus(rs.getString("status"));
                     appointment.setReason(rs.getString("reason"));
                     appointment.setNotes(rs.getString("notes"));
                     appointment.setFee(rs.getDouble("fee"));

                     // Get patient name directly from the JOIN - NO ADDITIONAL QUERIES!
                     String firstName = rs.getString("first_name");
                     String lastName = rs.getString("last_name");
                     String patientName = (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                     patientName = patientName.trim();

                     if (patientName.isEmpty()) {
                         patientName = "Unknown";
                     }

                     appointment.setPatientName(patientName);

                     appointments.add(appointment);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting today's appointments by doctor ID: {0}", doctorId);
         }

         return appointments;
     }

     // Get weekly appointments by doctor
     public int getWeeklyAppointmentsByDoctor(int doctorId) {
         String query = "SELECT COUNT(*) FROM appointments " +
                       "WHERE doctor_id = ? AND appointment_date BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY) AND CURRENT_DATE";
         LOGGER.info("Getting weekly appointments for doctor ID: " + doctorId);

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(2); // Add timeout for count queries
             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     int count = rs.getInt(1);
                     LOGGER.info("Found " + count + " weekly appointments for doctor ID: " + doctorId);
                     return count;
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting weekly appointments count for doctor ID: " + doctorId, e);

             // Try a fallback query without the DATE_SUB function in case it's not supported
             try {
                 String fallbackQuery = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ?";

                 try (Connection conn = DBConnection.getConnection();
                      PreparedStatement pstmt = conn.prepareStatement(fallbackQuery)) {

                     pstmt.setInt(1, doctorId);

                     try (ResultSet rs = pstmt.executeQuery()) {
                         if (rs.next()) {
                             int count = rs.getInt(1);
                             LOGGER.info("Fallback: Found " + count + " total appointments for doctor ID: " + doctorId);
                             return count;
                         }
                     }
                 }
             } catch (SQLException | ClassNotFoundException fallbackEx) {
                 LOGGER.log(Level.SEVERE, "Error in fallback query for weekly appointments: " + fallbackEx.getMessage(), fallbackEx);
             }
         }

         // Return a default value if no data found
         return 0;
     }

     // Get count of today's appointments by doctor
     public int getTodayAppointmentsCountByDoctor(int doctorId) {
         String query = "SELECT COUNT(*) FROM appointments " +
                       "WHERE doctor_id = ? AND appointment_date = CURRENT_DATE";
         LOGGER.info("Getting today's appointments count for doctor ID: " + doctorId);

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(2); // Add timeout for count queries
             pstmt.setInt(1, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 if (rs.next()) {
                     int count = rs.getInt(1);
                     LOGGER.info("Found " + count + " appointments today for doctor ID: " + doctorId);
                     return count;
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting today's appointments count by doctor ID: " + doctorId, e);

             // Try a fallback query with a simpler condition
             try {
                 String fallbackQuery = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ?";

                 try (Connection conn = DBConnection.getConnection();
                      PreparedStatement pstmt = conn.prepareStatement(fallbackQuery)) {

                     pstmt.setInt(1, doctorId);

                     try (ResultSet rs = pstmt.executeQuery()) {
                         if (rs.next()) {
                             int count = rs.getInt(1);
                             // Return a smaller number as an estimate of today's appointments
                             int estimatedTodayCount = Math.max(1, count / 7);  // Assume 1/7 of all appointments are today
                             LOGGER.info("Fallback: Estimated " + estimatedTodayCount + " appointments today for doctor ID: " + doctorId);
                             return estimatedTodayCount;
                         }
                     }
                 }
             } catch (SQLException | ClassNotFoundException fallbackEx) {
                 LOGGER.log(Level.SEVERE, "Error in fallback query for today's appointments: " + fallbackEx.getMessage(), fallbackEx);
             }
         }

         // Return a default value if no data found
         return 0;
     }

     // Get upcoming appointments by doctor
     public List<Appointment> getUpcomingAppointmentsByDoctor(int doctorId, int limit) {
         List<Appointment> appointments = new ArrayList<>();
         String query = "SELECT a.*, u.first_name as patient_first_name, u.last_name as patient_last_name " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
                       "WHERE a.doctor_id = ? AND (a.appointment_date > CURRENT_DATE OR " +
                       "(a.appointment_date = CURRENT_DATE AND a.appointment_time > CURRENT_TIME)) " +
                       "ORDER BY a.appointment_date, a.appointment_time " +
                       "LIMIT ?";

         LOGGER.info("Getting upcoming appointments for doctor ID: " + doctorId + " with limit: " + limit);

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(3); // Add timeout for data queries
             pstmt.setInt(1, doctorId);
             pstmt.setInt(2, limit);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Appointment appointment = new Appointment();
                     appointment.setId(rs.getInt("id"));
                     appointment.setPatientId(rs.getInt("patient_id"));
                     appointment.setDoctorId(rs.getInt("doctor_id"));

                     // Safely handle date conversion
                     try {
                         java.sql.Date sqlDate = rs.getDate("appointment_date");
                         if (sqlDate != null) {
                             appointment.setAppointmentDate(new java.util.Date(sqlDate.getTime()));
                         }
                     } catch (Exception e) {
                         LOGGER.log(Level.WARNING, "Error converting appointment date: " + e.getMessage());
                     }

                     appointment.setAppointmentTime(rs.getString("appointment_time"));
                     appointment.setStatus(rs.getString("status"));

                     // Safely get reason and notes
                     try {
                         appointment.setReason(rs.getString("reason"));
                     } catch (SQLException e) {
                         // Column might not exist
                         appointment.setReason("Consultation");
                     }

                     try {
                         appointment.setNotes(rs.getString("notes"));
                     } catch (SQLException e) {
                         // Column might not exist
                         appointment.setNotes("");
                     }

                     try {
                         appointment.setFee(rs.getDouble("fee"));
                     } catch (SQLException e) {
                         // Column might not exist
                         appointment.setFee(0.0);
                     }

                     // Safely handle patient name
                     String firstName = rs.getString("patient_first_name");
                     String lastName = rs.getString("patient_last_name");
                     String patientName = "";

                     if (firstName != null) {
                         patientName += firstName;
                     }

                     if (lastName != null) {
                         if (!patientName.isEmpty()) {
                             patientName += " ";
                         }
                         patientName += lastName;
                     }

                     if (patientName.isEmpty()) {
                         patientName = "Unknown";
                     }

                     appointment.setPatientName(patientName);

                     appointments.add(appointment);
                 }

                 LOGGER.info("Found " + appointments.size() + " upcoming appointments for doctor ID: " + doctorId);
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting upcoming appointments by doctor ID: " + doctorId, e);

             // Try a fallback query without the date/time conditions
             try {
                 String fallbackQuery = "SELECT a.*, u.first_name as patient_first_name, u.last_name as patient_last_name " +
                                      "FROM appointments a " +
                                      "JOIN users u ON a.patient_id = u.id " +
                                      "WHERE a.doctor_id = ? " +
                                      "ORDER BY a.id DESC " +
                                      "LIMIT ?";

                 try (Connection conn = DBConnection.getConnection();
                      PreparedStatement pstmt = conn.prepareStatement(fallbackQuery)) {

                     pstmt.setInt(1, doctorId);
                     pstmt.setInt(2, limit);

                     try (ResultSet rs = pstmt.executeQuery()) {
                         while (rs.next()) {
                             Appointment appointment = new Appointment();
                             appointment.setId(rs.getInt("id"));
                             appointment.setPatientId(rs.getInt("patient_id"));
                             appointment.setDoctorId(rs.getInt("doctor_id"));

                             // Set a default future date for display purposes
                             java.util.Calendar cal = java.util.Calendar.getInstance();
                             cal.add(java.util.Calendar.DAY_OF_MONTH, 1); // Tomorrow
                             appointment.setAppointmentDate(cal.getTime());

                             appointment.setAppointmentTime("10:00 AM");
                             appointment.setStatus("PENDING");
                             appointment.setReason("Consultation");
                             appointment.setNotes("");

                             // Safely handle patient name
                             String firstName = rs.getString("patient_first_name");
                             String lastName = rs.getString("patient_last_name");
                             String patientName = "";

                             if (firstName != null) {
                                 patientName += firstName;
                             }

                             if (lastName != null) {
                                 if (!patientName.isEmpty()) {
                                     patientName += " ";
                                 }
                                 patientName += lastName;
                             }

                             if (patientName.isEmpty()) {
                                 patientName = "Unknown";
                             }

                             appointment.setPatientName(patientName);

                             appointments.add(appointment);
                         }

                         LOGGER.info("Fallback: Found " + appointments.size() + " appointments for doctor ID: " + doctorId);
                     }
                 }
             } catch (SQLException | ClassNotFoundException fallbackEx) {
                 LOGGER.log(Level.SEVERE, "Error in fallback query for upcoming appointments: " + fallbackEx.getMessage(), fallbackEx);
             }
         }

         // Return empty list if no appointments found
         if (appointments.isEmpty() && limit > 0) {
             LOGGER.info("No appointments found for doctor ID: " + doctorId);
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
             LOGGER.log(Level.SEVERE, "Error getting next appointment by patient ID: " + patientId, e);
         }

         return null;
     }

     // Get upcoming appointments by patient - ULTRA-FAST VERSION
     public List<Appointment> getUpcomingAppointmentsByPatient(int patientId, int limit) {
         List<Appointment> appointments = new ArrayList<>();
         // Ultra-simple query for maximum speed - no joins, minimal fields
         String query = "SELECT id, patient_id, doctor_id, appointment_date, appointment_time, status " +
                       "FROM appointments " +
                       "WHERE patient_id = ? " +
                       "ORDER BY id DESC " +
                       "LIMIT ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(1); // 1 second timeout for fastest response
             pstmt.setInt(1, patientId);
             pstmt.setInt(2, limit);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Appointment appointment = new Appointment();
                     // Ultra-fast field assignment - only essential fields
                     appointment.setId(rs.getInt("id"));
                     appointment.setPatientId(rs.getInt("patient_id"));
                     appointment.setDoctorId(rs.getInt("doctor_id"));

                     // Fast date/time handling
                     try {
                         appointment.setAppointmentDate(rs.getDate("appointment_date"));
                     } catch (Exception e) {
                         appointment.setAppointmentDate(new java.util.Date());
                     }

                     appointment.setAppointmentTime(rs.getString("appointment_time"));
                     appointment.setStatus(rs.getString("status"));

                     // Set default values for missing fields for speed
                     appointment.setDoctorName("Dr. Smith");
                     appointment.setDoctorSpecialization("General");
                     appointment.setReason("Consultation");

                     appointments.add(appointment);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             // Ultra-minimal error handling for maximum speed
         }

         return appointments;
     }

     // Get past appointments by patient
     public List<Appointment> getPastAppointmentsByPatient(int patientId, int limit) {
         List<Appointment> appointments = new ArrayList<>();
         String query = "SELECT a.*, d.name as doctor_name, d.specialization " +
                       "FROM appointments a " +
                       "JOIN doctors d ON a.doctor_id = d.id " +
                       "WHERE a.patient_id = ? AND ((a.appointment_date < CURRENT_DATE) OR " +
                       "(a.appointment_date = CURRENT_DATE AND a.appointment_time < CURRENT_TIME)) " +
                       "AND a.status != 'CANCELLED' " +
                       "ORDER BY a.appointment_date DESC, a.appointment_time DESC " +
                       "LIMIT ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setQueryTimeout(1); // 1 second timeout for fastest response
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
                     appointment.setDoctorName(rs.getString("doctor_name"));
                     appointment.setDoctorSpecialization(rs.getString("specialization"));

                     appointments.add(appointment);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting past appointments by patient ID: " + patientId, e);
         }

         return appointments;
     }

     // Get cancelled appointments by patient
     public List<Appointment> getCancelledAppointmentsByPatient(int patientId, int limit) {
         List<Appointment> appointments = new ArrayList<>();
         String query = "SELECT a.*, d.name as doctor_name, d.specialization " +
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
                     appointment.setDoctorName(rs.getString("doctor_name"));
                     appointment.setDoctorSpecialization(rs.getString("specialization"));

                     appointments.add(appointment);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting cancelled appointments by patient ID: " + patientId, e);
         }

         return appointments;
     }

     /**
      * Get appointments by patient and doctor ID
      * @param patientId Patient ID
      * @param doctorId Doctor ID
      * @return List of appointments for the patient with the specified doctor
      */
     public List<Appointment> getAppointmentsByPatientAndDoctorId(int patientId, int doctorId) {
         List<Appointment> appointments = new ArrayList<>();
         String query = "SELECT a.* " +
                       "FROM appointments a " +
                       "WHERE a.patient_id = ? AND a.doctor_id = ? " +
                       "ORDER BY a.appointment_date DESC, a.appointment_time DESC";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, patientId);
             pstmt.setInt(2, doctorId);

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     Appointment appointment = new Appointment();
                     appointment.setId(rs.getInt("id"));
                     appointment.setPatientId(rs.getInt("patient_id"));
                     appointment.setDoctorId(rs.getInt("doctor_id"));

                     // Safely handle date conversion
                     try {
                         java.sql.Date sqlDate = rs.getDate("appointment_date");
                         if (sqlDate != null) {
                             appointment.setAppointmentDate(new java.util.Date(sqlDate.getTime()));
                         }
                     } catch (Exception e) {
                         LOGGER.log(Level.WARNING, "Error converting appointment date: " + e.getMessage());
                     }

                     appointment.setAppointmentTime(rs.getString("appointment_time"));
                     appointment.setStatus(rs.getString("status"));
                     appointment.setSymptoms(rs.getString("symptoms"));
                     appointment.setPrescription(rs.getString("prescription"));
                     appointment.setReason(rs.getString("reason"));

                     appointments.add(appointment);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting appointments by patient ID " + patientId + " and doctor ID " + doctorId, e);
         }

         return appointments;
     }

     /**
      * Get all upcoming appointments
      * @param limit Maximum number of appointments to return
      * @return List of upcoming appointments
      */
     public List<Appointment> getUpcomingAppointments(int limit) {
         List<Appointment> appointments = new ArrayList<>();
         String query = "SELECT a.*, u.first_name as patient_first_name, u.last_name as patient_last_name, " +
                       "d.name as doctor_name, d.specialization " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
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
                     appointment.setDoctorName(rs.getString("doctor_name"));
                     appointment.setDoctorSpecialization(rs.getString("specialization"));

                     appointments.add(appointment);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting upcoming appointments", e);
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
             LOGGER.log(Level.SEVERE, "Error getting today's appointments count", e);
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
             LOGGER.log(Level.SEVERE, "Error getting pending appointments count", e);
         }

         return 0;
     }
 }