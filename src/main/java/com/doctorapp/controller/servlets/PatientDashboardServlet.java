package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.doctorapp.dao.AppointmentDAO;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.dao.PatientDAO;
import com.doctorapp.dao.UserDAO;
import com.doctorapp.model.Patient;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient/dashboard-old")
public class PatientDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private PatientDAO patientDAO;
    private DoctorDAO doctorDAO;
    private AppointmentDAO appointmentDAO;

    public void init() {
        userDAO = new UserDAO();
        patientDAO = new PatientDAO();
        doctorDAO = new DoctorDAO();
        appointmentDAO = new AppointmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("PatientDashboardServlet: doGet method called");

            // Get the session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                System.out.println("PatientDashboardServlet: No user in session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (!"PATIENT".equals(user.getRole())) {
                System.out.println("PatientDashboardServlet: User is not a patient, redirecting to login");
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

            // Get patient data
            Patient patient = patientDAO.getPatientById(patientId);
            request.setAttribute("patient", patient);

            // Get active tab if provided
            String activeTab = request.getParameter("tab");
            if (activeTab == null || activeTab.isEmpty()) {
                activeTab = "appointments"; // Default tab
            }
            request.setAttribute("activeTab", activeTab);

            // Get filter date if provided
            String dateParam = request.getParameter("date");
            Date filterDate = null;
            if (dateParam != null && !dateParam.isEmpty()) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    filterDate = dateFormat.parse(dateParam);
                } catch (ParseException e) {
                    System.out.println("PatientDashboardServlet: Invalid date format: " + dateParam);
                }
            }

            // Get appointments - limit to 10 for display
            request.setAttribute("upcomingAppointments", appointmentDAO.getUpcomingAppointments(10));

            // Set default values for statistics
            request.setAttribute("totalVisits", 5);
            request.setAttribute("upcomingVisitsCount", 6);
            request.setAttribute("totalDoctors", 3);

            // Forward to the new dashboard
            request.getRequestDispatcher("/patient/newPatientDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error loading patient dashboard: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
