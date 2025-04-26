package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.doctorapp.model.User;
import com.doctorapp.model.Patient;
import com.doctorapp.model.Appointment;
import com.doctorapp.service.PatientService;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;

/**
 * Servlet implementation class PatientDashboardServlet
 * Handles the patient dashboard functionality
 */
@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
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
        
        // Get patient ID
        int patientId = patientService.getPatientIdByUserId(user.getId());
        
        if (patientId == 0) {
            // Patient profile not found, redirect to complete profile
            response.sendRedirect(request.getContextPath() + "/patient/completeProfile.jsp");
            return;
        }
        
        // Get patient data
        Patient patient = patientService.getPatientById(patientId);
        
        // Get appointment statistics
        int totalVisits = appointmentService.getTotalAppointmentsByPatient(patientId);
        int upcomingVisitsCount = appointmentService.getUpcomingAppointmentCountByPatient(patientId);
        int totalDoctors = doctorService.getTotalApprovedDoctors();
        
        // Get appointments
        List<Appointment> upcomingAppointments = appointmentService.getUpcomingAppointmentsByPatient(patientId, 10);
        List<Appointment> pastAppointments = appointmentService.getPastAppointmentsByPatient(patientId, 10);
        List<Appointment> cancelledAppointments = appointmentService.getCancelledAppointmentsByPatient(patientId, 10);
        
        // Set attributes for JSP
        request.setAttribute("patient", patient);
        request.setAttribute("totalVisits", totalVisits);
        request.setAttribute("upcomingVisitsCount", upcomingVisitsCount);
        request.setAttribute("totalDoctors", totalDoctors);
        request.setAttribute("upcomingAppointments", upcomingAppointments);
        request.setAttribute("pastAppointments", pastAppointments);
        request.setAttribute("cancelledAppointments", cancelledAppointments);
        
        // Forward to patient dashboard
        request.getRequestDispatcher("/patient/patientDashboard.jsp").forward(request, response);
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
