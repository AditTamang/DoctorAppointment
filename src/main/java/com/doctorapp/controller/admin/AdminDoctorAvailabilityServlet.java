package com.doctorapp.controller.admin;

import java.io.IOException;

import com.doctorapp.dao.DoctorAvailabilityDAO;
import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorService;
import com.doctorapp.util.JsonResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle doctor availability updates from admin
 */
@WebServlet("/admin/update-doctor-availability")
public class AdminDoctorAvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorDAO doctorDAO;
    private DoctorAvailabilityDAO availabilityDAO;
    private DoctorService doctorService;

    public AdminDoctorAvailabilityServlet() {
        super();
        doctorDAO = new DoctorDAO();
        availabilityDAO = new DoctorAvailabilityDAO();
        doctorService = new DoctorService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Check if user is logged in and is an admin
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                JsonResponse.send(response, false, "You must be logged in to update availability");
                return;
            }

            User user = (User) session.getAttribute("user");
            if (!"ADMIN".equals(user.getRole())) {
                JsonResponse.send(response, false, "Only admins can update doctor availability");
                return;
            }

            // Get doctor ID from request
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            
            // Get availability data from request
            String availableDays = request.getParameter("availableDays");
            String availableTime = request.getParameter("availableTime");

            System.out.println("Admin updating availability for doctor ID: " + doctorId);
            System.out.println("Available days: " + availableDays);
            System.out.println("Available time: " + availableTime);

            // Validate input
            if (availableDays == null || availableDays.isEmpty()) {
                JsonResponse.send(response, false, "Available days cannot be empty");
                return;
            }

            if (availableTime == null || availableTime.isEmpty()) {
                JsonResponse.send(response, false, "Available time cannot be empty");
                return;
            }

            // Update doctor availability
            boolean updated = availabilityDAO.updateDoctorAvailability(doctorId, availableDays, availableTime);

            if (updated) {
                // Get the updated doctor to ensure we have the latest data
                Doctor updatedDoctor = doctorService.getDoctorById(doctorId);
                
                // Store the updated doctor in the request for the view
                request.setAttribute("doctor", updatedDoctor);
                
                // Send success response
                JsonResponse.send(response, true, "Availability updated successfully");
            } else {
                JsonResponse.send(response, false, "Failed to update availability");
            }
        } catch (Exception e) {
            System.err.println("Error updating doctor availability: " + e.getMessage());
            e.printStackTrace();
            JsonResponse.send(response, false, "An error occurred while updating availability: " + e.getMessage());
        }
    }
}
