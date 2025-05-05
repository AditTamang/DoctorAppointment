package com.doctorapp.controller.patient;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient/appointments")
public class PatientAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;
    private PatientService patientService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get patient ID
        int patientId = patientService.getPatientIdByUserId(user.getId());
        if (patientId == 0) {
            // If patient profile doesn't exist, redirect to profile page
            response.sendRedirect(request.getContextPath() + "/patient/profile");
            return;
        }

        // Get all appointments for the patient
        List<Appointment> allAppointments = new ArrayList<>();

        // Get upcoming appointments
        List<Appointment> upcomingAppointments = appointmentService.getUpcomingAppointmentsByPatient(patientId, 100);
        if (upcomingAppointments != null) {
            allAppointments.addAll(upcomingAppointments);
        }

        // Get past appointments
        List<Appointment> pastAppointments = appointmentService.getPastAppointmentsByPatient(patientId, 100);
        if (pastAppointments != null) {
            allAppointments.addAll(pastAppointments);
        }

        // Get cancelled appointments
        List<Appointment> cancelledAppointments = appointmentService.getCancelledAppointmentsByPatient(patientId, 100);
        if (cancelledAppointments != null) {
            allAppointments.addAll(cancelledAppointments);
        }

        // Set all appointments in request
        request.setAttribute("appointments", allAppointments);

        // Forward to appointments page
        request.getRequestDispatcher("/patient/appointments.jsp").forward(request, response);
    }
}
