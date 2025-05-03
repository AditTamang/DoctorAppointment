package com.doctorapp.controller.doctor;

import java.io.IOException;

import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorService;
import com.doctorapp.service.UserService;
import com.doctorapp.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling doctor profile operations
 */
@WebServlet(urlPatterns = {
    "/doctor/profile",
    "/doctor/profile/update"
})
public class DoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;
    private UserService userService;

    public void init() {
        doctorService = new DoctorService();
        userService = new UserService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/doctor/profile":
                showDoctorProfile(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/doctor/profile/update":
                updateDoctorProfile(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
        }
    }

    /**
     * Show doctor profile page
     */
    private void showDoctorProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get doctor details
        Doctor doctor = doctorService.getDoctorByUserId(user.getId());

        if (doctor == null) {
            // This should not happen for approved doctors
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Doctor profile not found");
            return;
        }

        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);
    }

    /**
     * Update doctor profile
     */
    private void updateDoctorProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experience = request.getParameter("experience");
        String consultationFee = request.getParameter("consultationFee");
        String availableDays = request.getParameter("availableDays");
        String availableTime = request.getParameter("availableTime");
        String bio = request.getParameter("bio");
        String status = request.getParameter("status");

        // Validate input
        boolean hasError = false;

        if (!ValidationUtil.isValidName(firstName)) {
            request.setAttribute("firstNameError", "Please enter a valid first name");
            hasError = true;
        }

        if (!ValidationUtil.isValidName(lastName)) {
            request.setAttribute("lastNameError", "Please enter a valid last name");
            hasError = true;
        }

        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Please enter a valid phone number");
            hasError = true;
        }

        if (ValidationUtil.isNullOrEmpty(specialization)) {
            request.setAttribute("specializationError", "Please select a specialization");
            hasError = true;
        }

        if (ValidationUtil.isNullOrEmpty(qualification)) {
            request.setAttribute("qualificationError", "Please enter your qualification");
            hasError = true;
        }

        if (hasError) {
            // Get doctor details again
            Doctor doctor = doctorService.getDoctorByUserId(user.getId());
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
            return;
        }

        // Update user information
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        user.setAddress(address);

        boolean userUpdated = userService.updateUser(user);

        // Update doctor information
        Doctor doctor = doctorService.getDoctorByUserId(user.getId());

        if (doctor != null) {
            doctor.setSpecialization(specialization);
            doctor.setQualification(qualification);
            doctor.setExperience(experience);
            doctor.setConsultationFee(consultationFee);
            doctor.setAvailableDays(availableDays);
            doctor.setAvailableTime(availableTime);
            doctor.setBio(bio);

            // Set status if provided
            if (status != null && !status.isEmpty()) {
                doctor.setStatus(status);
            }

            boolean doctorUpdated = doctorService.updateDoctor(doctor);

            if (userUpdated && doctorUpdated) {
                // Update session with new user data
                session.setAttribute("user", user);

                request.setAttribute("successMessage", "Profile updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }
        } else {
            request.setAttribute("errorMessage", "Doctor record not found. Please contact support.");
        }

        // Refresh doctor data
        doctor = doctorService.getDoctorByUserId(user.getId());
        request.setAttribute("doctor", doctor);

        // Forward to edit-profile.jsp to show the success/error message
        request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
    }
}
