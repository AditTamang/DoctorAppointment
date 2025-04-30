package com.doctorapp.controller.doctor;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.User;
import com.doctorapp.model.Doctor;
import com.doctorapp.dao.DoctorDAO;

/**
 * Servlet to handle doctor profile completion
 */
@WebServlet("/doctor/complete-profile")
public class CompleteProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DoctorDAO doctorDAO;

    public void init() {
        doctorDAO = new DoctorDAO();
    }

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
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("PATIENT".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
            return;
        }

        // Forward to the complete profile page
        request.getRequestDispatcher("/doctor/complete-profile.jsp").forward(request, response);
    }

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
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            // Get form data
            String specialization = request.getParameter("specialization");
            String qualification = request.getParameter("qualification");
            String experience = request.getParameter("experience") + " years";
            String consultationFee = request.getParameter("consultationFee");
            String bio = request.getParameter("bio");
            String profileImage = request.getParameter("profileImage");

            // Create or update doctor profile
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());

            boolean success;
            if (doctor == null) {
                // Create new doctor profile
                doctor = new Doctor();
                doctor.setUserId(user.getId());
                doctor.setSpecialization(specialization);
                doctor.setQualification(qualification);
                doctor.setExperience(experience);
                doctor.setConsultationFee(consultationFee);
                doctor.setBio(bio);
                doctor.setProfileImage(profileImage);
                doctor.setStatus("ACTIVE");

                success = doctorDAO.addDoctorProfile(doctor);
            } else {
                // Update existing doctor profile
                doctor.setSpecialization(specialization);
                doctor.setQualification(qualification);
                doctor.setExperience(experience);
                doctor.setConsultationFee(consultationFee);
                doctor.setBio(bio);
                doctor.setProfileImage(profileImage);
                doctor.setStatus("ACTIVE");

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
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input. Please check your form data.");
            request.getRequestDispatcher("/doctor/complete-profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/doctor/complete-profile.jsp").forward(request, response);
        }
    }
}
