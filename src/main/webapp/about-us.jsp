<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - MedDoc</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        <%@include file="./assets/css/style.css"%>
    </style>
    <style>
        /* About Us Page Specific Styles */
        .about-hero {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('${pageContext.request.contextPath}/assets/images/about-hero.jpg');
            background-size: cover;
            background-position: center;
            padding: 80px 0;
            color: white;
            text-align: left;
        }

        .about-hero h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .mission-section {
            padding: 80px 0;
            background-color: #fff;
        }

        .mission-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            align-items: center;
        }

        .mission-content h2 {
            font-size: 1.8rem;
            margin-bottom: 20px;
            color: var(--text-dark);
        }

        .mission-content p {
            color: var(--text-light);
            margin-bottom: 20px;
            line-height: 1.7;
        }

        .mission-image img {
            width: 100%;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .stats-section {
            background-color: var(--primary-color);
            padding: 40px 0;
            color: white;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            text-align: center;
        }

        .stat-item {
            padding: 20px;
        }

        .stat-item i {
            font-size: 2rem;
            margin-bottom: 15px;
        }

        .stat-item h3 {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .experience-section {
            padding: 80px 0;
            background-color: #f9f9f9;
        }

        .experience-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            align-items: center;
        }

        .experience-content h2 {
            font-size: 1.8rem;
            margin-bottom: 20px;
            color: var(--text-dark);
        }

        .experience-content p {
            color: var(--text-light);
            margin-bottom: 20px;
            line-height: 1.7;
        }

        .experience-feature {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .experience-feature i {
            color: var(--primary-color);
            margin-right: 10px;
            font-size: 1.2rem;
        }

        .experience-image img {
            width: 100%;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .team-section {
            padding: 80px 0;
            background-color: #004d40;
            color: white;
        }

        .team-section h2 {
            text-align: center;
            margin-bottom: 50px;
            font-size: 2rem;
        }

        .team-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
        }

        .team-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }

        .team-card:hover {
            transform: translateY(-10px);
        }

        .team-image {
            height: 200px;
            overflow: hidden;
        }

        .team-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .team-info {
            padding: 20px;
            text-align: center;
            color: var(--text-dark);
        }

        .team-info h3 {
            font-size: 1.2rem;
            margin-bottom: 5px;
        }

        .team-info p {
            color: var(--primary-color);
            font-size: 0.9rem;
        }

        .testimonial-section {
            padding: 80px 0;
            background-color: #fff;
        }

        .testimonial-section h2 {
            text-align: center;
            margin-bottom: 50px;
            font-size: 2rem;
            color: var(--text-dark);
        }

        .testimonial-card {
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            text-align: center;
            max-width: 800px;
            margin: 0 auto;
        }

        .testimonial-image {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            overflow: hidden;
            margin: 0 auto 20px;
            border: 3px solid var(--primary-color);
        }

        .testimonial-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .testimonial-content p {
            font-style: italic;
            color: var(--text-light);
            margin-bottom: 20px;
            line-height: 1.7;
        }

        .testimonial-author {
            font-weight: 600;
            color: var(--text-dark);
        }

        .cta-section {
            padding: 60px 0;
            background-color: var(--primary-color);
            color: white;
            text-align: center;
        }

        .cta-section h2 {
            font-size: 2rem;
            margin-bottom: 20px;
        }

        .cta-section p {
            margin-bottom: 30px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .cta-phone {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            display: block;
        }

        .btn-white {
            background-color: white;
            color: var(--primary-color);
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-white:hover {
            background-color: var(--light-color);
            transform: translateY(-3px);
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .mission-container,
            .experience-container {
                grid-template-columns: 1fr;
            }

            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }

            .team-container {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
            .team-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 576px) {
            .stats-container,
            .team-container {
                grid-template-columns: 1fr;
            }

            .about-hero h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <% if(session.getAttribute("user") != null) { %>
        <!-- Include logged-in header for authenticated users -->
        <jsp:include page="includes/logged-in-header.jsp" />
    <% } else { %>
        <!-- Regular header for non-authenticated users -->
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="index.jsp" class="logo">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="MedDoc Logo" style="height: 30px; margin-right: 10px; vertical-align: middle;">
                        Med<span>Doc</span>
                    </a>
                    <ul class="nav-links">
                        <li><a href="index.jsp">Home</a></li>
                        <li><a href="doctors">Find Doctors</a></li>
                        <li><a href="about-us.jsp" class="active">About Us</a></li>
                        <li><a href="contact-us">Contact</a></li>
                        <li><a href="login" class="login-btn"><i class="fas fa-user"></i></a></li>
                    </ul>
                    <div class="mobile-menu">
                        <i class="fas fa-bars"></i>
                    </div>
                </nav>
            </div>
        </header>
    <% } %>

    <main>
        <!-- About Hero Section -->
        <section class="about-hero">
            <div class="container">
                <h1>About Our Hospital</h1>
            </div>
        </section>

        <!-- Mission Section -->
        <section class="mission-section">
            <div class="container">
                <div class="mission-container">
                    <div class="mission-content">
                        <h2>We built hospitals to provide services to helpless people</h2>
                        <p>At MedDoc, our mission is to provide exceptional healthcare services to all individuals, regardless of their background or circumstances. We believe that quality healthcare is a fundamental right, and we are committed to making it accessible to everyone.</p>
                        <p>Our team of dedicated healthcare professionals works tirelessly to ensure that every patient receives personalized care and attention. We combine cutting-edge medical technology with compassionate service to deliver the best possible outcomes for our patients.</p>

                        <div class="btn-group" style="margin-top: 20px;">
                            <a href="#" class="btn btn-primary">Online Appointment</a>
                            <a href="#" class="btn btn-outline">Emergency Care</a>
                        </div>
                    </div>
                    <div class="mission-image">
                        <img src="${pageContext.request.contextPath}/assets/images/specialties/hospital.png" alt="Hospital Team">
                    </div>
                </div>
            </div>
        </section>

        <!-- Stats Section -->
        <section class="stats-section">
            <div class="container">
                <div class="stats-container">
                    <div class="stat-item">
                        <i class="fas fa-user-md"></i>
                        <h3>342</h3>
                        <p>Doctors</p>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-users"></i>
                        <h3>142</h3>
                        <p>Staff</p>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-procedures"></i>
                        <h3>59</h3>
                        <p>Rooms</p>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-smile"></i>
                        <h3>142</h3>
                        <p>Happy Patients</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Experience Section -->
        <section class="experience-section">
            <div class="container">
                <div class="experience-container">
                    <div class="experience-image">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/d5.png" alt="Medical Team">
                    </div>
                    <div class="experience-content">
                        <h2>We Have 12 Years Experience</h2>
                        <p>For over a decade, MedDoc has been at the forefront of healthcare innovation and excellence. Our journey began with a simple vision: to create a healthcare institution that combines medical expertise with genuine compassion.</p>
                        <p>Throughout our 12 years of service, we have continuously evolved and improved our facilities, technologies, and services to meet the changing needs of our patients and the advancements in medical science.</p>

                        <div class="experience-features">
                            <div class="experience-feature">
                                <i class="fas fa-check-circle"></i>
                                <span>State-of-the-art medical equipment</span>
                            </div>
                            <div class="experience-feature">
                                <i class="fas fa-check-circle"></i>
                                <span>Highly qualified medical professionals</span>
                            </div>
                            <div class="experience-feature">
                                <i class="fas fa-check-circle"></i>
                                <span>24/7 emergency services</span>
                            </div>
                            <div class="experience-feature">
                                <i class="fas fa-check-circle"></i>
                                <span>Comprehensive healthcare solutions</span>
                            </div>
                        </div>

                        <a href="#" class="btn btn-primary" style="margin-top: 20px;">Learn More</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Team Section -->
        <section class="team-section">
            <div class="container">
                <h2>Our Specialist Doctor Team</h2>
                <div class="team-container">
                    <div class="team-card">
                        <div class="team-image">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Doctor">
                        </div>
                        <div class="team-info">
                            <h3>Dr. John Smith</h3>
                            <p>Cardiologist</p>
                        </div>
                    </div>
                    <div class="team-card">
                        <div class="team-image">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d2.png" alt="Doctor">
                        </div>
                        <div class="team-info">
                            <h3>Dr. Sarah Johnson</h3>
                            <p>Neurologist</p>
                        </div>
                    </div>
                    <div class="team-card">
                        <div class="team-image">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d3.png" alt="Doctor">
                        </div>
                        <div class="team-info">
                            <h3>Dr. Michael Brown</h3>
                            <p>Orthopedic Surgeon</p>
                        </div>
                    </div>
                    <div class="team-card">
                        <div class="team-image">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d4.png" alt="Doctor">
                        </div>
                        <div class="team-info">
                            <h3>Dr. Emily Davis</h3>
                            <p>Pediatrician</p>
                        </div>
                    </div>
                    <div class="team-card">
                        <div class="team-image">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d7.png" alt="Doctor">
                        </div>
                        <div class="team-info">
                            <h3>Dr. Robert Wilson</h3>
                            <p>Dermatologist</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Testimonial Section -->
        <section class="testimonial-section">
            <div class="container">
                <h2>Clients Are Saying</h2>
                <div class="testimonial-card">
                    <div class="testimonial-image">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/d7.png" alt="Patient">
                    </div>
                    <div class="testimonial-content">
                        <p>"I've been a patient at MedDoc for over 5 years, and I've always received exceptional care. The doctors are knowledgeable and compassionate, and the staff is friendly and professional. I wouldn't trust my health to anyone else!"</p>
                        <div class="testimonial-author">John M. Chambers</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <div class="container">
                <h2>Let's Make An Appointment!</h2>
                <p>Get Your Doctor Consultation Today</p>
                <span class="cta-phone">+977 9807373362</span>
                <a href="doctors" class="btn-white">Book Appointment</a>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-container">
                <div class="footer-col">
                    <div class="footer-logo">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="MedDoc Logo">
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
                        <li><a href="index.jsp"><i class="fas fa-chevron-right"></i> Home</a></li>
                        <li><a href="about-us"><i class="fas fa-chevron-right"></i> About Us</a></li>
                        <li><a href="doctors"><i class="fas fa-chevron-right"></i> Doctors</a></li>
                        <li><a href="index.jsp#services"><i class="fas fa-chevron-right"></i> Services</a></li>
                        <li><a href="index.jsp#contact"><i class="fas fa-chevron-right"></i> Contact</a></li>
                        <li><a href="login"><i class="fas fa-chevron-right"></i> Login</a></li>
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
                    <h3>Contact Info</h3>
                    <ul class="footer-contact">
                        <li><i class="fas fa-map-marker-alt"></i> MedDoc, Itahari 20-Sunsari, City, Nepal</li>
                        <li><i class="fas fa-phone"></i> +977 9807373362</li>
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