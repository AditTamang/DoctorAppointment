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
    <title>Appointments | MedDoc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
    <!-- Load doctor-layout-fix.css last to ensure it overrides other styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-layout-fix.css">
    <!-- Load doctor-sidebar-clean.css to ensure sidebar is properly styled -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-sidebar-clean.css">
    <style>
        /* Main Content Styling - Moved to doctor-layout-fix.css */

        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
        }

        .top-header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .search-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .search-icon:hover {
            background-color: #f5f5f5;
        }

        .appointment-section {
            background-color: #fff;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
            width: 100%;
        }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .appointment-header h2 {
            font-size: 22px;
            font-weight: 600;
            color: #333;
        }

        .appointment-tabs {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 15px;
        }

        .appointment-tab {
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            background-color: #f5f7fa;
        }

        .appointment-tab.active {
            background-color: #4361ee;
            color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .appointment-tab:hover:not(.active) {
            background-color: #e0e6f5;
        }

        .appointment-filter {
            margin-bottom: 20px;
        }

        .search-box {
            position: relative;
            width: 100%;
        }

        .search-box input {
            width: 100%;
            padding: 12px 15px 12px 40px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .search-box input:focus {
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
            outline: none;
        }

        .search-box::before {
            content: '\f002';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }

        .appointment-content {
            overflow-x: auto;
            width: 100%;
        }

        .appointment-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .appointment-table th,
        .appointment-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        .appointment-table th {
            font-weight: 600;
            color: #333;
            background-color: #f8f9fa;
            position: sticky;
            top: 0;
        }

        .appointment-table tr:hover {
            background-color: #f8f9fa;
        }

        .appointment-table .patient-name {
            font-weight: 500;
            color: #333;
        }

        .appointment-table .appointment-date {
            color: #555;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }

        .status-badge.active {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-badge.pending {
            background-color: #fff8e1;
            color: #f57c00;
        }

        .status-badge.completed {
            background-color: #e3f2fd;
            color: #1565c0;
        }

        .status-badge.cancelled {
            background-color: #ffebee;
            color: #c62828;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            margin-right: 5px;
            transition: all 0.3s ease;
        }

        .action-btn.view {
            background-color: #e3f2fd;
            color: #1565c0;
        }

        .action-btn.approve {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .action-btn.reject {
            background-color: #ffebee;
            color: #c62828;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .notes-badge {
            display: inline-block;
            padding: 5px 10px;
            background-color: #f5f5f5;
            border-radius: 4px;
            font-size: 12px;
            color: #555;
        }

        /* Appointment Stats */
        .appointment-stats {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 10px 20px;
        }

        .stat-label {
            font-size: 14px;
            color: #555;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 22px;
            font-weight: 600;
            padding: 5px 15px;
            border-radius: 20px;
        }

        .stat-value.approved {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .stat-value.completed {
            background-color: #e3f2fd;
            color: #1565c0;
        }

        .stat-value.rejected {
            background-color: #ffebee;
            color: #c62828;
        }

        /* No Appointments Message */
        .no-appointments {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            text-align: center;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin: 20px 0;
        }

        .no-data-icon {
            font-size: 50px;
            color: #aaa;
            margin-bottom: 15px;
        }

        .no-appointments h3 {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .no-appointments p {
            font-size: 15px;
            color: #666;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .appointment-section {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 8px;
            }

            .appointment-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }

            .appointment-stats {
                flex-direction: row;
                flex-wrap: wrap;
                gap: 10px;
                padding: 10px;
            }

            .stat-item {
                padding: 8px 15px;
            }

            .stat-value {
                font-size: 18px;
                padding: 4px 12px;
            }

            .appointment-tabs {
                width: 100%;
                overflow-x: auto;
                padding-bottom: 5px;
                gap: 5px;
                display: flex;
                flex-wrap: nowrap;
            }

            .appointment-tab {
                padding: 8px 15px;
                font-size: 14px;
                white-space: nowrap;
                flex: 0 0 auto;
            }

            .appointment-table th,
            .appointment-table td {
                padding: 10px;
                font-size: 14px;
            }

            .action-btn {
                padding: 5px 10px;
                font-size: 12px;
                margin-bottom: 5px;
                display: inline-block;
            }

            .no-appointments {
                padding: 30px 15px;
            }

            .no-data-icon {
                font-size: 40px;
            }

            .no-appointments h3 {
                font-size: 18px;
            }

            .no-appointments p {
                font-size: 14px;
            }
        }

        @media (max-width: 480px) {
            .appointment-section {
                padding: 12px;
            }

            .appointment-stats {
                flex-direction: column;
                padding: 8px;
            }

            .stat-item {
                width: 100%;
                padding: 6px 10px;
                flex-direction: row;
                justify-content: space-between;
                border-bottom: 1px solid #e0e0e0;
            }

            .stat-item:last-child {
                border-bottom: none;
            }

            .stat-label {
                margin-bottom: 0;
            }

            .stat-value {
                font-size: 16px;
                padding: 3px 10px;
            }

            .appointment-table {
                font-size: 13px;
            }

            .appointment-table th,
            .appointment-table td {
                padding: 8px;
            }

            .status-badge {
                padding: 4px 8px;
                font-size: 12px;
            }

            .action-btn {
                padding: 4px 8px;
                font-size: 11px;
                margin-right: 2px;
            }

            .notes-badge {
                padding: 4px 8px;
                font-size: 11px;
            }

            .no-appointments {
                padding: 20px 10px;
            }

            .no-data-icon {
                font-size: 35px;
            }

            .no-appointments h3 {
                font-size: 16px;
            }

            .no-appointments p {
                font-size: 13px;
            }
        }
    </style>
</head>
<body class="doctor-appointments-page">
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-right">
                    <div class="search-icon">
                        <i class="fas fa-search"></i>
                    </div>
                </div>
            </div>

            <!-- Appointment Management Section -->
            <div class="appointment-section">
                <div class="appointment-header">
                    <h2>Appointment Management</h2>
                </div>

                <div class="appointment-stats">
                    <div class="stat-item">
                        <span class="stat-label">Approved</span>
                        <span class="stat-value approved">1</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Completed</span>
                        <span class="stat-value completed">0</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Rejected</span>
                        <span class="stat-value rejected">2</span>
                    </div>
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
                    <!-- No appointments message -->
                    <div class="no-appointments">
                        <div class="no-data-icon">
                            <i class="fas fa-calendar-times"></i>
                        </div>
                        <h3>No pending appointments</h3>
                        <p>There are no pending appointments at this time.</p>
                    </div>

                    <!-- Table will be shown when there are appointments -->
                    <table class="appointment-table" style="display: none;">
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
