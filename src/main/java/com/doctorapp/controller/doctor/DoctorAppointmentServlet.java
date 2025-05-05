package com.doctorapp.controller.doctor;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.model.Appointment;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.AppointmentService;
import com.doctorapp.service.DoctorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/doctor/appointments-list", "/doctor/appointment/update-status"})
public class DoctorAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorAppointmentServlet.class.getName());

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

        // Get doctor ID
        Doctor doctor = doctorService.getDoctorByUserId(user.getId());
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }

        int doctorId = doctor.getId();

        // Get appointment status filter
        String status = request.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "PENDING"; // Default to pending appointments
        }

        try {
            // Get appointments by status
            List<Appointment> appointments = appointmentService.getAppointmentsByDoctorIdAndStatus(doctorId, status);

            // Get counts for different statuses
            int pendingCount = appointmentService.getAppointmentCountByDoctorIdAndStatus(doctorId, "PENDING");
            int confirmedCount = appointmentService.getAppointmentCountByDoctorIdAndStatus(doctorId, "CONFIRMED");
            int completedCount = appointmentService.getAppointmentCountByDoctorIdAndStatus(doctorId, "COMPLETED");
            int cancelledCount = appointmentService.getAppointmentCountByDoctorIdAndStatus(doctorId, "CANCELLED");

            // Set attributes
            request.setAttribute("appointments", appointments);
            request.setAttribute("status", status);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("confirmedCount", confirmedCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("cancelledCount", cancelledCount);

            // Forward to appointments page
            request.getRequestDispatcher("/doctor/appointments.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving appointments", e);
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getServletPath();

        if ("/doctor/appointment/update-status".equals(action)) {
            updateAppointmentStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
        }
    }

    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get appointment ID and new status
            String appointmentIdStr = request.getParameter("appointmentId");
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");

            if (appointmentIdStr == null || appointmentIdStr.isEmpty() || status == null || status.isEmpty()) {
                request.setAttribute("errorMessage", "Invalid request parameters");
                request.getRequestDispatcher("/doctor/appointments-list").forward(request, response);
                return;
            }

            int appointmentId = Integer.parseInt(appointmentIdStr);

            // Update appointment status
            boolean updated = false;
            if (notes != null && !notes.isEmpty()) {
                updated = appointmentService.updateAppointmentStatusWithReason(appointmentId, status, notes);
            } else {
                updated = appointmentService.updateAppointmentStatus(appointmentId, status);
            }

            if (updated) {
                request.setAttribute("successMessage", "Appointment status updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update appointment status");
            }

            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/doctor/appointments-list?status=" + status);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid appointment ID", e);
            request.setAttribute("errorMessage", "Invalid appointment ID");
            request.getRequestDispatcher("/doctor/appointments-list").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating appointment status", e);
            request.setAttribute("errorMessage", "Error updating appointment status: " + e.getMessage());
            request.getRequestDispatcher("/doctor/appointments-list").forward(request, response);
        }
    }
}
