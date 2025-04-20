<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Profile - MedDoc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .profile-container {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            padding: 40px 0;
        }
        
        .profile-sidebar {
            flex: 1;
            min-width: 300px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
        }
        
        .profile-content {
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
        
        .profile-section {
            margin-bottom: 30px;
        }
        
        .profile-section h2 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: var(--text-dark);
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text-dark);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
        }
        
        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .form-col {
            flex: 1;
            min-width: 200px;
        }
        
        .btn-update {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-update:hover {
            background-color: var(--primary-dark);
        }
        
        .medical-info {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .medical-item {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
        }
        
        .medical-item h4 {
            font-size: 1rem;
            margin-bottom: 5px;
            color: var(--text-dark);
        }
        
        .medical-item p {
            color: var(--text-light);
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
                        <li><a href="${pageContext.request.contextPath}/appointments">Appointments</a></li>
                        <li><a href="${pageContext.request.contextPath}/profile" class="active">Profile</a></li>
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
                <h1>Patient <span>Profile</span></h1>
                <p>Manage your personal information and medical records</p>
                <div class="banner-breadcrumb">
                    <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Profile</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Profile Section -->
    <section class="profile-section">
        <div class="container">
            <div class="profile-container">
                <div class="profile-sidebar">
                    <div class="profile-image">
                        <img src="${pageContext.request.contextPath}/assets/images/patients/p1.png" alt="Patient">
                    </div>
                    <div class="profile-info">
                        <% User user = (User) session.getAttribute("user"); %>
                        <h3><%= user != null ? user.getUsername() : "Patient" %></h3>
                        <p>Patient</p>
                    </div>
                    <ul class="profile-menu">
                        <li><a href="#" class="active"><i class="fas fa-user"></i> Personal Information</a></li>
                        <li><a href="${pageContext.request.contextPath}/appointments"><i class="fas fa-calendar-check"></i> My Appointments</a></li>
                        <li><a href="#"><i class="fas fa-file-medical"></i> Medical Records</a></li>
                        <li><a href="#"><i class="fas fa-prescription"></i> Prescriptions</a></li>
                        <li><a href="#"><i class="fas fa-bell"></i> Notifications</a></li>
                        <li><a href="#"><i class="fas fa-cog"></i> Settings</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </div>
                <div class="profile-content">
                    <div class="profile-section">
                        <h2>Personal Information</h2>
                        <form action="${pageContext.request.contextPath}/updateProfile" method="post">
                            <div class="form-row">
                                <div class="form-col">
                                    <div class="form-group">
                                        <label for="name" class="form-label">Full Name</label>
                                        <input type="text" id="name" name="name" class="form-control" value="<%= user != null ? user.getUsername() : "" %>" required>
                                    </div>
                                </div>
                                <div class="form-col">
                                    <div class="form-group">
                                        <label for="email" class="form-label">Email Address</label>
                                        <input type="email" id="email" name="email" class="form-control" value="<%= user != null ? user.getEmail() : "" %>" required>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-col">
                                    <div class="form-group">
                                        <label for="phone" class="form-label">Phone Number</label>
                                        <input type="tel" id="phone" name="phone" class="form-control" value="<%= user != null ? user.getPhone() : "" %>">
                                    </div>
                                </div>
                                <div class="form-col">
                                    <div class="form-group">
                                        <label for="dob" class="form-label">Date of Birth</label>
                                        <input type="date" id="dob" name="dob" class="form-control">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="address" class="form-label">Address</label>
                                <textarea id="address" name="address" class="form-control" rows="3"></textarea>
                            </div>
                            <div class="form-row">
                                <div class="form-col">
                                    <div class="form-group">
                                        <label for="password" class="form-label">Password</label>
                                        <input type="password" id="password" name="password" class="form-control" placeholder="Leave blank to keep current password">
                                    </div>
                                </div>
                                <div class="form-col">
                                    <div class="form-group">
                                        <label for="confirm_password" class="form-label">Confirm Password</label>
                                        <input type="password" id="confirm_password" name="confirm_password" class="form-control" placeholder="Leave blank to keep current password">
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn-update">Update Profile</button>
                        </form>
                    </div>
                    <div class="profile-section">
                        <h2>Medical Information</h2>
                        <div class="medical-info">
                            <div class="medical-item">
                                <h4>Blood Group</h4>
                                <p>A+</p>
                            </div>
                            <div class="medical-item">
                                <h4>Height</h4>
                                <p>175 cm</p>
                            </div>
                            <div class="medical-item">
                                <h4>Weight</h4>
                                <p>70 kg</p>
                            </div>
                            <div class="medical-item">
                                <h4>Allergies</h4>
                                <p>None</p>
                            </div>
                            <div class="medical-item">
                                <h4>Chronic Diseases</h4>
                                <p>None</p>
                            </div>
                            <div class="medical-item">
                                <h4>Current Medications</h4>
                                <p>None</p>
                            </div>
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
