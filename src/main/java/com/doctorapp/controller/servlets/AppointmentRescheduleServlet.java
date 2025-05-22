package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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

/**
 * Servlet for handling appointment rescheduling
 */
@WebServlet("/appointment/reschedule")
public class AppointmentRescheduleServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AppointmentRescheduleServlet.class.getName());
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;
    private DoctorService doctorService;
    private PatientService patientService;

    public void init() {
        appointmentService = new AppointmentService();
        doctorService = new DoctorService();
        patientService = new PatientService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set response type to JSON for all responses
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"User not logged in\"}");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get appointment ID and new date/time
        String appointmentIdStr = request.getParameter("appointmentId");
        String newDateStr = request.getParameter("newDate");
        String newTimeStr = request.getParameter("newTime");
        String reason = request.getParameter("reason");

        // Log all parameters for debugging
        LOGGER.log(Level.INFO, "Request parameters: appointmentId=" + appointmentIdStr +
                  ", newDate=" + newDateStr + ", newTime=" + newTimeStr +
                  ", reason=" + reason);

        LOGGER.log(Level.INFO, "Received reschedule request - ID: " + appointmentIdStr +
                  ", Date: " + newDateStr + ", Time: " + newTimeStr +
                  ", Reason: " + reason);

        if (appointmentIdStr == null || newDateStr == null || newTimeStr == null || reason == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Missing required parameters\"}");
            response.flushBuffer();
            return;
        }

        // Trim reason to ensure it's not just whitespace
        reason = reason.trim();
        if (reason.isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"Reason for rescheduling is required\"}");
            response.flushBuffer();
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);

            if (appointment == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"Appointment not found\"}");
                response.flushBuffer();
                return;
            }

            // Check if user has permission to reschedule this appointment
            if ("PATIENT".equals(user.getRole()) && appointment.getPatientId() != patientService.getPatientIdByUserId(user.getId())) {
                response.getWriter().write("{\"success\":false,\"message\":\"You don't have permission to reschedule this appointment\"}");
                response.flushBuffer();
                return;
            }

            // Check if appointment is in a status that allows rescheduling
            if (!"PENDING".equals(appointment.getRawStatus())) {
                response.getWriter().write("{\"success\":false,\"message\":\"Only pending appointments can be rescheduled\"}");
                response.flushBuffer();
                return;
            }

            if ("DOCTOR".equals(user.getRole()) && appointment.getDoctorId() != doctorService.getDoctorIdByUserId(user.getId())) {
                response.getWriter().write("{\"success\":false,\"message\":\"You don't have permission to reschedule this appointment\"}");
                response.flushBuffer();
                return;
            }

            // Parse the new date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date newDate = dateFormat.parse(newDateStr);

            // Update appointment
            appointment.setAppointmentDate(newDate);
            appointment.setAppointmentTime(newTimeStr);

            // Make sure to set both reason and reschedulingReason for compatibility
            appointment.setReschedulingReason(reason);
            appointment.setReason(reason);

            // Log the rescheduling details
            LOGGER.log(Level.INFO, "Rescheduling appointment ID: " + appointment.getId() +
                      " to date: " + newDateStr + ", time: " + newTimeStr +
                      ", reason: " + reason);

            // Save the updated appointment
            boolean updated = appointmentService.updateAppointment(appointment);

            if (updated) {
                // Log success
                LOGGER.log(Level.INFO, "Successfully rescheduled appointment ID: " + appointment.getId());

                // Check if this is a regular form submission or an AJAX request
                String isRegularSubmission = request.getParameter("isRegularSubmission");
                if (!"true".equals(isRegularSubmission) && "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    // Return JSON success response for AJAX requests
                    response.getWriter().write("{\"success\":true,\"message\":\"Appointment rescheduled successfully\"}");
                    response.flushBuffer();
                } else {
                    // For regular form submissions, redirect to the appointments page with a success message
                    if ("PATIENT".equals(user.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/patient/appointments?message=rescheduled");
                    } else if ("DOCTOR".equals(user.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/doctor/appointments?message=rescheduled");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/appointments?message=rescheduled");
                    }
                }
            } else {
                LOGGER.log(Level.SEVERE, "Failed to reschedule appointment ID: " + appointment.getId());

                // Check if this is a regular form submission or an AJAX request
                String isRegularSubmission = request.getParameter("isRegularSubmission");
                if (!"true".equals(isRegularSubmission) && "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    // Return JSON error response for AJAX requests
                    response.getWriter().write("{\"success\":false,\"message\":\"Failed to reschedule appointment\"}");
                    response.flushBuffer();
                } else {
                    // For regular form submissions, redirect back with an error message
                    if ("PATIENT".equals(user.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Failed to reschedule appointment");
                    } else if ("DOCTOR".equals(user.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/doctor/appointments?error=Failed to reschedule appointment");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/appointments?error=Failed to reschedule appointment");
                    }
                }
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid appointment ID: " + appointmentIdStr, e);

            // Check if this is a regular form submission or an AJAX request
            String isRegularSubmission = request.getParameter("isRegularSubmission");
            if (!"true".equals(isRegularSubmission) && "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.getWriter().write("{\"success\":false,\"message\":\"Invalid appointment ID\"}");
                response.flushBuffer();
            } else {
                // For regular form submissions, redirect back with an error message
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid appointment ID");
            }
        } catch (ParseException e) {
            LOGGER.log(Level.WARNING, "Invalid date format: " + newDateStr, e);

            // Check if this is a regular form submission or an AJAX request
            String isRegularSubmission = request.getParameter("isRegularSubmission");
            if (!"true".equals(isRegularSubmission) && "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.getWriter().write("{\"success\":false,\"message\":\"Invalid date format\"}");
                response.flushBuffer();
            } else {
                // For regular form submissions, redirect back with an error message
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid date format");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error rescheduling appointment: " + e.getMessage(), e);

            // Check if this is a regular form submission or an AJAX request
            String isRegularSubmission = request.getParameter("isRegularSubmission");
            if (!"true".equals(isRegularSubmission) && "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.getWriter().write("{\"success\":false,\"message\":\"An error occurred while rescheduling the appointment: " + e.getMessage() + "\"}");
                response.flushBuffer();
            } else {
                // For regular form submissions, redirect back with an error message
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=An error occurred while rescheduling the appointment");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect GET requests to POST
        doPost(request, response);
    }
}
