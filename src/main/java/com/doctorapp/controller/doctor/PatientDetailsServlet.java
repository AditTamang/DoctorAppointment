package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.doctorapp.model.User;
import com.doctorapp.model.Patient;
import com.doctorapp.model.Appointment;
import com.doctorapp.service.PatientService;
import com.doctorapp.service.AppointmentService;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Servlet to handle patient details requests from doctors
 */
@WebServlet("/doctor/patient-details")
public class PatientDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(PatientDetailsServlet.class.getName());
    
    private PatientService patientService;
    private AppointmentService appointmentService;
    
    public PatientDetailsServlet() {
        patientService = new PatientService();
        appointmentService = new AppointmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is a doctor
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get patient ID from request parameter
        String patientIdParam = request.getParameter("id");
        
        if (patientIdParam == null || patientIdParam.isEmpty()) {
            // If no specific patient is requested, show all patients for this doctor
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            List<Patient> patients = patientService.getPatientsByDoctorId(doctorId);
            request.setAttribute("patients", patients);
            request.getRequestDispatcher("/doctor/patient-details.jsp").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdParam);
            
            // Get patient details
            Patient patient = patientService.getPatientById(patientId);
            
            if (patient == null) {
                // Patient not found
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
                return;
            }
            
            // Get patient's appointments with this doctor
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            List<Appointment> appointments = appointmentService.getAppointmentsByPatientAndDoctorId(patientId, doctorId);
            
            // Set attributes for the JSP
            request.setAttribute("patient", patient);
            request.setAttribute("appointments", appointments);
            
            // Forward to patient details page
            request.getRequestDispatcher("/doctor/patient-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid patient ID: " + patientIdParam, e);
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving patient details", e);
            request.setAttribute("errorMessage", "Error retrieving patient details: " + e.getMessage());
            request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
        }
    }
}
