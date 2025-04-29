<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Doctor" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Details - Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        <%@include file="./assets/css/style.css"%>
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <nav class="navbar">
                <a href="../index.jsp" class="logo">Health<span>Care</span></a>
                <ul class="nav-links">
                    <li><a href="../index.jsp">Home</a></li>
                    <li><a href="../doctors" class="active">Find Doctors</a></li>
                    <li><a href="about-us.jsp">Find Doctors</a></li>
                    <li><a href="../index.jsp#services">Services</a></li>
                    <li><a href="../index.jsp#contact">Contact</a></li>
                    <% if(session.getAttribute("user") != null) { %>
                        <li><a href="../dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                        <li><a href="../appointments">Appointments</a></li>
                        <li><a href="../profile-redirect">Profile</a></li>
                        <li><a href="../logout" class="btn btn-primary">Logout</a></li>
                    <% } else { %>
                        <li><a href="../login" class="login-btn"><i class="fas fa-user"></i></a></li>
                    <% } %>
                </ul>
                <div class="mobile-menu">
                    <i class="fas fa-bars"></i>
                </div>
            </nav>
        </div>
    </header>

    <!-- Doctor Details Section -->
    <section class="py-5" style="margin-top: 70px;">
        <div class="container">
            <%
            Doctor doctor = (Doctor) request.getAttribute("doctor");
            if(doctor != null) {
            %>
            <!-- Breadcrumb -->
            <div style="margin-bottom: 2rem;">
                <ul style="display: flex; list-style: none; gap: 0.5rem; align-items: center;">
                    <li><a href="../index.jsp" style="color: #666;">Home</a></li>
                    <li><i class="fas fa-chevron-right" style="font-size: 0.7rem; color: #666;"></i></li>
                    <li><a href="../doctors" style="color: #666;">Doctors</a></li>
                    <li><i class="fas fa-chevron-right" style="font-size: 0.7rem; color: #666;"></i></li>
                    <li><span style="color: var(--primary-color);"><%= doctor.getName() %></span></li>
                </ul>
            </div>

            <div class="doctor-details">
                <div class="doctor-profile-img">
                    <img src="../<%= doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? doctor.getImageUrl() : "images/doctor-placeholder.jpg" %>" alt="<%= doctor.getName() %>">

                    <!-- Doctor Rating -->
                    <div style="position: absolute; bottom: 20px; left: 20px; background: rgba(255, 255, 255, 0.9); padding: 0.5rem 1rem; border-radius: 50px; display: flex; align-items: center; z-index: 2;">
                        <i class="fas fa-star" style="color: #ffc107; margin-right: 5px;"></i>
                        <span style="font-weight: 600;">4.8</span>
                        <span style="color: #666; margin-left: 5px; font-size: 0.9rem;">(120 reviews)</span>
                    </div>
                </div>

                <div class="doctor-profile-info">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                        <h2><%= doctor.getName() %></h2>
                        <div style="display: flex; gap: 0.5rem;">
                            <a href="#" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: 50%; background-color: rgba(78, 84, 200, 0.1); color: var(--primary-color);">
                                <i class="fas fa-share-alt"></i>
                            </a>
                            <a href="#" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: 50%; background-color: rgba(78, 84, 200, 0.1); color: var(--primary-color);">
                                <i class="far fa-heart"></i>
                            </a>
                        </div>
                    </div>

                    <p class="specialization"><%= doctor.getSpecialization() %></p>

                    <!-- Quick Info -->
                    <div style="display: flex; flex-wrap: wrap; gap: 1.5rem; margin-bottom: 2rem;">
                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background-color: rgba(78, 84, 200, 0.1); display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-briefcase" style="color: var(--primary-color);"></i>
                            </div>
                            <div>
                                <div style="font-size: 0.9rem; color: #666;">Experience</div>
                                <div style="font-weight: 600;"><%= doctor.getExperience() %> years</div>
                            </div>
                        </div>

                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background-color: rgba(78, 84, 200, 0.1); display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-money-bill-wave" style="color: var(--primary-color);"></i>
                            </div>
                            <div>
                                <div style="font-size: 0.9rem; color: #666;">Consultation Fee</div>
                                <div style="font-weight: 600;"><%= doctor.getConsultationFee() %></div>
                            </div>
                        </div>

                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background-color: rgba(78, 84, 200, 0.1); display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-clock" style="color: var(--primary-color);"></i>
                            </div>
                            <div>
                                <div style="font-size: 0.9rem; color: #666;">Availability</div>
                                <div style="font-weight: 600;"><%= doctor.getAvailableDays() %></div>
                            </div>
                        </div>
                    </div>

                    <!-- Tabs -->
                    <div style="margin-bottom: 2rem;">
                        <div style="display: flex; border-bottom: 1px solid #eee;">
                            <div style="padding: 1rem 1.5rem; border-bottom: 3px solid var(--primary-color); font-weight: 600; color: var(--primary-color);">Overview</div>
                            <div style="padding: 1rem 1.5rem; color: #666;">Reviews</div>
                            <div style="padding: 1rem 1.5rem; color: #666;">Location</div>
                        </div>

                        <div style="padding: 1.5rem 0;">
                            <h3 style="font-size: 1.2rem; margin-bottom: 1rem; color: var(--dark-color);">About Doctor</h3>
                            <p style="color: #666; line-height: 1.7; margin-bottom: 1.5rem;">Dr. <%= doctor.getName() %> is a highly skilled <%= doctor.getSpecialization() %> with <%= doctor.getExperience() %> years of experience. <%= doctor.getQualification() %>. Specializing in comprehensive care, Dr. <%= doctor.getName() %> is dedicated to providing personalized treatment plans for each patient.</p>

                            <h3 style="font-size: 1.2rem; margin-bottom: 1rem; color: var(--dark-color);">Contact Information</h3>

                            <div class="doctor-meta">
                                <div class="doctor-meta-item">
                                    <div class="doctor-meta-icon">
                                        <i class="fas fa-envelope"></i>
                                    </div>
                                    <div class="doctor-meta-content">
                                        <span class="doctor-meta-label">Email</span>
                                        <span class="doctor-meta-value"><%= doctor.getEmail() %></span>
                                    </div>
                                </div>

                                <div class="doctor-meta-item">
                                    <div class="doctor-meta-icon">
                                        <i class="fas fa-phone"></i>
                                    </div>
                                    <div class="doctor-meta-content">
                                        <span class="doctor-meta-label">Phone</span>
                                        <span class="doctor-meta-value"><%= doctor.getPhone() %></span>
                                    </div>
                                </div>

                                <div class="doctor-meta-item">
                                    <div class="doctor-meta-icon">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div class="doctor-meta-content">
                                        <span class="doctor-meta-label">Address</span>
                                        <span class="doctor-meta-value"><%= doctor.getAddress() %></span>
                                    </div>
                                </div>

                                <div class="doctor-meta-item">
                                    <div class="doctor-meta-icon">
                                        <i class="fas fa-calendar-alt"></i>
                                    </div>
                                    <div class="doctor-meta-content">
                                        <span class="doctor-meta-label">Available Days</span>
                                        <span class="doctor-meta-value"><%= doctor.getAvailableDays() %></span>
                                    </div>
                                </div>

                                <div class="doctor-meta-item">
                                    <div class="doctor-meta-icon">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div class="doctor-meta-content">
                                        <span class="doctor-meta-label">Available Time</span>
                                        <span class="doctor-meta-value"><%= doctor.getAvailableTime() %></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Book Appointment Button -->
                    <div style="display: flex; gap: 1rem;">
                        <% if(session.getAttribute("user") != null) { %>
                            <a href="../appointment/book?doctorId=<%= doctor.getId() %>" class="btn btn-primary" style="flex: 1; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                                <i class="fas fa-calendar-check"></i> Book Appointment
                            </a>
                            <a href="tel:<%= doctor.getPhone() %>" class="btn btn-outline" style="width: 50px; height: 50px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 50%;">
                                <i class="fas fa-phone"></i>
                            </a>
                        <% } else { %>
                            <a href="../login" class="btn btn-primary" style="flex: 1; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                                <i class="fas fa-user"></i> Login to Book Appointment
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="card" style="padding: 4rem; text-align: center; margin-top: 2rem;">
                <div style="font-size: 5rem; color: #ddd; margin-bottom: 1.5rem;">
                    <i class="fas fa-user-md"></i>
                </div>
                <h2 style="margin-bottom: 1rem; color: var(--dark-color); font-size: 2rem;">Doctor Not Found</h2>
                <p style="color: #666; margin-bottom: 2rem; font-size: 1.1rem;">The doctor you are looking for does not exist or has been removed.</p>
                <a href="../doctors" class="btn btn-primary">View All Doctors</a>
            </div>
            <% } %>
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
                        <li><a href="../index.jsp#services">Services</a></li>
                        <li><a href="../doctors">Doctors</a></li>
                        <li><a href="../index.jsp#contact">Contact</a></li>
                        <li><a href="../login">Login</a></li>
                        <li><a href="../register">Register</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h3>Services</h3>
                    <ul class="footer-links">
                        <li><a href="#">Find a Doctor</a></li>
                        <li><a href="#">Book Appointment</a></li>
                        <li><a href="#">Health Checkup</a></li>
                        <li><a href="#">Online Prescription</a></li>
                        <li><a href="#">Emergency Care</a></li>
                        <li><a href="#">Medical Advice</a></li>
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

    <script src="../js/script.js"></script>
</body>
</html>
