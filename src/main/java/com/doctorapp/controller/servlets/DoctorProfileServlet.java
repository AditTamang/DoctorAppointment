package com.doctorapp.controller.servlets;

import java.io.IOException;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Removing WebServlet annotation to avoid conflict with com.doctorapp.controller.doctor.DoctorProfileServlet
public class DoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorDAO doctorDAO;

    public void init() {
        doctorDAO = new DoctorDAO();
    }

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

        try {
            // Get doctor ID from user ID
            int doctorId = doctorDAO.getDoctorIdByUserId(user.getId());

            if (doctorId == 0) {
                // Doctor profile not found, redirect to complete profile
                response.sendRedirect(request.getContextPath() + "/complete-profile.jsp");
                return;
            }

            // Get doctor details
            Doctor doctor = doctorDAO.getDoctorById(doctorId);

            if (doctor == null) {
                // Doctor not found, redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                return;
            }

            // Set doctor in request attribute
            request.setAttribute("doctor", doctor);

            // Forward to profile page
            request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error loading doctor profile: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This will handle profile updates in the future
        doGet(request, response);
    }
}
