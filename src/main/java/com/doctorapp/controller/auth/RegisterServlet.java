package com.doctorapp.controller.auth;

import java.io.IOException;

import com.doctorapp.model.DoctorRegistrationRequest;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorRegistrationService;
import com.doctorapp.service.UserService;
import com.doctorapp.util.PasswordValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    private DoctorRegistrationService doctorRegistrationService;

    public void init() {
        userService = new UserService();
        doctorRegistrationService = new DoctorRegistrationService();
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

        // Initialize the database before registration
        com.doctorapp.util.DatabaseInitializer.initialize();

        // Validate password complexity
        if (!PasswordValidator.isValid(password)) {
            request.setAttribute("error", PasswordValidator.getValidationErrorMessage(password));
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists in users table
        if (userService.emailExists(email)) {
            request.setAttribute("error", "Email address already exists. Please use a different email.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Handle registration based on role
        if ("DOCTOR".equals(role)) {
            // For doctors, create a registration request instead of direct registration
            // Get doctor-specific fields
            String specialization = request.getParameter("specialization");
            String qualification = request.getParameter("qualification");
            String experience = request.getParameter("experience");
            String bio = request.getParameter("bio");

            // Create doctor registration request
            DoctorRegistrationRequest doctorRequest = new DoctorRegistrationRequest();
            doctorRequest.setUsername(name);
            doctorRequest.setEmail(email);
            doctorRequest.setPassword(password); // Password will be hashed in the DAO
            doctorRequest.setPhone(phone);
            doctorRequest.setFirstName(firstName);
            doctorRequest.setLastName(lastName);
            doctorRequest.setDateOfBirth(dateOfBirth);
            doctorRequest.setGender(gender);
            doctorRequest.setAddress(address);
            doctorRequest.setSpecialization(specialization);
            doctorRequest.setQualification(qualification);
            doctorRequest.setExperience(experience);
            doctorRequest.setBio(bio);
            doctorRequest.setStatus("PENDING");

            boolean requestCreated = doctorRegistrationService.createRequest(doctorRequest);

            if (requestCreated) {
                request.setAttribute("message", "Your registration request has been submitted. An administrator will review your application and you will be notified via email when your account is approved.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Failed to submit registration request. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
        } else {
            // For patients and admins, proceed with direct registration
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
                    }

                    // Even if details saving fails, we still consider registration successful
                    // since the user account was created
                    request.setAttribute("message", "Registration successful! Please login.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
            }
        }

        // If we get here, something went wrong
        request.setAttribute("error", "Registration failed. Please try again.");
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}