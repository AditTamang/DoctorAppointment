package com.doctorapp.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for admin dashboard - displays statistics and recent activity
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private DashboardService dashboardService;

    @Override
    public void init() {
        dashboardService = new DashboardService();
    }

    /**
     * Handles GET requests for the admin dashboard
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

        // Load dashboard data
        try {
            // Fetch dashboard statistics
            int doctorCount = dashboardService.getDoctorCount();
            int patientCount = dashboardService.getPatientCount();
            int newBookingCount = dashboardService.getNewBookingCount();
            int todaySessionCount = dashboardService.getTodaySessionCount();

            // Fetch recent activity data
            List<Appointment> upcomingAppointments = dashboardService.getUpcomingAppointments();
            List<Doctor> recentDoctors = dashboardService.getRecentDoctors();
            List<Appointment> recentPatientAppointments = dashboardService.getRecentPatientAppointments();

            // Set attributes for the dashboard view
            request.setAttribute("doctorCount", doctorCount);
            request.setAttribute("patientCount", patientCount);
            request.setAttribute("newBookingCount", newBookingCount);
            request.setAttribute("todaySessionCount", todaySessionCount);
            request.setAttribute("upcomingAppointments", upcomingAppointments);
            request.setAttribute("upcomingSessions", upcomingAppointments);
            request.setAttribute("topDoctors", recentDoctors);
            request.setAttribute("recentAppointments", recentPatientAppointments);

            // Display dashboard
            request.getRequestDispatcher("/admin/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle errors
            LOGGER.severe("Error retrieving dashboard data: " + e.getMessage());
            request.setAttribute("error", "Error retrieving dashboard data: " + e.getMessage());
            request.getRequestDispatcher("/admin/admin-dashboard.jsp").forward(request, response);
        }
    }
}
