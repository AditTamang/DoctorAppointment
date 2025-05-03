package com.doctorapp.service;


 import java.util.List;

 import com.doctorapp.dao.AppointmentDAO;
 import com.doctorapp.model.Appointment;

 /**
  * Service layer for Appointment-related operations.
  * This class acts as an intermediary between controllers and DAOs.
  */
 public class AppointmentService {
     private AppointmentDAO appointmentDAO;


     public AppointmentService() {
         this.appointmentDAO = new AppointmentDAO();
     }


     /**
      * Book a new appointment
      * @param appointment The appointment to book
      * @return true if booking was successful, false otherwise
      */
     public boolean bookAppointment(Appointment appointment) {
         return appointmentDAO.bookAppointment(appointment);
     }


     /**
      * Get an appointment by ID
      * @param id Appointment ID
      * @return Appointment object if found, null otherwise
      */
     public Appointment getAppointmentById(int id) {
         return appointmentDAO.getAppointmentById(id);
     }


     /**
      * Get appointments by patient ID
      * @param patientId Patient ID
      * @return List of appointments for the patient
      */
     public List<Appointment> getAppointmentsByPatientId(int patientId) {
         return appointmentDAO.getAppointmentsByPatientId(patientId);
     }


     /**
      * Get appointments by doctor ID
      * @param doctorId Doctor ID
      * @return List of appointments for the doctor
      */
     public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
         return appointmentDAO.getAppointmentsByDoctorId(doctorId);
     }


     /**
      * Get all appointments
      * @return List of all appointments
      */
     public List<Appointment> getAllAppointments() {
         return appointmentDAO.getAllAppointments();
     }


     /**
      * Update appointment status
      * @param id Appointment ID
      * @param status New status
      * @return true if update was successful, false otherwise
      */
     public boolean updateAppointmentStatus(int id, String status) {
         return appointmentDAO.updateAppointmentStatus(id, status);
     }


     /**
      * Update appointment prescription
      * @param id Appointment ID
      * @param prescription New prescription
      * @return true if update was successful, false otherwise
      */
     public boolean updateAppointmentPrescription(int id, String prescription) {
         return appointmentDAO.updateAppointmentPrescription(id, prescription);
     }


     /**
      * Delete an appointment
      * @param id Appointment ID
      * @return true if deletion was successful, false otherwise
      */
     public boolean deleteAppointment(int id) {
         return appointmentDAO.deleteAppointment(id);
     }


     /**
      * Get recent appointments
      * @param limit Number of appointments to return
      * @return List of recent appointments
      */
     public List<Appointment> getRecentAppointments(int limit) {
         return appointmentDAO.getRecentAppointments(limit);
     }


     /**
      * Get today's appointments by doctor
      * @param doctorId Doctor ID
      * @return List of today's appointments for the doctor
      */
     public List<Appointment> getTodayAppointmentsByDoctor(int doctorId) {
         return appointmentDAO.getTodayAppointmentsByDoctor(doctorId);
     }

     /**
      * Get count of today's appointments by doctor
      * @param doctorId Doctor ID
      * @return Count of today's appointments for the doctor
      */
     public int getTodayAppointmentsCountByDoctor(int doctorId) {
         return appointmentDAO.getTodayAppointmentsCountByDoctor(doctorId);
     }


     /**
      * Get next appointment by patient
      * @param patientId Patient ID
      * @return Next appointment for the patient
      */
     public Appointment getNextAppointmentByPatient(int patientId) {
         return appointmentDAO.getNextAppointmentByPatient(patientId);
     }


     /**
      * Get upcoming appointments by patient
      * @param patientId Patient ID
      * @param limit Number of appointments to return
      * @return List of upcoming appointments for the patient
      */
     public List<Appointment> getUpcomingAppointmentsByPatient(int patientId, int limit) {
         return appointmentDAO.getUpcomingAppointmentsByPatient(patientId, limit);
     }


     /**
      * Get past appointments by patient
      * @param patientId Patient ID
      * @param limit Number of appointments to return
      * @return List of past appointments for the patient
      */
     public List<Appointment> getPastAppointmentsByPatient(int patientId, int limit) {
         return appointmentDAO.getPastAppointmentsByPatient(patientId, limit);
     }

     /**
      * Get cancelled appointments by patient
      * @param patientId Patient ID
      * @param limit Number of appointments to return
      * @return List of cancelled appointments for the patient
      */
     public List<Appointment> getCancelledAppointmentsByPatient(int patientId, int limit) {
         return appointmentDAO.getCancelledAppointmentsByPatient(patientId, limit);
     }

     /**
      * Get total number of appointments by patient
      * @param patientId Patient ID
      * @return Total number of appointments for the patient
      */
     public int getTotalAppointmentsByPatient(int patientId) {
         return appointmentDAO.getTotalAppointmentsByPatient(patientId);
     }

     /**
      * Get upcoming appointment count by patient
      * @param patientId Patient ID
      * @return Count of upcoming appointments for the patient
      */
     public int getUpcomingAppointmentCountByPatient(int patientId) {
         return appointmentDAO.getUpcomingAppointmentCountByPatient(patientId);
     }

     /**
      * Get total number of appointments
      * @return Total number of appointments
      */
     public int getTotalAppointments() {
         return appointmentDAO.getTotalAppointments();
     }


     /**
      * Get total revenue from appointments
      * @return Total revenue
      */
     public double getTotalRevenue() {
         return appointmentDAO.getTotalRevenue();
     }

     /**
      * Get appointments by doctor ID and status
      * @param doctorId Doctor ID
      * @param status Appointment status
      * @return List of appointments for the doctor with the specified status
      */
     public List<Appointment> getAppointmentsByDoctorIdAndStatus(int doctorId, String status) {
         return appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, status);
     }

     /**
      * Get available time slots for a doctor
      * @param doctorId Doctor ID
      * @return List of available time slots
      */
     public List<String> getAvailableTimeSlots(int doctorId) {
         // Default time slots if not implemented in DAO
         List<String> timeSlots = new java.util.ArrayList<>();
         timeSlots.add("09:00 AM");
         timeSlots.add("10:00 AM");
         timeSlots.add("11:00 AM");
         timeSlots.add("12:00 PM");
         timeSlots.add("01:00 PM");
         timeSlots.add("02:00 PM");
         timeSlots.add("03:00 PM");
         timeSlots.add("04:00 PM");
         timeSlots.add("05:00 PM");

         // TODO: Implement actual time slot availability check in DAO
         // This would check the doctor's schedule and return only available slots

         return timeSlots;
     }

     /**
      * Check if a time slot is available for a doctor on a specific date
      * @param doctorId Doctor ID
      * @param date Appointment date
      * @param time Appointment time
      * @return true if the time slot is available, false otherwise
      */
     public boolean isTimeSlotAvailable(int doctorId, String date, String time) {
         // In a real implementation, this would check the database for existing appointments
         // For now, we'll assume all time slots are available

         try {
             // Convert date string to java.sql.Date for database comparison
             java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
             java.util.Date parsedDate = dateFormat.parse(date);
             java.sql.Date sqlDate = new java.sql.Date(parsedDate.getTime());

             // Check if there's an existing appointment for this doctor at this date and time
             List<Appointment> doctorAppointments = appointmentDAO.getAppointmentsByDoctorId(doctorId);

             for (Appointment appointment : doctorAppointments) {
                 // Skip cancelled appointments
                 if ("CANCELLED".equals(appointment.getStatus())) {
                     continue;
                 }

                 // Check if the appointment is on the same date
                 java.util.Date appointmentDate = appointment.getAppointmentDate();
                 if (appointmentDate != null) {
                     java.sql.Date appointmentSqlDate = new java.sql.Date(appointmentDate.getTime());

                     // If same date and same time, the slot is not available
                     if (sqlDate.equals(appointmentSqlDate) &&
                         time.equals(appointment.getAppointmentTime())) {
                         return false;
                     }
                 }
             }

             // If we get here, the time slot is available
             return true;
         } catch (Exception e) {
             System.err.println("Error checking time slot availability: " + e.getMessage());
             // In case of error, assume the slot is available to avoid blocking appointments
             return true;
         }
     }
 }