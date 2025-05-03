package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.List;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(urlPatterns = {
    "/appointments",
    "/appointment/details",
    "/appointment/cancel",
    "/doctor/appointments",
    "/doctor/appointment/update"
})
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
            case "/doctor/appointments":
                listDoctorAppointments(request, response);
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

        try {
            // Get doctor ID
            int doctorId = doctorService.getDoctorIdByUserId(user.getId());

            if (doctorId == 0) {
                // Doctor profile not found, redirect to complete profile
                response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
                return;
            }

            // Get doctor information
            Doctor doctor = doctorService.getDoctorById(doctorId);
            request.setAttribute("doctor", doctor);

            // Get appointments by status
            List<Appointment> pendingAppointments = appointmentService.getAppointmentsByDoctorIdAndStatus(doctorId, "PENDING");
            List<Appointment> approvedAppointments = appointmentService.getAppointmentsByDoctorIdAndStatus(doctorId, "APPROVED"); // This will be converted to CONFIRMED in DAO
            List<Appointment> completedAppointments = appointmentService.getAppointmentsByDoctorIdAndStatus(doctorId, "COMPLETED");
            List<Appointment> rejectedAppointments = appointmentService.getAppointmentsByDoctorIdAndStatus(doctorId, "REJECTED"); // This will be converted to CANCELLED in DAO

            // Set attributes
            request.setAttribute("pendingAppointments", pendingAppointments);
            request.setAttribute("approvedAppointments", approvedAppointments);
            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("rejectedAppointments", rejectedAppointments);

            // Forward to the appointment management page
            request.getRequestDispatcher("/doctor/appointment-management.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error
            System.err.println("Error loading doctor appointments: " + e.getMessage());
            e.printStackTrace();

            // Set error message and forward to error page
            request.setAttribute("errorMessage", "An error occurred while loading appointments: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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

    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Check if it's an AJAX request
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"User not logged in\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"DOCTOR".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
            // Only doctors and admins can update appointment status
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Unauthorized access\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
            return;
        }

        try {
            // Get form data - handle both regular and multipart requests
            int appointmentId;
            String status;

            // Check if it's a multipart request
            if (request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
                // Process multipart request
                Part idPart = request.getPart("id");
                Part statusPart = request.getPart("status");

                if (idPart == null || statusPart == null) {
                    if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\": false, \"message\": \"Missing required parameters\"}");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                    }
                    return;
                }

                appointmentId = Integer.parseInt(getPartValueAsString(idPart));
                status = getPartValueAsString(statusPart);

                // Process any uploaded files if needed
                Part medicalReportPart = request.getPart("medicalReport");
                if (medicalReportPart != null && medicalReportPart.getSize() > 0) {
                    // Handle file upload - for now we're just acknowledging it
                    System.out.println("Medical report file uploaded: " + medicalReportPart.getSubmittedFileName());
                }
            } else {
                // Process regular form submission
                String idParam = request.getParameter("id");
                status = request.getParameter("status");

                if (idParam == null || idParam.isEmpty() || status == null || status.isEmpty()) {
                    if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\": false, \"message\": \"Missing required parameters\"}");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                    }
                    return;
                }

                appointmentId = Integer.parseInt(idParam);
            }

            // Validate status
            if (!status.equals("APPROVED") && !status.equals("REJECTED") && !status.equals("COMPLETED")) {
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"message\": \"Invalid status\"}");
                } else {
                    request.setAttribute("error", "Invalid status value.");
                    response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                }
                return;
            }

            // Get doctor ID if user is a doctor
            if ("DOCTOR".equals(user.getRole())) {
                int doctorId = doctorService.getDoctorIdByUserId(user.getId());

                // Get appointment
                Appointment appointment = appointmentService.getAppointmentById(appointmentId);

                // Check if appointment exists and belongs to the doctor
                if (appointment == null) {
                    if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\": false, \"message\": \"Appointment not found\"}");
                    } else {
                        request.setAttribute("error", "Appointment not found.");
                        response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                    }
                    return;
                }

                if (appointment.getDoctorId() != doctorId) {
                    if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\": false, \"message\": \"Unauthorized access to this appointment\"}");
                    } else {
                        request.setAttribute("error", "You are not authorized to update this appointment.");
                        response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                    }
                    return;
                }
            }

            // Update appointment
            boolean success = appointmentService.updateAppointmentStatus(appointmentId, status);

            // Handle response based on request type
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                if (success) {
                    // Set HTTP status to 200 OK
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"success\": true, \"message\": \"Appointment status updated successfully\"}");
                } else {
                    // Set HTTP status to 500 Internal Server Error
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"success\": false, \"message\": \"Failed to update appointment status\"}");
                }
            } else {
                if (success) {
                    request.setAttribute("message", "Appointment updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update appointment. Please try again.");
                }

                // Redirect based on user role
                if ("DOCTOR".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                } else {
                    response.sendRedirect(request.getContextPath() + "/appointment/details?id=" + appointmentId);
                }
            }
        } catch (NumberFormatException e) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid appointment ID\"}");
            } else {
                request.setAttribute("error", "Invalid appointment ID.");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            }
        } catch (Exception e) {
            // Log the error
            System.err.println("Error updating appointment status: " + e.getMessage());
            e.printStackTrace();

            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"An error occurred: " + e.getMessage() + "\"}");
            } else {
                request.setAttribute("error", "An error occurred while updating the appointment. Please try again.");
                response.sendRedirect(request.getContextPath() + "/error.jsp");
            }
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
