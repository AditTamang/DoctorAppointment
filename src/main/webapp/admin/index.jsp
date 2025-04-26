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
                        <a href="index.jsp">
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
                        <a href="patients.jsp">
                            <i class="fas fa-users"></i>
                            <span>Patients</span>
                        </a>
                    </li>
                    <li>
                        <a href="appointments.jsp">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="specializations.jsp">
                            <i class="fas fa-stethoscope"></i>
                            <span>Specializations</span>
                        </a>
                    </li>
                    <li>
                        <a href="reports.jsp">
                            <i class="fas fa-chart-bar"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                    <li>
                        <a href="settings.jsp">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                    <li class="logout">
                        <a href="../logout">
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
                            <div class="status-number"><%= request.getAttribute("approvedDoctors") %></div>
                            <div class="status-label">Doctors</div>
                            <div class="status-icon"><i class="fas fa-user-md"></i></div>
                        </div>

                        <div class="status-card">
                            <div class="status-number"><%= request.getAttribute("totalPatients") %></div>
                            <div class="status-label">Patients</div>
                            <div class="status-icon"><i class="fas fa-users"></i></div>
                        </div>

                        <div class="status-card">
                            <div class="status-number"><%= request.getAttribute("newBookings") %></div>
                            <div class="status-label">NewBooking</div>
                            <div class="status-icon"><i class="fas fa-calendar-plus"></i></div>
                        </div>

                        <div class="status-card">
                            <div class="status-number"><%= request.getAttribute("todayAppointments") %></div>
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
                            <a href="appointments.jsp" class="btn">Show all Appointments</a>
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
                                    for(com.doctorapp.model.Appointment session : upcomingSessions) {
                                %>
                                <tr>
                                    <td>Appointment #<%= session.getId() %></td>
                                    <td><%= session.getDoctorName() %></td>
                                    <td><%= session.getAppointmentDate() %> <%= session.getAppointmentTime() %></td>
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
                            <a href="sessions.jsp" class="btn">Show all Sessions</a>
                        </div>
                    </div>
                </div>

                <!-- Recent Doctors and Patients -->
                <div class="tables-container">
                    <div class="table-card">
                        <div class="table-header">
                            <h3>Recent Doctors</h3>
                            <a href="doctors.jsp" class="view-all">View All</a>
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
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <img src="../images/doctors/doctor1.jpg" alt="Doctor">
                                                <div>
                                                    <h4>Dr. John Smith</h4>
                                                    <p>ID: DOC-001</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>Cardiologist</td>
                                        <td><span class="status-badge active">Active</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="btn-icon edit"><i class="fas fa-edit"></i></a>
                                                <a href="#" class="btn-icon delete"><i class="fas fa-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <img src="../images/doctors/doctor2.jpg" alt="Doctor">
                                                <div>
                                                    <h4>Dr. Sarah Johnson</h4>
                                                    <p>ID: DOC-002</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>Neurologist</td>
                                        <td><span class="status-badge active">Active</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="btn-icon edit"><i class="fas fa-edit"></i></a>
                                                <a href="#" class="btn-icon delete"><i class="fas fa-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <img src="../images/doctors/doctor3.jpg" alt="Doctor">
                                                <div>
                                                    <h4>Dr. Michael Brown</h4>
                                                    <p>ID: DOC-003</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>Orthopedic</td>
                                        <td><span class="status-badge inactive">Inactive</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="btn-icon edit"><i class="fas fa-edit"></i></a>
                                                <a href="#" class="btn-icon delete"><i class="fas fa-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="table-card">
                        <div class="table-header">
                            <h3>Recent Patients</h3>
                            <a href="patients.jsp" class="view-all">View All</a>
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
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <img src="../images/patients/patient1.jpg" alt="Patient">
                                                <div>
                                                    <h4>Robert Wilson</h4>
                                                    <p>ID: PAT-001</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>15 Apr 2023</td>
                                        <td><span class="status-badge active">Active</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="btn-icon edit"><i class="fas fa-edit"></i></a>
                                                <a href="#" class="btn-icon delete"><i class="fas fa-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <img src="../images/patients/patient2.jpg" alt="Patient">
                                                <div>
                                                    <h4>Emily Parker</h4>
                                                    <p>ID: PAT-002</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>12 Apr 2023</td>
                                        <td><span class="status-badge active">Active</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="btn-icon edit"><i class="fas fa-edit"></i></a>
                                                <a href="#" class="btn-icon delete"><i class="fas fa-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="user-info">
                                                <img src="../images/patients/patient3.jpg" alt="Patient">
                                                <div>
                                                    <h4>David Thompson</h4>
                                                    <p>ID: PAT-003</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>10 Apr 2023</td>
                                        <td><span class="status-badge inactive">Inactive</span></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                                <a href="#" class="btn-icon edit"><i class="fas fa-edit"></i></a>
                                                <a href="#" class="btn-icon delete"><i class="fas fa-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
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
    </script>
</body>
</html>
