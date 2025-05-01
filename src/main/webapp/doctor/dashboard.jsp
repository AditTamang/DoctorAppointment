<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard | Healthcare Portal</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Fullcalendar CSS -->
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.min.css' rel='stylesheet' />
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard.css">
</head>
<body class="dashboard-body">
    <div class="dashboard-container">
        <!-- Left Sidebar Navigation -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <div class="doctor-profile-small">
                    <img src="${doctor.profileImage != null ? doctor.profileImage : pageContext.request.contextPath.concat('/assets/images/default-doctor.png')}" alt="Doctor Profile" class="profile-pic-small">
                    <div class="status-indicator ${doctor.status == 'ACTIVE' ? 'active' : 'inactive'}"></div>
                </div>
                <h3>Dr. ${sessionScope.user.firstName} ${sessionScope.user.lastName}</h3>
                <button id="sidebar-toggle" class="sidebar-toggle">
                    <i class="fas fa-bars"></i>
                </button>
            </div>

            <nav class="sidebar-nav">
                <ul>
                    <li class="active"><a href="#dashboard-section"><i class="fas fa-home"></i> <span>Dashboard</span></a></li>
                    <li><a href="#profile-section"><i class="fas fa-user-md"></i> <span>Profile</span></a></li>
                    <li><a href="#appointments-section"><i class="fas fa-calendar-check"></i> <span>Appointments</span></a></li>
                    <li><a href="#patients-section"><i class="fas fa-users"></i> <span>Patients</span></a></li>
                    <li><a href="#availability-section"><i class="fas fa-clock"></i> <span>Availability</span></a></li>
                    <li><a href="#packages-section"><i class="fas fa-box-open"></i> <span>Health Packages</span></a></li>
                    <li><a href="#settings-section"><i class="fas fa-cog"></i> <span>Settings</span></a></li>
                </ul>
            </nav>

            <div class="sidebar-footer">
                <div class="status-toggle">
                    <span>Status: </span>
                    <label class="switch">
                        <input type="checkbox" id="status-toggle" ${doctor.status == 'ACTIVE' ? 'checked' : ''}>
                        <span class="slider round"></span>
                    </label>
                    <span id="status-text">${doctor.status == 'ACTIVE' ? 'Active' : 'Inactive'}</span>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <!-- Top Header -->
            <header class="top-header">
                <div class="current-date">
                    <i class="far fa-calendar-alt"></i>
                    <span id="current-date"></span>
                </div>
                <div class="header-actions">
                    <div class="search-container">
                        <input type="text" placeholder="Search patients, appointments..." class="search-input">
                        <button class="search-btn"><i class="fas fa-search"></i></button>
                    </div>
                    <div class="notifications">
                        <button class="notification-btn">
                            <i class="far fa-bell"></i>
                            <span class="notification-badge">3</span>
                        </button>
                        <div class="notification-dropdown">
                            <div class="notification-header">
                                <h3>Notifications</h3>
                                <a href="#">Mark all as read</a>
                            </div>
                            <ul class="notification-list">
                                <li class="unread">
                                    <div class="notification-icon"><i class="fas fa-calendar-plus"></i></div>
                                    <div class="notification-content">
                                        <p>New appointment request from <strong>John Doe</strong></p>
                                        <span class="notification-time">10 minutes ago</span>
                                    </div>
                                </li>
                                <li class="unread">
                                    <div class="notification-icon"><i class="fas fa-calendar-times"></i></div>
                                    <div class="notification-content">
                                        <p><strong>Sarah Johnson</strong> cancelled her appointment</p>
                                        <span class="notification-time">1 hour ago</span>
                                    </div>
                                </li>
                                <li class="unread">
                                    <div class="notification-icon"><i class="fas fa-user-plus"></i></div>
                                    <div class="notification-content">
                                        <p>New patient <strong>Michael Brown</strong> registered</p>
                                        <span class="notification-time">Yesterday</span>
                                    </div>
                                </li>
                            </ul>
                            <div class="notification-footer">
                                <a href="#">View all notifications</a>
                            </div>
                        </div>
                    </div>
                    <div class="account-dropdown">
                        <button class="account-btn">
                            <img src="${doctor.profileImage != null ? doctor.profileImage : pageContext.request.contextPath.concat('/assets/images/default-doctor.png')}" alt="Doctor Profile" class="profile-pic-tiny">
                            <span>Dr. ${sessionScope.user.firstName}</span>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="account-dropdown-menu">
                            <a href="#profile-section"><i class="fas fa-user"></i> My Profile</a>
                            <a href="#settings-section"><i class="fas fa-cog"></i> Settings</a>
                            <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content Sections -->
            <div class="dashboard-sections">
                <!-- Dashboard Home Section -->
                <section id="dashboard-section" class="dashboard-section active">
                    <h2 class="section-title">Dashboard</h2>

                    <!-- Dashboard Summary Cards -->
                    <div class="summary-cards">
                        <div class="summary-card">
                            <div class="card-icon"><i class="fas fa-calendar-day"></i></div>
                            <div class="card-content">
                                <h3>Today's Appointments</h3>
                                <div class="card-value">${todayAppointments} <span class="trend up"><i class="fas fa-arrow-up"></i> 15%</span></div>
                            </div>
                        </div>
                        <div class="summary-card">
                            <div class="card-icon"><i class="fas fa-calendar-week"></i></div>
                            <div class="card-content">
                                <h3>This Week's Total</h3>
                                <div class="card-value">${weeklyAppointments}</div>
                                <div class="progress-bar">
                                    <div class="progress" style="width: ${weeklyAppointmentsPercentage}%"></div>
                                </div>
                            </div>
                        </div>
                        <div class="summary-card">
                            <div class="card-icon"><i class="fas fa-user-check"></i></div>
                            <div class="card-content">
                                <h3>Patients Consulted</h3>
                                <div class="card-value">${patientsConsulted}</div>
                                <div class="mini-graph">
                                    <svg viewBox="0 0 100 20">
                                        <polyline points="0,20 10,15 20,18 30,10 40,15 50,5 60,10 70,5 80,10 90,5 100,10" fill="none" stroke="#4CAF50" stroke-width="2" />
                                    </svg>
                                </div>
                            </div>
                        </div>
                        <div class="summary-card warning">
                            <div class="card-icon"><i class="fas fa-calendar-times"></i></div>
                            <div class="card-content">
                                <h3>Cancelled/Missed</h3>
                                <div class="card-value">${cancelledAppointments}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Today's Schedule -->
                    <div class="today-schedule">
                        <div class="section-header">
                            <h3>Today's Schedule</h3>
                            <a href="#appointments-section" class="view-all">View All <i class="fas fa-arrow-right"></i></a>
                        </div>
                        <div class="timeline">
                            <c:forEach items="${todayAppointmentsList}" var="appointment">
                                <div class="timeline-item ${appointment.status}">
                                    <div class="timeline-time">${appointment.appointmentTime}</div>
                                    <div class="timeline-content">
                                        <div class="appointment-type">${appointment.appointmentType}</div>
                                        <div class="patient-name">${appointment.patientName}</div>
                                        <div class="appointment-actions">
                                            <button class="btn-view" data-appointment-id="${appointment.id}"><i class="fas fa-eye"></i></button>
                                            <button class="btn-reschedule" data-appointment-id="${appointment.id}"><i class="fas fa-calendar-alt"></i></button>
                                            <button class="btn-cancel" data-appointment-id="${appointment.id}"><i class="fas fa-times"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty todayAppointmentsList}">
                                <div class="empty-schedule">
                                    <i class="far fa-calendar-check"></i>
                                    <p>No appointments scheduled for today</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </section>

                <!-- Profile Section -->
                <section id="profile-section" class="dashboard-section">
                    <!-- Profile content will be loaded here -->
                </section>

                <!-- Appointments Section -->
                <section id="appointments-section" class="dashboard-section">
                    <!-- Appointments content will be loaded here -->
                </section>

                <!-- Patients Section -->
                <section id="patients-section" class="dashboard-section">
                    <!-- Patients content will be loaded here -->
                </section>

                <!-- Availability Section -->
                <section id="availability-section" class="dashboard-section">
                    <!-- Availability content will be loaded here -->
                </section>

                <!-- Health Packages Section -->
                <section id="packages-section" class="dashboard-section">
                    <!-- Health Packages content will be loaded here -->
                </section>

                <!-- Settings Section -->
                <section id="settings-section" class="dashboard-section">
                    <!-- Settings content will be loaded here -->
                </section>
            </div>
        </main>
    </div>

    <!-- Modal Templates -->
    <div class="modal fade" id="appointmentDetailModal" tabindex="-1" aria-hidden="true">
        <!-- Appointment detail modal content -->
    </div>

    <div class="modal fade" id="patientDetailModal" tabindex="-1" aria-hidden="true">
        <!-- Patient detail modal content -->
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.min.js'></script>
    <script src="${pageContext.request.contextPath}/assets/js/doctor-dashboard.js"></script>
