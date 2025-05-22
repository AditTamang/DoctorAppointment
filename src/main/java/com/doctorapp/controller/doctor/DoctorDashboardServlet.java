package com.doctorapp.controller.doctor;

import java.io.IOException;

import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle doctor dashboard requests
 */
@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Check if user is a doctor
        if (!"DOCTOR".equals(user.getRole())) {
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("PATIENT".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
            return;
        }

        // Directly render the dashboard instead of forwarding to avoid potential redirect loops
        try {
            // Import necessary classes
            com.doctorapp.dao.DoctorDAO doctorDAO = new com.doctorapp.dao.DoctorDAO();
            com.doctorapp.dao.PatientDAO patientDAO = new com.doctorapp.dao.PatientDAO();
            com.doctorapp.dao.AppointmentDAO appointmentDAO = new com.doctorapp.dao.AppointmentDAO();

            // Get doctor details
            com.doctorapp.model.Doctor doctor = (com.doctorapp.model.Doctor) session.getAttribute("doctor");
            int doctorId;

            if (doctor == null) {
                // Doctor not in session, get from database
                doctorId = doctorDAO.getDoctorIdByUserId(user.getId());

                if (doctorId == 0) {
                    // Doctor profile not found, redirect to complete profile
                    response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
                    return;
                }

                // Get doctor details from database
                doctor = doctorDAO.getDoctorById(doctorId);

                // Store in session for future use
                if (doctor != null) {
                    session.setAttribute("doctor", doctor);
                }
            } else {
                doctorId = doctor.getId();
            }

            // Set doctor in request
            request.setAttribute("doctor", doctor);

            // Set default values for all attributes
            request.setAttribute("totalPatients", doctorDAO.getTotalPatientsByDoctor(doctorId));
            request.setAttribute("weeklyAppointments", appointmentDAO.getWeeklyAppointmentsByDoctor(doctorId));
            request.setAttribute("averageRating", doctorDAO.getAverageRatingByDoctor(doctorId));
            request.setAttribute("todayAppointments", appointmentDAO.getTodayAppointmentsCountByDoctor(doctorId));
            request.setAttribute("recentPatients", patientDAO.getRecentPatientsByDoctor(doctorId, 4));
            request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointmentsByDoctor(doctorId, 4));

            // Forward to dashboard JSP
            request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
