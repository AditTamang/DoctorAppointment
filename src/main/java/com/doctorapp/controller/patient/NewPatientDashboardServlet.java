package com.doctorapp.controller.patient;

import java.io.IOException;
import java.util.List;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.Patient;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class NewPatientDashboardServlet
 * Handles the new patient dashboard functionality
 */
@WebServlet("/patient/new-dashboard")
public class NewPatientDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private PatientService patientService;
    private AppointmentService appointmentService;
    private DoctorService doctorService;

    public void init() {
        patientService = new PatientService();
        appointmentService = new AppointmentService();
        doctorService = new DoctorService();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(true); // Create session if it doesn't exist

        System.out.println("NewPatientDashboardServlet: Session ID: " + session.getId());

        if (session.getAttribute("user") == null) {
            System.out.println("NewPatientDashboardServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get user from session
        User user = (User) session.getAttribute("user");

        // Check if user is a patient
        if (!"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Get patient ID
            int patientId = patientService.getPatientIdByUserId(user.getId());

            if (patientId == 0) {
                // Patient profile not found, redirect to profile page to complete profile
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }

            // Get patient data
            Patient patient = patientService.getPatientById(patientId);

            // Get appointment statistics
            int totalVisits = 0;
            int upcomingVisitsCount = 0;
            int totalDoctors = 0;

            try {
                totalVisits = appointmentService.getTotalAppointmentsByPatient(patientId);
            } catch (Exception e) {
                System.err.println("Error getting total visits: " + e.getMessage());
            }

            try {
                upcomingVisitsCount = appointmentService.getUpcomingAppointmentCountByPatient(patientId);
            } catch (Exception e) {
                System.err.println("Error getting upcoming visits count: " + e.getMessage());
            }

            try {
                totalDoctors = doctorService.getTotalApprovedDoctors();
            } catch (Exception e) {
                System.err.println("Error getting total doctors: " + e.getMessage());
            }

            // Get appointments
            List<Appointment> upcomingAppointments = null;
            List<Appointment> pastAppointments = null;
            List<Appointment> cancelledAppointments = null;

            try {
                upcomingAppointments = appointmentService.getUpcomingAppointmentsByPatient(patientId, 10);
            } catch (Exception e) {
                System.err.println("Error getting upcoming appointments: " + e.getMessage());
            }

            try {
                pastAppointments = appointmentService.getPastAppointmentsByPatient(patientId, 10);
            } catch (Exception e) {
                System.err.println("Error getting past appointments: " + e.getMessage());
            }

            try {
                cancelledAppointments = appointmentService.getCancelledAppointmentsByPatient(patientId, 10);
            } catch (Exception e) {
                System.err.println("Error getting cancelled appointments: " + e.getMessage());
            }

            // Set attributes for JSP
            request.setAttribute("patient", patient);
            request.setAttribute("totalVisits", totalVisits);
            request.setAttribute("upcomingVisitsCount", upcomingVisitsCount);
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("upcomingAppointments", upcomingAppointments);
            request.setAttribute("pastAppointments", pastAppointments);
            request.setAttribute("cancelledAppointments", cancelledAppointments);

            // Forward to the new patient dashboard
            request.getRequestDispatcher("/patient-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in NewPatientDashboardServlet: " + e.getMessage());
            e.printStackTrace();

            // Set error message
            request.setAttribute("errorMessage", "An error occurred while loading the dashboard. Please try again later.");

            // Forward to error page
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
