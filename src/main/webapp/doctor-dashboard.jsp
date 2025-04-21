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
    <title>Doctor Dashboard - Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
   <style>
        <%@include file="./assets/css/style.css"%>
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
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
                    <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Doctor">
                </div>
                <div class="user-details">
                    <h4>${doctor != null ? 'Dr. ' + doctor.name : 'Doctor'}</h4>
                    <p>${doctor != null ? doctor.specialization : 'Specialist'}</p>
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
                        <a href="#"><i class="fas fa-users"></i> My Patients</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-clock"></i> Schedule</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-file-medical"></i> Medical Records</a>
                    </li>
                    <li>
                        <a href="#"><i class="fas fa-comments"></i> Messages</a>
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
                        <input type="text" placeholder="Search patients...">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                </div>

                <div class="header-actions">
                    <div class="notification-bell">
                        <i class="fas fa-bell"></i>
                        <span class="badge">4</span>
                    </div>
                    <div class="message-icon">
                        <i class="fas fa-envelope"></i>
                        <span class="badge">3</span>
                    </div>
                    <div class="user-profile">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Doctor">
                        <span>${user != null ? user.username : 'Doctor'}</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>Doctor Dashboard</h1>
                    <nav class="breadcrumb">
                        <a href="index.jsp">Home</a> /
                        <span>Dashboard</span>
                    </nav>
                </div>

                <!-- Today's Schedule -->
                <div class="today-schedule">
                    <div class="schedule-header">
                        <div class="schedule-date">
                            <h2>Today's Schedule</h2>
                            <p>April 17, 2023</p>
                        </div>
                        <div class="schedule-actions">
                            <button class="btn-outline"><i class="fas fa-calendar-alt"></i> View Full Schedule</button>
                        </div>
                    </div>

                    <div class="schedule-timeline">
                        <div class="timeline-header">
                            <div class="time-slots">
                                <span>8:00</span>
                                <span>9:00</span>
                                <span>10:00</span>
                                <span>11:00</span>
                                <span>12:00</span>
                                <span>13:00</span>
                                <span>14:00</span>
                                <span>15:00</span>
                                <span>16:00</span>
                                <span>17:00</span>
                            </div>
                        </div>

                        <div class="timeline-body">
                            <div class="timeline-ruler">
                                <div class="ruler-line"></div>
                                <div class="current-time" style="left: 42%">
                                    <div class="time-indicator"></div>
                                    <span class="time-label">10:05 AM</span>
                                </div>
                            </div>

                            <div class="appointment-slots">
                                <div class="appointment-item" style="left: 10%; width: 15%;">
                                    <div class="appointment-card completed">
                                        <div class="appointment-time">8:30 - 9:00 AM</div>
                                        <div class="appointment-patient">
                                            <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                                            <div>
                                                <h4>John Doe</h4>
                                                <p>Regular Checkup</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="appointment-item" style="left: 30%; width: 15%;">
                                    <div class="appointment-card active">
                                        <div class="appointment-time">10:00 - 10:30 AM</div>
                                        <div class="appointment-patient">
                                            <img src="${pageContext.request.contextPath}/assets/images/patients/p2.png" alt="Patient">
                                            <div>
                                                <h4>Emily Parker</h4>
                                                <p>Heart Consultation</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="appointment-item" style="left: 50%; width: 15%;">
                                    <div class="appointment-card">
                                        <div class="appointment-time">12:00 - 12:30 PM</div>
                                        <div class="appointment-patient">
                                            <img src="${pageContext.request.contextPath}/assets/images/patients/p3.png" alt="Patient">
                                            <div>
                                                <h4>David Thompson</h4>
                                                <p>Follow-up</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="appointment-item" style="left: 70%; width: 15%;">
                                    <div class="appointment-card">
                                        <div class="appointment-time">2:30 - 3:00 PM</div>
                                        <div class="appointment-patient">
                                            <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                                            <div>
                                                <h4>Sarah Wilson</h4>
                                                <p>New Patient</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="stats-cards">
                    <div class="stat-card primary">
                        <div class="stat-card-icon">
                            <i class="fas fa-user-injured"></i>
                        </div>
                        <div class="stat-card-info">
                            <h2>${totalPatients != null ? totalPatients : 0}</h2>
                            <p>Total Patients</p>
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
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-card-info">
                            <h2>${weeklyAppointments != null ? weeklyAppointments : 0}</h2>
                            <p>Appointments This Week</p>
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
                            <i class="fas fa-procedures"></i>
                        </div>
                        <div class="stat-card-info">
                            <h2>${pendingReports != null ? pendingReports : 0}</h2>
                            <p>Pending Reports</p>
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
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="stat-card-info">
                            <h2>${averageRating != null ? averageRating : 0.0}</h2>
                            <p>Average Rating</p>
                        </div>
                        <div class="stat-card-progress">
                            <div class="progress-bar" style="width: 85%"></div>
                        </div>
                        <div class="stat-card-link">
                            <a href="#">View Reviews <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                </div>

                <!-- Patient List and Upcoming Appointments -->
                <div class="dashboard-grid">
                    <div class="grid-card">
                        <div class="card-header">
                            <h3>Recent Patients</h3>
                            <a href="#" class="view-all">View All</a>
                        </div>
                        <div class="card-body">
                            <div class="patient-list">
                                <div class="patient-item">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                                    </div>
                                    <div class="patient-info">
                                        <h4>John Doe</h4>
                                        <p>42 years • Male • Heart Patient</p>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-alt"></i> Last Visit: 10 Apr 2023</span>
                                            <span><i class="fas fa-phone"></i> +1 234 567 890</span>
                                        </div>
                                    </div>
                                    <div class="patient-actions">
                                        <button class="btn-icon"><i class="fas fa-eye"></i></button>
                                        <button class="btn-icon"><i class="fas fa-file-medical"></i></button>
                                        <button class="btn-icon"><i class="fas fa-comment"></i></button>
                                    </div>
                                </div>

                                <div class="patient-item">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/p2.png" alt="Patient">
                                    </div>
                                    <div class="patient-info">
                                        <h4>Emily Parker</h4>
                                        <p>35 years • Female • Hypertension</p>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-alt"></i> Last Visit: 15 Apr 2023</span>
                                            <span><i class="fas fa-phone"></i> +1 345 678 901</span>
                                        </div>
                                    </div>
                                    <div class="patient-actions">
                                        <button class="btn-icon"><i class="fas fa-eye"></i></button>
                                        <button class="btn-icon"><i class="fas fa-file-medical"></i></button>
                                        <button class="btn-icon"><i class="fas fa-comment"></i></button>
                                    </div>
                                </div>

                                <div class="patient-item">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/p3.png" alt="Patient">
                                    </div>
                                    <div class="patient-info">
                                        <h4>David Thompson</h4>
                                        <p>28 years • Male • Post Surgery</p>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-alt"></i> Last Visit: 12 Apr 2023</span>
                                            <span><i class="fas fa-phone"></i> +1 456 789 012</span>
                                        </div>
                                    </div>
                                    <div class="patient-actions">
                                        <button class="btn-icon"><i class="fas fa-eye"></i></button>
                                        <button class="btn-icon"><i class="fas fa-file-medical"></i></button>
                                        <button class="btn-icon"><i class="fas fa-comment"></i></button>
                                    </div>
                                </div>

                                <div class="patient-item">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                                    </div>
                                    <div class="patient-info">
                                        <h4>Sarah Wilson</h4>
                                        <p>45 years • Female • Diabetes</p>
                                        <div class="patient-meta">
                                            <span><i class="fas fa-calendar-alt"></i> Last Visit: 5 Apr 2023</span>
                                            <span><i class="fas fa-phone"></i> +1 567 890 123</span>
                                        </div>
                                    </div>
                                    <div class="patient-actions">
                                        <button class="btn-icon"><i class="fas fa-eye"></i></button>
                                        <button class="btn-icon"><i class="fas fa-file-medical"></i></button>
                                        <button class="btn-icon"><i class="fas fa-comment"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid-card">
                        <div class="card-header">
                            <h3>Upcoming Appointments</h3>
                            <a href="#" class="view-all">View All</a>
                        </div>
                        <div class="card-body">
                            <div class="appointment-list">
                                <div class="appointment-item">
                                    <div class="appointment-date">
                                        <div class="date-box">
                                            <span class="month">APR</span>
                                            <span class="day">17</span>
                                        </div>
                                        <span class="time">10:00 AM</span>
                                    </div>
                                    <div class="appointment-details">
                                        <div class="patient-info">
                                            <img src="${pageContext.request.contextPath}/assets/images/patients/p2.png" alt="Patient">
                                            <div>
                                                <h4>Emily Parker</h4>
                                                <p>Heart Consultation</p>
                                            </div>
                                        </div>
                                        <div class="appointment-actions">
                                            <button class="btn-sm btn-outline"><i class="fas fa-video"></i> Video Call</button>
                                            <button class="btn-sm btn-outline-danger"><i class="fas fa-times"></i> Cancel</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="appointment-item">
                                    <div class="appointment-date">
                                        <div class="date-box">
                                            <span class="month">APR</span>
                                            <span class="day">17</span>
                                        </div>
                                        <span class="time">12:00 PM</span>
                                    </div>
                                    <div class="appointment-details">
                                        <div class="patient-info">
                                            <img src="${pageContext.request.contextPath}/assets/images/patients/p3.png" alt="Patient">
                                            <div>
                                                <h4>David Thompson</h4>
                                                <p>Follow-up</p>
                                            </div>
                                        </div>
                                        <div class="appointment-actions">
                                            <button class="btn-sm btn-outline"><i class="fas fa-video"></i> Video Call</button>
                                            <button class="btn-sm btn-outline-danger"><i class="fas fa-times"></i> Cancel</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="appointment-item">
                                    <div class="appointment-date">
                                        <div class="date-box">
                                            <span class="month">APR</span>
                                            <span class="day">17</span>
                                        </div>
                                        <span class="time">2:30 PM</span>
                                    </div>
                                    <div class="appointment-details">
                                        <div class="patient-info">
                                            <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                                            <div>
                                                <h4>Sarah Wilson</h4>
                                                <p>New Patient</p>
                                            </div>
                                        </div>
                                        <div class="appointment-actions">
                                            <button class="btn-sm btn-outline"><i class="fas fa-video"></i> Video Call</button>
                                            <button class="btn-sm btn-outline-danger"><i class="fas fa-times"></i> Cancel</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="appointment-item">
                                    <div class="appointment-date">
                                        <div class="date-box">
                                            <span class="month">APR</span>
                                            <span class="day">18</span>
                                        </div>
                                        <span class="time">9:15 AM</span>
                                    </div>
                                    <div class="appointment-details">
                                        <div class="patient-info">
                                            <img src="${pageContext.request.contextPath}/assets/images/patients/p2.png" alt="Patient">
                                            <div>
                                                <h4>Robert Johnson</h4>
                                                <p>Heart Checkup</p>
                                            </div>
                                        </div>
                                        <div class="appointment-actions">
                                            <button class="btn-sm btn-outline"><i class="fas fa-video"></i> Video Call</button>
                                            <button class="btn-sm btn-outline-danger"><i class="fas fa-times"></i> Cancel</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Performance Chart and Messages -->
                <div class="dashboard-grid">
                    <div class="grid-card">
                        <div class="card-header">
                            <h3>Performance Overview</h3>
                            <div class="card-actions">
                                <button class="btn-outline-sm active">Weekly</button>
                                <button class="btn-outline-sm">Monthly</button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="performance-chart">
                                <div class="chart-container">
                                    <div class="chart-bars">
                                        <div class="chart-bar">
                                            <div class="bar-group">
                                                <div class="bar-item" style="height: 70%" data-value="28"></div>
                                                <div class="bar-item secondary" style="height: 50%" data-value="20"></div>
                                            </div>
                                            <span class="bar-label">Mon</span>
                                        </div>
                                        <div class="chart-bar">
                                            <div class="bar-group">
                                                <div class="bar-item" style="height: 85%" data-value="34"></div>
                                                <div class="bar-item secondary" style="height: 65%" data-value="26"></div>
                                            </div>
                                            <span class="bar-label">Tue</span>
                                        </div>
                                        <div class="chart-bar">
                                            <div class="bar-group">
                                                <div class="bar-item" style="height: 60%" data-value="24"></div>
                                                <div class="bar-item secondary" style="height: 45%" data-value="18"></div>
                                            </div>
                                            <span class="bar-label">Wed</span>
                                        </div>
                                        <div class="chart-bar">
                                            <div class="bar-group">
                                                <div class="bar-item" style="height: 90%" data-value="36"></div>
                                                <div class="bar-item secondary" style="height: 75%" data-value="30"></div>
                                            </div>
                                            <span class="bar-label">Thu</span>
                                        </div>
                                        <div class="chart-bar">
                                            <div class="bar-group">
                                                <div class="bar-item" style="height: 75%" data-value="30"></div>
                                                <div class="bar-item secondary" style="height: 60%" data-value="24"></div>
                                            </div>
                                            <span class="bar-label">Fri</span>
                                        </div>
                                        <div class="chart-bar">
                                            <div class="bar-group">
                                                <div class="bar-item" style="height: 45%" data-value="18"></div>
                                                <div class="bar-item secondary" style="height: 30%" data-value="12"></div>
                                            </div>
                                            <span class="bar-label">Sat</span>
                                        </div>
                                        <div class="chart-bar">
                                            <div class="bar-group">
                                                <div class="bar-item" style="height: 30%" data-value="12"></div>
                                                <div class="bar-item secondary" style="height: 20%" data-value="8"></div>
                                            </div>
                                            <span class="bar-label">Sun</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="chart-legend">
                                    <div class="legend-item">
                                        <span class="legend-color primary"></span>
                                        <span class="legend-label">Appointments</span>
                                    </div>
                                    <div class="legend-item">
                                        <span class="legend-color secondary"></span>
                                        <span class="legend-label">Completed</span>
                                    </div>
                                </div>
                            </div>
                            <div class="performance-stats">
                                <div class="stat-item">
                                    <h4>182</h4>
                                    <p>Total Appointments</p>
                                    <div class="stat-trend up">
                                        <i class="fas fa-arrow-up"></i>
                                        <span>12% from last month</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <h4>138</h4>
                                    <p>Completed</p>
                                    <div class="stat-trend up">
                                        <i class="fas fa-arrow-up"></i>
                                        <span>8% from last month</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <h4>24</h4>
                                    <p>Cancelled</p>
                                    <div class="stat-trend down">
                                        <i class="fas fa-arrow-down"></i>
                                        <span>3% from last month</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <h4>20</h4>
                                    <p>No-shows</p>
                                    <div class="stat-trend down">
                                        <i class="fas fa-arrow-down"></i>
                                        <span>5% from last month</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid-card">
                        <div class="card-header">
                            <h3>Recent Messages</h3>
                            <a href="#" class="view-all">View All</a>
                        </div>
                        <div class="card-body">
                            <div class="message-list">
                                <div class="message-item unread">
                                    <div class="message-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/p2.png" alt="Patient">
                                    </div>
                                    <div class="message-content">
                                        <div class="message-header">
                                            <h4>Emily Parker</h4>
                                            <span class="message-time">10:30 AM</span>
                                        </div>
                                        <p>Hello Dr. Smith, I have a question about my medication. Is it normal to feel dizzy after taking it?</p>
                                    </div>
                                </div>

                                <div class="message-item">
                                    <div class="message-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                                    </div>
                                    <div class="message-content">
                                        <div class="message-header">
                                            <h4>John Doe</h4>
                                            <span class="message-time">Yesterday</span>
                                        </div>
                                        <p>Thank you for the appointment yesterday. I'm feeling much better already!</p>
                                    </div>
                                </div>

                                <div class="message-item">
                                    <div class="message-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/doctors/d2.png" alt="Staff">
                                    </div>
                                    <div class="message-content">
                                        <div class="message-header">
                                            <h4>Nurse Johnson</h4>
                                            <span class="message-time">Yesterday</span>
                                        </div>
                                        <p>Dr. Smith, the lab results for patient David Thompson are ready. Would you like me to schedule a follow-up?</p>
                                    </div>
                                </div>

                                <div class="message-item">
                                    <div class="message-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/p3.png" alt="Patient">
                                    </div>
                                    <div class="message-content">
                                        <div class="message-header">
                                            <h4>Sarah Wilson</h4>
                                            <span class="message-time">2 days ago</span>
                                        </div>
                                        <p>I need to reschedule my appointment for next week. Is there any availability on Thursday instead?</p>
                                    </div>
                                </div>
                            </div>

                            <div class="quick-reply">
                                <form>
                                    <input type="text" placeholder="Type a message...">
                                    <button type="submit"><i class="fas fa-paper-plane"></i></button>
                                </form>
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