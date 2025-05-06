<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a patient
    User user = (User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get appointment and doctor data from request attributes
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Doctor doctor = (Doctor) request.getAttribute("doctor");

    if (appointment == null || doctor == null) {
        response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Confirmed | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patient-sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment-confirmation-new.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Include Patient Sidebar -->
        <jsp:include page="patient-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <div class="confirmation-container">
                <div class="confirmation-header">
                    <div class="check-icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <h2>Appointment has been successfully booked</h2>
                </div>

                <div class="doctor-info">
                    <div class="doctor-avatar">
                        <% if (doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/<%= doctor.getProfileImage() %>" alt="<%= doctor.getName() %>">
                        <% } else { %>
                            <div class="initials"><%= doctor.getName().charAt(0) %></div>
                        <% } %>
                    </div>
                    <div class="doctor-details">
                        <h3 class="doctor-name"><%= doctor.getName().startsWith("Dr.") ? doctor.getName() : "Dr. " + doctor.getName() %></h3>
                        <p class="doctor-specialty"><%= doctor.getSpecialization() %></p>
                    </div>
                </div>

                <div class="appointment-details">
                    <div class="detail-row">
                        <div class="detail-label">Appointment ID:</div>
                        <div class="detail-value">#<%= appointment.getId() %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Date:</div>
                        <div class="detail-value"><%= appointment.getAppointmentDate() %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Time:</div>
                        <div class="detail-value"><%= appointment.getAppointmentTime() %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Status:</div>
                        <div class="detail-value">
                            <span class="status-badge status-<%= appointment.getStatus().toLowerCase() %>">
                                <%= appointment.getStatus() %>
                            </span>
                        </div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Reason:</div>
                        <div class="detail-value"><%= appointment.getReason() != null ? appointment.getReason() : "General checkup" %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Symptoms:</div>
                        <div class="detail-value"><%= appointment.getSymptoms() != null ? appointment.getSymptoms() : "Not specified" %></div>
                    </div>
                </div>

                <div class="important-instructions">
                    <h3>Important Information</h3>
                    <ul>
                        <li>Please arrive 15 minutes before your scheduled appointment time.</li>
                        <li>Bring your ID and any relevant medical records or test results.</li>
                        <li>If you need to cancel or reschedule, please do so at least 24 hours in advance.</li>
                        <li>The doctor will confirm your appointment. You'll receive a notification once confirmed.</li>
                        <li>For any queries, please contact our support team.</li>
                    </ul>
                </div>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary">
                        <i class="fas fa-home"></i> Go to Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/appointments" class="btn btn-primary">
                        <i class="fas fa-calendar-check"></i> View My Appointments
                    </a>
                </div>

                <div class="support-footer">
                    If you have any questions, please contact our support team at <a href="mailto:support@healthcare.com">support@healthcare.com</a> or call us at +1 (123) 456-7890
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/patient-sidebar.js"></script>
    <script>
        // Add any necessary JavaScript here
        document.addEventListener('DOMContentLoaded', function() {
            // You can add any initialization code here
        });
    </script>
</body>
</html>
