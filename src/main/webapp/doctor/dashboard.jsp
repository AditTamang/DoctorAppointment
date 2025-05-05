<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.DoctorSchedule" %>
<%@ page import="com.doctorapp.dao.DoctorScheduleDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor information from session or request attribute
    Doctor doctor = (Doctor) request.getAttribute("doctor");

    // Get dashboard data with null checks
    Integer totalPatientsObj = (Integer) request.getAttribute("totalPatients");
    Integer weeklyAppointmentsObj = (Integer) request.getAttribute("weeklyAppointments");
    Integer pendingAppointmentsObj = (Integer) request.getAttribute("pendingAppointments");
    Double averageRatingObj = (Double) request.getAttribute("averageRating");
    Integer todayAppointmentsObj = (Integer) request.getAttribute("todayAppointments");

    // Set default values if null
    int totalPatients = (totalPatientsObj != null) ? totalPatientsObj : 0;
    int weeklyAppointments = (weeklyAppointmentsObj != null) ? weeklyAppointmentsObj : 0;
    int pendingAppointments = (pendingAppointmentsObj != null) ? pendingAppointmentsObj : 0;
    double averageRating = (averageRatingObj != null) ? averageRatingObj : 0.0;
    int todayAppointments = (todayAppointmentsObj != null) ? todayAppointmentsObj : 0;

    // Get doctor's schedules
    DoctorScheduleDAO scheduleDAO = new DoctorScheduleDAO();
    List<DoctorSchedule> schedules = null;
    if (doctor != null) {
        schedules = scheduleDAO.getSchedulesByDoctorId(doctor.getId());
    }

    // Get recent appointments
    List<Appointment> recentAppointments = (List<Appointment>) request.getAttribute("recentAppointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - HealthPro Portal</title>

    <!-- Favicon -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" type="image/x-icon">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard-complete.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="HealthPro Logo">
                <h2>HealthPro Portal</h2>
                <button id="sidebar-toggle" class="sidebar-toggle">
                    <i class="fas fa-bars"></i>
                </button>
            </div>

            <div class="profile-overview">
                <h3><i class="fas fa-user-md"></i> <span>Doctor Dashboard</span></h3>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/doctor/dashboard">
                            <i class="fas fa-home"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/profile-legacy">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/appointments">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/patients">
                            <i class="fas fa-user-injured"></i>
                            <span>Patients</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/schedule">
                            <i class="fas fa-clock"></i>
                            <span>Availability</span>
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

        <!-- Main Content -->
        <div class="main-content" id="main-content">
            <!-- Top Header -->
            <header class="top-header">
                <div class="header-nav">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="active">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments">Appointments</a>
                    <a href="${pageContext.request.contextPath}/doctor/patients">Patients</a>
                </div>

                <div class="header-actions">
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" class="search-input" placeholder="Search...">
                    </div>

                    <div class="user-profile">
                        <img src="${(doctor != null && doctor.profileImage != null) ? doctor.profileImage : pageContext.request.contextPath.concat('/assets/images/default-doctor.png')}" alt="Doctor Profile">
                        <div class="user-info">
                            <span class="user-name">Dr. ${(user != null) ? user.firstName : ''} ${(user != null) ? user.lastName : ''}</span>
                            <span class="user-role">${(doctor != null) ? doctor.specialization : 'Specialist'}</span>
                        </div>
                        <i class="fas fa-chevron-down dropdown-icon"></i>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Welcome Section -->
                <div class="welcome-section">
                    <div class="welcome-header">
                        <div class="welcome-title">
                            <h2>Welcome, Dr. ${(user != null) ? user.firstName : ''} ${(user != null) ? user.lastName : ''}</h2>
                            <p>Here's what's happening with your practice today.</p>
                        </div>
                        <div class="welcome-actions">
                            <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-primary">
                                <i class="fas fa-clock"></i> Set Availability
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/dashboard-fix" class="btn btn-primary" style="margin-left: 10px;">
                                <i class="fas fa-th-large"></i> New Dashboard
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-icon primary">
                            <i class="fas fa-calendar-day"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value"><%= todayAppointments %></div>
                            <div class="stat-label">Today's Appointments</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon success">
                            <i class="fas fa-calendar-week"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value"><%= weeklyAppointments %></div>
                            <div class="stat-label">This Week's Total</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon warning">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value"><%= totalPatients %></div>
                            <div class="stat-label">Total Patients</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon info">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value"><%= String.format("%.1f", averageRating) %></div>
                            <div class="stat-label">Average Rating</div>
                        </div>
                    </div>
                </div>

                <!-- Appointment Requests -->
                <div class="content-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-plus"></i> Pending Appointment Requests
                        </h3>
                        <div class="card-actions">
                            <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-outline">
                                <i class="fas fa-eye"></i> View All
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Patient Name</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (recentAppointments != null && !recentAppointments.isEmpty()) {
                                        for (Appointment appointment : recentAppointments) {
                                            if ("PENDING".equals(appointment.getStatus())) {
                                    %>
                                    <tr>
                                        <td><%= appointment.getPatientName() %></td>
                                        <td><%= appointment.getAppointmentDate() %></td>
                                        <td><%= appointment.getAppointmentTime() %></td>
                                        <td><%= appointment.getAppointmentType() %></td>
                                        <td><span class="status-badge pending">Pending</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="action-btn approve-btn" onclick="approveAppointment(<%= appointment.getId() %>)"><i class="fas fa-check"></i> Approve</button>
                                                <button class="action-btn reject-btn" onclick="rejectAppointment(<%= appointment.getId() %>)"><i class="fas fa-times"></i> Reject</button>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center">No pending appointment requests</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Availability Section -->
                <div class="availability-container">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-clock"></i> Your Current Availability
                        </h3>
                        <div class="card-actions">
                            <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Manage Schedule
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <% if (schedules != null && !schedules.isEmpty()) { %>
                            <div class="table-container">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Day</th>
                                            <th>Start Time</th>
                                            <th>End Time</th>
                                            <th>Break Time</th>
                                            <th>Max Appointments</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (DoctorSchedule schedule : schedules) { %>
                                            <tr>
                                                <td><%= schedule.getDayOfWeek() %></td>
                                                <td><%= schedule.getStartTime() %></td>
                                                <td><%= schedule.getEndTime() %></td>
                                                <td>
                                                    <% if (schedule.getBreakStartTime() != null && schedule.getBreakEndTime() != null) { %>
                                                        <%= schedule.getBreakStartTime() %> - <%= schedule.getBreakEndTime() %>
                                                    <% } else { %>
                                                        No break
                                                    <% } %>
                                                </td>
                                                <td><%= schedule.getMaxAppointments() %></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="empty-state">
                                <p>You haven't set your availability yet.</p>
                                <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Set Availability
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Set context path for JavaScript
        const contextPath = '${pageContext.request.contextPath}';

        // Toggle sidebar
        document.getElementById('sidebar-toggle').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('sidebar-collapsed');
            document.getElementById('main-content').classList.toggle('main-content-expanded');
        });

        // Approve appointment function
        function approveAppointment(appointmentId) {
            if (confirm('Are you sure you want to approve this appointment?')) {
                // Create form data
                const formData = new FormData();
                formData.append('appointmentId', appointmentId);
                formData.append('status', 'APPROVED');

                // Send AJAX request
                fetch(contextPath + '/doctor/appointment/update-status', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        alert('Appointment approved successfully!');
                        window.location.reload();
                    } else {
                        alert('Failed to approve appointment. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred. Please try again.');
                });
            }
        }

        // Reject appointment function
        function rejectAppointment(appointmentId) {
            const reason = prompt('Please provide a reason for rejecting this appointment:', '');
            if (reason !== null) {
                // Create form data
                const formData = new FormData();
                formData.append('appointmentId', appointmentId);
                formData.append('status', 'REJECTED');
                formData.append('notes', reason);

                // Send AJAX request
                fetch(contextPath + '/doctor/appointment/update-status', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        alert('Appointment rejected successfully!');
                        window.location.reload();
                    } else {
                        alert('Failed to reject appointment. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred. Please try again.');
                });
            }
        }
    </script>
</body>
</html>
