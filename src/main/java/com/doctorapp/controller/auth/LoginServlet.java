
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
            User user = userService.login(email, password);

            if (user != null) {
                // For doctors, check if there's a pending registration request
                if ("DOCTOR".equals(user.getRole())) {
                    // Check if there's a pending doctor registration request for this email
                    boolean hasPendingRequest = doctorRegistrationService.getPendingRequests().stream()
                            .anyMatch(req -> req.getEmail().equals(email));

                    if (hasPendingRequest) {
                        request.setAttribute("error", "Your doctor registration request is still pending approval. You will be notified when your account is approved.");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                        return;
                    }
                }

                // Create user session using SessionUtil
                SessionUtil.createUserSession(request, response, user, rememberMe);

                // Check if there's a redirect parameter
                String redirect = request.getParameter("redirect");

                // Check if there's a redirectAfterLogin attribute in the session
                String redirectAfterLogin = (String) request.getSession().getAttribute("redirectAfterLogin");
                if (redirectAfterLogin != null) {
                    // Remove the attribute from the session
                    request.getSession().removeAttribute("redirectAfterLogin");
                    // Redirect to the stored URL
                    response.sendRedirect(request.getContextPath() + "/" + redirectAfterLogin);
                } else if (redirect != null && !redirect.isEmpty()) {
                    // Redirect to the requested page
                    response.sendRedirect(redirect);
                } else {
                    // Check user role for specific redirects
                    if ("ADMIN".equals(user.getRole())) {
                        // Redirect admin directly to admin dashboard
                        response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                    } else if ("DOCTOR".equals(user.getRole())) {
                        // Redirect doctor to doctor dashboard
                        response.sendRedirect(request.getContextPath() + "/dashboard");
                    } else {
                        // Redirect patient to home page
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