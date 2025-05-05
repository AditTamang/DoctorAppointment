package com.doctorapp.controller.patient;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.dao.AppointmentDAO;
import com.doctorapp.dao.PatientDAO;
import com.doctorapp.model.Appointment;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient/appointment")
public class ViewAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ViewAppointmentServlet.class.getName());
    
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get appointment ID
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Get appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                return;
            }
            
            // Get patient ID
            int patientId = patientDAO.getPatientIdByUserId(user.getId());
            
            // Check if appointment belongs to the patient
            if (appointment.getPatientId() != patientId) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                return;
            }
            
            // Set appointment in request
            request.setAttribute("appointment", appointment);
            
            // Forward to appointment details page
            request.getRequestDispatcher("/patient/appointment-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid appointment ID: " + appointmentIdStr, e);
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        }
    }
}
