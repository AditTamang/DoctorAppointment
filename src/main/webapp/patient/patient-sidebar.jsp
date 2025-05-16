<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
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
    <div class="user-profile">
        <div class="profile-image">
            <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                <div class="profile-initials">AT</div>
            <% } else { %>
                <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
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
        <li class="<%= activePage.equals("changePassword.jsp") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/patient/changePassword.jsp">
                <i class="fas fa-lock"></i>
                <span>Change Password</span>
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

<!-- Include sidebar JavaScript -->
<script src="${pageContext.request.contextPath}/js/patient-sidebar.js"></script>
