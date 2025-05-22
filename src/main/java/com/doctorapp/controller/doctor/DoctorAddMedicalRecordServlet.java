package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.time.LocalDate;
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
 * Servlet for handling adding medical records
 */
@WebServlet({"/doctor/add-medical-record", "/doctor/save-medical-record"})
public class DoctorAddMedicalRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorAddMedicalRecordServlet.class.getName());

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

            // Get patient ID from request parameter
            int patientId = Integer.parseInt(request.getParameter("patientId"));

            // Get patient details
            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/patients").forward(request, response);
                return;
            }

            // Set attributes for JSP
            request.setAttribute("patient", patient);
            request.setAttribute("doctorId", doctorId);

            // Forward to add medical record form
            request.getRequestDispatcher("/doctor/add-medical-record.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid patient ID", e);
            response.sendRedirect(request.getContextPath() + "/doctor/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DoctorAddMedicalRecordServlet.doGet", e);
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

        try {
            // Get doctor ID
            int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());
            if (doctorId == 0) {
                response.sendRedirect(request.getContextPath() + "/doctor/complete-profile");
                return;
            }

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
                // Set success message
                request.getSession().setAttribute("successMessage", "Medical record added successfully");
                // Redirect to patient details page
                response.sendRedirect(request.getContextPath() + "/doctor/view-patient?id=" + patientId);
            } else {
                // Set error message
                request.setAttribute("errorMessage", "Failed to add medical record");
                // Get patient details again
                Patient patient = patientService.getPatientById(patientId);
                request.setAttribute("patient", patient);
                request.setAttribute("doctorId", doctorId);
                request.setAttribute("medicalRecord", medicalRecord);
                // Forward back to form
                request.getRequestDispatcher("/doctor/add-medical-record.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid patient ID", e);
            response.sendRedirect(request.getContextPath() + "/doctor/patients");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DoctorAddMedicalRecordServlet.doPost", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
