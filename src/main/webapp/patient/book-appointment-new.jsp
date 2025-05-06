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
    <link rel="stylesheet" href="../css/patient-sidebar.css">
    <link rel="stylesheet" href="../css/appointment-booking-new.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Include Patient Sidebar -->
        <jsp:include page="patient-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <div class="booking-header">
                <h2>Book an Appointment</h2>
            </div>

            <!-- Doctor Card -->
            <div class="doctor-card">
                <div class="doctor-avatar">
                    <% if (doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty()) { %>
                        <img src="../<%= doctor.getProfileImage() %>" alt="<%= doctor.getName() %>">
                    <% } else { %>
                        <%= doctor.getName().charAt(0) %>
                    <% } %>
                </div>
                <div class="doctor-info">
                    <h3 class="doctor-name"><%= doctor.getName().startsWith("Dr.") ? doctor.getName() : "Dr. " + doctor.getName() %></h3>
                    <p class="doctor-specialty"><%= doctor.getSpecialization() %></p>
                    <div class="doctor-details">
                        <div class="doctor-detail">
                            <i class="fas fa-map-marker-alt"></i>
                            <%= doctor.getAddress() %>
                        </div>
                        <div class="doctor-detail">
                            <i class="fas fa-dollar-sign"></i>
                            Consultation Fee: $<%= doctor.getConsultationFee() %>
                        </div>
                        <div class="doctor-detail">
                            <i class="fas fa-star"></i>
                            Rating: <%= doctor.getRating() %>/5
                        </div>
                    </div>
                </div>
            </div>

            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <div class="booking-form">
                <form action="../appointment/book" method="post">
                    <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">

                    <div class="form-group">
                        <label for="appointmentDate">Appointment Date</label>
                        <input type="date" id="appointmentDate" name="appointmentDate" class="form-control"
                               value="${appointmentDate}" required>
                        <% if(request.getAttribute("dateError") != null) { %>
                            <div class="form-error">${dateError}</div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label>Appointment Time</label>
                        <div class="time-slots">
                            <div class="time-slot">
                                <input type="radio" id="time_11_00" name="appointmentTime" value="11:00 AM"
                                       ${appointmentTime == '11:00 AM' ? 'checked' : ''} required>
                                <label for="time_11_00">11:00 AM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" id="time_12_00" name="appointmentTime" value="12:00 PM"
                                       ${appointmentTime == '12:00 PM' ? 'checked' : ''}>
                                <label for="time_12_00">12:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" id="time_01_00" name="appointmentTime" value="01:00 PM"
                                       ${appointmentTime == '01:00 PM' ? 'checked' : ''}>
                                <label for="time_01_00">01:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" id="time_02_00" name="appointmentTime" value="02:00 PM"
                                       ${appointmentTime == '02:00 PM' ? 'checked' : ''}>
                                <label for="time_02_00">02:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" id="time_03_00" name="appointmentTime" value="03:00 PM"
                                       ${appointmentTime == '03:00 PM' ? 'checked' : ''}>
                                <label for="time_03_00">03:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" id="time_04_00" name="appointmentTime" value="04:00 PM"
                                       ${appointmentTime == '04:00 PM' ? 'checked' : ''}>
                                <label for="time_04_00">04:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" id="time_05_00" name="appointmentTime" value="05:00 PM"
                                       ${appointmentTime == '05:00 PM' ? 'checked' : ''}>
                                <label for="time_05_00">05:00 PM</label>
                            </div>
                        </div>
                        <% if(request.getAttribute("timeError") != null) { %>
                            <div class="form-error">${timeError}</div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label for="symptoms">Symptoms/Reason for Visit</label>
                        <textarea id="symptoms" name="symptoms" class="symptoms-textarea"
                                  placeholder="Describe your symptoms or reason for this appointment..." required>${symptoms}</textarea>
                        <% if(request.getAttribute("symptomsError") != null) { %>
                            <div class="form-error">${symptomsError}</div>
                        <% } %>
                    </div>

                    <div class="form-actions">
                        <a href="../doctors" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-calendar-check"></i> Confirm Booking
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/patient-sidebar.js"></script>
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
