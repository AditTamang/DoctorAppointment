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

        User user = new User();
        user.setUsername(name);
        user.setEmail(email);
        user.setPassword(password); // Password will be hashed in the DAO
        user.setPhone(phone); // Set the phone number
        user.setRole(role);

        System.out.println("Attempting to register user: " + user.getUsername() + ", " + user.getEmail() + ", " + user.getPhone() + ", " + user.getRole());

        // Initialize the database before registration
        com.doctorapp.util.DatabaseInitializer.initialize();

        boolean registrationSuccess = userService.registerUser(user);
        System.out.println("Registration success: " + registrationSuccess);

        if (registrationSuccess) {
            // Get the user ID for additional details
            User registeredUser = userService.getUserByEmail(email);

            if (registeredUser != null) {
                int userId = registeredUser.getId();

                if ("PATIENT".equals(role)) {
                    // Handle patient-specific fields
                    String dateOfBirth = request.getParameter("dateOfBirth");
                    String gender = request.getParameter("gender");
                    String address = request.getParameter("address");
                    String bloodGroup = request.getParameter("bloodGroup");
                    String allergies = request.getParameter("allergies");

                    // Save patient details to database
                    registrationSuccess = userService.savePatientDetails(userId, dateOfBirth, gender, address, bloodGroup, allergies);
                } else if ("DOCTOR".equals(role)) {
                    // Handle doctor-specific fields
                    String specialization = request.getParameter("specialization");
                    String qualification = request.getParameter("qualification");
                    String experience = request.getParameter("experience");
                    String address = request.getParameter("address");
                    String bio = request.getParameter("bio");

                    // Save doctor details to database
                    registrationSuccess = userService.saveDoctorDetails(userId, specialization, qualification, experience, address, bio);
                }
            }

            if (registrationSuccess) {
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