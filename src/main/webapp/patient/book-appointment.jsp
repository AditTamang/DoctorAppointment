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
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-booking.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/book-appointment-fix.css">
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

                    <div class="doctor-card mb-4">
                        <div class="doctor-image">
                            <img src="${pageContext.request.contextPath}${doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? doctor.getImageUrl() : '/assets/images/doctors/d1.png'}" alt="Doctor Profile">
                        </div>
                        <div class="doctor-info">
                            <h4><%= doctor.getName().startsWith("Dr.") ? doctor.getName() : "Dr. " + doctor.getName() %></h4>
                            <p><i class="fas fa-stethoscope"></i> <%= doctor.getSpecialization() %></p>
                            <p><i class="fas fa-graduation-cap"></i> <%= doctor.getQualification() != null ? doctor.getQualification() : "Qualified Professional" %></p>
                            <p><i class="fas fa-calendar-alt"></i> Available: <%= doctor.getAvailableDays() %></p>
                            <p><i class="fas fa-clock"></i> Hours: <%= doctor.getAvailableTime() %></p>
                            <p class="fee-text"><i class="fas fa-dollar-sign"></i> Consultation Fee: $<%= doctor.getConsultationFee() %></p>
                        </div>
                    </div>

                    <form action="../appointment/book" method="post">
                        <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">

                        <div class="booking-form-container">
                            <div class="form-group">
                                <label for="appointmentDate">Appointment Date</label>
                                <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label for="appointmentTime" class="time-slots-title">Select Appointment Time</label>
                                <div class="time-slots">
                                    <div class="time-slot">
                                        <input type="radio" id="time_09_00" name="appointmentTime" value="09:00 AM" required>
                                        <label for="time_09_00">09:00 AM</label>
                                    </div>
                                    <div class="time-slot">
                                        <input type="radio" id="time_10_00" name="appointmentTime" value="10:00 AM">
                                        <label for="time_10_00">10:00 AM</label>
                                    </div>
                                    <div class="time-slot">
                                        <input type="radio" id="time_11_00" name="appointmentTime" value="11:00 AM">
                                        <label for="time_11_00">11:00 AM</label>
                                    </div>
                                    <div class="time-slot">
                                        <input type="radio" id="time_12_00" name="appointmentTime" value="12:00 PM">
                                        <label for="time_12_00">12:00 PM</label>
                                    </div>
                                    <div class="time-slot">
                                        <input type="radio" id="time_01_00" name="appointmentTime" value="01:00 PM">
                                        <label for="time_01_00">01:00 PM</label>
                                    </div>
                                    <div class="time-slot">
                                        <input type="radio" id="time_02_00" name="appointmentTime" value="02:00 PM">
                                        <label for="time_02_00">02:00 PM</label>
                                    </div>
                                    <div class="time-slot">
                                        <input type="radio" id="time_03_00" name="appointmentTime" value="03:00 PM">
                                        <label for="time_03_00">03:00 PM</label>
                                    </div>
                                    <div class="time-slot">
                                        <input type="radio" id="time_04_00" name="appointmentTime" value="04:00 PM">
                                        <label for="time_04_00">04:00 PM</label>
                                    </div>
                                    <div class="time-slot">
                                        <input type="radio" id="time_05_00" name="appointmentTime" value="05:00 PM">
                                        <label for="time_05_00">05:00 PM</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group reason-container">
                                <label for="symptoms" class="reason-title">Symptoms/Reason for Visit</label>
                                <textarea id="symptoms" name="symptoms" class="form-control reason-input" rows="5" placeholder="Please describe your symptoms or reason for this appointment..." required></textarea>
                            </div>

                            <div class="form-group action-buttons">
                                <a href="../doctor/details?id=<%= doctor.getId() %>" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Back
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-calendar-check"></i> Confirm Booking
                                </button>
                            </div>
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

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        // Set minimum date to today for the date picker
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('appointmentDate').min = today;

            // Add click event listeners to time slots for better visual feedback
            const timeSlots = document.querySelectorAll('.time-slot input[type="radio"]');
            timeSlots.forEach(slot => {
                slot.addEventListener('change', function() {
                    // Remove selected class from all labels
                    document.querySelectorAll('.time-slot label').forEach(label => {
                        label.classList.remove('selected');
                    });

                    // Add selected class to the clicked label
                    if (this.checked) {
                        this.nextElementSibling.classList.add('selected');
                    }
                });
            });
        });
    </script>
</body>
</html>
