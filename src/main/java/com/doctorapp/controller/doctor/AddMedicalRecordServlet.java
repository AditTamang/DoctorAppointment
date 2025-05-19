package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.time.LocalDate;
import java.util.logging.Logger;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Doctor;
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

@WebServlet("/doctor/add-medical-record")
public class AddMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AddMedicalRecordServlet.class.getName());
    
    private PatientService patientService;
    private MedicalRecordService medicalRecordService;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() {
        patientService = new PatientService();
        medicalRecordService = new MedicalRecordService();
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is a doctor
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        // Get doctor ID
        int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());
        if (doctorId == 0) {
            response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
            return;
        }
        
        try {
            // Get patient ID from request parameter
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            
            // Get patient details
            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
                return;
            }
            
            // Set attributes for the JSP
            request.setAttribute("patient", patient);
            request.setAttribute("doctorId", doctorId);
            
            // Forward to add medical record form
            request.getRequestDispatcher("/doctor/add-medical-record.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid patient ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } catch (Exception e) {
            LOGGER.severe("Error showing add medical record form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is a doctor
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        // Get doctor ID
        int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());
        if (doctorId == 0) {
            response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
            return;
        }
        
        try {
            // Get form data
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");
            String notes = request.getParameter("notes");
            
            // Create medical record
            MedicalRecord medicalRecord = new MedicalRecord();
            medicalRecord.setPatientId(patientId);
            medicalRecord.setDoctorId(doctorId);
            medicalRecord.setDiagnosis(diagnosis);
            medicalRecord.setTreatment(treatment);
            medicalRecord.setNotes(notes);
            medicalRecord.setRecordDate(LocalDate.now().toString());
            
            // Save medical record
            boolean added = medicalRecordService.addMedicalRecord(medicalRecord);
            
            if (added) {
                request.setAttribute("successMessage", "Medical record added successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to add medical record");
            }
            
            // Redirect to patient details page
            response.sendRedirect(request.getContextPath() + "/doctor/view-patient?id=" + patientId);
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid patient ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } catch (Exception e) {
            LOGGER.severe("Error adding medical record: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
