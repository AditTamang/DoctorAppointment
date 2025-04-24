<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | HealthCare</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/dashboard.css">
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
                        <a href="appointments.jsp">
                            <i class="fas fa-calendar-check"></i>
                            <span>My Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="book-appointment.jsp">
                            <i class="fas fa-calendar-plus"></i>
                            <span>Book Appointment</span>
                        </a>
                    </li>
                    <li>
                        <a href="medical-records.jsp">
                            <i class="fas fa-file-medical"></i>
                            <span>Medical Records</span>
                        </a>
                    </li>
                    <li>
                        <a href="prescriptions.jsp">
                            <i class="fas fa-prescription"></i>
                            <span>Prescriptions</span>
                        </a>
                    </li>
                    <li>
                        <a href="messages.jsp">
                            <i class="fas fa-comment-medical"></i>
                            <span>Messages</span>
                            <span class="badge">2</span>
                        </a>
                    </li>
                    <li>
                        <a href="billing.jsp">
                            <i class="fas fa-file-invoice-dollar"></i>
                            <span>Billing</span>
                        </a>
                    </li>
                    <li>
                        <a href="profile.jsp">
                            <i class="fas fa-user"></i>
                            <span>My Profile</span>
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
                        <input type="text" placeholder="Search doctors...">
                    </div>

                    <div class="nav-notifications">
                        <div class="icon-badge">
                            <i class="fas fa-bell"></i>
                            <span class="badge">3</span>
                        </div>
                    </div>

                    <div class="nav-messages">
                        <div class="icon-badge">
                            <i class="fas fa-envelope"></i>
                            <span class="badge">2</span>
                        </div>
                    </div>

                    <div class="nav-user">
                        <img src="../images/patients/patient1.jpg" alt="Patient">
                        <div class="user-info">
                            <h4>Robert Wilson</h4>
                            <p>Patient</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>Patient Dashboard</h1>
                    <p>Welcome back, Robert Wilson</p>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <a href="book-appointment.jsp" class="quick-action-card">
                        <div class="quick-action-icon blue">
                            <i class="fas fa-calendar-plus"></i>
                        </div>
                        <h3>Book Appointment</h3>
                        <p>Schedule a new appointment with a doctor</p>
                    </a>

                    <a href="medical-records.jsp" class="quick-action-card">
                        <div class="quick-action-icon green">
                            <i class="fas fa-file-medical"></i>
                        </div>
                        <h3>Medical Records</h3>
                        <p>View your medical history and reports</p>
                    </a>

                    <a href="prescriptions.jsp" class="quick-action-card">
                        <div class="quick-action-icon purple">
                            <i class="fas fa-prescription"></i>
                        </div>
                        <h3>Prescriptions</h3>
                        <p>Access your current and past prescriptions</p>
                    </a>

                    <a href="messages.jsp" class="quick-action-card">
                        <div class="quick-action-icon orange">
                            <i class="fas fa-comment-medical"></i>
                        </div>
                        <h3>Messages</h3>
                        <p>Communicate with your healthcare providers</p>
                    </a>
                </div>

                <!-- Health Summary -->
                <div class="health-summary">
                    <div class="section-header">
                        <h3>Health Summary</h3>
                        <a href="medical-records.jsp" class="view-all">View Details</a>
                    </div>

                    <div class="health-stats">
                        <div class="health-stat-card">
                            <div class="health-stat-icon">
                                <i class="fas fa-heartbeat"></i>
                            </div>
                            <div class="health-stat-info">
                                <h4>Heart Rate</h4>
                                <div class="health-stat-value">
                                    <h2>78</h2>
                                    <span>bpm</span>
                                </div>
                                <p>Normal range: 60-100 bpm</p>
                                <div class="health-stat-date">Last updated: Apr 15, 2023</div>
                            </div>
                        </div>

                        <div class="health-stat-card">
                            <div class="health-stat-icon">
                                <i class="fas fa-weight"></i>
                            </div>
                            <div class="health-stat-info">
                                <h4>Weight</h4>
                                <div class="health-stat-value">
                                    <h2>75</h2>
                                    <span>kg</span>
                                </div>
                                <p>BMI: 24.5 (Normal)</p>
                                <div class="health-stat-date">Last updated: Apr 10, 2023</div>
                            </div>
                        </div>

                        <div class="health-stat-card">
                            <div class="health-stat-icon">
                                <i class="fas fa-tint"></i>
                            </div>
                            <div class="health-stat-info">
                                <h4>Blood Pressure</h4>
                                <div class="health-stat-value">
                                    <h2>120/80</h2>
                                    <span>mmHg</span>
                                </div>
                                <p>Normal range: 90-120/60-80 mmHg</p>
                                <div class="health-stat-date">Last updated: Apr 15, 2023</div>
                            </div>
                        </div>

                        <div class="health-stat-card">
                            <div class="health-stat-icon">
                                <i class="fas fa-burn"></i>
                            </div>
                            <div class="health-stat-info">
                                <h4>Blood Glucose</h4>
                                <div class="health-stat-value">
                                    <h2>95</h2>
                                    <span>mg/dL</span>
                                </div>
                                <p>Normal range: 70-99 mg/dL</p>
                                <div class="health-stat-date">Last updated: Apr 15, 2023</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Appointments -->
                <div class="upcoming-appointments">
                    <div class="section-header">
                        <h3>Upcoming Appointments</h3>
                        <a href="appointments.jsp" class="view-all">View All</a>
                    </div>

                    <div class="appointment-cards">
                        <div class="appointment-card">
                            <div class="appointment-date">
                                <div class="date-box">
                                    <div class="month">APR</div>
                                    <div class="day">18</div>
                                    <div class="time">10:30 AM</div>
                                </div>
                                <div class="appointment-status confirmed">Confirmed</div>
                            </div>
                            <div class="appointment-details">
                                <div class="doctor-info">
                                    <img src="../images/doctors/doctor1.jpg" alt="Doctor">
                                    <div>
                                        <h4>Dr. John Smith</h4>
                                        <p>Cardiologist</p>
                                    </div>
                                </div>
                                <div class="appointment-type">
                                    <i class="fas fa-heartbeat"></i>
                                    <span>Heart Checkup</span>
                                </div>
                                <div class="appointment-location">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span>Medical Center, Room 205</span>
                                </div>
                            </div>
                            <div class="appointment-actions">
                                <button class="btn btn-outline"><i class="fas fa-video"></i> Join Video</button>
                                <button class="btn btn-outline"><i class="fas fa-calendar-alt"></i> Reschedule</button>
                                <button class="btn btn-outline danger"><i class="fas fa-times"></i> Cancel</button>
                            </div>
                        </div>

                        <div class="appointment-card">
                            <div class="appointment-date">
                                <div class="date-box">
                                    <div class="month">APR</div>
                                    <div class="day">25</div>
                                    <div class="time">2:15 PM</div>
                                </div>
                                <div class="appointment-status pending">Pending</div>
                            </div>
                            <div class="appointment-details">
                                <div class="doctor-info">
                                    <img src="../images/doctors/doctor2.jpg" alt="Doctor">
                                    <div>
                                        <h4>Dr. Sarah Johnson</h4>
                                        <p>Neurologist</p>
                                    </div>
                                </div>
                                <div class="appointment-type">
                                    <i class="fas fa-brain"></i>
                                    <span>Neurological Consultation</span>
                                </div>
                                <div class="appointment-location">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span>Medical Center, Room 310</span>
                                </div>
                            </div>
                            <div class="appointment-actions">
                                <button class="btn btn-outline"><i class="fas fa-calendar-alt"></i> Reschedule</button>
                                <button class="btn btn-outline danger"><i class="fas fa-times"></i> Cancel</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Prescriptions -->
                <div class="recent-prescriptions">
                    <div class="section-header">
                        <h3>Recent Prescriptions</h3>
                        <a href="prescriptions.jsp" class="view-all">View All</a>
                    </div>

                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Medication</th>
                                    <th>Dosage</th>
                                    <th>Prescribed By</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="medication-info">
                                            <div class="medication-icon">
                                                <i class="fas fa-pills"></i>
                                            </div>
                                            <div>
                                                <h4>Lisinopril</h4>
                                                <p>For Hypertension</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>10mg, Once daily</td>
                                    <td>Dr. John Smith</td>
                                    <td>Apr 15, 2023</td>
                                    <td><span class="status-badge active">Active</span></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                            <a href="#" class="btn-icon download"><i class="fas fa-download"></i></a>
                                            <a href="#" class="btn-icon refill"><i class="fas fa-sync-alt"></i></a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="medication-info">
                                            <div class="medication-icon">
                                                <i class="fas fa-pills"></i>
                                            </div>
                                            <div>
                                                <h4>Atorvastatin</h4>
                                                <p>For Cholesterol</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>20mg, Once daily</td>
                                    <td>Dr. John Smith</td>
                                    <td>Apr 15, 2023</td>
                                    <td><span class="status-badge active">Active</span></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                            <a href="#" class="btn-icon download"><i class="fas fa-download"></i></a>
                                            <a href="#" class="btn-icon refill"><i class="fas fa-sync-alt"></i></a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="medication-info">
                                            <div class="medication-icon">
                                                <i class="fas fa-pills"></i>
                                            </div>
                                            <div>
                                                <h4>Aspirin</h4>
                                                <p>For Blood Thinning</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>81mg, Once daily</td>
                                    <td>Dr. John Smith</td>
                                    <td>Apr 15, 2023</td>
                                    <td><span class="status-badge active">Active</span></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                            <a href="#" class="btn-icon download"><i class="fas fa-download"></i></a>
                                            <a href="#" class="btn-icon refill"><i class="fas fa-sync-alt"></i></a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="medication-info">
                                            <div class="medication-icon">
                                                <i class="fas fa-pills"></i>
                                            </div>
                                            <div>
                                                <h4>Amoxicillin</h4>
                                                <p>For Infection</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>500mg, Three times daily</td>
                                    <td>Dr. Sarah Johnson</td>
                                    <td>Mar 28, 2023</td>
                                    <td><span class="status-badge completed">Completed</span></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-icon view"><i class="fas fa-eye"></i></a>
                                            <a href="#" class="btn-icon download"><i class="fas fa-download"></i></a>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Health Tips -->
                <div class="health-tips">
                    <div class="section-header">
                        <h3>Health Tips For You</h3>
                    </div>

                    <div class="tips-container">
                        <div class="tip-card">
                            <div class="tip-icon">
                                <i class="fas fa-heart"></i>
                            </div>
                            <h4>Heart Health</h4>
                            <p>Regular exercise, a balanced diet, and stress management can significantly improve your heart health.</p>
                            <a href="#" class="read-more">Read More</a>
                        </div>

                        <div class="tip-card">
                            <div class="tip-icon">
                                <i class="fas fa-apple-alt"></i>
                            </div>
                            <h4>Healthy Diet</h4>
                            <p>Include more fruits, vegetables, and whole grains in your diet to maintain optimal health.</p>
                            <a href="#" class="read-more">Read More</a>
                        </div>

                        <div class="tip-card">
                            <div class="tip-icon">
                                <i class="fas fa-running"></i>
                            </div>
                            <h4>Regular Exercise</h4>
                            <p>Aim for at least 30 minutes of moderate exercise most days of the week.</p>
                            <a href="#" class="read-more">Read More</a>
                        </div>

                        <div class="tip-card">
                            <div class="tip-icon">
                                <i class="fas fa-bed"></i>
                            </div>
                            <h4>Quality Sleep</h4>
                            <p>Aim for 7-9 hours of quality sleep each night to support overall health and well-being.</p>
                            <a href="#" class="read-more">Read More</a>
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

    <script>
        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.dashboard-sidebar').classList.toggle('active');
        });

        document.getElementById('sidebarClose').addEventListener('click', function() {
            document.querySelector('.dashboard-sidebar').classList.remove('active');
        });
    </script>
</body>
</html>
