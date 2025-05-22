package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.dao.DoctorDAO;
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

/**
 * Servlet for handling viewing and editing medical records
 */
@WebServlet({"/doctor/view-medical-record", "/doctor/edit-medical-record", "/doctor/update-medical-record"})
public class DoctorViewEditMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorViewEditMedicalRecordServlet.class.getName());

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

        String action = request.getServletPath();
        LOGGER.log(Level.INFO, "Processing request for action: " + action);

        try {
            // Get doctor ID
            int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());
            if (doctorId == 0) {
                response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
                return;
            }

            // Get medical record ID
            String recordIdParam = request.getParameter("id");
            if (recordIdParam == null || recordIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
                return;
            }

            int recordId = Integer.parseInt(recordIdParam);
            LOGGER.log(Level.INFO, "Processing medical record ID: " + recordId);

            // Get the medical record
            MedicalRecord record = medicalRecordService.getMedicalRecordById(recordId);
            if (record == null) {
                request.setAttribute("errorMessage", "Medical record not found");
                request.getRequestDispatcher("/doctor/patients").forward(request, response);
                return;
            }

            // Get patient details
            Patient patient = patientService.getPatientById(record.getPatientId());
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/patients").forward(request, response);
                return;
            }

            // Set attributes for JSP
            request.setAttribute("patient", patient);
            request.setAttribute("medicalRecord", record);
            request.setAttribute("doctorId", doctorId);

            // Forward to appropriate page based on action
            if (action.equals("/doctor/view-medical-record")) {
                LOGGER.log(Level.INFO, "Forwarding to view-medical-record.jsp");
                request.getRequestDispatcher("/doctor/view-medical-record.jsp").forward(request, response);
            } else if (action.equals("/doctor/edit-medical-record")) {
                LOGGER.log(Level.INFO, "Forwarding to edit-medical-record.jsp");
                request.getRequestDispatcher("/doctor/edit-medical-record.jsp").forward(request, response);
            } else {
                LOGGER.log(Level.WARNING, "Unknown action: " + action);
                response.sendRedirect(request.getContextPath() + "/doctor/patients");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid medical record ID", e);
            response.sendRedirect(request.getContextPath() + "/doctor/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DoctorViewEditMedicalRecordServlet.doGet", e);
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

        String action = request.getServletPath();
        LOGGER.log(Level.INFO, "Processing POST request for action: " + action);

        try {
            // Get doctor ID
            int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());
            if (doctorId == 0) {
                response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
                return;
            }

            // Get form data
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");
            String notes = request.getParameter("notes");

            LOGGER.log(Level.INFO, "Updating medical record ID: " + recordId + " for patient ID: " + patientId);

            // Get the existing medical record
            MedicalRecord record = medicalRecordService.getMedicalRecordById(recordId);
            if (record == null) {
                request.setAttribute("errorMessage", "Medical record not found");
                request.getRequestDispatcher("/doctor/patients").forward(request, response);
                return;
            }

            // Update medical record
            record.setDiagnosis(diagnosis);
            record.setTreatment(treatment);
            record.setNotes(notes);

            // Save updated medical record
            boolean updated = medicalRecordService.updateMedicalRecord(record);

            if (updated) {
                LOGGER.log(Level.INFO, "Medical record updated successfully");
                // Set success message
                request.getSession().setAttribute("successMessage", "Medical record updated successfully");
                // Redirect to medical records page
                response.sendRedirect(request.getContextPath() + "/doctor/medical-records?patientId=" + patientId);
            } else {
                LOGGER.log(Level.WARNING, "Failed to update medical record");
                // Set error message
                request.setAttribute("errorMessage", "Failed to update medical record");
                // Get patient details again
                Patient patient = patientService.getPatientById(patientId);
                request.setAttribute("patient", patient);
                request.setAttribute("doctorId", doctorId);
                request.setAttribute("medicalRecord", record);
                // Forward back to form
                request.getRequestDispatcher("/doctor/edit-medical-record.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid parameters", e);
            response.sendRedirect(request.getContextPath() + "/doctor/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DoctorViewEditMedicalRecordServlet.doPost", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
