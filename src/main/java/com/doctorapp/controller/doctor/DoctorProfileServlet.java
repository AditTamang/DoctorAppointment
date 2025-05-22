package com.doctorapp.controller.doctor;

import java.io.IOException;

import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling doctor profile operations
 * URL mappings are defined in web.xml
 */
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class DoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;

    @Override
    public void init() {
        doctorService = new DoctorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/doctor/profile":
                showDoctorProfile(request, response);
                break;
            case "/doctor/edit-profile":
                showEditProfileForm(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // All POST requests for profile updates are now handled by DoctorProfileUpdateServlet
        response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
    }

    /**
     * Show doctor profile page - redirects directly to edit profile
     */
    private void showDoctorProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect directly to edit profile page
        response.sendRedirect(request.getContextPath() + "/doctor/edit-profile");
    }

    /**
     * Show edit profile form
     */
    private void showEditProfileForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Check if doctor is already in session
            Doctor doctor = (Doctor) session.getAttribute("doctor");

            // If not in session, get from database
            if (doctor == null) {
                doctor = doctorService.getDoctorByUserId(user.getId());

                if (doctor == null) {
                    // This should not happen for approved doctors
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Doctor profile not found");
                    return;
                }

                // Store in session for future use
                session.setAttribute("doctor", doctor);
            }

            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/doctor/edit-profile.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error showing edit profile form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Error loading edit form: " + e.getMessage());
        }
    }
}
