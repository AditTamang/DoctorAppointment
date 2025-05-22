
package com.doctorapp.controller.auth;

import java.io.IOException;

import com.doctorapp.model.User;
import com.doctorapp.service.DoctorRegistrationService;
import com.doctorapp.service.UserService;
import com.doctorapp.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    private DoctorRegistrationService doctorRegistrationService;

    public void init() {
        userService = new UserService();
        doctorRegistrationService = new DoctorRegistrationService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        showLoginForm(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        loginUser(request, response);
    }

    private void showLoginForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));

        try {
            // First check if there's a pending doctor registration request for this email
            // Only check for pending requests if email is not null or empty
            if (email != null && !email.trim().isEmpty()) {
                try {
                    boolean hasPendingRequest = doctorRegistrationService.hasPendingRequest(email);

                    if (hasPendingRequest) {
                        request.setAttribute("error", "Your doctor registration request is still pending approval. You will be notified when your account is approved.");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                        return;
                    }
                } catch (Exception e) {
                    // Log the error but continue with login attempt
                    System.err.println("Error checking for pending doctor registration: " + e.getMessage());
                }
            }

            User user = userService.login(email, password);

            if (user != null) {
                // For doctors, verify they are approved
                if ("DOCTOR".equals(user.getRole())) {
                    try {
                        // Check if the doctor has been approved
                        boolean isDoctorApproved = doctorRegistrationService.isDoctorApproved(user.getId());

                        System.out.println("Doctor login attempt - User ID: " + user.getId() +
                                          ", Email: " + user.getEmail() +
                                          ", Approval Status: " + isDoctorApproved);

                        if (!isDoctorApproved) {
                            request.setAttribute("error", "Your doctor account has not been approved yet. Please wait for admin approval or contact support.");
                            request.getRequestDispatcher("/login.jsp").forward(request, response);
                            return;
                        }

                        System.out.println("Doctor approved, proceeding with login");
                    } catch (Exception e) {
                        // Log the error but allow login if we can't determine approval status
                        System.err.println("Error checking doctor approval status: " + e.getMessage());
                        e.printStackTrace();
                        // For security, we'll assume the doctor is approved if we can't check
                        // This prevents locking out doctors if the approval system has an error
                    }
                }

                // Create user session using SessionUtil
                HttpSession session = SessionUtil.createUserSession(request, response, user, rememberMe);
                System.out.println("LoginServlet: Created session with ID: " + session.getId());
                System.out.println("LoginServlet: User in session: " + session.getAttribute("user"));

                // Check if there's a redirect parameter
                String redirect = request.getParameter("redirect");

                if (redirect != null && !redirect.isEmpty()) {
                    // Redirect to the requested page
                    response.sendRedirect(redirect);
                } else {
                    // Check user role for specific redirects
                    if ("ADMIN".equals(user.getRole())) {
                        // Redirect admin directly to admin dashboard
                        response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                    } else if ("DOCTOR".equals(user.getRole())) {
                        // Redirect doctors to their dashboard
                        response.sendRedirect(request.getContextPath() + "/redirect-dashboard");
                    } else {
                        // Redirect patients to the index page
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                    }
                }
            } else {
                // Check if there's a pending doctor registration request for this email
                boolean hasPendingRequest = doctorRegistrationService.getPendingRequests().stream()
                        .anyMatch(req -> req.getEmail().equals(email));

                if (hasPendingRequest) {
                    request.setAttribute("error", "Your doctor registration request is still pending approval. You will be notified when your account is approved.");
                } else {
                    // Set error message in request attribute
                    request.setAttribute("error", "Invalid email or password");
                }

                // Forward back to login page
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log the error
            System.err.println("Login error: " + e.getMessage());
            e.printStackTrace();

            // Set error message in request attribute
            request.setAttribute("error", "Login failed: " + e.getMessage());
            // Forward back to login page
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}