<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.service.DoctorService" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-sidebar-clean.css">
<%
    // Get user and redirect if not logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor profile data
    Doctor doctor = null;
    if ("DOCTOR".equals(user.getRole())) {
        DoctorService doctorService = new DoctorService();
        doctor = doctorService.getDoctorByUserId(user.getId());
    }

    // Determine active menu item
    String currentPath = request.getRequestURI();
    String activePage = "";
    if (currentPath.contains("/")) {
        activePage = currentPath.substring(currentPath.lastIndexOf("/") + 1);
        if (activePage.isEmpty() || activePage.equals("dashboard")) {
            activePage = "dashboard";
        }
    }
%>
<!-- Styles moved to doctor-sidebar-clean.css -->

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-profile">
        <div class="profile-image">
            <%
            String imagePath = "";
            if (doctor != null && doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty()) {
                imagePath = request.getContextPath() + doctor.getProfileImage();
            } else if (doctor != null && doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty()) {
                imagePath = request.getContextPath() + doctor.getImageUrl();
            } else {
                imagePath = request.getContextPath() + "/assets/images/doctors/default-doctor.png";
            }

            // Check if we should display the image or initials
            boolean useDefaultImage = imagePath.contains("default-doctor.png");
            if (!useDefaultImage) {
            %>
                <img src="<%= imagePath %>" alt="Doctor"
                     onerror="this.onerror=null; this.parentNode.innerHTML = '<div class=\'profile-initials\'><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>';">
            <% } else { %>
                <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
            <% } %>
        </div>
        <div class="profile-name"><%= user.getFirstName() + " " + user.getLastName() %></div>
        <div class="profile-info"><%= user.getEmail() %></div>
        <div class="profile-info"><%= user.getPhone() != null ? user.getPhone() : "" %></div>
    </div>

    <div class="sidebar-nav">
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/doctor/dashboard" class="<%= activePage.equals("dashboard") || activePage.equals("index") || activePage.isEmpty() ? "active" : "" %>">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/doctor/appointments" class="<%= activePage.equals("appointments") ? "active" : "" %>">
                    <i class="fas fa-calendar-check"></i> My Appointments
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/doctor/patients" class="<%= activePage.equals("patients") ? "active" : "" %>">
                    <i class="fas fa-user-injured"></i> My Patients
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/doctor/edit-profile" class="<%= activePage.equals("profile") || activePage.equals("edit-profile") ? "active" : "" %>">
                    <i class="fas fa-user"></i> My Profile
                </a>
            </li>
        </ul>
    </div>

    <div class="logout">
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>

    <script>
        // Add mobile sidebar toggle functionality
        document.addEventListener('DOMContentLoaded', function() {
            // This will be used by a toggle button in the main content
            window.toggleSidebar = function() {
                document.querySelector('.sidebar').classList.toggle('active');
            };
        });
    </script>
</div>
