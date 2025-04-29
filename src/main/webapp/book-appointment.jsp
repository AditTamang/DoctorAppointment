<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        <%@include file="./assets/css/style.css"%>
        <%@include file="./assets/css/appointment.css"%>
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <jsp:include page="includes/dashboard-header.jsp" />

        <div class="appointment-container">
            <div class="page-header">
                <h1>Book an Appointment</h1>
                <nav class="breadcrumb">
                    <a href="index.jsp">Home</a> /
                    <a href="dashboard">Dashboard</a> /
                    <span>Book Appointment</span>
                </nav>
            </div>

            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if(request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= request.getAttribute("message") %>
                </div>
            <% } %>

            <div class="appointment-form-container">
                <form action="${pageContext.request.contextPath}/appointment/create" method="post" id="appointmentForm">
                    <div class="form-section">
                        <h3><i class="fas fa-user-md"></i> Select Doctor</h3>

                        <div class="form-group">
                            <label for="doctorId">Choose a Doctor:</label>
                            <select id="doctorId" name="doctorId" class="form-control" required>
                                <option value="">-- Select Doctor --</option>
                                <c:forEach var="doctor" items="${doctors}">
                                    <option value="${doctor.id}" ${param.doctorId == doctor.id ? 'selected' : ''}>
                                        Dr. ${doctor.fullName} - ${doctor.specialization}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div id="doctorDetails" class="doctor-details" style="display: none;">
                            <!-- Doctor details will be loaded here via JavaScript -->
                        </div>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-calendar-alt"></i> Appointment Details</h3>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="appointmentDate">Appointment Date:</label>
                                <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label for="appointmentTime">Preferred Time:</label>
                                <select id="appointmentTime" name="appointmentTime" class="form-control" required>
                                    <option value="">-- Select Time --</option>
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
                                </select>
                            </div>
                        </div>

                        <div id="availabilityMessage" class="availability-message"></div>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-notes-medical"></i> Medical Information</h3>

                        <div class="form-group">
                            <label for="reason">Reason for Visit:</label>
                            <input type="text" id="reason" name="reason" class="form-control" placeholder="Brief reason for your appointment" required>
                        </div>

                        <div class="form-group">
                            <label for="symptoms">Symptoms:</label>
                            <textarea id="symptoms" name="symptoms" class="form-control" rows="3" placeholder="Describe your symptoms in detail"></textarea>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="window.history.back();">Cancel</button>
                        <button type="submit" class="btn btn-primary">Book Appointment</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="includes/dashboard-footer.jsp" />
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set minimum date to today
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('appointmentDate').min = today;

            // Doctor selection change handler
            const doctorSelect = document.getElementById('doctorId');
            const doctorDetails = document.getElementById('doctorDetails');

            doctorSelect.addEventListener('change', function() {
                const doctorId = this.value;

                if (doctorId) {
                    // In a real application, you would fetch doctor details via AJAX
                    // For now, we'll simulate it with a simple display
                    fetchDoctorDetails(doctorId);
                } else {
                    doctorDetails.style.display = 'none';
                }
            });

            // If a doctor is pre-selected (from URL parameter), show their details
            if (doctorSelect.value) {
                fetchDoctorDetails(doctorSelect.value);
            }

            // Date and time selection handlers for availability check
            const dateInput = document.getElementById('appointmentDate');
            const timeSelect = document.getElementById('appointmentTime');
            const availabilityMessage = document.getElementById('availabilityMessage');

            function checkAvailability() {
                const date = dateInput.value;
                const time = timeSelect.value;
                const doctorId = doctorSelect.value;

                if (date && time && doctorId) {
                    // In a real application, you would check availability via AJAX
                    // For now, we'll simulate it
                    simulateAvailabilityCheck(doctorId, date, time);
                }
            }

            dateInput.addEventListener('change', checkAvailability);
            timeSelect.addEventListener('change', checkAvailability);

            // Form validation
            const appointmentForm = document.getElementById('appointmentForm');

            appointmentForm.addEventListener('submit', function(e) {
                const doctorId = doctorSelect.value;
                const date = dateInput.value;
                const time = timeSelect.value;

                if (!doctorId || !date || !time) {
                    e.preventDefault();
                    alert('Please select a doctor, date, and time for your appointment.');
                }
            });
        });

        // Simulated functions that would be replaced with real AJAX calls in production
        function fetchDoctorDetails(doctorId) {
            const doctorDetails = document.getElementById('doctorDetails');

            // In a real app, this would be an AJAX call to get doctor details
            // For now, we'll simulate it with hardcoded data
            const doctors = {
                <c:forEach var="doctor" items="${doctors}" varStatus="status">
                    "${doctor.id}": {
                        "name": "Dr. ${doctor.fullName}",
                        "specialization": "${doctor.specialization}",
                        "qualification": "${doctor.qualification}",
                        "experience": "${doctor.experience}",
                        "fee": "${doctor.consultationFee}",
                        "rating": ${doctor.rating},
                        "availableDays": "${doctor.availableDays}"
                    }${!status.last ? ',' : ''}
                </c:forEach>
            };

            if (doctors[doctorId]) {
                const doctor = doctors[doctorId];

                doctorDetails.innerHTML = `
                    <div class="doctor-card">
                        <div class="doctor-image">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/d1.png" alt="${doctor.name}">
                        </div>
                        <div class="doctor-info">
                            <h4>${doctor.name}</h4>
                            <p><i class="fas fa-stethoscope"></i> ${doctor.specialization}</p>
                            <p><i class="fas fa-graduation-cap"></i> ${doctor.qualification}</p>
                            <p><i class="fas fa-briefcase"></i> ${doctor.experience} years experience</p>
                            <div class="doctor-rating">
                                ${generateStarRating(doctor.rating)}
                                <span>(${doctor.rating})</span>
                            </div>
                            <p class="consultation-fee"><i class="fas fa-dollar-sign"></i> Consultation Fee: $${doctor.fee}</p>
                            <p><i class="fas fa-calendar-day"></i> Available: ${doctor.availableDays || 'Mon-Fri'}</p>
                        </div>
                    </div>
                `;

                doctorDetails.style.display = 'block';
            } else {
                doctorDetails.style.display = 'none';
            }
        }

        function simulateAvailabilityCheck(doctorId, date, time) {
            const availabilityMessage = document.getElementById('availabilityMessage');

            // In a real app, this would be an AJAX call to check availability
            // For now, we'll simulate it with a random response
            const isAvailable = Math.random() > 0.3; // 70% chance of availability

            if (isAvailable) {
                availabilityMessage.innerHTML = '<div class="available"><i class="fas fa-check-circle"></i> The selected time slot is available!</div>';
            } else {
                availabilityMessage.innerHTML = '<div class="unavailable"><i class="fas fa-times-circle"></i> Sorry, this time slot is not available. Please select another time.</div>';
            }
        }

        function generateStarRating(rating) {
            let stars = '';
            for (let i = 1; i <= 5; i++) {
                if (i <= rating) {
                    stars += '<i class="fas fa-star"></i>';
                } else if (i <= rating + 0.5) {
                    stars += '<i class="fas fa-star-half-alt"></i>';
                } else {
                    stars += '<i class="far fa-star"></i>';
                }
            }
            return stars;
        }
    </script>
</body>
</html>
