<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.doctorapp.model.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        <%@include file="./assets/css/style.css"%>
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="logo">
                    <span class="logo-icon"><i class="fas fa-hospital"></i></span>
                    <span class="logo-text">Med<span>Doc</span></span>
                </div>
                <button class="sidebar-close" id="sidebarClose">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="sidebar-user">
                <div class="user-image">
                    <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Admin">
                </div>
                <div class="user-details">
                    <h4>${user != null ? user.username : 'Admin User'}</h4>
                    <p>Administrator</p>
                </div>
            </div>

            <nav class="sidebar-nav">
                <ul>
                    <li class="active">
                        <a href="#"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-user-md"></i> Doctors</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-users"></i> Patients</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-calendar-check"></i> Appointments</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-chart-bar"></i> Reports</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-cog"></i> Settings</a>
                    </li>
                    <li class="sidebar-divider"></li>
                    <li>
                        <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="dashboard-header">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </div>

                <div class="header-search">
                    <form>
                        <input type="text" placeholder="Search...">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                </div>

                <div class="header-actions">
                    <div class="notification-bell">
                        <i class="fas fa-bell"></i>
                        <span class="badge">3</span>
                    </div>
                    <div class="message-icon">
                        <i class="fas fa-envelope"></i>
                        <span class="badge">5</span>
                    </div>
                    <div class="user-profile">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Admin">
                        <span>Admin</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>Admin Dashboard</h1>
                    <nav class="breadcrumb">
                        <a href="index.jsp">Home</a> /
                        <span>Dashboard</span>
                    </nav>
                </div>

                <!-- Stats Cards -->
                <div class="stats-cards">
                    <div class="stat-card primary">
                        <div class="stat-card-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-card-info">
                            <h2>${totalDoctors != null ? totalDoctors : 0}</h2>
                            <p>Total Doctors</p>
                        </div>
                        <div class="stat-card-progress">
                            <div class="progress-bar" style="width: 75%"></div>
                        </div>
                        <div class="stat-card-link">
                            <a href="#">View All <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>

                    <div class="stat-card success">
                        <div class="stat-card-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-card-info">
                            <h2>${totalPatients != null ? totalPatients : 0}</h2>
                            <p>Total Patients</p>
                        </div>
                        <div class="stat-card-progress">
                            <div class="progress-bar" style="width: 65%"></div>
                        </div>
                        <div class="stat-card-link">
                            <a href="#">View All <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>

                    <div class="stat-card warning">
                        <div class="stat-card-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-card-info">
                            <h2>${totalAppointments != null ? totalAppointments : 0}</h2>
                            <p>Appointments</p>
                        </div>
                        <div class="stat-card-progress">
                            <div class="progress-bar" style="width: 45%"></div>
                        </div>
                        <div class="stat-card-link">
                            <a href="#">View All <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>

                    <div class="stat-card info">
                        <div class="stat-card-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="stat-card-info">
                            <h2>$${totalRevenue != null ? totalRevenue : 0}</h2>
                            <p>Total Revenue</p>
                        </div>
                        <div class="stat-card-progress">
                            <div class="progress-bar" style="width: 85%"></div>
                        </div>
                        <div class="stat-card-link">
                            <a href="#">View Report <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="dashboard-charts">
                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Appointment Statistics</h3>
                            <div class="chart-actions">
                                <button class="btn-outline-sm active">Weekly</button>
                                <button class="btn-outline-sm">Monthly</button>
                                <button class="btn-outline-sm">Yearly</button>
                            </div>
                        </div>
                        <div class="chart-body">
                            <div class="chart-placeholder">
                                <div class="bar-chart">
                                    <div class="bar-item">
                                        <div class="bar-fill" style="height: 65%"></div>
                                        <span class="bar-label">Mon</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar-fill" style="height: 80%"></div>
                                        <span class="bar-label">Tue</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar-fill" style="height: 45%"></div>
                                        <span class="bar-label">Wed</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar-fill" style="height: 70%"></div>
                                        <span class="bar-label">Thu</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar-fill" style="height: 90%"></div>
                                        <span class="bar-label">Fri</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar-fill" style="height: 50%"></div>
                                        <span class="bar-label">Sat</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar-fill" style="height: 30%"></div>
                                        <span class="bar-label">Sun</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <h3>Doctor Specialties</h3>
                            <div class="chart-actions">
                                <button class="btn-icon"><i class="fas fa-ellipsis-v"></i></button>
                            </div>
                        </div>
                        <div class="chart-body">
                            <div class="chart-placeholder">
                                <div class="donut-chart">
                                    <div class="donut-segment" style="--offset: 0; --value: 30; --bg: var(--primary-color);"></div>
                                    <div class="donut-segment" style="--offset: 30; --value: 25; --bg: var(--success-color);"></div>
                                    <div class="donut-segment" style="--offset: 55; --value: 20; --bg: var(--warning-color);"></div>
                                    <div class="donut-segment" style="--offset: 75; --value: 15; --bg: var(--info-color);"></div>
                                    <div class="donut-segment" style="--offset: 90; --value: 10; --bg: var(--danger-color);"></div>
                                </div>
                                <div class="donut-legend">
                                    <div class="legend-item">
                                        <span class="legend-color" style="background-color: var(--primary-color)"></span>
                                        <span class="legend-label">Cardiology (30%)</span>
                                    </div>
                                    <div class="legend-item">
                                        <span class="legend-color" style="background-color: var(--success-color)"></span>
                                        <span class="legend-label">Neurology (25%)</span>
                                    </div>
                                    <div class="legend-item">
                                        <span class="legend-color" style="background-color: var(--warning-color)"></span>
                                        <span class="legend-label">Orthopedics (20%)</span>
                                    </div>
                                    <div class="legend-item">
                                        <span class="legend-color" style="background-color: var(--info-color)"></span>
                                        <span class="legend-label">Pediatrics (15%)</span>
                                    </div>
                                    <div class="legend-item">
                                        <span class="legend-color" style="background-color: var(--danger-color)"></span>
                                        <span class="legend-label">Others (10%)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity and Doctors -->
                <div class="dashboard-tables">
                    <div class="table-card">
                        <div class="table-header">
                            <h3>Recent Appointments</h3>
                            <a href="#" class="view-all">View All</a>
                        </div>
                        <div class="table-body">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="appointment" items="${recentAppointments}">
                                        <tr>
                                            <td>
                                                <div class="user-info">
                                                    <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                                                    <span>${appointment.patientName}</span>
                                                </div>
                                            </td>
                                            <td>${appointment.doctorName}</td>
                                            <td>${appointment.appointmentDate}</td>
                                            <td>${appointment.appointmentTime}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appointment.status == 'COMPLETED'}"><span class="status-badge completed">Completed</span></c:when>
                                                    <c:when test="${appointment.status == 'PENDING'}"><span class="status-badge pending">Pending</span></c:when>
                                                    <c:when test="${appointment.status == 'CANCELLED'}"><span class="status-badge cancelled">Cancelled</span></c:when>
                                                    <c:when test="${appointment.status == 'CONFIRMED'}"><span class="status-badge confirmed">Confirmed</span></c:when>
                                                    <c:otherwise><span class="status-badge">${appointment.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <a href="appointment/details?id=${appointment.id}" class="btn-icon"><i class="fas fa-eye"></i></a>
                                                    <a href="appointment/edit?id=${appointment.id}" class="btn-icon"><i class="fas fa-edit"></i></a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty recentAppointments}">
                                        <tr>
                                            <td colspan="6" class="text-center">No appointments found</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="table-card">
                        <div class="table-header">
                            <h3>Top Doctors</h3>
                            <a href="#" class="view-all">View All</a>
                        </div>
                        <div class="table-body">
                            <div class="doctor-list">
                                <c:forEach var="doctor" items="${topDoctors}">
                                    <div class="doctor-card">
                                        <div class="doctor-avatar">
                                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Doctor">
                                        </div>
                                        <div class="doctor-info">
                                            <h4>Dr. ${doctor.fullName}</h4>
                                            <p>${doctor.specialization}</p>
                                            <div class="doctor-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= doctor.rating}">
                                                            <i class="fas fa-star"></i>
                                                        </c:when>
                                                        <c:when test="${i <= doctor.rating + 0.5}">
                                                            <i class="fas fa-star-half-alt"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="far fa-star"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <span>(${doctor.rating})</span>
                                            </div>
                                        </div>
                                        <div class="doctor-stats">
                                            <div class="stat">
                                                <h5>${doctor.successRate}%</h5>
                                                <p>Success Rate</p>
                                            </div>
                                            <div class="stat">
                                                <h5>${doctor.patientCount}</h5>
                                                <p>Patients</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty topDoctors}">
                                    <div class="text-center w-100 p-4">
                                        <p>No doctors found</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
