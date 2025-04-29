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

// Handles the admin dashboard page
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private DashboardService dashboardService;

    @Override
    public void init() {
        dashboardService = new DashboardService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Make sure user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            // Send users to their correct dashboard
            if ("DOCTOR".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            } else if ("PATIENT".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        // Load all dashboard data
        try {
            // Get statistics
            int doctorCount = dashboardService.getDoctorCount();
            int patientCount = dashboardService.getPatientCount();
            int newBookingCount = dashboardService.getNewBookingCount();
            int todaySessionCount = dashboardService.getTodaySessionCount();

            // Get upcoming appointments for this week
            List<Appointment> upcomingAppointments = dashboardService.getUpcomingAppointments();

            // Get newest doctors
            List<Doctor> recentDoctors = dashboardService.getRecentDoctors();

            // Get latest patient appointments
            List<Appointment> recentPatientAppointments = dashboardService.getRecentPatientAppointments();

            // Add all data to the request
            request.setAttribute("doctorCount", doctorCount);
            request.setAttribute("patientCount", patientCount);
            request.setAttribute("newBookingCount", newBookingCount);
            request.setAttribute("todaySessionCount", todaySessionCount);
            request.setAttribute("upcomingAppointments", upcomingAppointments);
            request.setAttribute("upcomingSessions", upcomingAppointments); // Using same data for both
            request.setAttribute("topDoctors", recentDoctors);
            request.setAttribute("recentAppointments", recentPatientAppointments);

            // Show the admin dashboard page
            request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error and show error message
            LOGGER.severe("Error retrieving dashboard data: " + e.getMessage());
            request.setAttribute("error", "Error retrieving dashboard data: " + e.getMessage());
            request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
        }
    }
}
