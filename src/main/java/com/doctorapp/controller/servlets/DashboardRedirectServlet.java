package com.doctorapp.controller.servlets;

import java.io.IOException;

import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to redirect users to the appropriate dashboard
 */
@WebServlet(urlPatterns = {
    "/redirect-dashboard"
})
public class DashboardRedirectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getServletPath();

        switch (action) {
            case "/redirect-dashboard":
                redirectToDashboard(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    /**
     * Redirect to the appropriate dashboard based on user role
     */
    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        switch (user.getRole()) {
            case "ADMIN":
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
            case "DOCTOR":
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
            case "PATIENT":
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
