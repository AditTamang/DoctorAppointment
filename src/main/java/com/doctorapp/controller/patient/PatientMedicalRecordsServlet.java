package com.doctorapp.controller.patient;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.MedicalRecord;
import com.doctorapp.model.Patient;
import com.doctorapp.model.User;
import com.doctorapp.service.MedicalRecordService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient/medical-records")
public class PatientMedicalRecordsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(PatientMedicalRecordsServlet.class.getName());
    
    private PatientService patientService;
    private MedicalRecordService medicalRecordService;
    
    @Override
    public void init() {
        patientService = new PatientService();
        medicalRecordService = new MedicalRecordService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is a patient
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
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
            
            // Get medical records
            List<MedicalRecord> medicalRecords = medicalRecordService.getMedicalRecordsByPatientId(patientId);
            
            // Set attributes for JSP
            request.setAttribute("patient", patient);
            request.setAttribute("medicalRecords", medicalRecords);
            
            // Forward to medical records page
            request.getRequestDispatcher("/patient/medical-records.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving medical records", e);
            request.setAttribute("errorMessage", "Error retrieving medical records: " + e.getMessage());
            request.getRequestDispatcher("/patient/dashboard").forward(request, response);
        }
    }
}
