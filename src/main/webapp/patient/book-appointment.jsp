<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect("../login");
        return;
    }

    Doctor doctor = (Doctor) request.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("../doctors");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
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

    <!-- Book Appointment Section -->
    <section class="py-5">
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <h2>Book an Appointment with Dr. <%= doctor.getName() %></h2>
                </div>
                <div class="card-body">
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <div class="doctor-info mb-4">
                        <div class="doctor-meta-item">
                            <div class="doctor-meta-label">Doctor:</div>
                            <div class="doctor-meta-value"><%= doctor.getName() %></div>
                        </div>
                        <div class="doctor-meta-item">
                            <div class="doctor-meta-label">Specialization:</div>
                            <div class="doctor-meta-value"><%= doctor.getSpecialization() %></div>
                        </div>
                        <div class="doctor-meta-item">
                            <div class="doctor-meta-label">Consultation Fee:</div>
                            <div class="doctor-meta-value"><%= doctor.getConsultationFee() %></div>
                        </div>
                        <div class="doctor-meta-item">
                            <div class="doctor-meta-label">Available Days:</div>
                            <div class="doctor-meta-value"><%= doctor.getAvailableDays() %></div>
                        </div>
                        <div class="doctor-meta-item">
                            <div class="doctor-meta-label">Available Time:</div>
                            <div class="doctor-meta-value"><%= doctor.getAvailableTime() %></div>
                        </div>
                    </div>

                    <form action="../appointment/book" method="post">
                        <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">

                        <div class="form-group">
                            <label for="appointmentDate">Appointment Date</label>
                            <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="appointmentTime">Appointment Time</label>
                            <select id="appointmentTime" name="appointmentTime" class="form-control" required>
                                <option value="">Select Time</option>
                                <option value="09:00 AM">09:00 AM</option>
                                <option value="09:30 AM">09:30 AM</option>
                                <option value="10:00 AM">10:00 AM</option>
                                <option value="10:30 AM">10:30 AM</option>
                                <option value="11:00 AM">11:00 AM</option>
                                <option value="11:30 AM">11:30 AM</option>
                                <option value="12:00 PM">12:00 PM</option>
                                <option value="12:30 PM">12:30 PM</option>
                                <option value="02:00 PM">02:00 PM</option>
                                <option value="02:30 PM">02:30 PM</option>
                                <option value="03:00 PM">03:00 PM</option>
                                <option value="03:30 PM">03:30 PM</option>
                                <option value="04:00 PM">04:00 PM</option>
                                <option value="04:30 PM">04:30 PM</option>
                                <option value="05:00 PM">05:00 PM</option>
                                <option value="05:30 PM">05:30 PM</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="symptoms">Symptoms/Reason for Visit</label>
                            <textarea id="symptoms" name="symptoms" class="form-control" rows="5" required></textarea>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Book Appointment</button>
                            <a href="../doctor/details?id=<%= doctor.getId() %>" class="btn btn-outline">Cancel</a>
                        </div>
                    </form>
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

    <script src="../js/script.js"></script>
</body>
</html>
