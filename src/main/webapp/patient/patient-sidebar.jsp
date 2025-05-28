<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.service.PatientService" %>
<%
    // Get current user from session - authentication is handled by servlet
    User user = (User) session.getAttribute("user");

    // Get patient information from session or request attributes (avoid database call)
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        patient = (Patient) request.getAttribute("patient");
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
        <div class="profile-image" data-default-image="/assets/images/patients/default.jpg" data-initials="<%
            String firstName = user.getFirstName() != null ? user.getFirstName() : "U";
            String lastName = user.getLastName() != null ? user.getLastName() : "U";
            String initials = firstName.charAt(0) + "" + lastName.charAt(0);
            out.print(initials);
        %>">
            <% if (patient != null && patient.getProfileImage() != null && !patient.getProfileImage().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}${patient.getProfileImage()}" alt="<%= user.getFirstName() %>">
            <% } else { %>
                <div class="profile-initials"><%
                    String firstNameInit = user.getFirstName() != null ? user.getFirstName() : "U";
                    String lastNameInit = user.getLastName() != null ? user.getLastName() : "U";
                    out.print(firstNameInit.charAt(0) + "" + lastNameInit.charAt(0));
                %></div>
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
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/image-loading-fix.css">
<script src="${pageContext.request.contextPath}/js/patient-sidebar.js"></script>
