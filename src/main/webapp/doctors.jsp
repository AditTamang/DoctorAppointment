<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Doctors - MedDoc</title>
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
                <a href="index.jsp" class="logo">Med<span>Doc</span></a>
                <ul class="nav-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="about-us">About Us</a></li>
                    <li><a href="doctors" class="active">Find Doctors</a></li>
                    <li><a href="index.jsp#services">Services</a></li>
                    <li><a href="index.jsp#contact">Contact</a></li>
                    <% if(session.getAttribute("user") != null) { %>
                        <li><a href="appointments">Appointments</a></li>
                        <li><a href="profile">Profile</a></li>
                        <li><a href="logout" class="btn btn-primary">Logout</a></li>
                    <% } else { %>
                        <li><a href="login" class="login-btn"><i class="fas fa-user"></i></a></li>
                    <% } %>
                </ul>
                <div class="mobile-menu">
                    <i class="fas fa-bars"></i>
                </div>
            </nav>
        </div>
    </header>

    <!-- Hero Banner -->
    <section class="page-banner">
        <div class="container">
            <div class="banner-content">
                <h1>Find Your <span>Doctor</span></h1>
                <p>Discover the best medical professionals and book your appointment today.</p>
                <div class="banner-breadcrumb">
                    <a href="index.jsp">Home</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Find Doctors</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Doctors Section -->
    <section class="doctors-page">
        <div class="container">
            <div class="section-title">
                <h2>Expert <span>Specialists</span></h2>
                <p>Choose from our network of highly qualified medical professionals.</p>
            </div>

            <!-- Search and Filter Section -->
            <div class="search-filter-card">
                <div class="search-filter-body">
                    <form action="doctors" method="get" id="doctorFilterForm">
                        <div class="search-filter-grid">
                            <div class="search-filter-item search-item">
                                <label for="search">Search Doctor</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="search" name="search" placeholder="Search by name or specialty" class="form-control">
                                </div>
                            </div>

                            <div class="search-filter-item">
                                <label for="specialization">Specialization</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-stethoscope"></i>
                                    <select id="specialization" name="specialization" class="form-control">
                                        <option value="">All Specializations</option>
                                        <option value="Cardiologist" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Cardiologist") ? "selected" : "" %>>Cardiologist</option>
                                        <option value="Neurologist" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Neurologist") ? "selected" : "" %>>Neurologist</option>
                                        <option value="Orthopedic" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Orthopedic") ? "selected" : "" %>>Orthopedic</option>
                                        <option value="Dermatologist" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Dermatologist") ? "selected" : "" %>>Dermatologist</option>
                                        <option value="Pediatrician" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Pediatrician") ? "selected" : "" %>>Pediatrician</option>
                                        <option value="Gynecologist" <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Gynecologist") ? "selected" : "" %>>Gynecologist</option>
                                    </select>
                                </div>
                            </div>

                            <div class="search-filter-item">
                                <label for="experience">Experience</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-briefcase"></i>
                                    <select id="experience" name="experience" class="form-control">
                                        <option value="">Any Experience</option>
                                        <option value="0-5">0-5 Years</option>
                                        <option value="5-10">5-10 Years</option>
                                        <option value="10+">10+ Years</option>
                                    </select>
                                </div>
                            </div>

                            <div class="search-filter-item button-item">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-filter"></i> Apply Filters
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Specialty Quick Filters -->
            <div class="specialty-filters">
                <a href="doctors" class="specialty-filter <%= request.getAttribute("specialization") == null ? "active" : "" %>">
                    <div class="specialty-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <span>All</span>
                </a>
                <a href="doctors?specialization=Cardiologist" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Cardiologist") ? "active" : "" %>">
                    <div class="specialty-icon">
                        <i class="fas fa-heartbeat"></i>
                    </div>
                    <span>Cardiology</span>
                </a>
                <a href="doctors?specialization=Neurologist" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Neurologist") ? "active" : "" %>">
                    <div class="specialty-icon">
                        <i class="fas fa-brain"></i>
                    </div>
                    <span>Neurology</span>
                </a>
                <a href="doctors?specialization=Orthopedic" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Orthopedic") ? "active" : "" %>">
                    <div class="specialty-icon">
                        <i class="fas fa-bone"></i>
                    </div>
                    <span>Orthopedic</span>
                </a>
                <a href="doctors?specialization=Dermatologist" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Dermatologist") ? "active" : "" %>">
                    <div class="specialty-icon">
                        <i class="fas fa-allergies"></i>
                    </div>
                    <span>Dermatology</span>
                </a>
                <a href="doctors?specialization=Pediatrician" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Pediatrician") ? "active" : "" %>">
                    <div class="specialty-icon">
                        <i class="fas fa-baby"></i>
                    </div>
                    <span>Pediatrics</span>
                </a>
                <a href="doctors?specialization=Gynecologist" class="specialty-filter <%= request.getAttribute("specialization") != null && request.getAttribute("specialization").equals("Gynecologist") ? "active" : "" %>">
                    <div class="specialty-icon">
                        <i class="fas fa-venus"></i>
                    </div>
                    <span>Gynecology</span>
                </a>
            </div>

            <!-- Doctor Count -->
            <%
            List<Doctor> doctors = null;
            try {
                doctors = (List<Doctor>) request.getAttribute("doctors");
            } catch (Exception e) {
            }
            String specialization = (String) request.getAttribute("specialization");
            int doctorCount = doctors != null ? doctors.size() : 0;
            %>
            <div class="doctors-header">
                <div class="doctors-count">
                    <h3>
                        <% if(specialization != null && !specialization.isEmpty()) { %>
                            <span class="highlight"><%= specialization %></span> Doctors
                        <% } else { %>
                            All Doctors
                        <% } %>
                        <span class="count-badge"><%= doctorCount %> found</span>
                    </h3>
                </div>
                <div class="doctors-sort">
                    <select class="form-control">
                        <option>Sort by: Recommended</option>
                        <option>Sort by: Experience</option>
                        <option>Sort by: Fee (Low to High)</option>
                        <option>Sort by: Fee (High to Low)</option>
                    </select>
                </div>
            </div>

            <div class="doctors-grid">
                <%
                if(doctors != null && !doctors.isEmpty()) {
                    for(int i = 0; i < doctors.size(); i++) {
                        Doctor doctor = doctors.get(i);
                %>
                <div class="doctor-card">
                    <div class="doctor-status">Available Today</div>
                    <div class="doctor-img">
                        <img src="${pageContext.request.contextPath}${doctor.imageUrl != null && !doctor.imageUrl.isEmpty() ? (doctor.imageUrl.startsWith('/') ? doctor.imageUrl : '/assets/images/doctors/'.concat(doctor.imageUrl)) : '/assets/images/doctors/d1.png'}" alt="${doctor.name}">
                        <div class="doctor-rating">
                            <i class="fas fa-star"></i>
                            <span>4.8</span>
                            <span>(120)</span>
                        </div>
                    </div>
                    <div class="doctor-info">
                        <h3><%= doctor.getName() %></h3>
                        <p class="specialization"><%= doctor.getSpecialization() %></p>
                        <p><%= doctor.getQualification() %></p>

                        <div class="doctor-meta">
                            <div class="doctor-meta-item">
                                <i class="fas fa-briefcase"></i>
                                <span><%= doctor.getExperience() %> Years</span>
                            </div>
                            <div class="doctor-meta-item">
                                <i class="fas fa-money-bill-wave"></i>
                                <span><%= doctor.getConsultationFee() %></span>
                            </div>
                        </div>

                        <div class="doctor-actions">
                            <a href="doctor/details?id=<%= doctor.getId() %>" class="btn btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                            <a href="appointment/book?doctorId=<%= doctor.getId() %>" class="btn btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="no-results-card">
                    <div class="no-results-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <h3>No Doctors Found</h3>
                    <p>We couldn't find any doctors matching your criteria. Please try a different specialization or check back later.</p>
                    <a href="doctors" class="btn btn-primary">View All Doctors</a>
                </div>
                <% } %>
            </div>

            <!-- Pagination -->
            <% if(doctors != null && !doctors.isEmpty()) { %>
            <div class="pagination">
                <a href="#" class="pagination-arrow">
                    <i class="fas fa-chevron-left"></i>
                </a>
                <a href="#" class="pagination-number active">1</a>
                <a href="#" class="pagination-number">2</a>
                <a href="#" class="pagination-number">3</a>
                <span class="pagination-dots">...</span>
                <a href="#" class="pagination-number">10</a>
                <a href="#" class="pagination-arrow">
                    <i class="fas fa-chevron-right"></i>
                </a>
            </div>
            <% } %>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-container">
                <div class="footer-col">
                    <div class="footer-logo">
                        <img src="${pageContext.request.contextPath}/assets/images/logO.png" alt="MedDoc Logo">
                        <div class="footer-logo-text">Med<span>Doc</span></div>
                    </div>
                    <p>We are dedicated to providing you with the best medical services. Your health is our priority.</p>
                    <ul class="social-links">
                        <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                        <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                        <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                        <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                    </ul>

                    <div class="footer-badges">
                        <div class="footer-badge">
                            <i class="fas fa-check-circle"></i>
                            <span>Certified</span>
                        </div>
                        <div class="footer-badge">
                            <i class="fas fa-shield-alt"></i>
                            <span>Secure</span>
                        </div>
                        <div class="footer-badge">
                            <i class="fas fa-award"></i>
                            <span>Top Rated</span>
                        </div>
                    </div>
                </div>

                <div class="footer-col">
                    <h3>Quick Links</h3>
                    <ul class="footer-links">
                        <li><a href="index.jsp"><i class="fas fa-chevron-right"></i> Home</a></li>
                        <li><a href="about-us"><i class="fas fa-chevron-right"></i> About Us</a></li>
                        <li><a href="index.jsp#services"><i class="fas fa-chevron-right"></i> Services</a></li>
                        <li><a href="doctors"><i class="fas fa-chevron-right"></i> Doctors</a></li>
                        <li><a href="index.jsp#contact"><i class="fas fa-chevron-right"></i> Contact</a></li>
                        <li><a href="login"><i class="fas fa-chevron-right"></i> Login</a></li>
                        <li><a href="register"><i class="fas fa-chevron-right"></i> Register</a></li>
                    </ul>
                </div>

                <div class="footer-col">
                    <h3>Our Services</h3>
                    <ul class="footer-links">
                        <li><a href="doctors"><i class="fas fa-chevron-right"></i> Find a Doctor</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Book Appointment</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Health Checkup</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Online Prescription</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Emergency Care</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Medical Advice</a></li>
                    </ul>
                </div>

                <div class="footer-col">
                    <h3>Contact Us</h3>
                    <div class="footer-contact-item">
                        <div class="footer-contact-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <span>123 MedDoc Center, Health Street, City</span>
                    </div>
                    <div class="footer-contact-item">
                        <div class="footer-contact-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <span>+1 234 567 890</span>
                    </div>
                    <div class="footer-contact-item">
                        <div class="footer-contact-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <span>info@meddoc.com</span>
                    </div>

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