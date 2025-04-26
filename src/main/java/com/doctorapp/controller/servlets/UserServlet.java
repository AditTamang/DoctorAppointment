package com.doctorapp.controller.servlets;

import com.doctorapp.model.User;
import com.doctorapp.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/profile", "/updateProfile"})
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    public void init() {
        userService = new UserService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/profile":
                showProfile(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/updateProfile":
                updateProfile(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }



    private void showProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            request.setAttribute("user", user);

            // Forward to appropriate profile page based on role
            switch (user.getRole()) {
                case "ADMIN":
                    request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
                    break;
                case "DOCTOR":
                    request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);
                    break;
                case "PATIENT":
                    request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
                    break;
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } else {
            response.sendRedirect("login");
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User currentUser = (User) session.getAttribute("user");

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            User updatedUser = new User();
            updatedUser.setId(currentUser.getId());
            updatedUser.setUsername(name);
            updatedUser.setEmail(email);
            // Only set password if it's not empty
            if (password != null && !password.isEmpty()) {
                updatedUser.setPassword(password);
            }
            updatedUser.setRole(currentUser.getRole());

            // Update phone in patient or doctor table based on role
            if ("PATIENT".equals(currentUser.getRole()) && phone != null && !phone.isEmpty()) {
                // TODO: Implement method to update patient phone
                System.out.println("Updating patient phone: " + phone);
            } else if ("DOCTOR".equals(currentUser.getRole()) && phone != null && !phone.isEmpty()) {
                // TODO: Implement method to update doctor phone
                System.out.println("Updating doctor phone: " + phone);
            }

            if (userService.updateUser(updatedUser)) {
                // Get the updated user from the database
                User refreshedUser = userService.getUserById(currentUser.getId());
                session.setAttribute("user", refreshedUser);
                request.setAttribute("message", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update profile. Please try again.");
            }

            // Forward to appropriate profile page based on role
            switch (currentUser.getRole()) {
                case "ADMIN":
                    request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
                    break;
                case "DOCTOR":
                    request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);
                    break;
                case "PATIENT":
                    request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
                    break;
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } else {
            response.sendRedirect("login");
        }
    }
}
