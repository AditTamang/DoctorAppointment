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

            // Set additional required fields for new doctor
            if (doctor.getId() == 0) {
                // Use the existing user object from session
                doctor.setName(user.getFirstName() + " " + user.getLastName());
                doctor.setEmail(user.getEmail());
                doctor.setPhone(user.getPhone() != null ? user.getPhone() : "");
                doctor.setAddress(user.getAddress() != null ? user.getAddress() : "");
                doctor.setAvailableDays("Monday-Friday");
                doctor.setAvailableTime("09:00 AM - 05:00 PM");
            }

            // Save doctor profile
            boolean success;
            if (doctor.getId() == 0) {
                success = doctorDAO.addDoctor(doctor);
            } else {
                success = doctorDAO.updateDoctor(doctor);
            }

            if (success) {
                // Update the doctor in session
                Doctor updatedDoctor = doctorDAO.getDoctorByUserId(user.getId());
                if (updatedDoctor != null) {
                    session.setAttribute("doctor", updatedDoctor);
                    System.out.println("Updated doctor in session: " + updatedDoctor.getId());
                    System.out.println("Available days: " + updatedDoctor.getAvailableDays());
                    System.out.println("Available time: " + updatedDoctor.getAvailableTime());
                }

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
