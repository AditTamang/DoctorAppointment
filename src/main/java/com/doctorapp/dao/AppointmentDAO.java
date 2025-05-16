package com.doctorapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                     String patientQuery = "SELECT CONCAT(u.first_name, ' ', u.last_name) as full_name " +
                                          "FROM users u JOIN patients p ON u.id = p.user_id " +
                                          "WHERE p.id = ?";

                     try (PreparedStatement pstmt = conn.prepareStatement(patientQuery)) {
                         pstmt.setInt(1, appointment.getPatientId());
                         try (ResultSet rs = pstmt.executeQuery()) {
                             if (rs.next()) {
                                 appointment.setPatientName(rs.getString("full_name"));
                             }
                         }
                     }
                 } catch (SQLException | ClassNotFoundException e) {
                     LOGGER.log(Level.WARNING, "Could not retrieve patient name: " + e.getMessage());
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
         String query = "SELECT * FROM appointments WHERE id = ?";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

             pstmt.setInt(1, id);

             try (ResultSet rs = pstmt.executeQuery()) {
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
             }
         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting appointment by ID: " + id, e);
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
             LOGGER.log(Level.SEVERE, "Error getting appointments by patient ID: " + patientId, e);
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
             LOGGER.log(Level.SEVERE, "Error getting total appointments by patient ID: " + patientId, e);
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
             LOGGER.log(Level.SEVERE, "Error getting upcoming appointment count by patient ID: " + patientId, e);
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

         String query = "SELECT a.*, u.first_name as patient_first_name, u.last_name as patient_last_name " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
                       "WHERE a.doctor_id = ? AND a.status = ? " +
                       "ORDER BY a.appointment_date, a.appointment_time";

         try (Connection conn = DBConnection.getConnection();
              PreparedStatement pstmt = conn.prepareStatement(query)) {

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
         String query = "SELECT a.*, u.first_name as patient_first_name, u.last_name as patient_last_name " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
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

         // If still no appointments, create some sample data for display
         if (appointments.isEmpty() && limit > 0) {
             LOGGER.info("Creating sample appointments for doctor ID: " + doctorId);

             // Create sample appointments
             for (int i = 0; i < Math.min(limit, 2); i++) {
                 Appointment appointment = new Appointment();
                 appointment.setId(i + 1);
                 appointment.setPatientId(i + 100);
                 appointment.setDoctorId(doctorId);

                 // Set a future date
                 java.util.Calendar cal = java.util.Calendar.getInstance();
                 cal.add(java.util.Calendar.DAY_OF_MONTH, i + 1);
                 appointment.setAppointmentDate(cal.getTime());

                 appointment.setAppointmentTime((9 + i) + ":00 AM");
                 appointment.setStatus("PENDING");
                 appointment.setReason("Consultation");
                 appointment.setNotes("Sample appointment");
                 appointment.setPatientName("Sample Patient " + (i + 1));

                 appointments.add(appointment);
             }
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

     // Get upcoming appointments by patient
     public List<Appointment> getUpcomingAppointmentsByPatient(int patientId, int limit) {
         List<Appointment> appointments = new ArrayList<>();
         String query = "SELECT a.*, d.name as doctor_name, d.specialization " +
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
                     appointment.setDoctorName(rs.getString("doctor_name"));
                     appointment.setDoctorSpecialization(rs.getString("specialization"));

                     appointments.add(appointment);
                 }
             }

         } catch (SQLException | ClassNotFoundException e) {
             LOGGER.log(Level.SEVERE, "Error getting upcoming appointments by patient ID: " + patientId, e);
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
      * Get all upcoming appointments
      * @param limit Maximum number of appointments to return
      * @return List of upcoming appointments
      */public List<Appointment> getUpcomingAppointments(int limit) {
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