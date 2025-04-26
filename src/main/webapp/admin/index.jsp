<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is an admin
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Doctor Appointment System</title>
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
                    <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                        <div class="profile-initials">AT</div>
                    <% } else { %>
                        <img src="${pageContext.request.contextPath}/assets/images/admin/default.jpg" alt="Admin">
                    <% } %>
                    <h2>Health<span>Care</span></h2>
                </div>
                <div class="sidebar-close" id="sidebarClose">
                    <i class="fas fa-times"></i>
                </div>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/dashboard">
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
                    <div class="logout-nav">
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>Dashboard</h1>
                    <p>Welcome to the admin dashboard</p>
                </div>

                <!-- Date Display -->
                <div class="date-container">
                    <div class="date-display">
                        Today's Date: <span class="today-date"></span>
                    </div>
                </div>

                <!-- Status Section -->
                <div class="status-section">
                    <h2>Status</h2>
                    <div class="status-cards">
                        <div class="status-card">
                            <div class="status-number">
                                <%
                                Integer approvedDoctors = (Integer)request.getAttribute("approvedDoctors");
                                if (approvedDoctors != null) {
                                    out.print(approvedDoctors);
                                } else {
                                    out.print("0");
                                }
                                %>
                            </div>
                            <div class="status-label">Doctors</div>
                            <div class="status-icon"><i class="fas fa-user-md"></i></div>
                        </div>

                        <div class="status-card">
                            <div class="status-number">
                                <%
                                Integer totalPatients = (Integer)request.getAttribute("totalPatients");
                                if (totalPatients != null) {
                                    out.print(totalPatients);
                                } else {
                                    out.print("0");
                                }
                                %>
                            </div>
                            <div class="status-label">Patients</div>
                            <div class="status-icon"><i class="fas fa-users"></i></div>
                        </div>

                        <div class="status-card">
                            <div class="status-number">
                                <%
                                Integer newBookings = (Integer)request.getAttribute("newBookings");
                                if (newBookings != null) {
                                    out.print(newBookings);
                                } else {
                                    out.print("0");
                                }
                                %>
                            </div>
                            <div class="status-label">NewBooking</div>
                            <div class="status-icon"><i class="fas fa-calendar-plus"></i></div>
                        </div>

                        <div class="status-card">
                            <div class="status-number">
                                <%
                                Integer todayAppointments = (Integer)request.getAttribute("todayAppointments");
                                if (todayAppointments != null) {
                                    out.print(todayAppointments);
                                } else {
                                    out.print("0");
                                }
                                %>
                            </div>
                            <div class="status-label">Today Sessions</div>
                            <div class="status-icon"><i class="fas fa-calendar-check"></i></div>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Appointments Section -->
                <div class="upcoming-section">
                    <div class="upcoming-appointments">
                        <h2>Upcoming Appointments until Next Friday</h2>
                        <p>Here's Quick access to Upcoming Appointments until 7 days<br>
                        More details available in @Appointment section.</p>

                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Appointment number</th>
                                    <th>Patient name</th>
                                    <th>Doctor</th>
                                    <th>Session</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                java.util.List<com.doctorapp.model.Appointment> upcomingAppointments =
                                    (java.util.List<com.doctorapp.model.Appointment>)request.getAttribute("upcomingAppointments");
                                if(upcomingAppointments != null && !upcomingAppointments.isEmpty()) {
                                    for(com.doctorapp.model.Appointment appointment : upcomingAppointments) {
                                %>
                                <tr>
                                    <td><%= appointment.getId() %></td>
                                    <td><%= appointment.getPatientName() %></td>
                                    <td><%= appointment.getDoctorName() %></td>
                                    <td><%= appointment.getAppointmentDate() %> <%= appointment.getAppointmentTime() %></td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="4">No upcoming appointments found</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <div class="show-all-btn">
                            <a href="${pageContext.request.contextPath}/admin/appointments" class="btn">Show all Appointments</a>
                        </div>
                    </div>

                    <div class="upcoming-sessions">
                        <h2>Upcoming Sessions until Next Friday</h2>
                        <p>Here's Quick access to Upcoming Sessions that Scheduled until 7 days<br>
                        Add/Remove and Many features available in @Schedule section.</p>

                        <table class="session-table">
                            <thead>
                                <tr>
                                    <th>Session Title</th>
                                    <th>Doctor</th>
                                    <th>Scheduled Date & Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                java.util.List<com.doctorapp.model.Appointment> upcomingSessions =
                                    (java.util.List<com.doctorapp.model.Appointment>)request.getAttribute("upcomingSessions");
                                if(upcomingSessions != null && !upcomingSessions.isEmpty()) {
                                    for(com.doctorapp.model.Appointment sessionItem : upcomingSessions) {
                                %>
                                <tr>
                                    <td>Appointment #<%= sessionItem.getId() %></td>
                                    <td><%= sessionItem.getDoctorName() %></td>
                                    <td><%= sessionItem.getAppointmentDate() %> <%= sessionItem.getAppointmentTime() %></td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="3">No upcoming sessions found</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <div class="show-all-btn">
                            <a href="${pageContext.request.contextPath}/admin/appointments" class="btn">Show all Sessions</a>
                        </div>
                    </div>
                </div>

                <!-- Recent Doctors and Patients -->
                <div class="tables-container">
                    <div class="table-card">
                        <div class="table-header">
                            <h3>Recent Doctors</h3>
                            <a href="${pageContext.request.contextPath}/admin/doctorDashboard" class="view-all">View All</a>
                        </div>
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Doctor</th>
                                        <th>Specialization</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    java.util.List<com.doctorapp.model.Doctor> topDoctors =
                                        (java.util.List<com.doctorapp.model.Doctor>)request.getAttribute("topDoctors");
                                    if(topDoctors != null && !topDoctors.isEmpty()) {
                                        for(com.doctorapp.model.Doctor doctor : topDoctors) {
                                    %>
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <% if(doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty()) { %>
                                                    <img src="${pageContext.request.contextPath}/<%=doctor.getProfileImage()%>" alt="Doctor">
                                                <% } else { %>
                                                    <img src="${pageContext.request.contextPath}/images/doctors/default.jpg" alt="Doctor">
                                                <% } %>
                                                <div>
                                                    <h4><%= doctor.getName() %></h4>
                                                    <p>ID: DOC-<%= doctor.getId() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%= doctor.getSpecialization() %></td>
                                        <td><span class="status-badge active">Active</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/view-doctor?id=<%= doctor.getId() %>" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                                <a href="${pageContext.request.contextPath}/admin/edit-doctor?id=<%= doctor.getId() %>" class="btn-icon edit"><i class="fas fa-edit"></i></a>
                                                <a href="#" class="btn-icon delete" onclick="confirmDelete(<%= doctor.getId() %>)"><i class="fas fa-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="4">No doctors found</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="table-card">
                        <div class="table-header">
                            <h3>Recent Patients</h3>
                            <a href="${pageContext.request.contextPath}/admin/patients" class="view-all">View All</a>
                        </div>
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Patient</th>
                                        <th>Last Visit</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    java.util.List<com.doctorapp.model.Appointment> recentAppointments =
                                        (java.util.List<com.doctorapp.model.Appointment>)request.getAttribute("recentAppointments");
                                    if(recentAppointments != null && !recentAppointments.isEmpty()) {
                                        for(com.doctorapp.model.Appointment appointment : recentAppointments) {
                                    %>
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <img src="${pageContext.request.contextPath}/images/patients/default.jpg" alt="Patient">
                                                <div>
                                                    <h4><%= appointment.getPatientName() %></h4>
                                                    <p>ID: PAT-<%= appointment.getPatientId() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%= appointment.getAppointmentDate() %></td>
                                        <td><span class="status-badge active">Active</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/view-patient?id=<%= appointment.getPatientId() %>" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                                <a href="${pageContext.request.contextPath}/admin/edit-patient?id=<%= appointment.getPatientId() %>" class="btn-icon edit"><i class="fas fa-edit"></i></a>
                                                <a href="#" class="btn-icon delete" onclick="confirmDeletePatient(<%= appointment.getPatientId() %>)"><i class="fas fa-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="4">No patients found</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
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

        // Get today's date and display it
        function formatDate(date) {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        }

        // Add today's date to the page if there's a date element
        const todayDate = new Date();
        const dateElements = document.querySelectorAll('.today-date');
        if (dateElements.length > 0) {
            dateElements.forEach(element => {
                element.textContent = formatDate(todayDate);
            });
        }

        // Confirm delete for doctor
        function confirmDelete(doctorId) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/delete-doctor?id=' + doctorId;
            }
        }

        // Confirm delete for patient
        function confirmDeletePatient(patientId) {
            if (confirm('Are you sure you want to delete this patient?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/delete-patient?id=' + patientId;
            }
        }
    </script>
</body>
</html>
