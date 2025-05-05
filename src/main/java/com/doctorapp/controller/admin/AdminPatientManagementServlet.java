package com.doctorapp.controller.admin;

import java.io.IOException;

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
    "/admin/view-patient",
    "/admin/edit-patient",
    "/admin/update-patient",
    "/admin/delete-patient"
})
public class AdminPatientManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;
    
    public AdminPatientManagementServlet() {
        super();
        patientService = new PatientService();
    }
    
    @Override
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
            case "/admin/view-patient":
                viewPatient(request, response);
                break;
            case "/admin/edit-patient":
                showEditForm(request, response);
                break;
            case "/admin/delete-patient":
                deletePatient(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                break;
        }
    }

    @Override
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
            case "/admin/update-patient":
                updatePatient(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/patients");
                break;
        }
    }
    
    private void viewPatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Patient patient = patientService.getPatientById(id);
        
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/admin/patients");
            return;
        }
        
        request.setAttribute("patient", patient);
        request.getRequestDispatcher("/admin/view-patient.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Patient patient = patientService.getPatientById(id);
        
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/admin/patients");
            return;
        }
        
        request.setAttribute("patient", patient);
        request.getRequestDispatcher("/admin/edit-patient.jsp").forward(request, response);
    }
    
    private void updatePatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Patient patient = patientService.getPatientById(id);
        
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/admin/patients");
            return;
        }
        
        // Update patient details
        patient.setFirstName(request.getParameter("firstName"));
        patient.setLastName(request.getParameter("lastName"));
        patient.setEmail(request.getParameter("email"));
        patient.setPhone(request.getParameter("phone"));
        patient.setGender(request.getParameter("gender"));
        patient.setDateOfBirth(request.getParameter("dateOfBirth"));
        patient.setAddress(request.getParameter("address"));
        patient.setBloodGroup(request.getParameter("bloodGroup"));
        patient.setAllergies(request.getParameter("allergies"));
        patient.setMedicalHistory(request.getParameter("medicalHistory"));
        
        // Update patient in database
        boolean success = patientService.updatePatient(patient);
        
        if (success) {
            request.setAttribute("message", "Patient updated successfully");
        } else {
            request.setAttribute("error", "Failed to update patient");
        }
        
        // Redirect back to patient list
        response.sendRedirect(request.getContextPath() + "/admin/patients");
    }
    
    private void deletePatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Delete patient from database
        boolean success = patientService.deletePatient(id);
        
        if (success) {
            request.getSession().setAttribute("message", "Patient deleted successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to delete patient");
        }
        
        // Redirect back to patient list
        response.sendRedirect(request.getContextPath() + "/admin/patients");
    }
}
