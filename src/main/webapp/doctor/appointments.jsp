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

    // Get doctor information from session
    Doctor doctor = (Doctor) request.getAttribute("doctor");

    // Get appointments from request attributes
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");

    // Get appointment counts
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer confirmedCount = (Integer) request.getAttribute("confirmedCount");
    Integer completedCount = (Integer) request.getAttribute("completedCount");
    Integer cancelledCount = (Integer) request.getAttribute("cancelledCount");

    // Set default values if null
    if (pendingCount == null) pendingCount = 0;
    if (confirmedCount == null) confirmedCount = 0;
    if (completedCount == null) completedCount = 0;
    if (cancelledCount == null) cancelledCount = 0;

    // Get current status filter
    String currentStatus = (String) request.getAttribute("status");
    if (currentStatus == null) currentStatus = "PENDING";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-profile.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="HealthPro Logo">
                <h2>HealthPro Portal</h2>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="index.jsp">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/doctor/appointments-list">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointment Management</span>
                        </a>
                    </li>
                    <li>
                        <a href="patients.jsp">
                            <i class="fas fa-user-injured"></i>
                            <span>Patient Details</span>
                        </a>
                    </li>
                    <li>
                        <a href="schedule.jsp">
                            <i class="fas fa-clock"></i>
                            <span>Set Availability</span>
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
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-left">
                    <h2>Doctor Dashboard - Appointment Management</h2>
                </div>
            </div>

            <!-- Appointment Management Section -->
            <div class="appointment-section">
                <div class="appointment-header">
                    <h2>Appointment Management</h2>
                </div>

                <div class="appointment-tabs">
                    <a href="${pageContext.request.contextPath}/doctor/appointments-list?status=CONFIRMED"
                       class="appointment-tab <%= "CONFIRMED".equals(currentStatus) ? "active" : "" %>">
                        Confirmed (<%= confirmedCount %>)
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments-list?status=PENDING"
                       class="appointment-tab <%= "PENDING".equals(currentStatus) ? "active" : "" %>">
                        Pending (<%= pendingCount %>)
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments-list?status=COMPLETED"
                       class="appointment-tab <%= "COMPLETED".equals(currentStatus) ? "active" : "" %>">
                        Completed (<%= completedCount %>)
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments-list?status=CANCELLED"
                       class="appointment-tab <%= "CANCELLED".equals(currentStatus) ? "active" : "" %>">
                        Cancelled (<%= cancelledCount %>)
                    </a>
                </div>

                <div class="appointment-filter">
                    <div class="search-box">
                        <input type="text" placeholder="Search by patient name">
                    </div>
                </div>

                <div class="appointment-content">
                    <table class="appointment-table">
                        <thead>
                            <tr>
                                <th>Appointment ID</th>
                                <th>Patient Name</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Action</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (appointments != null && !appointments.isEmpty()) {
                                for (Appointment appointment : appointments) {
                                    String statusClass = "";
                                    String statusText = appointment.getStatus();

                                    if ("PENDING".equals(statusText)) {
                                        statusClass = "pending";
                                        statusText = "Pending";
                                    } else if ("CONFIRMED".equals(statusText)) {
                                        statusClass = "active";
                                        statusText = "Confirmed";
                                    } else if ("COMPLETED".equals(statusText)) {
                                        statusClass = "completed";
                                        statusText = "Completed";
                                    } else if ("CANCELLED".equals(statusText)) {
                                        statusClass = "cancelled";
                                        statusText = "Cancelled";
                                    }
                            %>
                            <tr>
                                <td><%= appointment.getId() %></td>
                                <td class="patient-name"><%= appointment.getPatientName() %></td>
                                <td class="appointment-date"><%= appointment.getAppointmentDate() %></td>
                                <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                                <td>
                                    <% if ("PENDING".equals(appointment.getStatus())) { %>
                                        <a href="#" class="action-btn approve" data-id="<%= appointment.getId() %>">Approve</a>
                                        <a href="#" class="action-btn reject" data-id="<%= appointment.getId() %>">Reject</a>
                                    <% } else { %>
                                        <a href="#" class="action-btn view" data-id="<%= appointment.getId() %>">View</a>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="notes-badge"><%= appointment.getNotes() != null ? appointment.getNotes() : (appointment.getReason() != null ? appointment.getReason() : "No notes") %></span>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="6" class="text-center">No appointments found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Set context path for JavaScript
        const contextPath = '${pageContext.request.contextPath}';

        document.addEventListener('DOMContentLoaded', function() {
            // Search functionality
            const searchInput = document.querySelector('.search-box input');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase();
                    const rows = document.querySelectorAll('.appointment-table tbody tr');

                    rows.forEach(row => {
                        const patientName = row.querySelector('.patient-name')?.textContent.toLowerCase() || '';
                        const appointmentId = row.querySelector('td:first-child')?.textContent.toLowerCase() || '';

                        if (patientName.includes(searchTerm) || appointmentId.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }

            // Approve appointment functionality
            const approveButtons = document.querySelectorAll('.action-btn.approve');
            approveButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const appointmentId = this.getAttribute('data-id');
                    const patientName = this.closest('tr').querySelector('.patient-name').textContent;

                    if (confirm(`Are you sure you want to approve the appointment for ${patientName}?`)) {
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
                                // Update the UI to reflect the change
                                const statusCell = this.closest('tr').querySelector('.status-badge');
                                statusCell.className = 'status-badge active';
                                statusCell.textContent = 'Confirmed';

                                // Replace approve/reject buttons with view button
                                const actionCell = this.closest('td');
                                actionCell.innerHTML = '<a href="#" class="action-btn view">View</a>';

                                alert('Appointment approved successfully!');
                            } else {
                                alert('Failed to approve appointment. Please try again.');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('An error occurred. Please try again.');
                        });
                    }
                });
            });

            // Reject appointment functionality
            const rejectButtons = document.querySelectorAll('.action-btn.reject');
            rejectButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const appointmentId = this.getAttribute('data-id');
                    const patientName = this.closest('tr').querySelector('.patient-name').textContent;

                    const reason = prompt(`Please provide a reason for rejecting ${patientName}'s appointment:`, '');

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
                                // Update the UI to reflect the change
                                const statusCell = this.closest('tr').querySelector('.status-badge');
                                statusCell.className = 'status-badge cancelled';
                                statusCell.textContent = 'Cancelled';

                                // Replace approve/reject buttons with view button
                                const actionCell = this.closest('td');
                                actionCell.innerHTML = '<a href="#" class="action-btn view">View</a>';

                                // Update notes
                                const notesCell = this.closest('tr').querySelector('.notes-badge');
                                notesCell.textContent = `Rejected: ${reason}`;

                                alert('Appointment rejected successfully!');
                            } else {
                                alert('Failed to reject appointment. Please try again.');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('An error occurred. Please try again.');
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>
