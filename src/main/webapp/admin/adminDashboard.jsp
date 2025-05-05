<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | HealthCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        <%@ include file="../css/adminDashboard.css" %>
    </style>
</head>
<body>
    <%
        // Check if user is logged in and is an admin
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
    %>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Dashboard</h3>
            </div>
            
            <div class="sidebar-menu">
                <ul>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/doctorDashboard">
                            <i class="fas fa-user-md"></i>
                            <span>Doctors</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/doctor-requests">
                            <i class="fas fa-user-plus"></i>
                            <span>Doctor Requests</span>
                            <%
                            // Get the count of pending doctor requests
                            com.doctorapp.service.DoctorRegistrationService doctorRegistrationService = new com.doctorapp.service.DoctorRegistrationService();
                            int pendingRequestsCount = doctorRegistrationService.getPendingRequests().size();
                            if (pendingRequestsCount > 0) {
                            %>
                            <span class="badge"><%= pendingRequestsCount %></span>
                            <% } %>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/departments">
                            <i class="fas fa-hospital"></i>
                            <span>Departments</span>
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
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h1>Admin Dashboard</h1>
                <div>
                    <span>Welcome, <%= currentUser.getFirstName() %> <%= currentUser.getLastName() %></span>
                </div>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card primary">
                    <div class="stat-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div>
                        <div class="stat-title">Total Doctors</div>
                        <div class="stat-value">${doctorCount}</div>
                    </div>
                </div>
                
                <div class="stat-card success">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div>
                        <div class="stat-title">Total Patients</div>
                        <div class="stat-value">${patientCount}</div>
                    </div>
                </div>
                
                <div class="stat-card warning">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-plus"></i>
                    </div>
                    <div>
                        <div class="stat-title">New Bookings</div>
                        <div class="stat-value">${newBookingCount}</div>
                    </div>
                </div>
                
                <div class="stat-card danger">
                    <div class="stat-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div>
                        <div class="stat-title">Today's Sessions</div>
                        <div class="stat-value">${todaySessionCount}</div>
                    </div>
                </div>
            </div>
            
            <!-- Upcoming Appointments -->
            <div class="card">
                <div class="card-header">
                    <h5>Upcoming Appointments</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Doctor</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="appointment" items="${upcomingAppointments}">
                                    <tr>
                                        <td>${appointment.patientName}</td>
                                        <td>${appointment.doctorName}</td>
                                        <td>${appointment.appointmentDate}</td>
                                        <td>${appointment.appointmentTime}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appointment.status == 'CONFIRMED'}">
                                                    <span class="status-badge active">Confirmed</span>
                                                </c:when>
                                                <c:when test="${appointment.status == 'PENDING'}">
                                                    <span class="status-badge pending">Pending</span>
                                                </c:when>
                                                <c:when test="${appointment.status == 'CANCELLED'}">
                                                    <span class="status-badge inactive">Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${appointment.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty upcomingAppointments}">
                                    <tr>
                                        <td colspan="5" class="text-center">No upcoming appointments</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Top Doctors -->
            <div class="card">
                <div class="card-header">
                    <h5>Top Doctors</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Doctor Name</th>
                                    <th>Email</th>
                                    <th>Specialties</th>
                                    <th>Events</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doctor" items="${topDoctors}">
                                    <tr>
                                        <td>${doctor.name}</td>
                                        <td>${doctor.email}</td>
                                        <td>${doctor.specialization}</td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/doctor/edit?id=${doctor.id}" class="btn-icon btn-edit"><i class="fas fa-edit"></i></a>
                                                <a href="${pageContext.request.contextPath}/admin/doctor/view?id=${doctor.id}" class="btn-icon btn-view"><i class="fas fa-eye"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty topDoctors}">
                                    <tr>
                                        <td colspan="4" class="text-center">No doctors found</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Recent Patient Appointments -->
            <div class="card">
                <div class="card-header">
                    <h5>Recent Patient Appointments</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Doctor</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="appointment" items="${recentAppointments}">
                                    <tr>
                                        <td>${appointment.patientName}</td>
                                        <td>${appointment.doctorName}</td>
                                        <td>${appointment.appointmentDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appointment.status == 'CONFIRMED'}">
                                                    <span class="status-badge active">Confirmed</span>
                                                </c:when>
                                                <c:when test="${appointment.status == 'PENDING'}">
                                                    <span class="status-badge pending">Pending</span>
                                                </c:when>
                                                <c:when test="${appointment.status == 'CANCELLED'}">
                                                    <span class="status-badge inactive">Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${appointment.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentAppointments}">
                                    <tr>
                                        <td colspan="4" class="text-center">No recent appointments</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
