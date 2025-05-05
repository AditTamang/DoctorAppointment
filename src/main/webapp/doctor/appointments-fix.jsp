<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

    // Format date
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Appointment Management | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard-fix-new.css">
    <style>
        /* Additional styles for appointment management page */
        .stats-container {
            margin-bottom: 30px;
        }

        .appointment-management {
            margin-bottom: 30px;
        }

        .appointment-filter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding: 0 20px;
        }

        .filter-group {
            display: flex;
            gap: 10px;
        }

        .filter-select {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            color: #555;
        }

        .search-box {
            position: relative;
        }

        .search-box input {
            padding: 8px 15px 8px 40px;
            border: 1px solid #ddd;
            border-radius: 20px;
            width: 250px;
            font-size: 14px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #888;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }

        .empty-state h4 {
            margin: 0 0 10px;
            font-size: 18px;
            color: #333;
        }

        .empty-state p {
            margin: 0;
            color: #666;
            font-size: 14px;
        }

        .status-badge.approved {
            background-color: #e8f5e9;
            color: #4caf50;
        }

        .status-badge.rejected {
            background-color: #ffebee;
            color: #f44336;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 4px;
            background-color: #4caf50;
            color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            opacity: 0;
            transform: translateY(-20px);
            transition: all 0.3s ease;
        }

        .notification.show {
            opacity: 1;
            transform: translateY(0);
        }

        .notification.success {
            background-color: #4caf50;
        }

        .notification.error {
            background-color: #f44336;
        }
    </style>
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
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/dashboard-fix">
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
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/doctor/appointments-fix">
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
                    <a href="${pageContext.request.contextPath}/doctor/dashboard-fix">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments-fix" class="active">Appointment Management</a>
                    <a href="${pageContext.request.contextPath}/doctor/patients">Patient Details</a>
                </div>
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Search...">
                </div>
            </div>

            <!-- Stats Section -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-value"><%= pendingAppointments != null ? pendingAppointments.size() : 0 %></div>
                    <div class="stat-label">Pending Appointments</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-value"><%= approvedAppointments != null ? approvedAppointments.size() : 0 %></div>
                    <div class="stat-label">Approved Appointments</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="fas fa-clipboard-check"></i>
                    </div>
                    <div class="stat-value"><%= completedAppointments != null ? completedAppointments.size() : 0 %></div>
                    <div class="stat-label">Completed Appointments</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-value"><%= rejectedAppointments != null ? rejectedAppointments.size() : 0 %></div>
                    <div class="stat-label">Rejected Appointments</div>
                </div>
            </div>

            <!-- Appointment Management Section -->
            <div class="appointment-management">
                <div class="appointment-header">
                    <h3>Appointment Management</h3>
                </div>

                <div class="appointment-tabs">
                    <div class="appointment-tab active" data-tab="pending">Pending</div>
                    <div class="appointment-tab" data-tab="approved">Approved</div>
                    <div class="appointment-tab" data-tab="completed">Completed</div>
                    <div class="appointment-tab" data-tab="rejected">Rejected</div>
                </div>

                <div class="appointment-filter">
                    <div class="filter-group">
                        <select class="filter-select" id="date-filter">
                            <option value="all">All Dates</option>
                            <option value="today">Today</option>
                            <option value="tomorrow">Tomorrow</option>
                            <option value="week">This Week</option>
                            <option value="month">This Month</option>
                        </select>
                    </div>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search patient name..." id="search-input">
                    </div>
                </div>

                <div class="appointment-content">
                    <!-- Pending Appointments Tab Content -->
                    <div class="tab-content" id="pending" style="display: block;">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Appointment Date</th>
                                    <th>Appointment Time</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (pendingAppointments != null && !pendingAppointments.isEmpty()) { %>
                                    <% for (Appointment appointment : pendingAppointments) { %>
                                        <tr data-appointment-id="<%= appointment.getId() %>">
                                            <td><%= appointment.getPatientName() != null ? appointment.getPatientName() : "Patient" %></td>
                                            <td><%= appointment.getAppointmentDate() != null ? dateFormat.format(appointment.getAppointmentDate()) : "N/A" %></td>
                                            <td><%= appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "N/A" %></td>
                                            <td><%= appointment.getReason() != null ? appointment.getReason() : "General Checkup" %></td>
                                            <td class="status-cell"><span class="status-badge pending">Pending</span></td>
                                            <td class="action-cell">
                                                <div class="action-buttons">
                                                    <button class="action-btn approve-btn" data-appointment-id="<%= appointment.getId() %>">
                                                        <i class="fas fa-check"></i> Approve
                                                    </button>
                                                    <button class="action-btn reject-btn" data-appointment-id="<%= appointment.getId() %>">
                                                        <i class="fas fa-times"></i> Reject
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="6" class="empty-state">
                                            <h4>No pending appointments</h4>
                                            <p>There are no pending appointment requests at this time.</p>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Approved Appointments Tab Content -->
                    <div class="tab-content" id="approved" style="display: none;">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Appointment Date</th>
                                    <th>Appointment Time</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (approvedAppointments != null && !approvedAppointments.isEmpty()) { %>
                                    <% for (Appointment appointment : approvedAppointments) { %>
                                        <tr data-appointment-id="<%= appointment.getId() %>">
                                            <td><%= appointment.getPatientName() != null ? appointment.getPatientName() : "Patient" %></td>
                                            <td><%= appointment.getAppointmentDate() != null ? dateFormat.format(appointment.getAppointmentDate()) : "N/A" %></td>
                                            <td><%= appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "N/A" %></td>
                                            <td><%= appointment.getReason() != null ? appointment.getReason() : "General Checkup" %></td>
                                            <td class="status-cell"><span class="status-badge approved">Approved</span></td>
                                            <td class="action-cell">
                                                <div class="action-buttons">
                                                    <button class="action-btn view-btn" data-appointment-id="<%= appointment.getId() %>">
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
                                                    <button class="action-btn complete-btn" data-appointment-id="<%= appointment.getId() %>">
                                                        <i class="fas fa-check-double"></i> Complete
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="6" class="empty-state">
                                            <h4>No approved appointments</h4>
                                            <p>There are no approved appointments at this time.</p>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Completed Appointments Tab Content -->
                    <div class="tab-content" id="completed" style="display: none;">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Appointment Date</th>
                                    <th>Appointment Time</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (completedAppointments != null && !completedAppointments.isEmpty()) { %>
                                    <% for (Appointment appointment : completedAppointments) { %>
                                        <tr data-appointment-id="<%= appointment.getId() %>">
                                            <td><%= appointment.getPatientName() != null ? appointment.getPatientName() : "Patient" %></td>
                                            <td><%= appointment.getAppointmentDate() != null ? dateFormat.format(appointment.getAppointmentDate()) : "N/A" %></td>
                                            <td><%= appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "N/A" %></td>
                                            <td><%= appointment.getReason() != null ? appointment.getReason() : "General Checkup" %></td>
                                            <td class="status-cell"><span class="status-badge completed">Completed</span></td>
                                            <td class="action-cell">
                                                <div class="action-buttons">
                                                    <button class="action-btn view-btn" data-appointment-id="<%= appointment.getId() %>">
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="6" class="empty-state">
                                            <h4>No completed appointments</h4>
                                            <p>There are no completed appointments at this time.</p>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Rejected Appointments Tab Content -->
                    <div class="tab-content" id="rejected" style="display: none;">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Appointment Date</th>
                                    <th>Appointment Time</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (rejectedAppointments != null && !rejectedAppointments.isEmpty()) { %>
                                    <% for (Appointment appointment : rejectedAppointments) { %>
                                        <tr data-appointment-id="<%= appointment.getId() %>">
                                            <td><%= appointment.getPatientName() != null ? appointment.getPatientName() : "Patient" %></td>
                                            <td><%= appointment.getAppointmentDate() != null ? dateFormat.format(appointment.getAppointmentDate()) : "N/A" %></td>
                                            <td><%= appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "N/A" %></td>
                                            <td><%= appointment.getReason() != null ? appointment.getReason() : "General Checkup" %></td>
                                            <td class="status-cell"><span class="status-badge rejected">Rejected</span></td>
                                            <td class="action-cell">
                                                <div class="action-buttons">
                                                    <button class="action-btn view-btn" data-appointment-id="<%= appointment.getId() %>">
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="6" class="empty-state">
                                            <h4>No rejected appointments</h4>
                                            <p>There are no rejected appointments at this time.</p>
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

    <!-- Notification Container -->
    <div id="notification-container"></div>

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/doctor-dashboard-fix.js"></script>
</body>
</html>
