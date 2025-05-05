package com.doctorapp.controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.doctorapp.model.Patient;
import com.doctorapp.model.User;
import com.doctorapp.service.PatientService;

/**
 * Servlet for handling patient management operations by admin
 */
@WebServlet(urlPatterns = {
    "/admin/patients"
})
public class AdminPatientsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;
    
    public AdminPatientsServlet() {
        super();
        patientService = new PatientService();
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
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        // Get search parameter if any
        String searchTerm = request.getParameter("search");
        List<Patient> patients;

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            // Search for patients by name or email
            patients = patientService.searchPatients(searchTerm);
        } else {
            // Get all patients
            patients = patientService.getAllPatients();
        }

        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/admin/patientDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
