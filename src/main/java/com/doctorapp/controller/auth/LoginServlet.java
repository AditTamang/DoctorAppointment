
package com.doctorapp.controller.auth;

import com.doctorapp.model.User;
import com.doctorapp.service.UserService;
import com.doctorapp.util.SessionUtil;

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
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));

        try {
            User user = userService.login(email, password);

            if (user != null) {
                // Create user session using SessionUtil
                SessionUtil.createUserSession(request, response, user, rememberMe);

                // Check if there's a redirect parameter
                String redirect = request.getParameter("redirect");

                if (redirect != null && !redirect.isEmpty()) {
                    // Redirect to the requested page
                    response.sendRedirect(redirect);
                } else {
                    // Redirect to the dashboard servlet which will handle role-based redirection
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
            } else {
                // Set error message in request attribute
                request.setAttribute("error", "Invalid email or password");
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