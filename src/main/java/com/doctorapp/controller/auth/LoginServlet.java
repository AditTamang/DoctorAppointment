package com.doctorapp.controller.auth;

import com.doctorapp.model.User;
import com.doctorapp.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    public void init() {
        userService = new UserService();
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

        try {
            User user = userService.login(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                // Generate unique token
                String token = UUID.randomUUID().toString();

                // Create login cookie
                Cookie loginCookie = new Cookie("loginToken", token);
                loginCookie.setHttpOnly(true);  // Prevent JS access to the cookie
                loginCookie.setPath("/");  // Make it available across the entire application
                loginCookie.setMaxAge(60 * 60); // 1 hour expiration

                // Add cookie to response
                response.addCookie(loginCookie);

                // Check if there's a redirect parameter
                String redirect = request.getParameter("redirect");
                if (redirect != null && !redirect.isEmpty()) {
                    // Redirect to the requested page
                    response.sendRedirect(redirect);
                } else {
                    // Redirect to the Dashboard page after successful login
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }

            } else {
                response.setContentType("application/json");
                response.setStatus(401); // Unauthorized
                response.getWriter().write("{\"error\": \"Invalid email or password\"}");
            }
        } catch (Exception e) {
            response.setContentType("application/json");
            response.setStatus(500); // Internal Server Error
            response.getWriter().write("{\"error\": \"Login failed: " + e.getMessage() + "\"}");
        }
    }
}