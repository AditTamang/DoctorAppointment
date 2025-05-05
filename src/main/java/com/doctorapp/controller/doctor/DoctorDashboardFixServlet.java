package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.List;

import com.doctorapp.dao.AppointmentDAO;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.dao.PatientDAO;
import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.Patient;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class DoctorDashboardFixServlet
 * Handles the fixed doctor dashboard and appointment management
 * URL mappings are defined in web.xml
 */
public class DoctorDashboardFixServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DoctorDAO doctorDAO;
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;

    public DoctorDashboardFixServlet() {
        super();
        doctorDAO = new DoctorDAO();
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/doctor/dashboard-fix":
                showDashboard(request, response);
                break;
            case "/doctor/appointments-fix":
                showAppointments(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/doctor/appointment/update-status-fix":
                updateAppointmentStatus(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }

    /**
     * Show the doctor dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get doctor information
        Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
            return;
        }

        // Get appointment counts
        int doctorId = doctor.getId();
        int pendingCount = appointmentDAO.getAppointmentCountByDoctorIdAndStatus(doctorId, "PENDING");
        int approvedCount = appointmentDAO.getAppointmentCountByDoctorIdAndStatus(doctorId, "APPROVED");
        int completedCount = appointmentDAO.getAppointmentCountByDoctorIdAndStatus(doctorId, "COMPLETED");
        int rejectedCount = appointmentDAO.getAppointmentCountByDoctorIdAndStatus(doctorId, "REJECTED");

        // Get recent appointments
        List<Appointment> pendingAppointments = appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, "PENDING");
        List<Appointment> approvedAppointments = appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, "APPROVED");
        List<Appointment> completedAppointments = appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, "COMPLETED");
        List<Appointment> rejectedAppointments = appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, "REJECTED");

        // Get recent patients
        List<Patient> recentPatients = patientDAO.getRecentPatientsByDoctor(doctorId, 5);

        // Set attributes
        request.setAttribute("doctor", doctor);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("pendingAppointments", pendingAppointments);
        request.setAttribute("approvedAppointments", approvedAppointments);
        request.setAttribute("completedAppointments", completedAppointments);
        request.setAttribute("rejectedAppointments", rejectedAppointments);
        request.setAttribute("recentPatients", recentPatients);

        // Forward to dashboard
        request.getRequestDispatcher("/doctor/doctor-dashboard-fix.jsp").forward(request, response);
    }

    /**
     * Show the appointments page
     */
    private void showAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get doctor information
        Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
            return;
        }

        // Get appointment data
        int doctorId = doctor.getId();
        List<Appointment> pendingAppointments = appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, "PENDING");
        List<Appointment> approvedAppointments = appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, "APPROVED");
        List<Appointment> completedAppointments = appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, "COMPLETED");
        List<Appointment> rejectedAppointments = appointmentDAO.getAppointmentsByDoctorIdAndStatus(doctorId, "REJECTED");

        // Set attributes
        request.setAttribute("doctor", doctor);
        request.setAttribute("pendingAppointments", pendingAppointments);
        request.setAttribute("approvedAppointments", approvedAppointments);
        request.setAttribute("completedAppointments", completedAppointments);
        request.setAttribute("rejectedAppointments", rejectedAppointments);

        // Forward to appointments page
        request.getRequestDispatcher("/doctor/appointments-fix.jsp").forward(request, response);
    }

    /**
     * Update appointment status
     */
    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Get parameters
        String appointmentIdParam = request.getParameter("id");
        String status = request.getParameter("status");

        if (appointmentIdParam == null || status == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);

            // Update appointment status
            boolean updated = appointmentDAO.updateAppointmentStatus(appointmentId, status);

            if (updated) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
