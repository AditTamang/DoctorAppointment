package com.doctorapp.controller.servlets;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;

/**
 * Servlet to handle doctor availability page
 */
@WebServlet("/doctor/availability")
public class DoctorAvailabilityPageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final DoctorDAO doctorDAO;

    public DoctorAvailabilityPageServlet() {
        super();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is a doctor
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        try {
            // Get the user ID first so it's available throughout the method
            int userId = 0;
            try {
                userId = user.getId();
                if (userId <= 0) {
                    System.err.println("Invalid user ID: " + userId);
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Invalid+user+ID");
                    return;
                }
            } catch (Exception e) {
                System.err.println("Error getting user ID: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Error+getting+user+ID");
                return;
            }

            // First check if doctor is in session
            Doctor doctor = null;
            try {
                doctor = (Doctor) session.getAttribute("doctor");
            } catch (Exception e) {
                System.err.println("Error retrieving doctor from session: " + e.getMessage());
                e.printStackTrace();
                // Continue with doctor as null
            }

            // If not in session, get from database
            if (doctor == null) {
                System.out.println("Doctor not found in session, retrieving from database for user ID: " + userId);

                try {
                    int doctorId = doctorDAO.getDoctorIdByUserId(userId);
                    System.out.println("Found doctor ID: " + doctorId + " for user ID: " + userId);

                    if (doctorId > 0) {
                        doctor = doctorDAO.getDoctorById(doctorId);
                        // Store in session for future use
                        if (doctor != null) {
                            session.setAttribute("doctor", doctor);
                            System.out.println("Stored doctor in session: " + doctor.getId());
                        } else {
                            System.err.println("Doctor with ID " + doctorId + " not found in database");
                        }
                    } else {
                        System.out.println("No doctor ID found for user ID: " + userId);
                    }
                } catch (Exception e) {
                    System.err.println("Error getting doctor by user ID: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("Using doctor from session: " + doctor.getId());
                System.out.println("Available days: " + doctor.getAvailableDays());
                System.out.println("Available time: " + doctor.getAvailableTime());
            }

            // If doctor is null, create a default doctor object for the view
            // but don't try to save it to the database yet
            if (doctor == null) {
                System.out.println("Creating default doctor object for user ID: " + userId);
                doctor = new Doctor();
                doctor.setUserId(userId);
                doctor.setName("Dr. " + user.getFirstName() + " " + user.getLastName());
                doctor.setSpecialization("General Medicine");
                doctor.setQualification("MBBS");
                doctor.setExperience("0 years");
                doctor.setEmail(user.getEmail());
                doctor.setPhone(user.getPhone());
                doctor.setAddress(user.getAddress());
                doctor.setConsultationFee("1000");
                doctor.setAvailableDays("Monday,Tuesday,Wednesday,Thursday,Friday");
                doctor.setAvailableTime("09:00 AM - 05:00 PM");
                doctor.setStatus("ACTIVE");
                System.out.println("Created default doctor object with name: " + doctor.getName());
            }

            // Set doctor in request
            request.setAttribute("doctor", doctor);

            // Forward to availability page
            request.getRequestDispatcher("/doctor/availability.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in DoctorAvailabilityPageServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=An+unexpected+error+occurred");
        }
    }
}
