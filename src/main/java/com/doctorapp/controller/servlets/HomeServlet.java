package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.List;

import com.doctorapp.model.Doctor;
import com.doctorapp.service.DoctorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * HomeServlet handles requests to the home page.
 * It displays featured doctors and other home page content.
 */
@WebServlet(urlPatterns = {"", "/", "/home"})
public class HomeServlet extends HttpServlet {
    private DoctorService doctorService;

    public void init() throws ServletException {
        doctorService = new DoctorService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Initialize the database if needed
            com.doctorapp.util.DatabaseInitializer.initialize();

            try {
                // Get top doctors for the home page (featured doctors)
                List<Doctor> featuredDoctors = doctorService.getTopDoctors(3);
                request.setAttribute("featuredDoctors", featuredDoctors);
            } catch (Exception e) {
                // Log the error but continue
                getServletContext().log("Error getting featured doctors: " + e.getMessage(), e);
                // Set an empty list to avoid null pointer exceptions
                request.setAttribute("featuredDoctors", java.util.Collections.emptyList());
            }

            // Check if there's a redirect parameter
            String redirect = request.getParameter("redirect");
            if (redirect != null && !redirect.isEmpty()) {
                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("user") != null) {
                    // User is logged in, redirect to the requested page
                    response.sendRedirect(redirect);
                    return;
                }
            }

            // Forward to the index.jsp page
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error in HomeServlet: " + e.getMessage(), e);
            // Forward to error page
            request.setAttribute("errorMessage", "An error occurred while loading the home page. Please try again later.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle any POST requests by delegating to doGet
        doGet(request, response);
    }
}
