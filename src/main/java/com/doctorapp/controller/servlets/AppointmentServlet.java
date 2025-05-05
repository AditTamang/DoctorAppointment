package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.List;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

// Servlet mappings defined in web.xml
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;
    private DoctorService doctorService;
    private PatientService patientService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        doctorService = new DoctorService();
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/appointments":
                listAppointments(request, response);
                break;
            case "/appointment/details":
                showAppointmentDetails(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/appointment/cancel":
                cancelAppointment(request, response);
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
            List<Appointment> appointments = appointmentService.getAppointmentsByPatientId(patientId);
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
            int doctorId = doctorService.getDoctorIdByUserId(user.getId());

            if (doctorId != appointment.getDoctorId()) {
                // Not the doctor's appointment
                response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
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





    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            // Get appointment ID from request parameter
            int appointmentId;

            // Process form submission
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                appointmentId = Integer.parseInt(idParam);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            Appointment appointment = appointmentService.getAppointmentById(appointmentId);

            if (appointment == null) {
                // Appointment not found
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Check if user has access to cancel this appointment
            User user = (User) session.getAttribute("user");

            if ("PATIENT".equals(user.getRole())) {
                int patientId = patientService.getPatientIdByUserId(user.getId());

                if (patientId != appointment.getPatientId()) {
                    // Not the patient's appointment
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
            } else if (!"ADMIN".equals(user.getRole())) {
                // Not admin or patient
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // Cancel appointment
            boolean success = appointmentService.updateAppointmentStatus(appointmentId, "CANCELLED");

            if (success) {
                // Set success status
                response.setStatus(HttpServletResponse.SC_OK);

                // If it's not an AJAX request, redirect
                if (!"XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    if ("PATIENT".equals(user.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/appointments");
                    }
                }
            } else {
                // Set error status
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            // Log the error
            System.err.println("Error cancelling appointment: " + e.getMessage());

            // Set error status
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }



    // Helper method to get String value from a Part
    private String getPartValueAsString(Part part) throws IOException {
        if (part == null) return null;

        java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(part.getInputStream()));
        StringBuilder value = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            value.append(line);
        }
        return value.toString();
    }
}
