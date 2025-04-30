package com.doctorapp.controller.doctor;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.User;
import com.doctorapp.model.Doctor;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.dao.AppointmentDAO;
import com.doctorapp.dao.PatientDAO;

/**
 * Servlet to handle doctor dashboard requests
 */
@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DoctorDAO doctorDAO;
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;

    public void init() {
        doctorDAO = new DoctorDAO();
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
    }

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

        try {
            // Get doctor information
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());

            if (doctor == null) {
                // Doctor profile not found, redirect to complete profile or show error
                request.setAttribute("error", "Doctor profile not found. Please complete your profile.");
                request.getRequestDispatcher("/doctor/complete-profile.jsp").forward(request, response);
                return;
            }

            request.setAttribute("doctor", doctor);

            // Get dashboard data
            int doctorId = doctor.getId();

            // Load doctor dashboard data
            request.setAttribute("totalPatients", doctorDAO.getTotalPatientsByDoctor(doctorId));
            request.setAttribute("weeklyAppointments", appointmentDAO.getWeeklyAppointmentsByDoctor(doctorId));
            request.setAttribute("pendingReports", doctorDAO.getPendingReportsByDoctor(doctorId));
            request.setAttribute("averageRating", doctorDAO.getAverageRatingByDoctor(doctorId));

            // Get today's appointments
            request.setAttribute("todayAppointments", appointmentDAO.getTodayAppointmentsByDoctor(doctorId));
            request.setAttribute("recentPatients", patientDAO.getRecentPatientsByDoctor(doctorId, 4));
            request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointmentsByDoctor(doctorId, 4));

            // Get cancelled appointments
            request.setAttribute("cancelledAppointments", appointmentDAO.getCancelledAppointmentsByDoctor(doctorId));

            // Get patients consulted
            request.setAttribute("patientsConsulted", doctorDAO.getPatientsConsultedByDoctor(doctorId));

            // Forward to the dashboard page
            request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
