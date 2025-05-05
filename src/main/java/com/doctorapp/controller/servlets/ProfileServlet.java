package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.dao.PatientDAO;
import com.doctorapp.dao.UserDAO;
import com.doctorapp.model.Patient;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Removing WebServlet annotation to use web.xml mapping instead
// This servlet is mapped to /patient/profile-legacy in web.xml
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());

    private PatientDAO patientDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                LOGGER.log(Level.WARNING, "Patient not found for user ID: " + user.getId());
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                return;
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving patient profile", e);
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Patient patient = patientDAO.getPatientByUserId(user.getId());
            if (patient == null) {
                LOGGER.log(Level.WARNING, "Patient not found for user ID: " + user.getId());
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                return;
            }

            // Update patient information
            patient.setFirstName(request.getParameter("firstName"));
            patient.setLastName(request.getParameter("lastName"));

            // Make sure email is not null or empty
            String email = request.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                // If email is not provided in the form, use the existing email from the user object
                email = user.getEmail();
            }
            patient.setEmail(email);

            patient.setPhone(request.getParameter("phone"));
            patient.setAddress(request.getParameter("address"));
            patient.setGender(request.getParameter("gender"));
            patient.setDateOfBirth(request.getParameter("dateOfBirth"));
            patient.setBloodGroup(request.getParameter("bloodGroup"));

            // Update patient in database
            boolean updated = patientDAO.updatePatient(patient);

            // Also update the user information
            user.setFirstName(patient.getFirstName());
            user.setLastName(patient.getLastName());
            user.setEmail(patient.getEmail());
            user.setPhone(patient.getPhone());

            boolean userUpdated = userDAO.updateUser(user);

            if (updated && userUpdated) {
                // Update the user in session
                session.setAttribute("user", user);
                request.setAttribute("successMessage", "Profile updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile");
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating patient profile", e);
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        }
    }
}
