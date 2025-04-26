<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | HealthCare</title>
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
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search...">
                    </div>

                    <div class="nav-notifications">
                        <div class="icon-badge">
                            <i class="fas fa-bell"></i>
                            <span class="badge">5</span>
                        </div>
                    </div>

                    <div class="nav-user">
                        <img src="../images/admin-avatar.jpg" alt="Admin">
                        <div class="user-info">
                            <h4>Admin User</h4>
                            <p>Administrator</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>Dashboard</h1>
                    <p>Welcome to the admin dashboard</p>
                </div>

                <!-- Stats Cards -->
                <div class="stats-container">
                    <div class="stat-card">
                        <div class="stat-card-icon blue">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-card-info">
                            <h3>Total Doctors</h3>
                            <h2>42</h2>
                            <p><span class="positive"><i class="fas fa-arrow-up"></i> 12%</span> from last month</p>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-card-icon green">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-card-info">
                            <h3>Total Patients</h3>
                            <h2>1,286</h2>
                            <p><span class="positive"><i class="fas fa-arrow-up"></i> 8%</span> from last month</p>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-card-icon purple">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-card-info">
                            <h3>Appointments</h3>
                            <h2>152</h2>
                            <p><span class="positive"><i class="fas fa-arrow-up"></i> 5%</span> from last month</p>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-card-icon orange">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <div class="stat-card-info">
                            <h3>Revenue</h3>
                            <h2>$24,500</h2>
                            <p><span class="positive"><i class="fas fa-arrow-up"></i> 15%</span> from last month</p>
                        </div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="charts-container">
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Appointment Statistics</h3>
                            <div class="chart-actions">
                                <select>
                                    <option>Last 7 Days</option>
                                    <option>Last 30 Days</option>
                                    <option>Last 90 Days</option>
                                </select>
                            </div>
                        </div>
                        <div class="chart-body">
                            <canvas id="appointmentChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Revenue Overview</h3>
                            <div class="chart-actions">
                                <select>
                                    <option>Last 7 Days</option>
                                    <option>Last 30 Days</option>
                                    <option>Last 90 Days</option>
                                </select>
                            </div>
                        </div>
                        <div class="chart-body">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="recent-activity">
                    <div class="section-header">
                        <h3>Recent Activity</h3>
                        <a href="#" class="view-all">View All</a>
                    </div>

                    <div class="activity-list">
                        <div class="activity-item">
                            <div class="activity-icon green">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="activity-details">
                                <h4>New doctor registered</h4>
                                <p>Dr. Sarah Johnson (Neurologist) has registered</p>
                                <span class="activity-time">2 hours ago</span>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-icon blue">
                                <i class="fas fa-calendar-plus"></i>
                            </div>
                            <div class="activity-details">
                                <h4>New appointment booked</h4>
                                <p>John Smith booked an appointment with Dr. Michael Brown</p>
                                <span class="activity-time">3 hours ago</span>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-icon orange">
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="activity-details">
                                <h4>New review received</h4>
                                <p>Dr. Emily Parker received a 5-star review</p>
                                <span class="activity-time">5 hours ago</span>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-icon purple">
                                <i class="fas fa-calendar-times"></i>
                            </div>
                            <div class="activity-details">
                                <h4>Appointment cancelled</h4>
                                <p>Robert Wilson cancelled his appointment with Dr. John Smith</p>
                                <span class="activity-time">Yesterday</span>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-icon red">
                                <i class="fas fa-exclamation-circle"></i>
                            </div>
                            <div class="activity-details">
                                <h4>System alert</h4>
                                <p>Server maintenance completed successfully</p>
                                <span class="activity-time">Yesterday</span>
                            </div>
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

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.dashboard-sidebar').classList.toggle('active');
        });

        document.getElementById('sidebarClose').addEventListener('click', function() {
            document.querySelector('.dashboard-sidebar').classList.remove('active');
        });

        // Charts
        const appointmentCtx = document.getElementById('appointmentChart').getContext('2d');
        const appointmentChart = new Chart(appointmentCtx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Appointments',
                    data: [15, 22, 18, 24, 30, 25, 18],
                    backgroundColor: 'rgba(78, 84, 200, 0.1)',
                    borderColor: '#4e54c8',
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            display: true,
                            color: 'rgba(0, 0, 0, 0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });

        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Revenue',
                    data: [3500, 4200, 3800, 5000, 4800, 5500, 4000],
                    backgroundColor: '#00d2ff',
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            display: true,
                            color: 'rgba(0, 0, 0, 0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
