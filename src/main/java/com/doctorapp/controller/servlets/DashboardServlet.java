package com.doctorapp.controller.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.User;
import com.doctorapp.dao.UserDAO;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.dao.PatientDAO;
import com.doctorapp.dao.AppointmentDAO;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;

    public void init() {
        userDAO = new UserDAO();
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
        appointmentDAO = new AppointmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("DashboardServlet: doGet method called");
            HttpSession session = request.getSession(false);
            System.out.println("DashboardServlet: Session ID: " + (session != null ? session.getId() : "null"));

            // Check if user is logged in
            if (session == null || session.getAttribute("user") == null) {
                System.out.println("DashboardServlet: No user in session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            String role = user.getRole();

            System.out.println("DashboardServlet: User ID: " + user.getId() + ", Username: " + user.getUsername() + ", Role: " + role);

            // Route to appropriate dashboard based on role
            switch (role) {
                case "ADMIN":
                    System.out.println("DashboardServlet: Loading admin dashboard");
                    loadAdminDashboard(request, response);
                    break;
                case "DOCTOR":
                    System.out.println("DashboardServlet: Loading doctor dashboard");
                    loadDoctorDashboard(request, response);
                    break;
                case "PATIENT":
                    System.out.println("DashboardServlet: Loading patient dashboard");
                    loadPatientDashboard(request, response);
                    break;
                default:
                    // Invalid role, redirect to login
                    System.out.println("DashboardServlet: Invalid role: " + role);
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid role: " + role);
                    break;
            }
        } catch (Exception e) {
            System.err.println("DashboardServlet Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private void loadAdminDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("Loading admin dashboard data");
            // Load admin dashboard data
            int totalDoctors = doctorDAO.getTotalDoctors();
            int totalPatients = patientDAO.getTotalPatients();
            int totalAppointments = appointmentDAO.getTotalAppointments();
            double totalRevenue = appointmentDAO.getTotalRevenue();

            System.out.println("Admin dashboard stats: Doctors=" + totalDoctors + ", Patients=" + totalPatients + ", Appointments=" + totalAppointments);

            // Get recent appointments
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentAppointments", appointmentDAO.getRecentAppointments(5));
            request.setAttribute("topDoctors", doctorDAO.getTopDoctors(3));

            System.out.println("Forwarding to admin-dashboard.jsp");
            // Forward to admin dashboard
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error loading admin dashboard: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private void loadDoctorDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the logged-in doctor's ID
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());

        if (doctorId == 0) {
            // Doctor profile not found, redirect to complete profile
            response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
            return;
        }

        // Load doctor dashboard data
        request.setAttribute("totalPatients", doctorDAO.getTotalPatientsByDoctor(doctorId));
        request.setAttribute("weeklyAppointments", appointmentDAO.getWeeklyAppointmentsByDoctor(doctorId));
        request.setAttribute("pendingReports", doctorDAO.getPendingReportsByDoctor(doctorId));
        request.setAttribute("averageRating", doctorDAO.getAverageRatingByDoctor(doctorId));

        // Get today's appointments
        request.setAttribute("todayAppointments", appointmentDAO.getTodayAppointmentsByDoctor(doctorId));
        request.setAttribute("recentPatients", patientDAO.getRecentPatientsByDoctor(doctorId, 4));
        request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointmentsByDoctor(doctorId, 4));

        // Forward to doctor dashboard
        request.getRequestDispatcher("/doctor-dashboard.jsp").forward(request, response);
    }

    private void loadPatientDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the logged-in patient's ID
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int patientId = patientDAO.getPatientIdByUserId(user.getId());

        if (patientId == 0) {
            // Patient profile not found, redirect to complete profile
            response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
            return;
        }

        // Load patient dashboard data
        request.setAttribute("nextAppointment", appointmentDAO.getNextAppointmentByPatient(patientId));
        request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointmentsByPatient(patientId, 3));
        request.setAttribute("recentMedicalRecords", patientDAO.getRecentMedicalRecords(patientId, 4));
        request.setAttribute("currentPrescriptions", patientDAO.getCurrentPrescriptions(patientId));

        // Forward to patient dashboard
        request.getRequestDispatcher("/patient-dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
