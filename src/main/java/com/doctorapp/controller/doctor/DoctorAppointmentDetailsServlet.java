package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;
import com.doctorapp.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/doctor/appointment/details", "/doctor/appointment/cancel"})
public class DoctorAppointmentDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorAppointmentDetailsServlet.class.getName());

    private AppointmentService appointmentService;
    private DoctorService doctorService;
    private PatientService patientService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        doctorService = new DoctorService();
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getServletPath();

        try {
            int doctorId = doctorService.getDoctorIdByUserId(user.getId());
            if (doctorId == 0) {
                response.sendRedirect(request.getContextPath() + "/doctor/profile");
                return;
            }

            if ("/doctor/appointment/details".equals(action)) {
                viewAppointmentDetails(request, response, doctorId);
            } else if ("/doctor/appointment/cancel".equals(action)) {
                cancelAppointment(request, response, doctorId);
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet: " + e.getMessage(), e);
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=" + e.getMessage());
        }
    }

    private void viewAppointmentDetails(HttpServletRequest request, HttpServletResponse response, int doctorId) throws ServletException, IOException {
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get appointment
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
                return;
            }
            
            // Check if appointment belongs to the doctor
            if (appointment.getDoctorId() != doctorId) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
                return;
            }
            
            // Set appointment in request
            request.setAttribute("appointment", appointment);
            
            // Forward to appointment details page
            request.getRequestDispatcher("/doctor/appointment-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid appointment ID: " + appointmentIdStr, e);
            response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
        }
    }

    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response, int doctorId) throws ServletException, IOException {
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get appointment
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
                return;
            }
            
            // Check if appointment belongs to the doctor
            if (appointment.getDoctorId() != doctorId) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
                return;
            }
            
            // Cancel appointment
            boolean updated = appointmentService.updateAppointmentStatus(appointmentId, "CANCELLED");
            
            if (updated) {
                request.getSession().setAttribute("successMessage", "Appointment cancelled successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to cancel appointment");
            }
            
            // Redirect back to appointments list
            response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid appointment ID: " + appointmentIdStr, e);
            response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
        }
    }
}
