package com.doctorapp.controller.auth;

import com.doctorapp.model.User;
import com.doctorapp.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    public void init() {
        userService = new UserService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        showRegisterForm(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        registerUser(request, response);
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone"); // Will be used for patient/doctor details
        String role = request.getParameter("role") != null ? request.getParameter("role") : "PATIENT";

        // Get additional fields that might be present in the form
        String dateOfBirth = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");

        // Split the name into first and last name
        String firstName = "";
        String lastName = "";
        if (name != null && !name.isEmpty()) {
            String[] nameParts = name.split(" ", 2);
            firstName = nameParts[0];
            lastName = nameParts.length > 1 ? nameParts[1] : "";
        }

        User user = new User();
        user.setUsername(name);
        user.setEmail(email);
        user.setPassword(password); // Password will be hashed in the DAO
        user.setPhone(phone); // Set the phone number
        user.setRole(role);
        user.setFirstName(firstName);
        user.setLastName(lastName);

        // Set additional fields if they are present
        user.setDateOfBirth(dateOfBirth);
        user.setGender(gender);
        user.setAddress(address);

        // Initialize the database before registration
        com.doctorapp.util.DatabaseInitializer.initialize();

        // First check if email already exists
        if (userService.emailExists(email)) {
            request.setAttribute("error", "Email address already exists. Please use a different email.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        boolean registrationSuccess = userService.registerUser(user);

        if (registrationSuccess) {
            // Get the user ID for additional details
            User registeredUser = userService.getUserByEmail(email);

            if (registeredUser != null) {
                int userId = registeredUser.getId();
                boolean detailsSaved = false;

                if ("PATIENT".equals(role)) {
                    // Handle patient-specific fields
                    // We already have dateOfBirth, gender, and address from earlier
                    String bloodGroup = request.getParameter("bloodGroup");
                    String allergies = request.getParameter("allergies");

                    // Save patient details to database
                    detailsSaved = userService.savePatientDetails(userId, dateOfBirth, gender, address, bloodGroup, allergies);

                    if (!detailsSaved) {
                        System.out.println("Failed to save patient details for user ID: " + userId);
                    }
                } else if ("DOCTOR".equals(role)) {
                    // Handle doctor-specific fields
                    String specialization = request.getParameter("specialization");
                    String qualification = request.getParameter("qualification");
                    String experience = request.getParameter("experience");
                    String bio = request.getParameter("bio");
                    // We already have address from earlier

                    // Save doctor details to database
                    detailsSaved = userService.saveDoctorDetails(userId, specialization, qualification, experience, address, bio);

                    if (!detailsSaved) {
                        System.out.println("Failed to save doctor details for user ID: " + userId);
                    }
                }

                // Even if details saving fails, we still consider registration successful
                // since the user account was created
                request.setAttribute("message", "Registration successful! Please login.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
        }

        // If we get here, something went wrong
        request.setAttribute("error", "Registration failed. Please try again.");
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}