package com.doctorapp.controller.patient;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Removed WebServlet annotation to resolve URL mapping conflict
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;
    private PatientService patientService;
    private AppointmentService appointmentService;

    @Override
    public void init() {
        doctorService = new DoctorService();
        patientService = new PatientService();
        appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get doctor ID from request
        String doctorIdParam = request.getParameter("doctorId");
        if (doctorIdParam == null || doctorIdParam.isEmpty()) {
            // If no doctor ID is provided, redirect to doctors list
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdParam);

            // Get doctor details
            Doctor doctor = doctorService.getDoctorById(doctorId);
            if (doctor == null) {
                response.sendRedirect(request.getContextPath() + "/doctors");
                return;
            }

            // Set doctor in request
            request.setAttribute("doctor", doctor);

            // Forward to booking form
            request.getRequestDispatcher("/patient/book-appointment.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctors");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get form data
        String doctorIdParam = request.getParameter("doctorId");
        String appointmentDateParam = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String symptoms = request.getParameter("symptoms");

        // Validate input
        if (doctorIdParam == null || doctorIdParam.isEmpty() ||
            appointmentDateParam == null || appointmentDateParam.isEmpty() ||
            appointmentTime == null || appointmentTime.isEmpty() ||
            symptoms == null || symptoms.isEmpty()) {

            request.setAttribute("error", "All fields are required");
            doGet(request, response);
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdParam);

            // Get doctor details
            Doctor doctor = doctorService.getDoctorById(doctorId);
            if (doctor == null) {
                response.sendRedirect(request.getContextPath() + "/doctors");
                return;
            }

            // Get patient ID
            int patientId = patientService.getPatientIdByUserId(user.getId());
            if (patientId == 0) {
                // Create a new patient record if it doesn't exist
                com.doctorapp.model.Patient patient = new com.doctorapp.model.Patient();
                patient.setUserId(user.getId());
                patient.setFirstName(user.getFirstName());
                patient.setLastName(user.getLastName());
                patient.setEmail(user.getEmail());
                patient.setPhone(user.getPhone());
                patient.setAddress(user.getAddress());

                // Save the new patient
                patientService.addPatient(patient);

                // Get the newly created patient ID
                patientId = patientService.getPatientIdByUserId(user.getId());
            }

            // Create appointment object
            Appointment appointment = new Appointment();
            appointment.setDoctorId(doctorId);
            appointment.setPatientId(patientId);

            // Parse appointment date
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date appointmentDate = dateFormat.parse(appointmentDateParam);
                appointment.setAppointmentDate(appointmentDate);
            } catch (Exception e) {
                request.setAttribute("error", "Invalid date format");
                doGet(request, response);
                return;
            }

            appointment.setAppointmentTime(appointmentTime);
            appointment.setReason("Consultation");
            appointment.setSymptoms(symptoms);
            appointment.setStatus("PENDING");
            appointment.setNotes("Appointment booked by patient");

            // Set fee from doctor's consultation fee if available
            if (doctor.getConsultationFee() != null && !doctor.getConsultationFee().isEmpty()) {
                try {
                    double fee = Double.parseDouble(doctor.getConsultationFee());
                    appointment.setFee(fee);
                } catch (NumberFormatException e) {
                    appointment.setFee(0.0);
                }
            } else {
                appointment.setFee(0.0);
            }

            // Book appointment
            boolean booked = appointmentService.bookAppointment(appointment);

            if (booked) {
                // Set doctor name in appointment for display
                appointment.setDoctorName(doctor.getName());

                // Set patient name in appointment for display
                String patientName = user.getFirstName() + " " + user.getLastName();
                appointment.setPatientName(patientName);

                // Store appointment in session for confirmation page
                session.setAttribute("appointment", appointment);
                session.setAttribute("successMessage", "Appointment booked successfully");

                // Redirect to confirmation page
                response.sendRedirect(request.getContextPath() + "/patient/appointmentConfirmation.jsp");
            } else {
                request.setAttribute("error", "Failed to book appointment. Please try again.");
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/patient/book-appointment.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid doctor ID");
            doGet(request, response);
        }
    }
}
