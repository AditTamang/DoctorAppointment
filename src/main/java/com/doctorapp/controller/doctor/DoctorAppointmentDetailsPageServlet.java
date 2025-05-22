package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling the doctor appointment details page
 */
public class DoctorAppointmentDetailsPageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorAppointmentDetailsPageServlet.class.getName());

    private AppointmentService appointmentService;
    private DoctorService doctorService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        doctorService = new DoctorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int doctorId = doctorService.getDoctorIdByUserId(user.getId());
            if (doctorId == 0) {
                response.sendRedirect(request.getContextPath() + "/doctor/profile");
                return;
            }

            String appointmentIdStr = request.getParameter("id");
            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }

            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);

                // Get appointment
                Appointment appointment = appointmentService.getAppointmentById(appointmentId);
                if (appointment == null) {
                    response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                    return;
                }

                // Check if appointment belongs to the doctor
                if (appointment.getDoctorId() != doctorId) {
                    response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                    return;
                }

                // Set appointment in request
                request.setAttribute("appointment", appointment);

                // Forward to appointment details page
                request.getRequestDispatcher("/doctor/appointment-details.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid appointment ID: " + appointmentIdStr, e);
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet: " + e.getMessage(), e);
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=" + e.getMessage());
        }
    }
}
