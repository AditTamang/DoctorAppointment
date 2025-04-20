package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.sql.Date;
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

@WebServlet(urlPatterns = {
    "/appointments",
    "/appointment/book",
    "/appointment/details",
    "/appointment/cancel",
    "/doctor/appointments",
    "/doctor/appointment/update"
})
public class AppointmentServlet extends HttpServlet {
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
            case "/appointments":
                listAppointments(request, response);
                break;
            case "/appointment/book":
                showBookAppointmentForm(request, response);
                break;
            case "/appointment/details":
                showAppointmentDetails(request, response);
                break;
            case "/doctor/appointments":
                listDoctorAppointments(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/appointment/book":
                bookAppointment(request, response);
                break;
            case "/appointment/cancel":
                cancelAppointment(request, response);
                break;
            case "/doctor/appointment/update":
                updateAppointmentStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if ("PATIENT".equals(user.getRole())) {
            // Get patient ID
            int patientId = patientService.getPatientIdByUserId(user.getId());

            if (patientId == 0) {
                // Patient profile not found, redirect to complete profile
                response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
                return;
            }

            // Get patient appointments
            List<Appointment> appointments = appointmentService.getAppointmentsByPatient(patientId);
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/patient/appointments.jsp").forward(request, response);
        } else if ("ADMIN".equals(user.getRole())) {
            // Get all appointments for admin
            List<Appointment> appointments = appointmentService.getAllAppointments();
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/admin/appointments.jsp").forward(request, response);
        } else {
            // Redirect to dashboard for other roles
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    private void showBookAppointmentForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"PATIENT".equals(user.getRole())) {
            // Only patients can book appointments
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Get patient ID
        int patientId = patientService.getPatientIdByUserId(user.getId());

        if (patientId == 0) {
            // Patient profile not found, redirect to complete profile
            response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
            return;
        }

        // Get doctor ID from request parameter
        String doctorIdParam = request.getParameter("doctorId");

        if (doctorIdParam != null && !doctorIdParam.isEmpty()) {
            int doctorId = Integer.parseInt(doctorIdParam);
            Doctor doctor = doctorService.getDoctorById(doctorId);
            request.setAttribute("doctor", doctor);
        }

        // Get all doctors for dropdown
        List<Doctor> doctors = doctorService.getAllDoctors();
        request.setAttribute("doctors", doctors);

        request.getRequestDispatcher("/book-appointment.jsp").forward(request, response);
    }

    private void showAppointmentDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get appointment ID
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentService.getAppointmentById(appointmentId);

        if (appointment == null) {
            // Appointment not found
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        }

        // Check if user has access to this appointment
        User user = (User) session.getAttribute("user");

        if ("PATIENT".equals(user.getRole())) {
            int patientId = patientService.getPatientIdByUserId(user.getId());

            if (patientId != appointment.getPatientId()) {
                // Not the patient's appointment
                response.sendRedirect(request.getContextPath() + "/appointments");
                return;
            }
        } else if ("DOCTOR".equals(user.getRole())) {
            // This method doesn't exist in our service yet, we'll need to add it
            // For now, we'll just use 0 as a placeholder
            int doctorId = 0; // doctorService.getDoctorIdByUserId(user.getId());

            if (doctorId != appointment.getDoctorId()) {
                // Not the doctor's appointment
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
        } else if (!"ADMIN".equals(user.getRole())) {
            // Not admin, patient, or doctor
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Set appointment in request
        request.setAttribute("appointment", appointment);

        // Forward to appropriate page based on role
        if ("PATIENT".equals(user.getRole())) {
            request.getRequestDispatcher("/patient/appointment-details.jsp").forward(request, response);
        } else if ("DOCTOR".equals(user.getRole())) {
            request.getRequestDispatcher("/doctor/appointment-details.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/admin/appointment-details.jsp").forward(request, response);
        }
    }

    private void listDoctorAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"DOCTOR".equals(user.getRole())) {
            // Only doctors can view their appointments
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Get doctor ID
        // This method doesn't exist in our service yet, we'll need to add it
        // For now, we'll just use 0 as a placeholder
        int doctorId = 0; // doctorService.getDoctorIdByUserId(user.getId());

        if (doctorId == 0) {
            // Doctor profile not found, redirect to complete profile
            response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
            return;
        }

        // Get doctor appointments
        List<Appointment> appointments = appointmentService.getAppointmentsByDoctorId(doctorId);
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/doctor/appointments.jsp").forward(request, response);
    }

    private void bookAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"PATIENT".equals(user.getRole())) {
            // Only patients can book appointments
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Get patient ID
        int patientId = patientService.getPatientIdByUserId(user.getId());

        if (patientId == 0) {
            // Patient profile not found, redirect to complete profile
            response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
            return;
        }

        // Get form data
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        String appointmentDateStr = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String symptoms = request.getParameter("symptoms");
        String reason = request.getParameter("reason");

        // Get doctor and patient names
        Doctor doctor = doctorService.getDoctorById(doctorId);
        String patientName = user.getUsername();
        String doctorName = doctor.getName();

        // Create appointment object
        Appointment appointment = new Appointment();
        appointment.setPatientId(patientId);
        appointment.setDoctorId(doctorId);
        appointment.setPatientName(patientName);
        appointment.setDoctorName(doctorName);
        appointment.setAppointmentDate(Date.valueOf(appointmentDateStr));
        appointment.setAppointmentTime(appointmentTime);
        appointment.setStatus("PENDING");
        appointment.setSymptoms(symptoms);
        appointment.setReason(reason);
        appointment.setFee(Double.parseDouble(doctor.getConsultationFee()));

        // Book appointment
        if (appointmentService.bookAppointment(appointment)) {
            request.setAttribute("message", "Appointment booked successfully!");
        } else {
            request.setAttribute("error", "Failed to book appointment. Please try again.");
        }

        // Redirect to appointments list
        response.sendRedirect(request.getContextPath() + "/appointments");
    }

    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get appointment ID
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentService.getAppointmentById(appointmentId);

        if (appointment == null) {
            // Appointment not found
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        }

        // Check if user has access to cancel this appointment
        User user = (User) session.getAttribute("user");

        if ("PATIENT".equals(user.getRole())) {
            int patientId = patientService.getPatientIdByUserId(user.getId());

            if (patientId != appointment.getPatientId()) {
                // Not the patient's appointment
                response.sendRedirect(request.getContextPath() + "/appointments");
                return;
            }
        } else if (!"ADMIN".equals(user.getRole())) {
            // Not admin or patient
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Cancel appointment
        if (appointmentService.updateAppointmentStatus(appointmentId, "CANCELLED")) {
            request.setAttribute("message", "Appointment cancelled successfully!");
        } else {
            request.setAttribute("error", "Failed to cancel appointment. Please try again.");
        }

        // Redirect to appointments list
        if ("PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/appointments");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
        }
    }

    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"DOCTOR".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
            // Only doctors and admins can update appointment status
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Get form data
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");
        String medicalReport = request.getParameter("medicalReport");

        // Update appointment
        // This method doesn't exist in our service yet, we'll need to add it
        if (appointmentService.updateAppointmentStatus(appointmentId, status)) {
            // For now, we'll just update the status
            request.setAttribute("message", "Appointment updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update appointment. Please try again.");
        }

        // Redirect to appointment details
        response.sendRedirect(request.getContextPath() + "/appointment/details?id=" + appointmentId);
    }
}
