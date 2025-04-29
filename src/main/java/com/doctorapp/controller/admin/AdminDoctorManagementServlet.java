package com.doctorapp.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorService;

/**
 * Servlet for handling doctor management operations by admin
 */
@WebServlet(urlPatterns = {
    "/admin/doctors/view",
    "/admin/doctors/edit",
    "/admin/doctors/update",
    "/admin/doctors/delete"
})
public class AdminDoctorManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;

    public void init() {
        doctorService = new DoctorService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        switch (action) {
            case "/admin/doctors/view":
                viewDoctor(request, response);
                break;
            case "/admin/doctors/edit":
                showEditForm(request, response);
                break;
            case "/admin/doctors/delete":
                deleteDoctor(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        switch (action) {
            case "/admin/doctors/update":
                updateDoctor(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
                break;
        }
    }

    /**
     * View doctor details
     */
    private void viewDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorService.getDoctorById(doctorId);
        
        if (doctor == null) {
            request.setAttribute("errorMessage", "Doctor not found");
            request.getRequestDispatcher("/admin/doctorDashboard.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/admin/viewDoctor.jsp").forward(request, response);
    }

    /**
     * Show edit form for doctor
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorService.getDoctorById(doctorId);
        
        if (doctor == null) {
            request.setAttribute("errorMessage", "Doctor not found");
            request.getRequestDispatcher("/admin/doctorDashboard.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/admin/editDoctor.jsp").forward(request, response);
    }

    /**
     * Update doctor information
     */
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorService.getDoctorById(doctorId);
        
        if (doctor == null) {
            request.setAttribute("errorMessage", "Doctor not found");
            request.getRequestDispatcher("/admin/doctorDashboard.jsp").forward(request, response);
            return;
        }
        
        // Get form data
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experience = request.getParameter("experience");
        String consultationFee = request.getParameter("consultationFee");
        String availableDays = request.getParameter("availableDays");
        String availableTime = request.getParameter("availableTime");
        String bio = request.getParameter("bio");
        
        // Update doctor information
        doctor.setSpecialization(specialization);
        doctor.setQualification(qualification);
        doctor.setExperience(experience);
        doctor.setConsultationFee(consultationFee);
        doctor.setAvailableDays(availableDays);
        doctor.setAvailableTime(availableTime);
        doctor.setBio(bio);
        
        boolean updated = doctorService.updateDoctor(doctor);
        
        if (updated) {
            request.setAttribute("successMessage", "Doctor information updated successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to update doctor information");
        }
        
        // Refresh doctor data
        doctor = doctorService.getDoctorById(doctorId);
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/admin/viewDoctor.jsp").forward(request, response);
    }

    /**
     * Delete doctor
     */
    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("id"));
        
        boolean deleted = doctorService.deleteDoctor(doctorId);
        
        if (deleted) {
            request.setAttribute("successMessage", "Doctor deleted successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to delete doctor");
        }
        
        // Redirect to doctor list
        response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
    }
}
