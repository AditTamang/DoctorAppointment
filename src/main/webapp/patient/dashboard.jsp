<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect("../login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <nav class="navbar">
                <a href="../index.jsp" class="logo">Health<span>Care</span></a>
                <ul class="nav-links">
                    <li><a href="../index.jsp">Home</a></li>
                    <li><a href="../doctors">Doctors</a></li>
                    <li><a href="../appointments">Appointments</a></li>
                    <li><a href="../profile">Profile</a></li>
                    <li><a href="../logout" class="btn btn-primary">Logout</a></li>
                </ul>
                <div class="mobile-menu">
                    <i class="fas fa-bars"></i>
                </div>
            </nav>
        </div>
    </header>

    <!-- Dashboard Section -->
    <section class="dashboard">
        <div class="container">
            <div class="dashboard-header">
                <h2 class="dashboard-title">Patient Dashboard</h2>
                <div>
                    <a href="../doctors" class="btn btn-primary">Find a Doctor</a>
                </div>
            </div>

            <div class="dashboard-container">
                <div class="dashboard-sidebar">
                    <ul class="dashboard-menu">
                        <li><a href="dashboard.jsp" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li><a href="../appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                        <li><a href="../profile"><i class="fas fa-user"></i> My Profile</a></li>
                        <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>

                <div class="dashboard-content">
                    <div class="stats-container">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-value">0</div>
                            <div class="stat-label">Total Appointments</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-value">0</div>
                            <div class="stat-label">Pending Appointments</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-value">0</div>
                            <div class="stat-label">Completed Appointments</div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3>Recent Appointments</h3>
                        </div>
                        <div class="card-body">
                            <div class="table-container">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Doctor</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="5" class="text-center">No appointments found.</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer">
                            <a href="../appointments" class="btn btn-outline">View All Appointments</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-container">
                <div class="footer-col">
                    <h3>HealthCare</h3>
                    <p>We are dedicated to providing you with the best healthcare services. Your health is our priority.</p>
                    <ul class="social-links">
                        <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                        <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                        <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                        <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h3>Quick Links</h3>
                    <ul class="footer-links">
                        <li><a href="../index.jsp">Home</a></li>
                        <li><a href="../doctors">Doctors</a></li>
                        <li><a href="../appointments">Appointments</a></li>
                        <li><a href="../profile">Profile</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h3>Contact Us</h3>
                    <p><i class="fas fa-map-marker-alt"></i> 123 Medical Center, Health Street, City</p>
                    <p><i class="fas fa-phone"></i> +1 234 567 890</p>
                    <p><i class="fas fa-envelope"></i> info@healthcare.com</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2023 HealthCare. All Rights Reserved.</p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
