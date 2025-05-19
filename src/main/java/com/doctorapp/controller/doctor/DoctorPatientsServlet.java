package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Appointment;
import com.doctorapp.model.Patient;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling doctor's patients page
 */
@WebServlet("/doctor/patients")
public class DoctorPatientsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorPatientsServlet.class.getName());

    private PatientService patientService;
    private AppointmentService appointmentService;
    private DoctorDAO doctorDAO;

    @Override
    public void init() {
        patientService = new PatientService();
        appointmentService = new AppointmentService();
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

            // Get search parameter if any
            String searchTerm = request.getParameter("search");

            // Get approved appointments for this doctor
            List<Appointment> approvedAppointments = appointmentService.getAppointmentsByDoctorIdAndStatus(doctorId, "CONFIRMED");
            LOGGER.log(Level.INFO, "Found " + approvedAppointments.size() + " approved appointments for doctor ID: " + doctorId);

            // Extract unique patients from approved appointments
            List<Patient> patients = new ArrayList<>();
            for (Appointment appointment : approvedAppointments) {
                Patient patient = patientService.getPatientById(appointment.getPatientId());
                if (patient != null && !containsPatient(patients, patient.getId())) {
                    // Add last visit date to patient
                    if (appointment.getAppointmentDate() != null) {
                        // Convert Date to String in yyyy-MM-dd format
                        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
                        String lastVisitStr = dateFormat.format(appointment.getAppointmentDate());
                        patient.setLastVisit(lastVisitStr);
                    }
                    patients.add(patient);
                }
            }

            // Filter patients by search term if provided
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                List<Patient> filteredPatients = new ArrayList<>();
                for (Patient patient : patients) {
                    if (patient.getFirstName().toLowerCase().contains(searchTerm.toLowerCase()) ||
                        patient.getLastName().toLowerCase().contains(searchTerm.toLowerCase()) ||
                        patient.getEmail().toLowerCase().contains(searchTerm.toLowerCase())) {
                        filteredPatients.add(patient);
                    }
                }
                patients = filteredPatients;
                LOGGER.log(Level.INFO, "Filtered to " + patients.size() + " patients matching search term: " + searchTerm);
            }

            // Set attributes for JSP
            request.setAttribute("patients", patients);
            request.setAttribute("searchTerm", searchTerm);

            // Forward to patients page
            request.getRequestDispatcher("/doctor/patients-new.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DoctorPatientsServlet.doGet", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Check if a patient is already in the list
     * @param patients List of patients
     * @param patientId Patient ID to check
     * @return true if patient is in the list, false otherwise
     */
    private boolean containsPatient(List<Patient> patients, int patientId) {
        for (Patient patient : patients) {
            if (patient.getId() == patientId) {
                return true;
            }
        }
        return false;
    }
}
