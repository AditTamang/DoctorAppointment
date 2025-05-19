package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.MedicalRecord;
import com.doctorapp.model.Patient;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.MedicalRecordService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/doctor/view-patient", "/doctor/edit-patient"})
public class DoctorPatientViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorPatientViewServlet.class.getName());

    private PatientService patientService;
    private AppointmentService appointmentService;
    private MedicalRecordService medicalRecordService;
    private DoctorDAO doctorDAO;

    @Override
    public void init() {
        patientService = new PatientService();
        appointmentService = new AppointmentService();
        medicalRecordService = new MedicalRecordService();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

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
            switch (action) {
                case "/doctor/view-patient":
                    viewPatient(request, response, doctorId);
                    break;
                case "/doctor/edit-patient":
                    showEditPatientForm(request, response, doctorId);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                    break;
            }
        } catch (Exception e) {
            LOGGER.severe("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=" + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

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

        switch (action) {
            case "/doctor/edit-patient":
                updatePatient(request, response, doctorId);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
        }
    }

    /**
     * View patient details
     */
    private void viewPatient(HttpServletRequest request, HttpServletResponse response, int doctorId) throws ServletException, IOException {
        try {
            // Get patient ID from request parameter
            int patientId = Integer.parseInt(request.getParameter("id"));

            // Get patient details
            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
                return;
            }

            // Get patient's appointments with this doctor
            List<Appointment> appointments = appointmentService.getAppointmentsByPatientAndDoctorId(patientId, doctorId);

            // Get patient's medical records
            List<MedicalRecord> medicalRecords = medicalRecordService.getMedicalRecordsByPatientId(patientId);

            // Set attributes for the JSP
            request.setAttribute("patient", patient);
            request.setAttribute("appointments", appointments);
            request.setAttribute("medicalRecords", medicalRecords);

            // Forward to patient details page
            request.getRequestDispatcher("/doctor/view-patient.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid patient ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } catch (Exception e) {
            LOGGER.severe("Error viewing patient: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    /**
     * Show edit patient form
     */
    private void showEditPatientForm(HttpServletRequest request, HttpServletResponse response, int doctorId) throws ServletException, IOException {
        try {
            // Get patient ID from request parameter
            int patientId = Integer.parseInt(request.getParameter("id"));

            // Get patient details
            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
                return;
            }

            // Set attributes for the JSP
            request.setAttribute("patient", patient);

            // Forward to edit patient form
            request.getRequestDispatcher("/doctor/edit-patient.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid patient ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } catch (Exception e) {
            LOGGER.severe("Error showing edit patient form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    /**
     * Update patient information
     */
    private void updatePatient(HttpServletRequest request, HttpServletResponse response, int doctorId) throws ServletException, IOException {
        try {
            // Get patient ID from request parameter
            int patientId = Integer.parseInt(request.getParameter("id"));

            // Get patient details
            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
                return;
            }

            // Update patient information
            String bloodGroup = request.getParameter("bloodGroup");
            String allergies = request.getParameter("allergies");
            String medicalHistory = request.getParameter("medicalHistory");

            patient.setBloodGroup(bloodGroup);
            patient.setAllergies(allergies);
            patient.setMedicalHistory(medicalHistory);

            // Save updated patient
            boolean updated = patientService.updatePatient(patient);

            if (updated) {
                request.setAttribute("successMessage", "Patient information updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update patient information");
            }

            // Refresh patient data
            patient = patientService.getPatientById(patientId);
            request.setAttribute("patient", patient);

            // Forward to view patient page
            request.getRequestDispatcher("/doctor/view-patient.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid patient ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } catch (Exception e) {
            LOGGER.severe("Error updating patient: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
