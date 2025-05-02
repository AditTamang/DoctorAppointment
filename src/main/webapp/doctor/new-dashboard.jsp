<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Get the doctor and user objects from the session
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    User user = (User) session.getAttribute("user");

    // Get dashboard data with null checks
    Integer totalPatientsObj = (Integer) request.getAttribute("totalPatients");
    Integer weeklyAppointmentsObj = (Integer) request.getAttribute("weeklyAppointments");
    Integer pendingReportsObj = (Integer) request.getAttribute("pendingReports");
    Double averageRatingObj = (Double) request.getAttribute("averageRating");
    Integer todayAppointmentsObj = (Integer) request.getAttribute("todayAppointments");

    // Set default values if null
    int totalPatients = (totalPatientsObj != null) ? totalPatientsObj : 0;
    int weeklyAppointments = (weeklyAppointmentsObj != null) ? weeklyAppointmentsObj : 0;
    int pendingReports = (pendingReportsObj != null) ? pendingReportsObj : 0;
    double averageRating = (averageRatingObj != null) ? averageRatingObj : 0.0;
    int todayAppointments = (todayAppointmentsObj != null) ? todayAppointmentsObj : 0;

    // Get lists of data
    List<Patient> recentPatients = (List<Patient>) request.getAttribute("recentPatients");
    List<Appointment> upcomingAppointments = (List<Appointment>) request.getAttribute("upcomingAppointments");

    // Format date
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy");
    String currentDate = dateFormat.format(new Date());

    // Calculate weekly appointments percentage (assuming max 50 per week) with null check
    int weeklyAppointmentsPercentage = (weeklyAppointments > 0) ? Math.min((weeklyAppointments * 100) / 50, 100) : 0;
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/healthpro-dashboard.css">
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
                <h3><i class="fas fa-user-md"></i> <span>Profile Overview</span></h3>
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
                        <a href="${pageContext.request.contextPath}/doctor/profile">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/appointments">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointment Management</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/patients">
                            <i class="fas fa-user-injured"></i>
                            <span>Patient Details</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/availability">
                            <i class="fas fa-clock"></i>
                            <span>Set Availability</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/health-packages">
                            <i class="fas fa-box-open"></i>
                            <span>Health Packages</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/preferences">
                            <i class="fas fa-cog"></i>
                            <span>UI Preferences</span>
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
        <div class="main-content">
            <!-- Top Header -->
            <header class="top-header">
                <div class="header-nav">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="active">Profile</a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments">Appointment Management</a>
                    <a href="${pageContext.request.contextPath}/doctor/patients">Patient Details</a>
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

            <!-- Content Area -->
            <div class="content-area">
                <!-- Profile Card -->
                <div class="card">
                    <div class="profile-card">
                        <img src="${(doctor != null && doctor.profileImage != null) ? doctor.profileImage : pageContext.request.contextPath.concat('/assets/images/default-doctor.png')}" alt="Doctor Profile" class="profile-image">

                        <div class="profile-details">
                            <h1 class="profile-name">Dr. ${(user != null) ? user.firstName : ''} ${(user != null) ? user.lastName : ''}</h1>
                            <p class="profile-specialty">${(doctor != null) ? doctor.specialization : 'Specialist'}</p>

                            <div class="profile-info">
                                <div class="profile-info-item">
                                    <i class="fas fa-graduation-cap"></i>
                                    <span>${(doctor != null) ? doctor.qualification : 'MBBS'}</span>
                                </div>
                                <div class="profile-info-item">
                                    <i class="fas fa-briefcase"></i>
                                    <span>${(doctor != null) ? doctor.experience : '0 years'} Experience</span>
                                </div>
                                <div class="profile-info-item">
                                    <i class="fas fa-envelope"></i>
                                    <span>${(doctor != null) ? doctor.email : (user != null ? user.getEmail() : 'doctor@example.com')}</span>
                                </div>
                                <div class="profile-info-item">
                                    <i class="fas fa-phone"></i>
                                    <span>${(doctor != null) ? doctor.phone : 'Not available'}</span>
                                </div>
                            </div>

                            <div class="profile-actions">
                                <button class="btn btn-primary">Edit Profile</button>
                                <button class="btn btn-outline">Set Active ${(doctor != null && doctor.status == 'ACTIVE') ? 'Off' : 'On'}</button>
                                <button class="btn btn-danger">Delete Profile</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Appointment Management -->
                <div class="card">
                    <div class="card-header">
                        <h2>Appointment Management</h2>
                    </div>

                    <div class="card-body">
                        <div class="tabs">
                            <div class="tab active">Upcoming</div>
                            <div class="tab">Past</div>
                            <div class="tab">Pending</div>
                        </div>

                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Appointment ID</th>
                                        <th>Patient Name</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                        <th>Assigned Doctor</th>
                                        <th>Action</th>
                                        <th>Notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(upcomingAppointments != null && !upcomingAppointments.isEmpty()) {
                                        for(Appointment appointment : upcomingAppointments) {
                                            // Safely get values with null checks
                                            String appointmentId = String.valueOf(appointment.getId());
                                            String patientName = (appointment.getPatientName() != null) ? appointment.getPatientName() : "Unknown";

                                            // Format date properly using the getFormattedDate method
                                            String appointmentDate = "Not set";
                                            if (appointment.getAppointmentDate() != null) {
                                                try {
                                                    // Use the built-in formatter from the Appointment class
                                                    String formattedDate = appointment.getFormattedDate();
                                                    if (formattedDate != null && !formattedDate.isEmpty()) {
                                                        appointmentDate = formattedDate;
                                                    }
                                                } catch (Exception e) {
                                                    // If there's an error formatting the date, use a default value
                                                    appointmentDate = "Not set";
                                                    System.err.println("Error formatting appointment date: " + e.getMessage());
                                                }
                                            }

                                            String status = (appointment.getStatus() != null) ? appointment.getStatus() : "Pending";
                                            String statusClass = (appointment.getStatus() != null) ? appointment.getStatus().toLowerCase() : "pending";
                                            String notes = (appointment.getNotes() != null) ? appointment.getNotes() : "No notes";
                                        %>
                                    <tr>
                                        <td><%= appointmentId %></td>
                                        <td><%= patientName %></td>
                                        <td><%= appointmentDate %></td>
                                        <td><span class="status <%= statusClass %>"><%= status %></span></td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/assets/images/default-doctor.png" alt="Doctor" style="width: 30px; height: 30px; border-radius: 50%;">
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                            </div>
                                        </td>
                                        <td><%= notes %></td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td>001</td>
                                        <td>John Doe</td>
                                        <td>2023-10-10</td>
                                        <td><span class="status confirmed">Confirmed</span></td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/assets/images/default-doctor.png" alt="Doctor" style="width: 30px; height: 30px; border-radius: 50%;">
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                            </div>
                                        </td>
                                        <td>Follow-up required</td>
                                    </tr>
                                    <tr>
                                        <td>002</td>
                                        <td>Jane Smith</td>
                                        <td>2023-10-11</td>
                                        <td><span class="status pending">Pending</span></td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/assets/images/default-doctor.png" alt="Doctor" style="width: 30px; height: 30px; border-radius: 50%;">
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                            </div>
                                        </td>
                                        <td>First consultation</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
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
                            <div class="stat-value">
                                <% if (todayAppointmentsObj != null) { %>
                                    <%= todayAppointments %>
                                <% } else { %>
                                    0
                                <% } %>
                            </div>
                            <div class="stat-label">Today's Appointments</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon success">
                            <i class="fas fa-calendar-week"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">
                                <% if (weeklyAppointmentsObj != null) { %>
                                    <%= weeklyAppointments %>
                                <% } else { %>
                                    0
                                <% } %>
                            </div>
                            <div class="stat-label">This Week's Total</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon warning">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">
                                <% if (totalPatientsObj != null) { %>
                                    <%= totalPatients %>
                                <% } else { %>
                                    0
                                <% } %>
                            </div>
                            <div class="stat-label">Total Patients</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon info">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-value">
                                <% if (averageRatingObj != null) { %>
                                    <%= String.format("%.1f", averageRating) %>
                                <% } else { %>
                                    0.0
                                <% } %>
                            </div>
                            <div class="stat-label">Average Rating</div>
                        </div>
                    </div>
                </div>

                <!-- Recent Patients -->
                <div class="card">
                    <div class="card-header">
                        <h2>Recent Patients</h2>
                        <a href="${pageContext.request.contextPath}/doctor/patients" class="btn btn-outline">View All</a>
                    </div>

                    <div class="card-body">
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Patient Name</th>
                                        <th>Age</th>
                                        <th>Gender</th>
                                        <th>Last Visit</th>
                                        <th>Contact</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(recentPatients != null && !recentPatients.isEmpty()) {
                                        for(Patient patient : recentPatients) {
                                            // Safely get values with null checks
                                            String firstName = (patient.getFirstName() != null) ? patient.getFirstName() : "";
                                            String lastName = (patient.getLastName() != null) ? patient.getLastName() : "";
                                            String fullName = firstName + " " + lastName;
                                            if (fullName.trim().isEmpty()) fullName = "Unknown";

                                            int age = patient.getAge();
                                            String gender = (patient.getGender() != null) ? patient.getGender() : "Not specified";
                                            String lastVisit = (patient.getLastVisit() != null) ? patient.getLastVisit() : "N/A";
                                            String phone = (patient.getPhone() != null) ? patient.getPhone() : "Not available";
                                        %>
                                    <tr>
                                        <td><%= fullName %></td>
                                        <td><%= age %></td>
                                        <td><%= gender %></td>
                                        <td><%= lastVisit %></td>
                                        <td><%= phone %></td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td>John Doe</td>
                                        <td>42</td>
                                        <td>Male</td>
                                        <td>2023-10-05</td>
                                        <td>+1 234 567 890</td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Jane Smith</td>
                                        <td>35</td>
                                        <td>Female</td>
                                        <td>2023-10-07</td>
                                        <td>+1 234 567 891</td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Set context path for JavaScript
        const contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/healthpro-dashboard.js"></script>
</body>
</html>
