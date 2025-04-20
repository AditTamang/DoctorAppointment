<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MedDoc - Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <nav class="navbar">
                <a href="index.jsp" class="logo">Med<span>Doc</span></a>
                <ul class="nav-links">
                    <li><a href="index.jsp" class="active">Home</a></li>
                    <li><a href="about-us.jsp">About Us</a></li>
                    <li><a href="doctors">Find Doctors</a></li>
                    <li><a href="#services">Services</a></li>
                    <li><a href="#contact">Contact</a></li>
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

    <main>
    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <div class="hero-content">
                <h1>Your Health Is Our <span>Priority</span></h1>
                <p>Book appointments with the best doctors in your city. We provide quality medical services for you and your family.</p>
                <div class="btn-group">
                    <a href="doctors" class="btn btn-primary">Find a Doctor <i class="fas fa-user-md"></i></a>
                    <a href="#services" class="btn btn-outline">Our Services <i class="fas fa-chevron-down"></i></a>
                </div>
            </div>

            <!-- Hero Features -->
            <div class="hero-features">
                <div class="hero-feature">
                    <div class="hero-feature-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="hero-feature-content">
                        <h3>Qualified Doctors</h3>
                        <p>Experienced specialists for your care</p>
                    </div>
                </div>
                <div class="hero-feature">
                    <div class="hero-feature-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="hero-feature-content">
                        <h3>24/7 Service</h3>
                        <p>Round-the-clock medical assistance</p>
                    </div>
                </div>
                <div class="hero-feature">
                    <div class="hero-feature-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="hero-feature-content">
                        <h3>Easy Booking</h3>
                        <p>Schedule appointments in minutes</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="services">
        <div class="container">
            <div class="section-title">
                <h2>Our <span>Services</span></h2>
                <p>We provide a wide range of medical services to ensure you receive the best care possible.</p>
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

    <!-- Featured Doctors Section -->
    <section class="doctors">
        <div class="container">
            <div class="doctors-header">
                <div class="doctors-header-left">
                    <h2>Meet Our <span>Specialists</span></h2>
                    <p>Our team of experienced doctors are dedicated to providing you with the best medical services. Each specialist brings years of expertise and a commitment to patient care.</p>
                </div>
                <div class="doctors-header-right">
                    <a href="doctors" class="btn btn-primary">View All Doctors <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>

            <div class="doctors-grid">
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
                            <a href="doctor/details?id=1" class="btn btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                            <a href="appointment/book?doctorId=1" class="btn btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
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
                            <a href="doctor/details?id=2" class="btn btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                            <a href="appointment/book?doctorId=2" class="btn btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
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
                            <a href="doctor/details?id=3" class="btn btn-primary"><i class="fas fa-eye"></i> View Profile</a>
                            <a href="appointment/book?doctorId=3" class="btn btn-outline"><i class="fas fa-calendar-check"></i> Book</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonials">
        <div class="container">
            <div class="section-title">
                <h2>What Our Patients Say</h2>
                <p>Read testimonials from our satisfied patients who have experienced our quality medical services.</p>
            </div>
            <div class="testimonials-grid">
                <div class="testimonial">
                    <div class="testimonial-img">
                        <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                    </div>
                    <div class="testimonial-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="testimonial-content">
                        <p>"I had a great experience with Dr. Smith. He was very professional and took the time to explain everything to me. The appointment booking process was also very smooth."</p>
                        <h4 class="testimonial-author">Robert Wilson</h4>
                        <span class="testimonial-role">Heart Patient</span>
                    </div>
                </div>

                <div class="testimonial">
                    <div class="testimonial-img">
                        <img src="${pageContext.request.contextPath}/assets/images/patients/p2.png" alt="Patient">
                    </div>
                    <div class="testimonial-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="testimonial-content">
                        <p>"The doctors here are amazing! Dr. Johnson helped me with my chronic back pain, and I've seen significant improvement. The staff is friendly and the facility is clean and modern."</p>
                        <h4 class="testimonial-author">Emily Parker</h4>
                        <span class="testimonial-role">Back Pain Patient</span>
                    </div>
                </div>

                <div class="testimonial">
                    <div class="testimonial-img">
                        <img src="${pageContext.request.contextPath}/assets/images/patients/p3.png" alt="Patient">
                    </div>
                    <div class="testimonial-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                    </div>
                    <div class="testimonial-content">
                        <p>"I've been bringing my family here for years. The pediatric care is exceptional, and the online appointment system makes scheduling so convenient. Highly recommend this MedDoc center!"</p>
                        <h4 class="testimonial-author">David Thompson</h4>
                        <span class="testimonial-role">Parent</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="contact">
        <div class="container">
            <div class="section-title">
                <h2>Contact Us</h2>
                <p>Have questions or need assistance? Reach out to us and we'll be happy to help.</p>
            </div>
            <div class="contact-container">
                <div class="contact-info">
                    <h3>Contact Information</h3>
                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="contact-details">
                            <h4>Address</h4>
                            <p>123 MedDoc Center, Health Street, City, Country</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="contact-details">
                            <h4>Phone</h4>
                            <p>+1 234 567 890</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="contact-details">
                            <h4>Email</h4>
                            <p>info@meddoc.com</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="contact-details">
                            <h4>Working Hours</h4>
                            <p>Monday - Friday: 9:00 AM - 6:00 PM</p>
                            <p>Saturday: 9:00 AM - 1:00 PM</p>
                            <p>Sunday: Closed</p>
                        </div>
                    </div>

                    <!-- Google Map -->
                    <div class="contact-map">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3022.215151997078!2d-73.98784492426285!3d40.75790657138285!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c25855c6480299%3A0x55194ec5a1ae072e!2sTimes%20Square!5e0!3m2!1sen!2sus!4v1710349480842!5m2!1sen!2sus" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                    </div>
                </div>

                <div class="contact-form">
                    <h3>Send us a Message</h3>
                    <form action="#" method="post">
                        <div class="form-group">
                            <label for="name" class="form-label">Your Name</label>
                            <div style="position: relative;">
                                <i class="fas fa-user" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                                <input type="text" id="name" name="name" class="form-control" style="padding-left: 45px;" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email" class="form-label">Your Email</label>
                            <div style="position: relative;">
                                <i class="fas fa-envelope" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                                <input type="email" id="email" name="email" class="form-control" style="padding-left: 45px;" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="subject" class="form-label">Subject</label>
                            <div style="position: relative;">
                                <i class="fas fa-heading" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666;"></i>
                                <input type="text" id="subject" name="subject" class="form-control" style="padding-left: 45px;" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="message" class="form-label">Your Message</label>
                            <div style="position: relative;">
                                <i class="fas fa-comment" style="position: absolute; left: 15px; top: 15px; color: #666;"></i>
                                <textarea id="message" name="message" class="form-control" style="padding-left: 45px;" rows="5" required></textarea>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary">Send Message <i class="fas fa-paper-plane"></i></button>
                    </form>

                    <div class="contact-social">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
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
                        <li><a href="about-us.jsp"><i class="fas fa-chevron-right"></i> About Us</a></li>
                        <li><a href="#services"><i class="fas fa-chevron-right"></i> Services</a></li>
                        <li><a href="doctors"><i class="fas fa-chevron-right"></i> Doctors</a></li>
                        <li><a href="#contact"><i class="fas fa-chevron-right"></i> Contact</a></li>
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
