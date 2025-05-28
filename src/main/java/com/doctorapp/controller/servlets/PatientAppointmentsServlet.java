package com.doctorapp.controller.servlets;

import java.io.IOException;

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
        long startTime = System.currentTimeMillis();

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

            // ULTRA-FAST patient record lookup - minimal processing
            int patientId = patientDAO.getPatientIdByUserId(user.getId());
            if (patientId == 0) {
                request.setAttribute("appointments", new java.util.ArrayList<>());
            } else {
                // ULTRA-FAST appointments query
                try {
                    request.setAttribute("appointments", appointmentDAO.getAppointmentsByPatientId(patientId));
                } catch (Exception e) {
                    request.setAttribute("appointments", new java.util.ArrayList<>());
                }
            }

            // Forward to the appointments page
            request.getRequestDispatcher("/patient/appointments.jsp").forward(request, response);

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
