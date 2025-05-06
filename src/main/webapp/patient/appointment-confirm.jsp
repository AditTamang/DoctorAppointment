<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor from request attribute
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctors");
        return;
    }

    // Get patient ID from request
    String patientId = request.getParameter("patientId");
    if (patientId == null || patientId.isEmpty()) {
        patientId = String.valueOf(request.getAttribute("patientId"));
    }

    // Get available time slots
    List<String> availableTimeSlots = (List<String>) request.getAttribute("availableTimeSlots");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patientDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-booking.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-confirmation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-confirm-fix.css">
    <style>
        /* Fix for unavailable time slots */
        .time-slot.unavailable label {
            background-color: #ffebee;
            color: #d32f2f;
            text-decoration: line-through;
            cursor: not-allowed;
            border: 1px solid #ffcdd2;
            position: relative;
        }

        .time-slot.unavailable input[type="radio"]:disabled + label {
            background-color: #ffebee;
            color: #d32f2f;
            border-color: #ffcdd2;
            box-shadow: none;
            text-decoration: line-through;
            cursor: not-allowed;
        }

        .time-unavailable-message {
            color: #d32f2f;
            font-size: 0.85rem;
            margin-top: 8px;
            font-style: italic;
            background-color: #ffebee;
            padding: 8px 12px;
            border-radius: 4px;
            border-left: 3px solid #d32f2f;
            display: none;
            align-items: center;
        }

        .time-unavailable-message:before {
            content: "⚠";
            margin-right: 8px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <div class="logo-container">
                        <div class="logo-initial"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                    </div>
                    <div class="logo-text">
                        <h3><%= user.getFirstName() + " " + user.getLastName() %></h3>
                        <p>Patient</p>
                    </div>
                </div>
            </div>

            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/patient/dashboard">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/appointments">
                        <i class="fas fa-calendar-check"></i>
                        <span>My Appointments</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctors">
                        <i class="fas fa-user-md"></i>
                        <span>Find Doctors</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/patient/medicalRecords.jsp">
                        <i class="fas fa-file-medical"></i>
                        <span>Medical Records</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/patient/profile">
                        <i class="fas fa-user"></i>
                        <span>My Profile</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="dashboard-main">
            <!-- Top Navigation -->
            <div class="dashboard-nav">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </div>

                <div class="nav-right">
                    <div class="nav-user">
                        <div class="user-image">
                            <div class="user-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                        </div>
                        <div class="user-info">
                            <h4><%= user.getFirstName() + " " + user.getLastName() %></h4>
                            <p>Patient</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="content-header">
                    <h2>Book Appointment</h2>
                    <p>Please confirm your appointment with the selected doctor</p>
                </div>

                <div class="content-body">
                    <div class="booking-form-container">
                        <div class="doctor-info">
                            <h3>Doctor Information</h3>
                            <div class="doctor-details">
                                <p><strong>Name:</strong> Dr. <%= doctor.getFirstName() %> <%= doctor.getLastName() %></p>
                                <p><strong>Specialization:</strong> <%= doctor.getSpecialization() != null ? doctor.getSpecialization() : "General Physician" %></p>
                                <p><strong>Experience:</strong> <%= doctor.getExperience() != null ? doctor.getExperience() : "Experienced" %></p>
                                <p><strong>Consultation Fee:</strong> $<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "100.00" %></p>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/appointment/confirm" method="post">
                            <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                            <input type="hidden" name="patientId" value="<%= patientId %>">

                            <div class="form-group">
                                <label for="appointmentDate">Appointment Date</label>
                                <input type="date" id="appointmentDate" name="appointmentDate" required
                                       min="<%= java.time.LocalDate.now() %>"
                                       value="${appointmentDate != null ? appointmentDate : ''}">
                                <c:if test="${not empty dateError}">
                                    <div class="error-message">${dateError}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label>Appointment Time</label>
                                <div class="time-slots">
                                    <div class="time-slot">
                                        <input type="radio" id="time_09_00" name="appointmentTime" value="09:00 AM" required>
                                        <label for="time_09_00">09:00 AM</label>
                                    </div>
                                    <div class="time-slot unavailable">
                                        <input type="radio" id="time_10_00" name="appointmentTime" value="10:00 AM" disabled>
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
                                <div class="time-unavailable-message">This time slot is no longer available. Please select another time.</div>
                                <c:if test="${not empty timeError}">
                                    <div class="error-message">${timeError}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="reason">Reason for Visit</label>
                                <textarea id="reason" name="reason" placeholder="Please describe the reason for your visit">${reason != null ? reason : ''}</textarea>
                                <c:if test="${not empty reasonError}">
                                    <div class="error-message">${reasonError}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="symptoms">Symptoms (if any)</label>
                                <textarea id="symptoms" name="symptoms" placeholder="Please describe any symptoms you are experiencing">${symptoms != null ? symptoms : ''}</textarea>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/doctors" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Back
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-check"></i> Confirm Booking
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
        });

        // Set minimum date to today for the date picker
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('appointmentDate').min = today;

            // Pre-select time slot if it was previously selected
            const selectedTime = "${appointmentTime}";
            if (selectedTime) {
                const timeInput = document.querySelector(`input[name="appointmentTime"][value="${selectedTime}"]`);
                if (timeInput) {
                    timeInput.checked = true;
                }
            }

            // Handle unavailable time slots
            const unavailableSlots = document.querySelectorAll('.time-slot.unavailable');
            if (unavailableSlots.length > 0) {
                const unavailableMessage = document.querySelector('.time-unavailable-message');
                if (unavailableMessage) {
                    unavailableMessage.style.display = 'flex';
                }

                // Disable radio buttons for unavailable slots
                unavailableSlots.forEach(slot => {
                    const radio = slot.querySelector('input[type="radio"]');
                    if (radio) {
                        radio.disabled = true;
                        radio.required = false;
                    }
                });
            } else {
                // Hide the unavailable message if no slots are unavailable
                const unavailableMessage = document.querySelector('.time-unavailable-message');
                if (unavailableMessage) {
                    unavailableMessage.style.display = 'none';
                }
            }
        });
    </script>
</body>
</html>
