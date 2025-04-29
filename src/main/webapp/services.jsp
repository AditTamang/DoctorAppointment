<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.service.DoctorService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Services - MedDoc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Services Page Styles */
        .services-container {
            padding: 50px 0;
        }

        .services-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .services-header h1 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 15px;
        }

        .services-header p {
            color: #666;
            max-width: 800px;
            margin: 0 auto;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }

        .service-card {
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .service-image {
            height: 200px;
            overflow: hidden;
        }

        .service-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }

        .service-card:hover .service-image img {
            transform: scale(1.1);
        }

        .service-content {
            padding: 25px;
        }

        .service-content h3 {
            font-size: 1.3rem;
            color: #333;
            margin-bottom: 15px;
        }

        .service-content p {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .service-content .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s, color 0.3s;
        }

        .service-content .btn-outline {
            border: 1px solid #4e73df;
            color: #4e73df;
        }

        .service-content .btn-outline:hover {
            background-color: #4e73df;
            color: white;
        }

        /* Specialists Section Styles */
        .specialists {
            padding: 50px 0;
            background-color: #f8f9fa;
        }

        .specialists-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .specialists-header-left h2 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 10px;
        }

        .specialists-header-left h2 span {
            color: #4e73df;
        }

        .specialists-header-left p {
            color: #666;
            max-width: 700px;
            line-height: 1.6;
        }

        .specialists-header-right .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s, color 0.3s;
        }

        .specialists-header-right .btn-primary {
            background-color: #4e73df;
            color: white;
        }

        .specialists-header-right .btn-primary:hover {
            background-color: #3a5fc8;
        }

        .specialists-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
        }

        .doctor-card {
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }

        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }

        .doctor-status {
            position: absolute;
            top: 15px;
            left: 15px;
            background-color: rgba(46, 204, 113, 0.9);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 500;
            z-index: 1;
        }

        .doctor-img {
            height: 200px;
            position: relative;
            overflow: hidden;
        }

        .doctor-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }

        .doctor-card:hover .doctor-img img {
            transform: scale(1.05);
        }

        .doctor-rating {
            position: absolute;
            bottom: 10px;
            left: 10px;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 5px 10px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.8rem;
        }

        .doctor-rating i {
            color: #ffc107;
        }

        .doctor-info {
            padding: 20px;
        }

        .doctor-info h3 {
            margin: 0 0 5px 0;
            font-size: 1.1rem;
            color: #333;
        }

        .doctor-info .specialization {
            color: #4e73df;
            font-weight: 500;
            margin-bottom: 5px;
            font-size: 0.9rem;
        }

        .doctor-info p {
            color: #666;
            font-size: 0.85rem;
            margin-bottom: 15px;
            line-height: 1.5;
        }

        .doctor-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }

        .doctor-meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.85rem;
            color: #555;
        }

        .doctor-meta-item i {
            color: #4e73df;
        }

        .doctor-actions {
            display: flex;
            gap: 10px;
        }

        .doctor-actions a {
            flex: 1;
            text-align: center;
            padding: 8px 0;
            border-radius: 5px;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            transition: background-color 0.3s, color 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        .doctor-actions .btn-primary {
            background-color: #4e73df;
            color: white;
        }

        .doctor-actions .btn-primary:hover {
            background-color: #3a5fc8;
        }

        .doctor-actions .btn-outline {
            border: 1px solid #4e73df;
            color: #4e73df;
            background-color: transparent;
        }

        .doctor-actions .btn-outline:hover {
            background-color: #4e73df;
            color: white;
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .specialists-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }

            .specialists-header-right {
                width: 100%;
                text-align: left;
            }
        }

        @media (max-width: 768px) {
            .services-grid,
            .specialists-grid {
                grid-template-columns: 1fr;
            }

            .services-header h1 {
                font-size: 2rem;
            }

            .specialists-header-left h2 {
                font-size: 1.8rem;
            }
        }
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
                    <li><a href="doctors">Find Doctors</a></li>
                    <li><a href="about-us.jsp">About Us</a></li>
                    <li><a href="services.jsp" class="active">Services</a></li>
                    <li><a href="contact-us.jsp">Contact</a></li>
                    <% if(session.getAttribute("user") != null) { %>
                        <li><a href="patient/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                        <li><a href="patient/profile">Profile</a></li>
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

    <main>
        <!-- Services Section -->
        <section class="services-container">
            <div class="container">
                <div class="services-header">
                    <h1>Our <span style="color: #4e73df;">Services</span></h1>
                    <p>We provide a wide range of medical services to ensure you receive the best care possible. Our team of experienced doctors and medical professionals are dedicated to your health and well-being.</p>
                </div>

                <div class="services-grid">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/specialties/s3.png" alt="Find a Doctor">
                        </div>
                        <div class="service-content">
                            <h3>Find a Doctor</h3>
                            <p>Find the best doctors in your area with our comprehensive directory. Search by specialty, location, or availability.</p>
                            <a href="doctors" class="btn btn-outline">Find Now</a>
                        </div>
                    </div>

                    <div class="service-card">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d3.png" alt="Book Appointment">
                        </div>
                        <div class="service-content">
                            <h3>Book Appointment</h3>
                            <p>Book appointments with your preferred doctors at your convenient time. Easy scheduling and reminders.</p>
                            <a href="doctors" class="btn btn-outline">Book Now</a>
                        </div>
                    </div>

                    <div class="service-card">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/specialties/s1.png" alt="Health Checkup">
                        </div>
                        <div class="service-content">
                            <h3>Health Checkup</h3>
                            <p>Regular health checkups to ensure you stay healthy and fit. Comprehensive tests and expert analysis.</p>
                            <a href="#" class="btn btn-outline">Learn More</a>
                        </div>
                    </div>

                    <div class="service-card">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/specialties/s4.png" alt="Online Prescription">
                        </div>
                        <div class="service-content">
                            <h3>Online Prescription</h3>
                            <p>Get your prescriptions online after your consultation. Secure, convenient, and paperless process.</p>
                            <a href="#" class="btn btn-outline">Learn More</a>
                        </div>
                    </div>

                    <div class="service-card">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/specialties/s6.png" alt="Emergency Care">
                        </div>
                        <div class="service-content">
                            <h3>Emergency Care</h3>
                            <p>24/7 emergency care services for critical situations. Quick response and professional medical attention.</p>
                            <a href="#" class="btn btn-outline">Learn More</a>
                        </div>
                    </div>

                    <div class="service-card">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/specialties/s10.png" alt="Medical Advice">
                        </div>
                        <div class="service-content">
                            <h3>Medical Advice</h3>
                            <p>Get expert medical advice from our experienced doctors. Personalized guidance for your health concerns.</p>
                            <a href="#" class="btn btn-outline">Learn More</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Meet Our Specialists Section -->
        <section class="specialists">
            <div class="container">
                <div class="specialists-header">
                    <div class="specialists-header-left">
                        <h2>Meet Our <span>Specialists</span></h2>
                        <p>Our team of experienced doctors are dedicated to providing you with the best medical services. Each specialist brings years of expertise and a commitment to patient care.</p>
                    </div>
                    <div class="specialists-header-right">
                        <a href="doctors" class="btn btn-primary">View All Doctors <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>

                <div class="specialists-grid">
                    <%
                    // Get doctors from the database
                    DoctorService doctorService = new DoctorService();
                    List<Doctor> doctors = doctorService.getApprovedDoctors();

                    // Display up to 3 doctors
                    int count = 0;
                    if(doctors != null && !doctors.isEmpty()) {
                        for(Doctor doctor : doctors) {
                            if(count >= 3) break; // Limit to 3 doctors
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
                            <p><%= doctor.getQualification() != null ? doctor.getQualification() : "Specialist Doctor" %></p>

                            <div class="doctor-meta">
                                <div class="doctor-meta-item">
                                    <i class="fas fa-briefcase"></i>
                                    <span><%= doctor.getExperience() != null ? doctor.getExperience() + " Years" : "Experienced" %></span>
                                </div>
                                <div class="doctor-meta-item">
                                    <i class="fas fa-money-bill-wave"></i>
                                    <span><%= doctor.getConsultationFee() != null ? "$" + doctor.getConsultationFee() : "$100" %></span>
                                </div>
                            </div>

                            <div class="doctor-actions">
                                <a href="${pageContext.request.contextPath}/doctor/details?id=<%= doctor.getId() %>" class="btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                                <a href="${pageContext.request.contextPath}/doctors?action=book&doctorId=<%= doctor.getId() %>" class="btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
                            </div>
                        </div>
                    </div>
                    <%
                            count++;
                        }
                    } else {
                        // If no doctors found, display sample doctors
                    %>
                    <div class="doctor-card">
                        <div class="doctor-status">Available Today</div>
                        <div class="doctor-img">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d7.png" alt="Doctor">
                            <div class="doctor-rating">
                                <i class="fas fa-star"></i>
                                <span>4.9</span>
                                <span>(120)</span>
                            </div>
                        </div>
                        <div class="doctor-info">
                            <h3>Dr. John Smith</h3>
                            <p class="specialization">Cardiologist</p>
                            <p>MD in Cardiology, 15+ years of experience in treating heart-related issues.</p>

                            <div class="doctor-meta">
                                <div class="doctor-meta-item">
                                    <i class="fas fa-briefcase"></i>
                                    <span>15 Years</span>
                                </div>
                                <div class="doctor-meta-item">
                                    <i class="fas fa-money-bill-wave"></i>
                                    <span>$150</span>
                                </div>
                            </div>

                            <div class="doctor-actions">
                                <a href="doctor/details?id=1" class="btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                                <a href="appointment/book?doctorId=1" class="btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
                            </div>
                        </div>
                    </div>

                    <div class="doctor-card">
                        <div class="doctor-status">Available Today</div>
                        <div class="doctor-img">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d2.png" alt="Doctor">
                            <div class="doctor-rating">
                                <i class="fas fa-star"></i>
                                <span>4.8</span>
                                <span>(95)</span>
                            </div>
                        </div>
                        <div class="doctor-info">
                            <h3>Dr. Sarah Johnson</h3>
                            <p class="specialization">Neurologist</p>
                            <p>Specialized in treating neurological disorders with 10+ years of experience.</p>

                            <div class="doctor-meta">
                                <div class="doctor-meta-item">
                                    <i class="fas fa-briefcase"></i>
                                    <span>10 Years</span>
                                </div>
                                <div class="doctor-meta-item">
                                    <i class="fas fa-money-bill-wave"></i>
                                    <span>$180</span>
                                </div>
                            </div>

                            <div class="doctor-actions">
                                <a href="doctor/details?id=2" class="btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                                <a href="appointment/book?doctorId=2" class="btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
                            </div>
                        </div>
                    </div>

                    <div class="doctor-card">
                        <div class="doctor-status">Available Today</div>
                        <div class="doctor-img">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="Doctor">
                            <div class="doctor-rating">
                                <i class="fas fa-star"></i>
                                <span>4.7</span>
                                <span>(87)</span>
                            </div>
                        </div>
                        <div class="doctor-info">
                            <h3>Dr. Michael Brown</h3>
                            <p class="specialization">Orthopedic Surgeon</p>
                            <p>Expert in orthopedic surgeries with 12+ years of experience in joint replacements.</p>

                            <div class="doctor-meta">
                                <div class="doctor-meta-item">
                                    <i class="fas fa-briefcase"></i>
                                    <span>12 Years</span>
                                </div>
                                <div class="doctor-meta-item">
                                    <i class="fas fa-money-bill-wave"></i>
                                    <span>$200</span>
                                </div>
                            </div>

                            <div class="doctor-actions">
                                <a href="doctor/details?id=3" class="btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                                <a href="appointment/book?doctorId=3" class="btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </section>
    </main>

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
                        <li><a href="index.jsp"><i class="fas fa-chevron-right"></i> Home</a></li>
                        <li><a href="services.jsp"><i class="fas fa-chevron-right"></i> Services</a></li>
                        <li><a href="doctors"><i class="fas fa-chevron-right"></i> Doctors</a></li>
                        <li><a href="contact-us.jsp"><i class="fas fa-chevron-right"></i> Contact</a></li>
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
