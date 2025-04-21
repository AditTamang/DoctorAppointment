// package com.doctorapp.controller.auth;

// import com.doctorapp.model.User;
// import com.doctorapp.service.UserService;

// import jakarta.servlet.ServletException;
// import jakarta.servlet.annotation.WebServlet;
// import jakarta.servlet.http.HttpServlet;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import jakarta.servlet.http.HttpSession;

// import java.io.IOException;

// @WebServlet("/login")
// public class LoginServlet extends HttpServlet {
//     private static final long serialVersionUID = 1L;
//     private UserService userService;

//     public void init() {
//         userService = new UserService();
//     }

//     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//         showLoginForm(request, response);
//     }

//     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//         loginUser(request, response);
//     }

//     private void showLoginForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//         request.getRequestDispatcher("/login.jsp").forward(request, response);
//     }

//     private void loginUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//         String email = request.getParameter("email");
//         String password = request.getParameter("password");

//         try {
//             User user = userService.login(email, password);

//             if (user != null) {
//                 HttpSession session = request.getSession();
//                 session.setAttribute("user", user);

//                 // Redirect to the appropriate dashboard based on role
//                 String role = user.getRole();
//                 String dashboardUrl = request.getContextPath() + "/dashboard";

//                 switch (role) {
//                     case "ADMIN":
//                     case "DOCTOR":
//                     case "PATIENT":
//                         response.sendRedirect(dashboardUrl);
//                         break;
//                     default:
//                         // Invalid role, redirect to login
//                         session.invalidate();
//                         request.setAttribute("error", "Invalid user role: " + role);
//                         request.getRequestDispatcher("/login.jsp").forward(request, response);
//                         break;
//                 }
//             } else {
//                 request.setAttribute("error", "Invalid email or password");
//                 request.getRequestDispatcher("/login.jsp").forward(request, response);
//             }
//         } catch (Exception e) {
//             request.setAttribute("error", "An error occurred during login: " + e.getMessage());
//             request.getRequestDispatcher("/login.jsp").forward(request, response);
//         }
//     }
// }
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

                // Redirect to the Dashboard page after successful login
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");

            } else {
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"Invalid email or password\"}");
            }
        } catch (Exception e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Login failed: " + e.getMessage() + "\"}");
        }
    }
}