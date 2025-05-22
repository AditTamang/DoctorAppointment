package com.doctorapp.service;


 import java.util.List;

 import com.doctorapp.dao.AppointmentDAO;
 import com.doctorapp.model.Appointment;

/**
 * Service for managing appointments between doctors and patients
 */
 public class AppointmentService {
     private AppointmentDAO appointmentDAO;


     public AppointmentService() {
         this.appointmentDAO = new AppointmentDAO();
     }


     /**
      * Creates a new appointment booking
      */
     public boolean bookAppointment(Appointment appointment) {
         return appointmentDAO.bookAppointment(appointment);
     }

     /**
      * Retrieves appointment by ID
      */
     public Appointment getAppointmentById(int id) {
         return appointmentDAO.getAppointmentById(id);
     }

     /**
      * Gets all appointments for a patient
      */
     public List<Appointment> getAppointmentsByPatientId(int patientId) {
         return appointmentDAO.getAppointmentsByPatientId(patientId);
     }

     /**
      * Gets all appointments for a doctor
      */
     public List<Appointment> getAppointmentsByDoctorId(int doctorId) {
         return appointmentDAO.getAppointmentsByDoctorId(doctorId);
     }


     /**
      * Gets all appointments in the system
      */
     public List<Appointment> getAllAppointments() {
         return appointmentDAO.getAllAppointments();
     }

     /**
      * Updates the status of an appointment
      */
     public boolean updateAppointmentStatus(int id, String status) {
         return appointmentDAO.updateAppointmentStatus(id, status);
     }

     /**
      * Updates the prescription for an appointment
      */
     public boolean updateAppointmentPrescription(int id, String prescription) {
         return appointmentDAO.updateAppointmentPrescription(id, prescription);
     }

     /**
      * Updates an appointment with new information
      */
     public boolean updateAppointment(Appointment appointment) {
         return appointmentDAO.updateAppointment(appointment);
     }

     /**
      * Deletes an appointment from the system
      */
     public boolean deleteAppointment(int id) {
         return appointmentDAO.deleteAppointment(id);
     }


     /**
      * Gets most recent appointments, limited by count
      */
     public List<Appointment> getRecentAppointments(int limit) {
         return appointmentDAO.getRecentAppointments(limit);
     }

     /**
      * Gets today's appointments for a specific doctor
      */
     public List<Appointment> getTodayAppointmentsByDoctor(int doctorId) {
         return appointmentDAO.getTodayAppointmentsByDoctor(doctorId);
     }

     /**
      * Counts today's appointments for a doctor
      */
     public int getTodayAppointmentsCountByDoctor(int doctorId) {
         return appointmentDAO.getTodayAppointmentsCountByDoctor(doctorId);
     }

     /**
      * Gets the next upcoming appointment for a patient
      */
     public Appointment getNextAppointmentByPatient(int patientId) {
         return appointmentDAO.getNextAppointmentByPatient(patientId);
     }


     /**
      * Gets upcoming appointments for a patient
      */
     public List<Appointment> getUpcomingAppointmentsByPatient(int patientId, int limit) {
         return appointmentDAO.getUpcomingAppointmentsByPatient(patientId, limit);
     }

     /**
      * Gets past appointments for a patient
      */
     public List<Appointment> getPastAppointmentsByPatient(int patientId, int limit) {
         return appointmentDAO.getPastAppointmentsByPatient(patientId, limit);
     }

     /**
      * Gets cancelled appointments for a patient
      */
     public List<Appointment> getCancelledAppointmentsByPatient(int patientId, int limit) {
         return appointmentDAO.getCancelledAppointmentsByPatient(patientId, limit);
     }

     /**
      * Counts total appointments for a patient
      */
     public int getTotalAppointmentsByPatient(int patientId) {
         return appointmentDAO.getTotalAppointmentsByPatient(patientId);
     }

     /**
      * Counts upcoming appointments for a patient
      */
     public int getUpcomingAppointmentCountByPatient(int patientId) {
         return appointmentDAO.getUpcomingAppointmentCountByPatient(patientId);
     }

     /**
      * Counts all appointments in the system
      */
     public int getTotalAppointments() {
         return appointmentDAO.getTotalAppointments();
     }

     /**
      * Calculates total revenue from all appointments
      */
     public double getTotalRevenue() {
         return appointmentDAO.getTotalRevenue();
     }

     /**
      * Gets appointments for a doctor with specific status
      */
     public List<Appointment> getAppointmentsByDoctorIdAndStatus(int doctorId, String status) {
         return appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, status);
     }

     /**
      * Gets appointments between a specific patient and doctor
      */
     public List<Appointment> getAppointmentsByPatientAndDoctorId(int patientId, int doctorId) {
         return appointmentDAO.getAppointmentsByPatientAndDoctorId(patientId, doctorId);
     }

     /**
      * Gets available appointment time slots for a doctor on a specific date
      */
     public List<String> getAvailableTimeSlots(int doctorId, String date) {
         List<String> timeSlots = new java.util.ArrayList<>();

         try {
             // Get doctor data
             com.doctorapp.dao.DoctorDAO doctorDAO = new com.doctorapp.dao.DoctorDAO();
             com.doctorapp.model.Doctor doctor = doctorDAO.getDoctorById(doctorId);

             if (doctor == null) {
                 return getDefaultTimeSlots(); // Use default slots if doctor not found
             }

             // Check doctor status
             if (!"ACTIVE".equals(doctor.getStatus())) {
                 return new java.util.ArrayList<>(); // No slots for inactive doctors
             }

             // Get doctor's schedule
             String availableTime = doctor.getAvailableTime();
             if (availableTime == null || availableTime.isEmpty()) {
                 availableTime = "09:00 AM - 05:00 PM"; // Default schedule
             }

             // Parse available time range
             String[] timeRange = availableTime.split("-");
             if (timeRange.length != 2) {
                 System.err.println("Invalid time range format: " + availableTime);
                 return getDefaultTimeSlots(); // Return default slots if format is invalid
             }

             String startTimeStr = timeRange[0].trim();
             String endTimeStr = timeRange[1].trim();

             // Parse start and end times
             java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("hh:mm a");
             java.util.Date startTime = timeFormat.parse(startTimeStr);
             java.util.Date endTime = timeFormat.parse(endTimeStr);

             System.out.println("Start time: " + timeFormat.format(startTime));
             System.out.println("End time: " + timeFormat.format(endTime));

             // Generate time slots at 15-minute intervals to provide more options
             java.util.Calendar calendar = java.util.Calendar.getInstance();
             calendar.setTime(startTime);

             // Make sure we include the end time if it's exactly on a 15-minute interval
             java.util.Calendar endCalendar = java.util.Calendar.getInstance();
             endCalendar.setTime(endTime);

             while (calendar.getTime().before(endTime) || calendar.getTime().equals(endTime)) {
                 timeSlots.add(timeFormat.format(calendar.getTime()));

                 // Add 15 minutes
                 calendar.add(java.util.Calendar.MINUTE, 15);

                 // Break if we've gone past the end time
                 if (calendar.getTime().after(endTime)) {
                     break;
                 }
             }

             System.out.println("Generated " + timeSlots.size() + " time slots");

             // If date is provided, filter out already booked slots
             if (date != null && !date.isEmpty()) {
                 List<String> availableSlots = new java.util.ArrayList<>();

                 for (String slot : timeSlots) {
                     // Check if this time slot is available
                     if (isTimeSlotAvailable(doctorId, date, slot)) {
                         availableSlots.add(slot);
                         System.out.println("Available time slot: " + slot);
                     } else {
                         System.out.println("Booked time slot: " + slot);
                     }
                 }

                 System.out.println("After filtering, " + availableSlots.size() + " time slots are available");
                 return availableSlots;
             } else {
                 // If no date provided, return all time slots
                 for (String slot : timeSlots) {
                     System.out.println("Time slot: " + slot);
                 }
                 return timeSlots;
             }
         } catch (Exception e) {
             System.err.println("Error getting available time slots: " + e.getMessage());
             e.printStackTrace();
             return getDefaultTimeSlots(); // Return default slots in case of error
         }
     }

     /**
      * Get available time slots for a doctor (overloaded method for backward compatibility)
      * @param doctorId Doctor ID
      * @return List of available time slots
      */
     public List<String> getAvailableTimeSlots(int doctorId) {
         return getAvailableTimeSlots(doctorId, null);
     }

     /**
      * Get default time slots
      * @return List of default time slots
      */
     private List<String> getDefaultTimeSlots() {
         List<String> timeSlots = new java.util.ArrayList<>();

         try {
             // Generate time slots from 9:00 AM to 5:00 PM at 15-minute intervals
             java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("hh:mm a");
             java.util.Date startTime = timeFormat.parse("09:00 AM");
             java.util.Date endTime = timeFormat.parse("05:00 PM");

             java.util.Calendar calendar = java.util.Calendar.getInstance();
             calendar.setTime(startTime);

             while (calendar.getTime().before(endTime) || calendar.getTime().equals(endTime)) {
                 timeSlots.add(timeFormat.format(calendar.getTime()));

                 // Add 15 minutes
                 calendar.add(java.util.Calendar.MINUTE, 15);

                 // Break if we've gone past the end time
                 if (calendar.getTime().after(endTime)) {
                     break;
                 }
             }
         } catch (Exception e) {
             // If there's an error, fall back to hardcoded slots
             System.err.println("Error generating default time slots: " + e.getMessage());

             // Add hardcoded slots as fallback
             timeSlots.add("09:00 AM");
             timeSlots.add("09:15 AM");
             timeSlots.add("09:30 AM");
             timeSlots.add("09:45 AM");
             timeSlots.add("10:00 AM");
             timeSlots.add("10:15 AM");
             timeSlots.add("10:30 AM");
             timeSlots.add("10:45 AM");
             timeSlots.add("11:00 AM");
             timeSlots.add("11:15 AM");
             timeSlots.add("11:30 AM");
             timeSlots.add("11:45 AM");
             timeSlots.add("12:00 PM");
             timeSlots.add("12:15 PM");
             timeSlots.add("12:30 PM");
             timeSlots.add("12:45 PM");
             timeSlots.add("01:00 PM");
             timeSlots.add("01:15 PM");
             timeSlots.add("01:30 PM");
             timeSlots.add("01:45 PM");
             timeSlots.add("02:00 PM");
             timeSlots.add("02:15 PM");
             timeSlots.add("02:30 PM");
             timeSlots.add("02:45 PM");
             timeSlots.add("03:00 PM");
             timeSlots.add("03:15 PM");
             timeSlots.add("03:30 PM");
             timeSlots.add("03:45 PM");
             timeSlots.add("04:00 PM");
             timeSlots.add("04:15 PM");
             timeSlots.add("04:30 PM");
             timeSlots.add("04:45 PM");
             timeSlots.add("05:00 PM");
         }

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
         try {
             // Get doctor information to check availability
             com.doctorapp.dao.DoctorDAO doctorDAO = new com.doctorapp.dao.DoctorDAO();
             com.doctorapp.model.Doctor doctor = doctorDAO.getDoctorById(doctorId);

             if (doctor == null) {
                 System.err.println("Doctor not found with ID: " + doctorId);
                 return false;
             }

             // Check if doctor is active
             if (!"ACTIVE".equals(doctor.getStatus())) {
                 System.out.println("Doctor is not active: " + doctorId);
                 return false;
             }

             // Convert date string to java.util.Date for comparison
             java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
             java.util.Date parsedDate = dateFormat.parse(date);
             java.sql.Date sqlDate = new java.sql.Date(parsedDate.getTime());

             // Get day of week from the date
             java.util.Calendar calendar = java.util.Calendar.getInstance();
             calendar.setTime(parsedDate);
             int dayOfWeek = calendar.get(java.util.Calendar.DAY_OF_WEEK);
             String[] daysOfWeek = {"", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
             String dayName = daysOfWeek[dayOfWeek];

             // Check if doctor is available on this day
             String availableDays = doctor.getAvailableDays();
             if (availableDays == null || availableDays.isEmpty()) {
                 availableDays = "Monday,Tuesday,Wednesday,Thursday,Friday"; // Default
             }

             boolean isDayAvailable = false;
             for (String day : availableDays.split(",")) {
                 if (day.trim().equalsIgnoreCase(dayName)) {
                     isDayAvailable = true;
                     break;
                 }
             }

             if (!isDayAvailable) {
                 System.out.println("Doctor is not available on " + dayName);
                 return false;
             }

             // Check if time is within doctor's available hours
             String availableTime = doctor.getAvailableTime();
             if (availableTime == null || availableTime.isEmpty()) {
                 availableTime = "09:00 AM - 05:00 PM"; // Default
             }

             // Parse available time range
             String[] timeRange = availableTime.split("-");
             if (timeRange.length != 2) {
                 System.err.println("Invalid time range format: " + availableTime);
                 return true; // Default to available if format is invalid
             }

             String startTimeStr = timeRange[0].trim();
             String endTimeStr = timeRange[1].trim();

             // Parse appointment time
             java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("hh:mm a");
             java.util.Date appointmentTime = timeFormat.parse(time);
             java.util.Date doctorStartTime = timeFormat.parse(startTimeStr);
             java.util.Date doctorEndTime = timeFormat.parse(endTimeStr);

             // Check if appointment time is within doctor's available hours
             if (appointmentTime.before(doctorStartTime) || appointmentTime.after(doctorEndTime)) {
                 System.out.println("Appointment time is outside doctor's available hours");
                 return false;
             }

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
             e.printStackTrace();
             // In case of error, assume the slot is not available to be safe
             return false;
         }
     }
 }