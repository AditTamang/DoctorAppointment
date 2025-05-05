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

@WebServlet("/patient/sessions")
public class PatientSessionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(PatientSessionsServlet.class.getName());
    
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
            // Get completed appointments (sessions) for the patient
            List<Appointment> completedAppointments = appointmentDAO.getAppointmentsByPatientIdAndStatus(user.getId(), "COMPLETED");
            
            request.setAttribute("sessions", completedAppointments);
            request.getRequestDispatcher("/patient/sessions.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving patient sessions", e);
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        }
    }
}
