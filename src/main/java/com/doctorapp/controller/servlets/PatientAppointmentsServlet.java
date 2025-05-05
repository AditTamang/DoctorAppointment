package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.dao.AppointmentDAO;
import com.doctorapp.model.Appointment;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient/appointments-legacy")
public class PatientAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(PatientAppointmentsServlet.class.getName());

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Get filter parameters
            String status = request.getParameter("status");
            String sortBy = request.getParameter("sortBy");

            // Get appointments for the patient
            List<Appointment> appointments;
            if (status != null && !status.isEmpty()) {
                appointments = appointmentDAO.getAppointmentsByPatientIdAndStatus(user.getId(), status);
            } else {
                appointments = appointmentDAO.getAppointmentsByPatientId(user.getId());
            }

            // Sort appointments if needed
            if (sortBy != null && !sortBy.isEmpty()) {
                if ("date-asc".equals(sortBy)) {
                    appointments.sort((a1, a2) -> a1.getAppointmentDate().compareTo(a2.getAppointmentDate()));
                } else if ("date-desc".equals(sortBy)) {
                    appointments.sort((a1, a2) -> a2.getAppointmentDate().compareTo(a1.getAppointmentDate()));
                } else if ("doctor".equals(sortBy)) {
                    appointments.sort((a1, a2) -> a1.getDoctorName().compareTo(a2.getDoctorName()));
                } else if ("status".equals(sortBy)) {
                    appointments.sort((a1, a2) -> a1.getStatus().compareTo(a2.getStatus()));
                }
            }

            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/patient/appointments.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving patient appointments", e);
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            return;
        }

        try {
            if ("cancel".equals(action)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

                // Verify that the appointment belongs to the current user
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                if (appointment == null || appointment.getPatientId() != user.getId()) {
                    response.sendRedirect(request.getContextPath() + "/patient/appointments");
                    return;
                }

                // Cancel the appointment
                boolean cancelled = appointmentDAO.updateAppointmentStatus(appointmentId, "CANCELLED");
                if (cancelled) {
                    request.setAttribute("successMessage", "Appointment cancelled successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to cancel appointment");
                }
            }

            // Redirect to the appointments page
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing appointment action", e);
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        }
    }
}
