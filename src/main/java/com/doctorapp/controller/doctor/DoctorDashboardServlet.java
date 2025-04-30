package com.doctorapp.controller.doctor;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.User;

/**
 * Servlet to handle doctor dashboard requests
 */
@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Check if user is a doctor
        if (!"DOCTOR".equals(user.getRole())) {
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("PATIENT".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
            return;
        }

        // Forward to the main dashboard servlet
        request.getRequestDispatcher("/dashboard").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
