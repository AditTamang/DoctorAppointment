<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.AppointmentDAO" %>

<%
    // Get current user from session
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"DOCTOR".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get pending appointment count
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    int pendingAppointments = appointmentDAO.getPendingAppointmentCountByDoctorId(currentUser.getId());

    // Get current page for highlighting active menu item
    String currentPage = request.getParameter("currentPage");
    if (currentPage == null) {
        currentPage = "dashboard";
    }
%>

<div class="sidebar">
    <div class="sidebar-header">
        <h3>Doctor Dashboard</h3>
    </div>

    <div class="sidebar-menu">
        <ul>
            <li class="<%= "dashboard".equals(currentPage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/dashboard">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="<%= "appointments".equals(currentPage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/appointments">
                    <i class="fas fa-calendar-check"></i>
                    <span>Appointments</span>
                    <% if (pendingAppointments > 0) { %>
                    <span class="badge"><%= pendingAppointments %></span>
                    <% } %>
                </a>
            </li>
            <li class="<%= "schedule".equals(currentPage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/schedule">
                    <i class="fas fa-clock"></i>
                    <span>My Schedule</span>
                </a>
            </li>
            <li class="<%= "patients".equals(currentPage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/patients">
                    <i class="fas fa-user-injured"></i>
                    <span>My Patients</span>
                </a>
            </li>
            <li class="<%= "profile".equals(currentPage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/profile-legacy">
                    <i class="fas fa-user-md"></i>
                    <span>My Profile</span>
                </a>
            </li>
            <li class="<%= "messages".equals(currentPage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/doctor/messages">
                    <i class="fas fa-envelope"></i>
                    <span>Messages</span>
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
</div>
