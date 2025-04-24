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
    <title>Patient Dashboard - Doctor Appointment System</title>
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
                    <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                </div>
                <div class="user-details">
                    <h4>John Doe</h4>
                    <p>Patient</p>
                </div>
            </div>

            <nav class="sidebar-nav">
                <ul>
                    <li class="active">
                        <a href="#"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-calendar-alt"></i> Appointments</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-user-md"></i> Find Doctors</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-file-medical"></i> Medical Records</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-pills"></i> Prescriptions</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-credit-card"></i> Payments</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-user-edit"></i> Profile</a>
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
                        <input type="text" placeholder="Search doctors, specialties...">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                </div>

                <div class="header-actions">
                    <div class="notification-bell">
                        <i class="fas fa-bell"></i>
                        <span class="badge">2</span>
                    </div>
                    <div class="message-icon">
                        <i class="fas fa-envelope"></i>
                        <span class="badge">1</span>
                    </div>
                    <div class="user-profile">
                        <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                        <span>John Doe</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>Patient Dashboard</h1>
                    <nav class="breadcrumb">
                        <a href="index.jsp">Home</a> /
                        <span>Dashboard</span>
                    </nav>
                </div>

                <!-- Welcome Banner -->
                <div class="welcome-banner">
                    <div class="welcome-content">
                        <h2>Welcome back, ${user != null ? user.username : 'Patient'}!</h2>
                        <c:choose>
                            <c:when test="${nextAppointment != null}">
                                <p>Your next appointment is scheduled for <strong>${nextAppointment.formattedDateTime}</strong> with <strong>Dr. ${nextAppointment.doctorName}</strong>.</p>
                                <div class="welcome-actions">
                                    <a href="appointment/details?id=${nextAppointment.id}" class="btn btn-primary"><i class="fas fa-calendar-check"></i> View Appointment</a>
                                    <a href="appointment/join?id=${nextAppointment.id}" class="btn btn-outline"><i class="fas fa-video"></i> Join Virtual Consultation</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p>You don't have any upcoming appointments. Would you like to schedule one?</p>
                                <div class="welcome-actions">
                                    <a href="appointment/book" class="btn btn-primary"><i class="fas fa-calendar-plus"></i> Book Appointment</a>
                                    <a href="doctors" class="btn btn-outline"><i class="fas fa-user-md"></i> Find Doctors</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="welcome-image">
                        <img src="${pageContext.request.contextPath}/assets/images/patients/p2.png" alt="Welcome">
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <div class="action-card">
                        <div class="action-icon primary">
                            <i class="fas fa-calendar-plus"></i>
                        </div>
                        <div class="action-details">
                            <h3>Book Appointment</h3>
                            <p>Schedule a new appointment with a doctor</p>
                        </div>
                    </div>

                    <div class="action-card">
                        <div class="action-icon success">
                            <i class="fas fa-file-medical"></i>
                        </div>
                        <div class="action-details">
                            <h3>Medical Records</h3>
                            <p>View and download your medical records</p>
                        </div>
                    </div>

                    <div class="action-card">
                        <div class="action-icon warning">
                            <i class="fas fa-pills"></i>
                        </div>
                        <div class="action-details">
                            <h3>Prescriptions</h3>
                            <p>View your current prescriptions</p>
                        </div>
                    </div>

                    <div class="action-card">
                        <div class="action-icon info">
                            <i class="fas fa-comments"></i>
                        </div>
                        <div class="action-details">
                            <h3>Message Doctor</h3>
                            <p>Send a message to your doctor</p>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Appointments and Health Stats -->
                <div class="dashboard-grid">
                    <div class="grid-card">
                        <div class="card-header">
                            <h3>Upcoming Appointments</h3>
                            <a href="#" class="view-all">View All</a>
                        </div>
                        <div class="card-body">
                            <div class="appointment-list">
                                <c:forEach var="appointment" items="${upcomingAppointments}">
                                    <div class="appointment-item">
                                        <div class="appointment-date">
                                            <div class="date-box">
                                                <span class="month">
                                                    <c:choose>
                                                        <c:when test="${appointment.appointmentDate != null}">
                                                            <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM" />
                                                        </c:when>
                                                        <c:otherwise>N/A</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span class="day">
                                                    <c:choose>
                                                        <c:when test="${appointment.appointmentDate != null}">
                                                            <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd" />
                                                        </c:when>
                                                        <c:otherwise>--</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <span class="time">${appointment.appointmentTime}</span>
                                        </div>
                                        <div class="appointment-details">
                                            <div class="doctor-info">
                                                <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Doctor">
                                                <div>
                                                    <h4>${appointment.doctorName}</h4>
                                                    <p>${appointment.doctorSpecialization}</p>
                                                </div>
                                            </div>
                                            <div class="appointment-actions">
                                                <a href="appointment/join?id=${appointment.id}" class="btn-sm btn-outline"><i class="fas fa-video"></i> Video Call</a>
                                                <a href="appointment/cancel?id=${appointment.id}" class="btn-sm btn-outline-danger"><i class="fas fa-times"></i> Cancel</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty upcomingAppointments}">
                                    <div class="text-center p-4">
                                        <p>No upcoming appointments found</p>
                                        <a href="appointment/book" class="btn-sm btn-primary mt-2"><i class="fas fa-calendar-plus"></i> Book Appointment</a>
                                    </div>
                                </c:if>
                            </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid-card">
                        <div class="card-header">
                            <h3>Health Statistics</h3>
                            <div class="card-actions">
                                <button class="btn-outline-sm active">Weekly</button>
                                <button class="btn-outline-sm">Monthly</button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="health-stats">
                                <div class="stat-item">
                                    <div class="stat-icon" style="background-color: rgba(76, 175, 80, 0.1); color: #4CAF50;">
                                        <i class="fas fa-heartbeat"></i>
                                    </div>
                                    <div class="stat-details">
                                        <h4>Heart Rate</h4>
                                        <div class="stat-value">
                                            <span class="value">72</span>
                                            <span class="unit">bpm</span>
                                        </div>
                                        <div class="stat-trend up">
                                            <i class="fas fa-arrow-up"></i>
                                            <span>2%</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-item">
                                    <div class="stat-icon" style="background-color: rgba(33, 150, 243, 0.1); color: #2196F3;">
                                        <i class="fas fa-weight"></i>
                                    </div>
                                    <div class="stat-details">
                                        <h4>Weight</h4>
                                        <div class="stat-value">
                                            <span class="value">68</span>
                                            <span class="unit">kg</span>
                                        </div>
                                        <div class="stat-trend down">
                                            <i class="fas fa-arrow-down"></i>
                                            <span>1.5%</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-item">
                                    <div class="stat-icon" style="background-color: rgba(255, 193, 7, 0.1); color: #FFC107;">
                                        <i class="fas fa-tint"></i>
                                    </div>
                                    <div class="stat-details">
                                        <h4>Blood Pressure</h4>
                                        <div class="stat-value">
                                            <span class="value">120/80</span>
                                            <span class="unit">mmHg</span>
                                        </div>
                                        <div class="stat-trend stable">
                                            <i class="fas fa-equals"></i>
                                            <span>Stable</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="stat-item">
                                    <div class="stat-icon" style="background-color: rgba(233, 30, 99, 0.1); color: #E91E63;">
                                        <i class="fas fa-burn"></i>
                                    </div>
                                    <div class="stat-details">
                                        <h4>Temperature</h4>
                                        <div class="stat-value">
                                            <span class="value">36.6</span>
                                            <span class="unit">°C</span>
                                        </div>
                                        <div class="stat-trend stable">
                                            <i class="fas fa-equals"></i>
                                            <span>Stable</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="health-chart">
                                <div class="chart-title">
                                    <h4>Blood Pressure History</h4>
                                </div>
                                <div class="line-chart">
                                    <div class="chart-lines">
                                        <div class="chart-line" style="--height: 20%"></div>
                                        <div class="chart-line" style="--height: 40%"></div>
                                        <div class="chart-line" style="--height: 60%"></div>
                                        <div class="chart-line" style="--height: 80%"></div>
                                        <div class="chart-line" style="--height: 100%"></div>
                                    </div>
                                    <div class="chart-data">
                                        <div class="data-point" style="--x: 0%; --y: 60%">
                                            <span class="tooltip">120/80</span>
                                        </div>
                                        <div class="data-point" style="--x: 20%; --y: 70%">
                                            <span class="tooltip">125/85</span>
                                        </div>
                                        <div class="data-point" style="--x: 40%; --y: 50%">
                                            <span class="tooltip">118/78</span>
                                        </div>
                                        <div class="data-point" style="--x: 60%; --y: 65%">
                                            <span class="tooltip">122/82</span>
                                        </div>
                                        <div class="data-point" style="--x: 80%; --y: 55%">
                                            <span class="tooltip">119/79</span>
                                        </div>
                                        <div class="data-point" style="--x: 100%; --y: 60%">
                                            <span class="tooltip">120/80</span>
                                        </div>
                                        <div class="data-line"></div>
                                    </div>
                                    <div class="chart-labels">
                                        <span>Mon</span>
                                        <span>Tue</span>
                                        <span>Wed</span>
                                        <span>Thu</span>
                                        <span>Fri</span>
                                        <span>Sat</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Medical Records and Prescriptions -->
                <div class="dashboard-grid">
                    <div class="grid-card">
                        <div class="card-header">
                            <h3>Recent Medical Records</h3>
                            <a href="#" class="view-all">View All</a>
                        </div>
                        <div class="card-body">
                            <div class="medical-records">
                                <c:forEach var="record" items="${recentMedicalRecords}">
                                    <div class="record-item">
                                        <div class="record-icon">
                                            <c:choose>
                                                <c:when test="${record.recordType == 'EXAMINATION'}"><i class="fas fa-file-medical"></i></c:when>
                                                <c:when test="${record.recordType == 'LAB_TEST'}"><i class="fas fa-microscope"></i></c:when>
                                                <c:when test="${record.recordType == 'X_RAY'}"><i class="fas fa-x-ray"></i></c:when>
                                                <c:when test="${record.recordType == 'CONSULTATION'}"><i class="fas fa-notes-medical"></i></c:when>
                                                <c:otherwise><i class="fas fa-file-medical-alt"></i></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="record-details">
                                            <h4>${record.diagnosis}</h4>
                                            <p>${record.doctorName} • ${record.formattedDate}</p>
                                        </div>
                                        <div class="record-actions">
                                            <a href="medical-records/download?id=${record.id}" class="btn-icon"><i class="fas fa-download"></i></a>
                                            <a href="medical-records/view?id=${record.id}" class="btn-icon"><i class="fas fa-eye"></i></a>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty recentMedicalRecords}">
                                    <div class="text-center p-4">
                                        <p>No medical records found</p>
                                    </div>
                                </c:if>
                            </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid-card">
                        <div class="card-header">
                            <h3>Current Prescriptions</h3>
                            <a href="#" class="view-all">View All</a>
                        </div>
                        <div class="card-body">
                            <div class="prescriptions">
                                <c:forEach var="prescription" items="${currentPrescriptions}">
                                    <div class="prescription-item">
                                        <div class="prescription-icon">
                                            <c:choose>
                                                <c:when test="${prescription.medicationName.toLowerCase().contains('pill') || prescription.medicationName.toLowerCase().contains('tablet')}"><i class="fas fa-pills"></i></c:when>
                                                <c:when test="${prescription.medicationName.toLowerCase().contains('capsule')}"><i class="fas fa-capsules"></i></c:when>
                                                <c:when test="${prescription.medicationName.toLowerCase().contains('syrup')}"><i class="fas fa-prescription-bottle"></i></c:when>
                                                <c:otherwise><i class="fas fa-tablets"></i></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="prescription-details">
                                            <h4>${prescription.medicationName}</h4>
                                            <p>${prescription.dosage} • ${prescription.frequency} • ${prescription.duration}</p>
                                            <div class="prescription-meta">
                                                <span><i class="fas fa-calendar-alt"></i> ${prescription.dateRange}</span>
                                                <span><i class="fas fa-user-md"></i> ${prescription.doctorName}</span>
                                            </div>
                                        </div>
                                        <div class="prescription-status">
                                            <c:choose>
                                                <c:when test="${prescription.active}"><span class="status-badge active">Active</span></c:when>
                                                <c:otherwise><span class="status-badge expired">Expired</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty currentPrescriptions}">
                                    <div class="text-center p-4">
                                        <p>No current prescriptions found</p>
                                    </div>
                                </c:if>
                            </div>
                            </div>

                            <div class="prescription-reminder">
                                <div class="reminder-icon">
                                    <i class="fas fa-bell"></i>
                                </div>
                                <div class="reminder-content">
                                    <h4>Medication Reminder</h4>
                                    <p>Set up reminders for your medications to never miss a dose.</p>
                                    <button class="btn-sm btn-primary">Set Reminder</button>
                                </div>
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
