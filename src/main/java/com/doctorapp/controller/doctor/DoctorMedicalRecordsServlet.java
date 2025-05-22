package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.List;
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
 * Servlet for handling medical records viewing
 */
@WebServlet("/doctor/medical-records")
public class DoctorMedicalRecordsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorMedicalRecordsServlet.class.getName());

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

        try {
            // Get doctor ID
            int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());
            if (doctorId == 0) {
                response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
                return;
            }

            // Get patient ID from request parameter with proper null checking
            String patientIdParam = request.getParameter("patientId");
            if (patientIdParam == null || patientIdParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Patient ID is required");
                request.getRequestDispatcher("/doctor/patients").forward(request, response);
                return;
            }

            int patientId = Integer.parseInt(patientIdParam);

            // Get patient details
            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/patients").forward(request, response);
                return;
            }

            // Get medical records for this patient
            List<MedicalRecord> medicalRecords = medicalRecordService.getMedicalRecordsByPatientId(patientId);

            // Set attributes for JSP
            request.setAttribute("patient", patient);
            request.setAttribute("medicalRecords", medicalRecords);
            request.setAttribute("doctorId", doctorId);

            // Forward to medical records page
            request.getRequestDispatcher("/doctor/medical-records.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid patient ID", e);
            response.sendRedirect(request.getContextPath() + "/doctor/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DoctorMedicalRecordsServlet.doGet", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
