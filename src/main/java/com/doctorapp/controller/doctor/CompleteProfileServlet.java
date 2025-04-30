package com.doctorapp.controller.doctor;

import java.io.IOException;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle doctor profile completion
 */
@WebServlet("/doctor/complete-profile")
public class CompleteProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DoctorDAO doctorDAO;

    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Check if user is a doctor
        if (!"DOCTOR".equals(user.getRole())) {
            String redirectPath;
            switch (user.getRole()) {
                case "ADMIN":
                    redirectPath = "/admin/dashboard";
                    break;
                case "PATIENT":
                    redirectPath = "/patient/dashboard";
                    break;
                default:
                    redirectPath = "/index.jsp";
                    break;
            }
            response.sendRedirect(request.getContextPath() + redirectPath);
            return;
        }

        // Forward to the complete profile page
        request.getRequestDispatcher("/doctor/complete-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Check if user is a doctor
        if (!"DOCTOR".equals(user.getRole())) {
            String redirectPath;
            switch (user.getRole()) {
                case "ADMIN":
                    redirectPath = "/admin/dashboard";
                    break;
                case "PATIENT":
                    redirectPath = "/patient/dashboard";
                    break;
                default:
                    redirectPath = "/index.jsp";
                    break;
            }
            response.sendRedirect(request.getContextPath() + redirectPath);
            return;
        }

        try {
            // Get form data
            String specialization = request.getParameter("specialization");
            String qualification = request.getParameter("qualification");
            String experience = request.getParameter("experience");
            String consultationFee = request.getParameter("consultationFee");
            String bio = request.getParameter("bio");
            String profileImage = request.getParameter("profileImage");

            // Create or update doctor profile
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());

            if (doctor == null) {
                // Create new doctor profile
                doctor = new Doctor();
                doctor.setUserId(user.getId());
            }

            // Set doctor properties
            doctor.setSpecialization(specialization);
            doctor.setQualification(qualification);
            doctor.setExperience(experience);
            doctor.setConsultationFee(consultationFee);
            doctor.setBio(bio);
            doctor.setProfileImage(profileImage);
            doctor.setStatus("ACTIVE");

            // Save doctor profile
            boolean success;
            if (doctor.getId() == 0) {
                success = doctorDAO.addDoctor(doctor);
            } else {
                success = doctorDAO.updateDoctor(doctor);
            }

            if (success) {
                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            } else {
                // Show error message
                request.setAttribute("error", "Failed to save doctor profile. Please try again.");
                request.getRequestDispatcher("/doctor/complete-profile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log the error
            System.err.println("Error in CompleteProfileServlet: " + e.getMessage());
            // Set error message for the user
            request.setAttribute("error", "An error occurred while saving your profile. Please try again.");
            request.getRequestDispatcher("/doctor/complete-profile.jsp").forward(request, response);
        }
    }
}
