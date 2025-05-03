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

    // Get doctor information
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    String doctorName = "Dr. " + user.getFirstName() + " " + user.getLastName();

    // Get appointments
    List<Appointment> pendingAppointments = (List<Appointment>) request.getAttribute("pendingAppointments");
    List<Appointment> approvedAppointments = (List<Appointment>) request.getAttribute("approvedAppointments");
    List<Appointment> completedAppointments = (List<Appointment>) request.getAttribute("completedAppointments");
    List<Appointment> rejectedAppointments = (List<Appointment>) request.getAttribute("rejectedAppointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Appointment Management | Doctor Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctorDashboard.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h2>HealthPro Portal</h2>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/dashboard">
                            Dashboard
                        </a>
                    </li>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/doctor/appointments">
                            Appointment Management
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/patients">
                            Patient Details
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor/profile">
                            My Profile
                        </a>
                    </li>
                    <li class="logout">
                        <a href="${pageContext.request.contextPath}/logout">
                            Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-left">
                    <h2>Appointment Management</h2>
                </div>
                <div class="top-header-right">
                    <div class="user-info">
                        <span><%= doctorName %></span>
                    </div>
                </div>
            </div>

            <!-- Appointment Management Section -->
            <div class="appointment-management">
                <div class="appointment-header">
                    <h3>Manage Patient Appointments</h3>
                </div>

                <div class="appointment-tabs">
                    <button class="tab-button active" data-tab="pending">
                        Pending
                        <span class="count-badge" id="pending-count"><%= pendingAppointments != null ? pendingAppointments.size() : 0 %></span>
                    </button>
                    <button class="tab-button" data-tab="approved">
                        Approved
                        <span class="count-badge" id="approved-count"><%= approvedAppointments != null ? approvedAppointments.size() : 0 %></span>
                    </button>
                    <button class="tab-button" data-tab="completed">
                        Completed
                        <span class="count-badge" id="completed-count"><%= completedAppointments != null ? completedAppointments.size() : 0 %></span>
                    </button>
                    <button class="tab-button" data-tab="rejected">
                        Rejected
                        <span class="count-badge" id="rejected-count"><%= rejectedAppointments != null ? rejectedAppointments.size() : 0 %></span>
                    </button>
                </div>

                <!-- Pending Appointments Tab -->
                <div class="tab-content" id="pending">
                    <div class="appointment-table-container">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (pendingAppointments != null && !pendingAppointments.isEmpty()) { %>
                                    <% for (Appointment appointment : pendingAppointments) { %>
                                        <tr data-appointment-id="<%= appointment.getId() %>">
                                            <td><%= appointment.getPatientName() %></td>
                                            <td><%= appointment.getAppointmentDate() %></td>
                                            <td><%= appointment.getAppointmentTime() %></td>
                                            <td class="status-cell"><span class="status-badge pending">PENDING</span></td>
                                            <td class="action-cell">
                                                <div class="action-buttons">
                                                    <button class="approve-btn" data-appointment-id="<%= appointment.getId() %>">Approve</button>
                                                    <button class="reject-btn" data-appointment-id="<%= appointment.getId() %>">Reject</button>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="5" class="empty-state">
                                            <i class="fas fa-calendar-times"></i>
                                            <h4>No pending appointments</h4>
                                            <p>There are no pending appointments at this time.</p>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Approved Appointments Tab -->
                <div class="tab-content" id="approved" style="display: none;">
                    <div class="appointment-table-container">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (approvedAppointments != null && !approvedAppointments.isEmpty()) { %>
                                    <% for (Appointment appointment : approvedAppointments) { %>
                                        <tr data-appointment-id="<%= appointment.getId() %>">
                                            <td><%= appointment.getPatientName() %></td>
                                            <td><%= appointment.getAppointmentDate() %></td>
                                            <td><%= appointment.getAppointmentTime() %></td>
                                            <td class="status-cell"><span class="status-badge approved">APPROVED</span></td>
                                            <td class="action-cell">
                                                <button class="view-details-btn" data-appointment-id="<%= appointment.getId() %>">View Details</button>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="5" class="empty-state">
                                            <i class="fas fa-calendar-check"></i>
                                            <h4>No approved appointments</h4>
                                            <p>There are no approved appointments at this time.</p>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Completed Appointments Tab -->
                <div class="tab-content" id="completed" style="display: none;">
                    <div class="appointment-table-container">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (completedAppointments != null && !completedAppointments.isEmpty()) { %>
                                    <% for (Appointment appointment : completedAppointments) { %>
                                        <tr data-appointment-id="<%= appointment.getId() %>">
                                            <td><%= appointment.getPatientName() %></td>
                                            <td><%= appointment.getAppointmentDate() %></td>
                                            <td><%= appointment.getAppointmentTime() %></td>
                                            <td class="status-cell"><span class="status-badge completed">COMPLETED</span></td>
                                            <td class="action-cell">
                                                <button class="view-details-btn" data-appointment-id="<%= appointment.getId() %>">View Details</button>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="5" class="empty-state">
                                            <i class="fas fa-clipboard-check"></i>
                                            <h4>No completed appointments</h4>
                                            <p>There are no completed appointments at this time.</p>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Rejected Appointments Tab -->
                <div class="tab-content" id="rejected" style="display: none;">
                    <div class="appointment-table-container">
                        <table class="appointment-table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (rejectedAppointments != null && !rejectedAppointments.isEmpty()) { %>
                                    <% for (Appointment appointment : rejectedAppointments) { %>
                                        <tr data-appointment-id="<%= appointment.getId() %>">
                                            <td><%= appointment.getPatientName() %></td>
                                            <td><%= appointment.getAppointmentDate() %></td>
                                            <td><%= appointment.getAppointmentTime() %></td>
                                            <td class="status-cell"><span class="status-badge rejected">REJECTED</span></td>
                                            <td class="action-cell">
                                                <span class="rejected-text">Appointment Rejected</span>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="5" class="empty-state">
                                            <i class="fas fa-times-circle"></i>
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
    <script src="${pageContext.request.contextPath}/js/doctorDashboard.js"></script>
</body>
</html>
