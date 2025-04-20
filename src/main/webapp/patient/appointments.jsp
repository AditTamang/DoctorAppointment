<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - MedDoc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .appointments-container {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            padding: 40px 0;
        }
        
        .appointments-sidebar {
            flex: 1;
            min-width: 300px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
        }
        
        .appointments-content {
            flex: 3;
            min-width: 300px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
        }
        
        .profile-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            margin: 0 auto 20px;
            border: 5px solid var(--primary-color);
        }
        
        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .profile-info {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .profile-info h3 {
            font-size: 1.5rem;
            margin-bottom: 5px;
            color: var(--text-dark);
        }
        
        .profile-info p {
            color: var(--primary-color);
            font-weight: 500;
        }
        
        .profile-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .profile-menu li {
            margin-bottom: 10px;
        }
        
        .profile-menu a {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border-radius: 5px;
            color: var(--text-dark);
            transition: all 0.3s;
            font-weight: 500;
        }
        
        .profile-menu a:hover, .profile-menu a.active {
            background-color: var(--primary-color);
            color: white;
        }
        
        .profile-menu a i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        .appointments-section {
            margin-bottom: 30px;
        }
        
        .appointments-section h2 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: var(--text-dark);
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .appointment-card {
            background-color: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.03);
            transition: all 0.3s;
        }
        
        .appointment-card:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }
        
        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .appointment-doctor {
            display: flex;
            align-items: center;
        }
        
        .doctor-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 15px;
        }
        
        .doctor-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .doctor-info h4 {
            font-size: 1.1rem;
            margin-bottom: 5px;
            color: var(--text-dark);
        }
        
        .doctor-info p {
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        .appointment-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-pending {
            background-color: #fff8e1;
            color: #ffa000;
        }
        
        .status-confirmed {
            background-color: #e8f5e9;
            color: #388e3c;
        }
        
        .status-completed {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .status-cancelled {
            background-color: #ffebee;
            color: #d32f2f;
        }
        
        .appointment-details {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .detail-item h5 {
            font-size: 0.9rem;
            color: var(--text-light);
            margin-bottom: 5px;
        }
        
        .detail-item p {
            font-size: 1rem;
            color: var(--text-dark);
            font-weight: 500;
        }
        
        .appointment-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-view {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-view:hover {
            background-color: var(--primary-dark);
        }
        
        .btn-cancel {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-cancel:hover {
            background-color: #d32f2f;
        }
        
        .btn-reschedule {
            background-color: #ff9800;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-reschedule:hover {
            background-color: #f57c00;
        }
        
        .empty-appointments {
            text-align: center;
            padding: 50px 0;
        }
        
        .empty-appointments i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-appointments h3 {
            font-size: 1.5rem;
            color: var(--text-dark);
            margin-bottom: 10px;
        }
        
        .empty-appointments p {
            color: var(--text-light);
            margin-bottom: 20px;
        }
        
        .btn-book {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-block;
        }
        
        .btn-book:hover {
            background-color: var(--primary-dark);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Med<span>Doc</span></a>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/about-us">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/doctors">Find Doctors</a></li>
                    <li><a href="${pageContext.request.contextPath}/index.jsp#services">Services</a></li>
                    <li><a href="${pageContext.request.contextPath}/index.jsp#contact">Contact</a></li>
                    <% if(session.getAttribute("user") != null) { %>
                        <li><a href="${pageContext.request.contextPath}/appointments" class="active">Appointments</a></li>
                        <li><a href="${pageContext.request.contextPath}/profile">Profile</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="btn btn-primary">Logout</a></li>
                    <% } else { %>
                        <li><a href="${pageContext.request.contextPath}/login" class="login-btn"><i class="fas fa-user"></i></a></li>
                    <% } %>
                </ul>
                <div class="mobile-menu">
                    <i class="fas fa-bars"></i>
                </div>
            </nav>
        </div>
    </header>

    <!-- Page Banner -->
    <section class="page-banner">
        <div class="container">
            <div class="banner-content">
                <h1>My <span>Appointments</span></h1>
                <p>View and manage your medical appointments</p>
                <div class="banner-breadcrumb">
                    <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Appointments</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Appointments Section -->
    <section class="appointments-section">
        <div class="container">
            <div class="appointments-container">
                <div class="appointments-sidebar">
                    <div class="profile-image">
                        <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                    </div>
                    <div class="profile-info">
                        <% User user = (User) session.getAttribute("user"); %>
                        <h3><%= user != null ? user.getUsername() : "Patient" %></h3>
                        <p>Patient</p>
                    </div>
                    <ul class="profile-menu">
                        <li><a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Personal Information</a></li>
                        <li><a href="${pageContext.request.contextPath}/appointments" class="active"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                        <li><a href="#"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                        <li><a href="#"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                        <li><a href="#"><i class="fas fa-bell"></i> Notifications</a></li>
                        <li><a href="#"><i class="fas fa-cog"></i> Settings</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>
                <div class="appointments-content">
                    <div class="appointments-section">
                        <h2>My Appointments</h2>
                        
                        <% 
                        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Appointment appointment : appointments) {
                        %>
                        <div class="appointment-card">
                            <div class="appointment-header">
                                <div class="appointment-doctor">
                                    <div class="doctor-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.jpg" alt="Doctor">
                                    </div>
                                    <div class="doctor-info">
                                        <h4><%= appointment.getDoctorName() %></h4>
                                        <p><%= appointment.getDoctorSpecialization() != null ? appointment.getDoctorSpecialization() : "Specialist" %></p>
                                    </div>
                                </div>
                                <div class="appointment-status status-<%= appointment.getStatus().toLowerCase() %>">
                                    <%= appointment.getStatus() %>
                                </div>
                            </div>
                            <div class="appointment-details">
                                <div class="detail-item">
                                    <h5>Date</h5>
                                    <p><i class="far fa-calendar-alt"></i> <%= appointment.getAppointmentDate() %></p>
                                </div>
                                <div class="detail-item">
                                    <h5>Time</h5>
                                    <p><i class="far fa-clock"></i> <%= appointment.getAppointmentTime() %></p>
                                </div>
                                <div class="detail-item">
                                    <h5>Appointment ID</h5>
                                    <p><i class="fas fa-hashtag"></i> <%= appointment.getId() %></p>
                                </div>
                                <div class="detail-item">
                                    <h5>Fee</h5>
                                    <p><i class="fas fa-dollar-sign"></i> <%= appointment.getFee() %></p>
                                </div>
                            </div>
                            <div class="appointment-actions">
                                <a href="${pageContext.request.contextPath}/appointment/details?id=<%= appointment.getId() %>" class="btn-view">View Details</a>
                                <% if (!"COMPLETED".equals(appointment.getStatus()) && !"CANCELLED".equals(appointment.getStatus())) { %>
                                    <form action="${pageContext.request.contextPath}/appointment/cancel" method="post" style="display: inline;">
                                        <input type="hidden" name="id" value="<%= appointment.getId() %>">
                                        <button type="submit" class="btn-cancel" onclick="return confirm('Are you sure you want to cancel this appointment?')">Cancel</button>
                                    </form>
                                <% } %>
                            </div>
                        </div>
                        <% 
                            }
                        } else {
                        %>
                        <div class="empty-appointments">
                            <i class="far fa-calendar-times"></i>
                            <h3>No Appointments Found</h3>
                            <p>You don't have any appointments scheduled yet.</p>
                            <a href="${pageContext.request.contextPath}/appointment/book" class="btn-book">Book an Appointment</a>
                        </div>
                        <% } %>
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
                    <div class="footer-logo">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="MedDoc Logo">
                        <div class="footer-logo-text">Med<span>Doc</span></div>
                    </div>
                    <p>We are dedicated to providing you with the best medical services. Your health is our priority.</p>
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
                        <li><a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-chevron-right"></i> Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/about-us"><i class="fas fa-chevron-right"></i> About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/doctors"><i class="fas fa-chevron-right"></i> Doctors</a></li>
                        <li><a href="${pageContext.request.contextPath}/index.jsp#services"><i class="fas fa-chevron-right"></i> Services</a></li>
                        <li><a href="${pageContext.request.contextPath}/index.jsp#contact"><i class="fas fa-chevron-right"></i> Contact</a></li>
                        <li><a href="${pageContext.request.contextPath}/login"><i class="fas fa-chevron-right"></i> Login</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h3>Our Services</h3>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/doctors"><i class="fas fa-chevron-right"></i> Find a Doctor</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Book Appointment</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Health Checkup</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Online Prescription</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Emergency Care</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Medical Advice</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h3>Contact Info</h3>
                    <ul class="footer-contact">
                        <li><i class="fas fa-map-marker-alt"></i> 123 MedDoc Center, Health Street, City, Country</li>
                        <li><i class="fas fa-phone"></i> +1 234 567 890</li>
                        <li><i class="fas fa-envelope"></i> info@meddoc.com</li>
                        <li><i class="fas fa-clock"></i> Mon-Fri: 9:00 AM - 7:00 PM</li>
                    </ul>
                    <h3 style="margin-top: 2rem;">Newsletter</h3>
                    <p>Subscribe for health tips and updates</p>
                    <div class="newsletter-form">
                        <input type="email" class="newsletter-input" placeholder="Your Email" required>
                        <button type="submit" class="newsletter-btn"><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2023 MedDoc. All Rights Reserved. | Designed with <i class="fas fa-heart" style="color: #ff6b6b;"></i> by <a href="#">MedDoc Team</a></p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
