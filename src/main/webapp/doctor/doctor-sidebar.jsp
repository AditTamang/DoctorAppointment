<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%
    // Get current user from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
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
    <div class="sidebar-header">
        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="MedDoc">
        <h2>HealthPro Portal</h2>
    </div>

    <div class="user-profile">
        <div class="profile-image">
            <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                <div class="profile-initials">AT</div>
            <% } else { %>
                <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
            <% } %>
        </div>
        <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
        <p class="user-email"><%= user.getEmail() %></p>
        <p class="user-phone"><%= user.getPhone() %></p>
    </div>

    <div class="sidebar-menu">
        <ul>
            <li class="<%= activePage.equals("dashboard") || activePage.equals("index") || activePage.isEmpty() ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/dashboard">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="<%= activePage.equals("profile") || activePage.equals("edit-profile") ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/profile">
                    <i class="fas fa-user"></i>
                    <span>Profile</span>
                </a>
            </li>
            <li class="<%= activePage.equals("appointments") || activePage.equals("appointment-management") || activePage.equals("appointment-details") || activePage.equals("edit-appointment") ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/appointments">
                    <i class="fas fa-calendar-check"></i>
                    <span>Appointment Management</span>
                </a>
            </li>
            <li class="<%= activePage.equals("patients") ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/patients">
                    <i class="fas fa-user-injured"></i>
                    <span>Patient Details</span>
                </a>
            </li>
            <li class="<%= activePage.equals("availability") ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/availability">
                    <i class="fas fa-clock"></i>
                    <span>Set Availability</span>
                </a>
            </li>
            <li class="<%= activePage.equals("health-packages") ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/health-packages">
                    <i class="fas fa-box-open"></i>
                    <span>Health Packages</span>
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
</div>
