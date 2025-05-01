package com.doctorapp.controller.patient;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;
import com.doctorapp.service.PatientService;
import com.doctorapp.util.ValidationUtil;

/**
 * Servlet for handling appointment booking operations
 */
@WebServlet(urlPatterns = {
    "/appointment/book",
    "/appointment/confirm"
})
public class AppointmentBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;
    private DoctorService doctorService;
    private PatientService patientService;

    public void init() {
        appointmentService = new AppointmentService();
        doctorService = new DoctorService();
        patientService = new PatientService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/appointment/book":
                showBookingForm(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctors");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/appointment/confirm":
                confirmBooking(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctors");
                break;
        }
    }

    /**
     * Show appointment booking form
     */
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            // Save the requested URL for redirect after login
            session.setAttribute("redirectAfterLogin", request.getRequestURI() + "?" + request.getQueryString());
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get doctor ID from request
        String doctorIdParam = request.getParameter("doctorId");
        if (doctorIdParam == null || doctorIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        }

        int doctorId;
        try {
            doctorId = Integer.parseInt(doctorIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        }

        // Get doctor details
        Doctor doctor = doctorService.getDoctorById(doctorId);
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        }

        // Get patient ID
        int patientId = patientService.getPatientIdByUserId(user.getId());
        if (patientId == 0) {
            // Create a new patient record if it doesn't exist
            com.doctorapp.model.Patient patient = new com.doctorapp.model.Patient();
            patient.setUserId(user.getId());
            patient.setFirstName(user.getFirstName());
            patient.setLastName(user.getLastName());
            patient.setEmail(user.getEmail());
            patient.setPhone(user.getPhone());
            patient.setAddress(user.getAddress());

            // Save the new patient
            patientService.addPatient(patient);

            // Get the newly created patient ID
            patientId = patientService.getPatientIdByUserId(user.getId());
        }

        // Get available time slots for the doctor
        List<String> availableTimeSlots = appointmentService.getAvailableTimeSlots(doctorId);

        // Set attributes for the booking form
        request.setAttribute("doctor", doctor);
        request.setAttribute("patientId", patientId);
        request.setAttribute("availableTimeSlots", availableTimeSlots);

        // Forward to booking form
        request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
    }

    /**
     * Confirm appointment booking
     */
    private void confirmBooking(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get form data
        String doctorIdParam = request.getParameter("doctorId");
        String patientIdParam = request.getParameter("patientId");
        String appointmentDate = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String reason = request.getParameter("reason");
        String symptoms = request.getParameter("symptoms");

        // Validate input
        boolean hasError = false;

        if (doctorIdParam == null || doctorIdParam.isEmpty() || patientIdParam == null || patientIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Invalid doctor or patient information");
            hasError = true;
        }

        if (appointmentDate == null || appointmentDate.isEmpty()) {
            request.setAttribute("dateError", "Please select an appointment date");
            hasError = true;
        } else {
            try {
                LocalDate date = LocalDate.parse(appointmentDate);
                LocalDate today = LocalDate.now();

                if (date.isBefore(today)) {
                    request.setAttribute("dateError", "Appointment date cannot be in the past");
                    hasError = true;
                }
            } catch (DateTimeParseException e) {
                request.setAttribute("dateError", "Invalid date format");
                hasError = true;
            }
        }

        if (appointmentTime == null || appointmentTime.isEmpty()) {
            request.setAttribute("timeError", "Please select an appointment time");
            hasError = true;
        }

        if (reason == null || reason.isEmpty()) {
            request.setAttribute("reasonError", "Please provide a reason for the appointment");
            hasError = true;
        }

        if (hasError) {
            // Get doctor details again
            int doctorId = Integer.parseInt(doctorIdParam);
            Doctor doctor = doctorService.getDoctorById(doctorId);

            // Get available time slots for the doctor
            List<String> availableTimeSlots = appointmentService.getAvailableTimeSlots(doctorId);

            // Set attributes for the booking form
            request.setAttribute("doctor", doctor);
            request.setAttribute("patientId", patientIdParam);
            request.setAttribute("availableTimeSlots", availableTimeSlots);
            request.setAttribute("appointmentDate", appointmentDate);
            request.setAttribute("appointmentTime", appointmentTime);
            request.setAttribute("reason", reason);
            request.setAttribute("symptoms", symptoms);

            // Forward back to booking form
            request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
            return;
        }

        // Parse IDs
        int doctorId = Integer.parseInt(doctorIdParam);
        int patientId = Integer.parseInt(patientIdParam);

        // Create appointment object
        Appointment appointment = new Appointment();
        appointment.setDoctorId(doctorId);
        appointment.setPatientId(patientId);

        // Convert String date to java.util.Date
        try {
            java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Date parsedDate = dateFormat.parse(appointmentDate);
            appointment.setAppointmentDate(parsedDate);
        } catch (Exception e) {
            System.err.println("Error parsing date: " + e.getMessage());
            // Use current date as fallback
            appointment.setAppointmentDate(new java.util.Date());
        }

        appointment.setAppointmentTime(appointmentTime);
        appointment.setReason(reason);
        appointment.setSymptoms(symptoms);
        appointment.setStatus("PENDING");

        // Check if the time slot is already booked
        boolean isTimeSlotAvailable = appointmentService.isTimeSlotAvailable(doctorId, appointmentDate, appointmentTime);

        if (!isTimeSlotAvailable) {
            // Time slot is already booked
            request.setAttribute("timeError", "This time slot is no longer available. Please select another time.");

            // Get doctor details again
            Doctor doctor = doctorService.getDoctorById(doctorId);

            // Get available time slots for the doctor (refresh the list)
            List<String> availableTimeSlots = appointmentService.getAvailableTimeSlots(doctorId);

            // Set attributes for the booking form
            request.setAttribute("doctor", doctor);
            request.setAttribute("patientId", patientId);
            request.setAttribute("availableTimeSlots", availableTimeSlots);
            request.setAttribute("appointmentDate", appointmentDate);
            request.setAttribute("reason", reason);
            request.setAttribute("symptoms", symptoms);

            // Forward back to booking form
            request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
            return;
        }

        // Book appointment
        boolean booked = appointmentService.bookAppointment(appointment);

        if (booked) {
            // Update doctor's patient count
            doctorService.incrementPatientCount(doctorId);

            // Get doctor details for confirmation page
            Doctor doctor = doctorService.getDoctorById(doctorId);

            // Set doctor name in appointment for display
            appointment.setDoctorName(doctor.getName());

            // Set patient name in appointment for display
            String patientName = user.getFirstName() + " " + user.getLastName();
            appointment.setPatientName(patientName);

            // Redirect to success page
            request.setAttribute("successMessage", "Appointment booked successfully");
            request.setAttribute("appointment", appointment);
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/patient/appointmentConfirmation.jsp").forward(request, response);
        } else {
            // Redirect back to booking form with error
            request.setAttribute("errorMessage", "Failed to book appointment. Please try again.");

            // Get doctor details again
            Doctor doctor = doctorService.getDoctorById(doctorId);

            // Get available time slots for the doctor
            List<String> availableTimeSlots = appointmentService.getAvailableTimeSlots(doctorId);

            // Set attributes for the booking form
            request.setAttribute("doctor", doctor);
            request.setAttribute("patientId", patientId);
            request.setAttribute("availableTimeSlots", availableTimeSlots);
            request.setAttribute("appointmentDate", appointmentDate);
            request.setAttribute("appointmentTime", appointmentTime);
            request.setAttribute("reason", reason);
            request.setAttribute("symptoms", symptoms);

            // Forward back to booking form
            request.getRequestDispatcher("/patient/bookAppointment.jsp").forward(request, response);
        }
    }
}
