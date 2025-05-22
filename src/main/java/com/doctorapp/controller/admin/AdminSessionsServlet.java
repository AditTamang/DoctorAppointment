package com.doctorapp.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for admin sessions management
 */
@WebServlet("/admin/sessions")
public class AdminSessionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminSessionsServlet.class.getName());
    private AppointmentService appointmentService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
    }

    /**
     * Handles GET requests for the admin sessions page
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verify admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            // Redirect to appropriate dashboard based on role
            if ("DOCTOR".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            } else if ("PATIENT".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        // Load sessions data
        try {
            // Get all appointments (sessions)
            List<Appointment> sessions = appointmentService.getAllAppointments();
            request.setAttribute("sessions", sessions);
            
            // Forward to the sessions page
            request.getRequestDispatcher("/admin/sessions.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle errors
            LOGGER.severe("Error retrieving sessions data: " + e.getMessage());
            request.setAttribute("error", "Error retrieving sessions data: " + e.getMessage());
            request.getRequestDispatcher("/admin/sessions.jsp").forward(request, response);
        }
    }
}
