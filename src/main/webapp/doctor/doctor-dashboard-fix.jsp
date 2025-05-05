<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor data from session or request attribute
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        doctor = (Doctor) request.getAttribute("doctor");
    }

    // Get appointment data
    List<Appointment> pendingAppointments = (List<Appointment>) request.getAttribute("pendingAppointments");
    List<Appointment> approvedAppointments = (List<Appointment>) request.getAttribute("approvedAppointments");
    List<Appointment> completedAppointments = (List<Appointment>) request.getAttribute("completedAppointments");
    List<Appointment> rejectedAppointments = (List<Appointment>) request.getAttribute("rejectedAppointments");

    // Get recent patients
    List<Patient> recentPatients = (List<Patient>) request.getAttribute("recentPatients");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Doctor Dashboard | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard-fix-new.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h2>HealthPro Portal</h2>
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
                        <a href="${pageContext.request.contextPath}/doctor/appointments-fix" id="appointment-management-link">
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
                        <a href="${pageContext.request.contextPath}/doctor/schedule">
                            <i class="fas fa-clock"></i>
                            <span>Set Availability</span>
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
            <div class="top-header">
                <div class="header-nav">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard-fix" class="active">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments-fix">Appointment Management</a>
                    <a href="${pageContext.request.contextPath}/doctor/patients">Patient Details</a>
                </div>
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Search...">
                </div>
            </div>

            <!-- Doctor Profile Section -->
            <div class="doctor-profile">
                <div class="doctor-profile-header">
                    <h3>Doctor Profile</h3>
                    <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-outline">
                        <i class="fas fa-edit"></i> Edit Profile
                    </a>
                </div>
                <div class="doctor-profile-content">
                    <div class="doctor-info">
                        <div class="doctor-avatar">
                            <img src="${pageContext.request.contextPath}/assets/images/default-doctor.png" alt="Doctor Avatar">
                        </div>
                        <div class="doctor-details">
                            <h2>Dr. Orson Ferrell</h2>
                            <p><i class="fas fa-stethoscope"></i> Ophthalmology</p>
                            <p><i class="fas fa-hospital"></i> Riverside Clinic</p>
                            <p><i class="fas fa-phone"></i> +1 (201) 201-5465</p>
                        </div>
                    </div>
                    <div class="doctor-actions">
                        <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-outline">
                            <i class="fas fa-clock"></i> Set Active Off
                        </a>
                        <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-outline">
                            <i class="fas fa-trash"></i> Delete Profile
                        </a>
                    </div>
                </div>
            </div>

            <!-- Appointment Management Section -->
            <div class="appointment-management">
                <div class="appointment-header">
                    <h3>Appointment Management</h3>
                </div>
                <div class="appointment-tabs">
                    <div class="appointment-tab active" data-tab="upcoming">Upcoming</div>
                    <div class="appointment-tab" data-tab="past">Past</div>
                    <div class="appointment-tab" data-tab="pending">Pending</div>
                </div>
                <div class="appointment-content">
                    <!-- Upcoming Appointments Tab Content -->
                    <div class="tab-content" id="upcoming" style="display: block;">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Age/Gender</th>
                                    <th>Last Visit</th>
                                    <th>Contact</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr data-appointment-id="1">
                                    <td>John Doe</td>
                                    <td>42, Male</td>
                                    <td>2023-10-05</td>
                                    <td>+1 (123) 456-7890</td>
                                    <td class="action-cell">
                                        <div class="action-buttons">
                                            <button class="action-btn view-btn" data-appointment-id="1">
                                                <i class="fas fa-eye"></i> View
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr data-appointment-id="2">
                                    <td>Jane Smith</td>
                                    <td>35, Female</td>
                                    <td>2023-10-07</td>
                                    <td>+1 (234) 567-8901</td>
                                    <td class="action-cell">
                                        <div class="action-buttons">
                                            <button class="action-btn view-btn" data-appointment-id="2">
                                                <i class="fas fa-eye"></i> View
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Past Appointments Tab Content -->
                    <div class="tab-content" id="past" style="display: none;">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Age/Gender</th>
                                    <th>Visit Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr data-appointment-id="3">
                                    <td>Robert Johnson</td>
                                    <td>50, Male</td>
                                    <td>2023-09-15</td>
                                    <td class="status-cell"><span class="status-badge completed">Completed</span></td>
                                    <td class="action-cell">
                                        <div class="action-buttons">
                                            <button class="action-btn view-btn" data-appointment-id="3">
                                                <i class="fas fa-eye"></i> View
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr data-appointment-id="4">
                                    <td>Emily Davis</td>
                                    <td>28, Female</td>
                                    <td>2023-09-20</td>
                                    <td class="status-cell"><span class="status-badge completed">Completed</span></td>
                                    <td class="action-cell">
                                        <div class="action-buttons">
                                            <button class="action-btn view-btn" data-appointment-id="4">
                                                <i class="fas fa-eye"></i> View
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pending Appointments Tab Content -->
                    <div class="tab-content" id="pending" style="display: none;">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Age/Gender</th>
                                    <th>Requested Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr data-appointment-id="5">
                                    <td>Michael Brown</td>
                                    <td>45, Male</td>
                                    <td>2023-10-15</td>
                                    <td class="status-cell"><span class="status-badge pending">Pending</span></td>
                                    <td class="action-cell">
                                        <div class="action-buttons">
                                            <button class="action-btn approve-btn" data-appointment-id="5">
                                                <i class="fas fa-check"></i> Approve
                                            </button>
                                            <button class="action-btn reject-btn" data-appointment-id="5">
                                                <i class="fas fa-times"></i> Reject
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr data-appointment-id="6">
                                    <td>Sarah Wilson</td>
                                    <td>32, Female</td>
                                    <td>2023-10-18</td>
                                    <td class="status-cell"><span class="status-badge pending">Pending</span></td>
                                    <td class="action-cell">
                                        <div class="action-buttons">
                                            <button class="action-btn approve-btn" data-appointment-id="6">
                                                <i class="fas fa-check"></i> Approve
                                            </button>
                                            <button class="action-btn reject-btn" data-appointment-id="6">
                                                <i class="fas fa-times"></i> Reject
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Recent Patients Section -->
            <div class="recent-patients">
                <div class="recent-patients-header">
                    <h3>Recent Patients</h3>
                    <a href="${pageContext.request.contextPath}/doctor/patients" class="btn btn-outline">
                        <i class="fas fa-eye"></i> View All
                    </a>
                </div>
                <div class="recent-patients-content">
                    <table class="patient-table">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Age/Gender</th>
                                <th>Last Visit</th>
                                <th>Contact</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>John Doe</td>
                                <td>42, Male</td>
                                <td>2023-10-05</td>
                                <td>+1 (123) 456-7890</td>
                                <td>
                                    <button class="action-btn view-btn">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>Jane Smith</td>
                                <td>35, Female</td>
                                <td>2023-10-07</td>
                                <td>+1 (234) 567-8901</td>
                                <td>
                                    <button class="action-btn view-btn">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/doctor-dashboard-fix.js"></script>
    <script>
        // Additional initialization script
        document.addEventListener('DOMContentLoaded', function() {
            // Add click event to the appointment management link
            const appointmentManagementLink = document.getElementById('appointment-management-link');
            if (appointmentManagementLink) {
                appointmentManagementLink.addEventListener('click', function(e) {
                    e.preventDefault();
                    window.location.href = '${pageContext.request.contextPath}/doctor/appointments-fix';
                });
            }
        });
    </script>
</body>
</html>
