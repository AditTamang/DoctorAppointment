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

@WebServlet(urlPatterns = {
    "/patient/medical-records",
    "/patient/medical-record/view"
})
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

        // Get the servlet path to determine which action to take
        String servletPath = request.getServletPath();

        if ("/patient/medical-record/view".equals(servletPath)) {
            viewSingleMedicalRecord(request, response, user);
        } else {
            // Default action: list all medical records
            listMedicalRecords(request, response, user);
        }
    }

    /**
     * View a single medical record with proper access control
     */
    private void viewSingleMedicalRecord(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            // Get patient ID for the current logged-in user
            int patientId = patientService.getPatientIdByUserId(user.getId());

            if (patientId == 0) {
                // Patient profile not found, redirect to profile page to complete profile
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }

            // Get the requested medical record ID
            String recordIdParam = request.getParameter("id");
            if (recordIdParam == null || recordIdParam.isEmpty()) {
                request.setAttribute("errorMessage", "Medical record ID is required");
                request.getRequestDispatcher("/patient/medical-records").forward(request, response);
                return;
            }

            try {
                int recordId = Integer.parseInt(recordIdParam);

                // Check if the patient has access to this record
                if (!medicalRecordService.canPatientAccessRecord(patientId, recordId)) {
                    LOGGER.log(Level.WARNING, "Security violation: Patient ID {0} attempted to access record ID {1}",
                        new Object[]{patientId, recordId});
                    request.setAttribute("errorMessage", "You are not authorized to view this medical record");
                    request.getRequestDispatcher("/patient/medical-records").forward(request, response);
                    return;
                }

                // Get the medical record
                MedicalRecord record = medicalRecordService.getMedicalRecordById(recordId);
                if (record == null) {
                    request.setAttribute("errorMessage", "Medical record not found");
                    request.getRequestDispatcher("/patient/medical-records").forward(request, response);
                    return;
                }

                // Get patient data
                Patient patient = patientService.getPatientById(patientId);

                // Set attributes for JSP
                request.setAttribute("patient", patient);
                request.setAttribute("medicalRecord", record);

                // Forward to medical record detail page
                request.getRequestDispatcher("/patient/medical-record-detail.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid medical record ID: {0}", recordIdParam);
                request.setAttribute("errorMessage", "Invalid medical record ID");
                request.getRequestDispatcher("/patient/medical-records").forward(request, response);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error viewing medical record", e);
            request.setAttribute("errorMessage", "Error retrieving medical record: " + e.getMessage());
            request.getRequestDispatcher("/patient/medical-records").forward(request, response);
        }
    }

    /**
     * List all medical records for the current patient
     */
    private void listMedicalRecords(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            // Get patient ID for the current logged-in user
            int patientId = patientService.getPatientIdByUserId(user.getId());

            if (patientId == 0) {
                // Patient profile not found, redirect to profile page to complete profile
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            }

            // Get patient data
            Patient patient = patientService.getPatientById(patientId);

            // Check if a specific patient ID was requested in the URL
            String requestedPatientIdParam = request.getParameter("patientId");
            if (requestedPatientIdParam != null && !requestedPatientIdParam.isEmpty()) {
                try {
                    int requestedPatientId = Integer.parseInt(requestedPatientIdParam);

                    // Security check: Ensure patients can only view their own records
                    if (requestedPatientId != patientId) {
                        LOGGER.log(Level.WARNING, "Security violation: Patient ID {0} attempted to access records for Patient ID {1}",
                            new Object[]{patientId, requestedPatientId});
                        request.setAttribute("errorMessage", "You are not authorized to view these medical records");
                        request.getRequestDispatcher("/patient/dashboard").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid patient ID parameter: {0}", requestedPatientIdParam);
                }
            }

            // Get medical records with proper error handling - only for the current patient
            List<MedicalRecord> medicalRecords;
            try {
                medicalRecords = medicalRecordService.getMedicalRecordsByPatientId(patientId);
                LOGGER.log(Level.INFO, "Retrieved {0} medical records for patient ID: {1}",
                    new Object[]{medicalRecords != null ? medicalRecords.size() : 0, patientId});
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error retrieving medical records for patient ID: {0}", patientId);
                LOGGER.log(Level.WARNING, "Exception details:", e);
                medicalRecords = java.util.Collections.emptyList();
            }

            // Set attributes for JSP
            request.setAttribute("patient", patient);
            request.setAttribute("medicalRecords", medicalRecords);

            // Forward to medical records page
            request.getRequestDispatcher("/patient/medical-records.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error retrieving medical records", e);
            try {
                request.setAttribute("errorMessage", "Error retrieving medical records: " + e.getMessage());
                request.getRequestDispatcher("/patient/dashboard").forward(request, response);
            } catch (ServletException | IOException ex) {
                LOGGER.log(Level.SEVERE, "Failed to forward to error page", ex);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
            }
        }
    }
}
