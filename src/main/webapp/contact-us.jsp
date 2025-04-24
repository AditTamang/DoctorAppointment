<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - MedDoc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        <%@include file="./assets/css/style.css"%>
        
        /* Additional styles for contact page */
        .contact-page {
            padding: 80px 0;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .contact-page-header {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .contact-page-header h1 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 15px;
        }
        
        .contact-page-header p {
            font-size: 1.1rem;
            color: #666;
            max-width: 700px;
            margin: 0 auto;
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
                    <li><a href="index.jsp#services">Services</a></li>
                    <li><a href="contact-us.jsp" class="active">Contact</a></li>
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
        <!-- Contact Page Header -->
        <section class="contact-page-header">
            <div class="container">
                <h1>Contact Us</h1>
                <p>Have questions or need assistance? Reach out to us and we'll be happy to help. Fill out the form below or use our contact information to get in touch.</p>
            </div>
        </section>
        
        <!-- Contact Section -->
        <section class="contact contact-page">
            <div class="container">
                <!-- Display success or error message if any -->
                <% if(request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success">
                        <%= request.getAttribute("successMessage") %>
                    </div>
                <% } %>
                
                <% if(request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                
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
                        <form action="contact/submit" method="post">
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
                </div>
                <div class="footer-col">
                    <h3>Quick Links</h3>
                    <ul class="footer-links">
                        <li><a href="index.jsp"><i class="fas fa-chevron-right"></i> Home</a></li>
                        <li><a href="index.jsp#services"><i class="fas fa-chevron-right"></i> Services</a></li>
                        <li><a href="doctors"><i class="fas fa-chevron-right"></i> Doctors</a></li>
                        <li><a href="contact-us.jsp"><i class="fas fa-chevron-right"></i> Contact</a></li>
                        <li><a href="login"><i class="fas fa-chevron-right"></i> Login</a></li>
                        <li><a href="register"><i class="fas fa-chevron-right"></i> Register</a></li>
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
