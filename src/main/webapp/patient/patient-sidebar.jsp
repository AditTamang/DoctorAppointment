<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.service.PatientService" %>
<%
    // Get current user from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get patient information including profile image
    Patient patient = null;
    if ("PATIENT".equals(user.getRole())) {
        PatientService patientService = new PatientService();
        patient = patientService.getPatientByUserId(user.getId());
    }

    // Get current page path to highlight active menu item
    String currentPath = request.getRequestURI();

    // Extract the last part of the path for active menu highlighting
    String activePage = "";
    if (currentPath.contains("/")) {
        activePage = currentPath.substring(currentPath.lastIndexOf("/") + 1);
        // Handle default page (index.jsp or empty path)
        if (activePage.isEmpty() || activePage.equals("dashboard")) {
            activePage = "dashboard";
        }
    }
%>
<!-- Sidebar -->
<div class="sidebar">
    <div class="user-profile">
        <div class="profile-image" data-default-image="/assets/images/patients/default.jpg" data-initials="<%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %>">
            <% if (patient != null && patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= user.getFirstName() %>" onerror="this.src='${pageContext.request.contextPath}/assets/images/patients/default.jpg'">
            <% } else { %>
                <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
            <% } %>
        </div>
        <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
        <p class="user-email"><%= user.getEmail() %></p>
        <p class="user-phone"><%= user.getPhone() != null ? user.getPhone() : "No phone number" %></p>
    </div>

    <ul class="sidebar-menu">
        <li class="<%= activePage.equals("dashboard") || activePage.isEmpty() ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/patient/dashboard">
                <i class="fas fa-home"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="<%= activePage.equals("appointments") || activePage.contains("appointment") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/patient/appointments">
                <i class="fas fa-calendar-check"></i>
                <span>My Appointments</span>
            </a>
        </li>
        <li class="<%= currentPath.contains("/doctors") || activePage.equals("doctors") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/doctors">
                <i class="fas fa-user-md"></i>
                <span>Find Doctors</span>
            </a>
        </li>
        <li class="<%= activePage.equals("medical-records") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/patient/medical-records">
                <i class="fas fa-file-medical"></i>
                <span>Medical Records</span>
            </a>
        </li>
        <li class="<%= activePage.equals("profile") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/patient/profile">
                <i class="fas fa-user"></i>
                <span>My Profile</span>
            </a>
        </li>

        <li class="logout">
            <a href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>

<!-- Include sidebar CSS and JavaScript -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-profile-image.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar-button-fix.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-sidebar-fix.css">
<script src="${pageContext.request.contextPath}/js/patient-sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/profile-image-handler.js"></script>
