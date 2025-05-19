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
    String doctorName = "Dr. Harlan Drake";
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

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
                    <div class="appointment-tab active" data-tab="upcoming">Upcoming</div>
                    <div class="appointment-tab" data-tab="past">Past</div>
                    <div class="appointment-tab" data-tab="pending">Pending</div>
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
                            <tr>
                                <td>001</td>
                                <td class="patient-name">John Doe</td>
                                <td class="appointment-date">2023-10-10</td>
                                <td><span class="status-badge active">Active</span></td>
                                <td>
                                    <a href="#" class="action-btn view">View</a>
                                </td>
                                <td>
                                    <span class="notes-badge">Follow-up required</span>
                                </td>
                            </tr>
                            <tr>
                                <td>002</td>
                                <td class="patient-name">Jane Smith</td>
                                <td class="appointment-date">2023-10-11</td>
                                <td><span class="status-badge active">Active</span></td>
                                <td>
                                    <a href="#" class="action-btn view">View</a>
                                </td>
                                <td>
                                    <span class="notes-badge">First consultation</span>
                                </td>
                            </tr>
                            <tr>
                                <td>003</td>
                                <td class="patient-name">Emily Brown</td>
                                <td class="appointment-date">2023-10-12</td>
                                <td><span class="status-badge pending">Pending</span></td>
                                <td>
                                    <a href="#" class="action-btn approve" data-id="003">Approve</a>
                                    <a href="#" class="action-btn reject" data-id="003">Reject</a>
                                </td>
                                <td>
                                    <span class="notes-badge">New appointment request</span>
                                </td>
                            </tr>
                            <tr>
                                <td>004</td>
                                <td class="patient-name">David Wilson</td>
                                <td class="appointment-date">2023-10-13</td>
                                <td><span class="status-badge completed">Completed</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/doctor/appointment/details?id=004" class="action-btn view">View</a>
                                </td>
                                <td>
                                    <span class="notes-badge">Routine check-up</span>
                                </td>
                            </tr>
                            <tr>
                                <td>005</td>
                                <td class="patient-name">Sarah White</td>
                                <td class="appointment-date">2023-10-14</td>
                                <td><span class="status-badge pending">Pending</span></td>
                                <td>
                                    <a href="#" class="action-btn approve" data-id="005">Approve</a>
                                    <a href="#" class="action-btn reject" data-id="005">Reject</a>
                                </td>
                                <td>
                                    <span class="notes-badge">Follow-up request</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching functionality
            const tabs = document.querySelectorAll('.appointment-tab');

            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    // Remove active class from all tabs
                    tabs.forEach(t => t.classList.remove('active'));

                    // Add active class to clicked tab
                    this.classList.add('active');

                    // Here you would typically show/hide content based on the selected tab
                    const tabName = this.getAttribute('data-tab');
                    console.log('Switched to tab:', tabName);

                    // In a real implementation, you would fetch data for the selected tab
                    // and update the table content
                });
            });

            // Search functionality
            const searchInput = document.querySelector('.search-box input');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase();
                    const rows = document.querySelectorAll('.appointment-table tbody tr');

                    rows.forEach(row => {
                        const patientName = row.querySelector('.patient-name').textContent.toLowerCase();
                        const appointmentId = row.querySelector('td:first-child').textContent.toLowerCase();

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

                    if (confirm('Are you sure you want to approve the appointment for ' + patientName + '?')) {
                        // Here you would send the approval to the server
                        // For example:
                        // fetch('/doctor/appointment/update', {
                        //     method: 'POST',
                        //     headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        //     body: 'id=' + appointmentId + '&status=APPROVED'
                        // })

                        // Update the UI to reflect the change
                        const statusCell = this.closest('tr').querySelector('.status-badge');
                        statusCell.className = 'status-badge active';
                        statusCell.textContent = 'Active';

                        // Replace approve/reject buttons with view button
                        const actionCell = this.closest('td');
                        actionCell.innerHTML = '<a href="${pageContext.request.contextPath}/doctor/appointment/details?id=' + appointmentId + '" class="action-btn view">View</a>';

                        alert('Appointment approved successfully!');
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

                    const reason = prompt('Please provide a reason for rejecting ' + patientName + '\'s appointment:', '');

                    if (reason !== null) {
                        // Here you would send the rejection to the server
                        // For example:
                        // fetch('/doctor/appointment/update', {
                        //     method: 'POST',
                        //     headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        //     body: 'id=' + appointmentId + '&status=REJECTED&notes=' + encodeURIComponent(reason)
                        // })

                        // Update the UI to reflect the change
                        const statusCell = this.closest('tr').querySelector('.status-badge');
                        statusCell.className = 'status-badge cancelled';
                        statusCell.textContent = 'Rejected';

                        // Replace approve/reject buttons with view button
                        const actionCell = this.closest('td');
                        actionCell.innerHTML = '<a href="${pageContext.request.contextPath}/doctor/appointment/details?id=' + appointmentId + '" class="action-btn view">View</a>';

                        // Update notes
                        const notesCell = this.closest('tr').querySelector('.notes-badge');
                        notesCell.textContent = 'Rejected: ' + reason;

                        alert('Appointment rejected successfully!');
                    }
                });
            });
        });
    </script>
</body>
</html>
