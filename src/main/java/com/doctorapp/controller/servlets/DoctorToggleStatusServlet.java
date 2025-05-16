package com.doctorapp.controller.servlets;

import java.io.IOException;

import com.doctorapp.dao.DoctorAvailabilityDAO;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.User;
import com.doctorapp.util.JsonResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle toggling doctor status (ACTIVE/INACTIVE)
 */
@WebServlet("/doctor/toggle-status")
public class DoctorToggleStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final DoctorDAO doctorDAO;
    private final DoctorAvailabilityDAO availabilityDAO;
    
    public DoctorToggleStatusServlet() {
        super();
        doctorDAO = new DoctorDAO();
        availabilityDAO = new DoctorAvailabilityDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Check if user is logged in and is a doctor
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                JsonResponse.send(response, false, "You must be logged in to update status");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            if (!"DOCTOR".equals(user.getRole())) {
                JsonResponse.send(response, false, "Only doctors can update status");
                return;
            }
            
            // Get doctor information
            int userId = user.getId();
            int doctorId = doctorDAO.getDoctorIdByUserId(userId);
            
            if (doctorId == 0) {
                JsonResponse.send(response, false, "Doctor profile not found");
                return;
            }
            
            // Toggle doctor status
            String newStatus = availabilityDAO.toggleDoctorStatus(doctorId);
            
            if (newStatus != null) {
                JsonResponse.send(response, true, "Status updated successfully", "status", newStatus);
            } else {
                JsonResponse.send(response, false, "Failed to update status");
            }
        } catch (Exception e) {
            System.err.println("Error toggling doctor status: " + e.getMessage());
            JsonResponse.send(response, false, "An error occurred while updating status");
        }
    }
}
