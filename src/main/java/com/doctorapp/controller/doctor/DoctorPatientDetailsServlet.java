package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Appointment;
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

/**
 * Servlet to handle doctor viewing patient details
 */
@WebServlet("/doctor/patient-details")
public class DoctorPatientDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorPatientDetailsServlet.class.getName());

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
}
