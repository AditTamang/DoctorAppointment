package com.doctorapp.controller.admin;

import java.io.IOException;
import java.util.List;

import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;
import com.doctorapp.service.DoctorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/doctorDashboard")
public class AdminDoctorsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;

    @Override
    public void init() {
        doctorService = new DoctorService();
        // We don't need userService for this servlet
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Get search parameter if any
        String searchTerm = request.getParameter("search");
        List<Doctor> doctors;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            // Search for doctors by name or email
            doctors = doctorService.searchDoctors(searchTerm);
        } else {
            // Get all doctors
            doctors = doctorService.getAllDoctors();
        }

        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/admin/doctorDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
