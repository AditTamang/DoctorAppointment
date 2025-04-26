<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Doctors | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Include CSS files using JSP include directive -->
    <style>
        <%@ include file="../css/common.css" %>
        <%@ include file="../css/adminDashboard.css" %>
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <img src="../images/logo.png" alt="HealthCare Logo">
                    <h2>Health<span>Care</span></h2>
                </div>
                <div class="sidebar-close" id="sidebarClose">
                    <i class="fas fa-times"></i>
                </div>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="active">
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
                            <span class="badge badge-primary"><%= pendingRequestsCount %></span>
                            <% } %>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/patients">
                            <i class="fas fa-users"></i>
                            <span>Patients</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/appointments">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/specializations">
                            <i class="fas fa-stethoscope"></i>
                            <span>Specializations</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fas fa-chart-bar"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
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
        <div class="dashboard-main">
            <!-- Top Navigation -->
            <div class="dashboard-nav">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </div>

                <div class="nav-right">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" placeholder="Search Doctor name or Email" value="${param.search}">
                    </div>
                    <button type="submit" class="search-button">Search</button>

                    <div class="nav-user">
                        <img src="../images/admin-avatar.jpg" alt="Admin">
                        <div class="user-info">
                            <h4>Administrator</h4>
                            <p>admin@edoc.com</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>Add New Doctor</h1>
                </div>

                <div class="content-header">
                    <div>
                        <h2>All Doctors</h2>
                        <%
                        List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                        int doctorCount = (doctors != null) ? doctors.size() : 0;
                        %>
                        <p>(<%= doctorCount %>)</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/doctor/add" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New
                    </a>
                </div>

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
                            <%
                            if (doctors != null && !doctors.isEmpty()) {
                                for (Doctor doctor : doctors) {
                            %>
                            <tr>
                                <td><%= doctor.getName() %></td>
                                <td><%= doctor.getEmail() %></td>
                                <td><%= doctor.getSpecialization() %></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/admin/doctor/edit?id=<%= doctor.getId() %>" class="btn-icon btn-edit"><i class="fas fa-edit"></i></a>
                                        <a href="${pageContext.request.contextPath}/admin/doctor/view?id=<%= doctor.getId() %>" class="btn-icon btn-view"><i class="fas fa-eye"></i></a>
                                        <a href="#" onclick="confirmDelete(<%= doctor.getId() %>)" class="btn-icon btn-remove"><i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center">No doctors found. Please add a doctor using the "Add New" button.</td>
                            </tr>
                            <%
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Footer -->
            <div class="dashboard-footer">
                <p>&copy; 2023 HealthCare. All Rights Reserved.</p>
                <p>Version 1.0.0</p>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.dashboard-sidebar').classList.toggle('active');
        });

        document.getElementById('sidebarClose').addEventListener('click', function() {
            document.querySelector('.dashboard-sidebar').classList.remove('active');
        });

        function confirmDelete(doctorId) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/doctor/delete?id=' + doctorId;
            }
        }
    </script>
</body>
</html>
