package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.doctorapp.dao.AppointmentDAO;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.dao.PatientDAO;
import com.doctorapp.dao.UserDAO;
import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.Patient;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

            // Get doctor counts by status
            int approvedDoctors = doctorDAO.getApprovedDoctorsCount();
            int pendingDoctors = doctorDAO.getPendingDoctorsCount();
            int rejectedDoctors = doctorDAO.getRejectedDoctorsCount();

            // Get today's appointments count
            int todayAppointments = appointmentDAO.getTodayAppointmentsCount();

            // Get new bookings count (pending appointments)
            int newBookings = appointmentDAO.getPendingAppointmentsCount();

            System.out.println("Admin dashboard stats: Doctors=" + totalDoctors + ", Patients=" + totalPatients + ", Appointments=" + totalAppointments);
            System.out.println("Doctor status counts: Approved=" + approvedDoctors + ", Pending=" + pendingDoctors + ", Rejected=" + rejectedDoctors);

            // Set attributes for the dashboard
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("approvedDoctors", approvedDoctors);
            request.setAttribute("pendingDoctors", pendingDoctors);
            request.setAttribute("rejectedDoctors", rejectedDoctors);
            request.setAttribute("todayAppointments", todayAppointments);
            request.setAttribute("newBookings", newBookings);

            // Get upcoming appointments and sessions
            try {
                request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointments(5));
                request.setAttribute("upcomingSessions", appointmentDAO.getUpcomingSessions(5));
                request.setAttribute("recentAppointments", appointmentDAO.getRecentAppointments(5));
                request.setAttribute("topDoctors", doctorDAO.getTopDoctors(3));
            } catch (Exception e) {
                System.err.println("Error getting dashboard data: " + e.getMessage());
                e.printStackTrace();
                // Set empty lists as fallback
                request.setAttribute("upcomingAppointments", new ArrayList<Appointment>());
                request.setAttribute("upcomingSessions", new ArrayList<Appointment>());
                request.setAttribute("recentAppointments", new ArrayList<Appointment>());
                request.setAttribute("topDoctors", new ArrayList<Doctor>());
            }

            System.out.println("Forwarding to admin/index.jsp");
            // Forward to admin dashboard
            request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error loading admin dashboard: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private void loadDoctorDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get the logged-in doctor's ID
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("user");
            int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());

            if (doctorId == 0) {
                // Doctor profile not found, redirect to complete profile
                response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
                return;
            }

            // Get doctor information
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            request.setAttribute("doctor", doctor);

            // Load doctor dashboard data
            int totalPatients = doctorDAO.getTotalPatientsByDoctor(doctorId);
            int weeklyAppointments = appointmentDAO.getWeeklyAppointmentsByDoctor(doctorId);
            int pendingReports = doctorDAO.getPendingReportsByDoctor(doctorId);
            double averageRating = doctorDAO.getAverageRatingByDoctor(doctorId);

            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("weeklyAppointments", weeklyAppointments);
            request.setAttribute("pendingReports", pendingReports);
            request.setAttribute("averageRating", averageRating);

            // Get today's appointments
            List<Appointment> todayAppointments = appointmentDAO.getTodayAppointmentsByDoctor(doctorId);
            List<Patient> recentPatients = patientDAO.getRecentPatientsByDoctor(doctorId, 4);
            List<Appointment> upcomingAppointments = appointmentDAO.getUpcomingAppointmentsByDoctor(doctorId, 4);

            request.setAttribute("todayAppointments", todayAppointments);
            request.setAttribute("todayAppointmentsCount", todayAppointments != null ? todayAppointments.size() : 0);
            request.setAttribute("recentPatients", recentPatients);
            request.setAttribute("upcomingAppointments", upcomingAppointments);
            request.setAttribute("upcomingAppointmentsCount", upcomingAppointments != null ? upcomingAppointments.size() : 0);

            System.out.println("Forwarding to doctor/index.jsp");
            // Forward to doctor dashboard
            request.getRequestDispatcher("/doctor/index.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error loading doctor dashboard: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
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
