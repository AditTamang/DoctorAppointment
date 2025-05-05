package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.doctorapp.dao.DoctorDAO;
import com.doctorapp.model.Doctor;
import com.doctorapp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Removing WebServlet annotation to resolve URL mapping conflict
// with com.doctorapp.controller.doctor.DoctorProfileServlet
public class DoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DoctorProfileServlet.class.getName());

    private DoctorDAO doctorDAO;

    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            if (doctor == null) {
                LOGGER.log(Level.WARNING, "Doctor not found for user ID: " + user.getId());
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                return;
            }

            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor profile", e);
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getId());
            if (doctor == null) {
                LOGGER.log(Level.WARNING, "Doctor not found for user ID: " + user.getId());
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                return;
            }

            // Update doctor information
            doctor.setFirstName(request.getParameter("firstName"));
            doctor.setLastName(request.getParameter("lastName"));
            doctor.setEmail(request.getParameter("email"));
            doctor.setPhone(request.getParameter("phone"));
            doctor.setAddress(request.getParameter("address"));
            doctor.setSpecialization(request.getParameter("specialization"));
            doctor.setQualification(request.getParameter("qualifications"));
            doctor.setBio(request.getParameter("bio"));

            // Set experience and consultation fee as strings
            doctor.setExperience(request.getParameter("experience"));
            doctor.setConsultationFee(request.getParameter("consultationFee"));

            // Update doctor in database
            boolean updated = doctorDAO.updateDoctor(doctor);
            if (updated) {
                request.setAttribute("successMessage", "Profile updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile");
            }

            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/doctor/profile.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating doctor profile", e);
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }
}
