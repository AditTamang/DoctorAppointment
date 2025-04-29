package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.doctorapp.dao.AppointmentDAO;
import com.doctorapp.dao.PatientDAO;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient/appointments")
public class PatientAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;

    public void init() {
        patientDAO = new PatientDAO();
        appointmentDAO = new AppointmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("PatientAppointmentsServlet: doGet method called");

            // Get the session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                System.out.println("PatientAppointmentsServlet: No user in session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (!"PATIENT".equals(user.getRole())) {
                System.out.println("PatientAppointmentsServlet: User is not a patient, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // Get patient ID
            int patientId = patientDAO.getPatientIdByUserId(user.getId());
            if (patientId == 0) {
                // Patient profile not found, redirect to complete profile
                response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
                return;
            }

            // Get filter date if provided
            String dateParam = request.getParameter("date");
            Date filterDate = null;
            if (dateParam != null && !dateParam.isEmpty()) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    filterDate = dateFormat.parse(dateParam);
                } catch (ParseException e) {
                    System.out.println("PatientAppointmentsServlet: Invalid date format: " + dateParam);
                }
            }

            // Get appointments - use upcomingAppointments method
            request.setAttribute("appointments", appointmentDAO.getUpcomingAppointments(10));

            // Redirect back to the dashboard with appointments tab active
            response.sendRedirect(request.getContextPath() + "/patient/dashboard?tab=appointments");
        } catch (Exception e) {
            System.err.println("Error loading patient appointments: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
