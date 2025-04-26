package com.doctorapp.controller.servlets;

import java.io.IOException;
import java.util.ArrayList;
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

@WebServlet(urlPatterns = {
    "/doctors",
    "/find-doctors",
    "/doctor/details",
    "/admin/doctors",
    "/admin/doctor/add",
    "/admin/doctor/edit",
    "/admin/doctor/delete"
})
public class DoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;

    public void init() {
        doctorService = new DoctorService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/doctors":
                listDoctors(request, response);
                break;
            case "/find-doctors":
                findDoctors(request, response);
                break;
            case "/doctor/details":
                showDoctorDetails(request, response);
                break;
            case "/admin/doctors":
                listDoctorsForAdmin(request, response);
                break;
            case "/admin/doctor/add":
                showAddDoctorForm(request, response);
                break;
            case "/admin/doctor/edit":
                showEditDoctorForm(request, response);
                break;
            case "/admin/doctor/view":
                viewDoctorDetails(request, response);
                break;
            case "/admin/doctor/delete":
                deleteDoctor(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/admin/doctor/add":
                addDoctor(request, response);
                break;
            case "/admin/doctor/edit":
                updateDoctor(request, response);
                break;
            case "/admin/doctor/delete":
                deleteDoctor(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    private void findDoctors(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This method handles the new find-doctors page with the modern UI
        String specialization = request.getParameter("specialization");
        String searchTerm = request.getParameter("search");
        String experience = request.getParameter("experience");
        List<Doctor> doctors;

        // Set the specialization as a request attribute for the JSP
        if (specialization != null && !specialization.isEmpty()) {
            request.setAttribute("specialization", specialization);
            // Use approved doctors by specialization for public display
            System.out.println("Fetching doctors with specialization: " + specialization);
            doctors = doctorService.getApprovedDoctorsBySpecialization(specialization);
        } else if (searchTerm != null && !searchTerm.isEmpty()) {
            // Use search functionality if search term is provided
            System.out.println("Searching for doctors with term: " + searchTerm);
            doctors = doctorService.searchApprovedDoctors(searchTerm);
        } else {
            // Use approved doctors for public display
            System.out.println("Fetching all approved doctors");
            doctors = doctorService.getApprovedDoctors();
        }

        // Filter by experience if provided
        if (experience != null && !experience.isEmpty() && doctors != null) {
            List<Doctor> filteredDoctors = new ArrayList<>();
            for (Doctor doctor : doctors) {
                if (doctor.getExperience() != null && !doctor.getExperience().isEmpty()) {
                    try {
                        int exp = Integer.parseInt(doctor.getExperience());
                        if (experience.equals("0-5") && exp >= 0 && exp <= 5) {
                            filteredDoctors.add(doctor);
                        } else if (experience.equals("5-10") && exp > 5 && exp <= 10) {
                            filteredDoctors.add(doctor);
                        } else if (experience.equals("10+") && exp > 10) {
                            filteredDoctors.add(doctor);
                        }
                    } catch (NumberFormatException e) {
                        // If experience is not a number, skip this doctor
                        continue;
                    }
                }
            }
            doctors = filteredDoctors;
        }

        System.out.println("Found " + (doctors != null ? doctors.size() : 0) + " doctors");

        // Set doctors as request attribute
        request.setAttribute("doctors", doctors);

        // Forward to the find-doctors.jsp page
        request.getRequestDispatcher("/find-doctors.jsp").forward(request, response);
    }

    private void listDoctors(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String specialization = request.getParameter("specialization");
        String searchTerm = request.getParameter("search");
        String experience = request.getParameter("experience");
        List<Doctor> doctors;

        // Set the specialization as a request attribute for the JSP
        if (specialization != null && !specialization.isEmpty()) {
            request.setAttribute("specialization", specialization);
            // Use approved doctors by specialization for public display
            System.out.println("Fetching doctors with specialization: " + specialization);
            doctors = doctorService.getApprovedDoctorsBySpecialization(specialization);
        } else if (searchTerm != null && !searchTerm.isEmpty()) {
            // Use search functionality if search term is provided
            System.out.println("Searching for doctors with term: " + searchTerm);
            doctors = doctorService.searchApprovedDoctors(searchTerm);
        } else {
            // Use approved doctors for public display
            System.out.println("Fetching all approved doctors");
            doctors = doctorService.getApprovedDoctors();
        }

        // Filter by experience if provided
        if (experience != null && !experience.isEmpty() && doctors != null) {
            List<Doctor> filteredDoctors = new ArrayList<>();
            for (Doctor doctor : doctors) {
                if (doctor.getExperience() != null && !doctor.getExperience().isEmpty()) {
                    try {
                        int exp = Integer.parseInt(doctor.getExperience());
                        if (experience.equals("0-5") && exp >= 0 && exp <= 5) {
                            filteredDoctors.add(doctor);
                        } else if (experience.equals("5-10") && exp > 5 && exp <= 10) {
                            filteredDoctors.add(doctor);
                        } else if (experience.equals("10+") && exp > 10) {
                            filteredDoctors.add(doctor);
                        }
                    } catch (NumberFormatException e) {
                        // If experience is not a number, skip this doctor
                        continue;
                    }
                }
            }
            doctors = filteredDoctors;
        }

        System.out.println("Found " + (doctors != null ? doctors.size() : 0) + " doctors");

        // Set the specialization attribute for the JSP
        request.setAttribute("specialization", specialization);
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/doctors.jsp").forward(request, response);
    }

    private void showDoctorDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorService.getDoctorById(id);

        if (doctor != null) {
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/doctor-details.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/doctors");
        }
    }

    private void listDoctorsForAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        List<Doctor> doctors = doctorService.getAllDoctors();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/admin/doctors.jsp").forward(request, response);
    }

    private void showAddDoctorForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        request.getRequestDispatcher("/admin/add-doctor.jsp").forward(request, response);
    }

    private void showEditDoctorForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        int id = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorService.getDoctorById(id);

        if (doctor != null) {
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/admin/edit-doctor.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
        }
    }

    private void addDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        // Get form data
        String name = request.getParameter("name");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experience = request.getParameter("experience");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String consultationFee = request.getParameter("consultationFee");
        String availableDays = request.getParameter("availableDays");
        String availableTime = request.getParameter("availableTime");
        String imageUrl = request.getParameter("imageUrl");

        // Create doctor object
        Doctor doctor = new Doctor();
        doctor.setName(name);
        doctor.setSpecialization(specialization);
        doctor.setQualification(qualification);
        doctor.setExperience(experience);
        doctor.setEmail(email);
        doctor.setPhone(phone);
        doctor.setAddress(address);
        doctor.setConsultationFee(consultationFee);
        doctor.setAvailableDays(availableDays);
        doctor.setAvailableTime(availableTime);
        doctor.setImageUrl(imageUrl);

        // Add doctor to database
        if (doctorService.addDoctor(doctor)) {
            request.setAttribute("message", "Doctor added successfully!");
        } else {
            request.setAttribute("error", "Failed to add doctor. Please try again.");
        }

        // Forward back to the form
        request.getRequestDispatcher("/admin/add-doctor.jsp").forward(request, response);
    }

    private void updateDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        // Get form data
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experience = request.getParameter("experience");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String consultationFee = request.getParameter("consultationFee");
        String availableDays = request.getParameter("availableDays");
        String availableTime = request.getParameter("availableTime");
        String imageUrl = request.getParameter("imageUrl");

        // Create doctor object
        Doctor doctor = new Doctor();
        doctor.setId(id);
        doctor.setName(name);
        doctor.setSpecialization(specialization);
        doctor.setQualification(qualification);
        doctor.setExperience(experience);
        doctor.setEmail(email);
        doctor.setPhone(phone);
        doctor.setAddress(address);
        doctor.setConsultationFee(consultationFee);
        doctor.setAvailableDays(availableDays);
        doctor.setAvailableTime(availableTime);
        doctor.setImageUrl(imageUrl);

        // Update doctor in database
        if (doctorService.updateDoctor(doctor)) {
            request.setAttribute("message", "Doctor updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update doctor. Please try again.");
        }

        // Forward back to the form
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/admin/edit-doctor.jsp").forward(request, response);
    }

    private void viewDoctorDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        // Get doctor ID
        int id = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorService.getDoctorById(id);

        if (doctor != null) {
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/admin/view-doctor.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
        }
    }

    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        // Get doctor ID
        int id = Integer.parseInt(request.getParameter("id"));

        // Delete doctor from database
        if (doctorService.deleteDoctor(id)) {
            request.setAttribute("message", "Doctor deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete doctor. Please try again.");
        }

        // Redirect to doctors list
        response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
    }
}