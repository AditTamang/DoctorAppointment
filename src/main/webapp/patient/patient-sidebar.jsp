<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%
    // Get current user from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get current page path to highlight active menu item
    String currentPath = request.getRequestURI();
%>
<!-- Sidebar -->
<div class="sidebar">
    <div class="profile-circle">
        <div class="profile-initials">
            <%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %>
        </div>
    </div>
    <div class="patient-name">
        <%= user.getFirstName() %> <%= user.getLastName() %>
    </div>
    <div class="patient-role">
        Patient
    </div>

    <!-- Mobile menu toggle -->
    <div class="menu-toggle">
        <i class="fas fa-bars"></i>
    </div>

    <ul class="sidebar-menu">
        <li class="<%= currentPath.contains("/dashboard") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/patient/dashboard">
                <i class="fas fa-home"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="<%= currentPath.contains("/appointments") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/appointments">
                <i class="fas fa-calendar-check"></i>
                <span>My Appointments</span>
            </a>
        </li>
        <li class="<%= currentPath.contains("/doctors") || currentPath.contains("/appointment/book") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/doctors">
                <i class="fas fa-user-md"></i>
                <span>Find Doctors</span>
            </a>
        </li>
        <li class="<%= currentPath.contains("/medical-records") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/medical-records">
                <i class="fas fa-file-medical"></i>
                <span>Medical Records</span>
            </a>
        </li>
        <li class="<%= currentPath.contains("/profile") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/patient/profile">
                <i class="fas fa-user"></i>
                <span>My Profile</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>

<!-- Include sidebar JavaScript -->
<script src="${pageContext.request.contextPath}/js/patient-sidebar.js"></script>
