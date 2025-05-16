<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get appointment ID from request parameter
    String appointmentId = request.getParameter("id");
    if (appointmentId == null || appointmentId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/doctor/index.jsp");
        return;
    }

    // In a real application, you would fetch the appointment details from the database
    // For now, we'll use dummy data
    String patientName = "John Doe";
    String appointmentDate = "2023-10-10";
    String appointmentTime = "10:30 AM";
    String status = "Active";
    String symptoms = "Headache, Fever";
    String notes = "Follow-up required";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Appointment | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile-dashboard.css">
    <style>
        .appointment-edit-container {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .appointment-edit-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }

        .appointment-edit-header h2 {
            font-size: 20px;
            font-weight: 600;
        }

        .appointment-edit-content {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 5px;
            color: #6c757d;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 16px;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-group textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            resize: vertical;
        }

        .appointment-actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }

        @media (max-width: 768px) {
            .appointment-edit-content {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: span 1;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-left">
                    <a href="index.jsp">Profile</a>
                    <a href="appointments.jsp" class="active">Appointment Management</a>
                    <a href="patients.jsp">Patient Details</a>
                </div>

                <div class="top-header-right">
                    <div class="search-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="user-profile-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                    </div>
                </div>
            </div>

            <!-- Edit Appointment Form -->
            <div class="appointment-edit-container">
                <div class="appointment-edit-header">
                    <h2>Edit Appointment</h2>
                    <a href="appointments.jsp" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Back to Appointments
                    </a>
                </div>

                <form id="edit-appointment-form">
                    <div class="appointment-edit-content">
                        <div class="form-group">
                            <label for="appointment-id">Appointment ID</label>
                            <input type="text" id="appointment-id" value="<%= appointmentId %>" readonly>
                        </div>

                        <div class="form-group">
                            <label for="patient-name">Patient Name</label>
                            <input type="text" id="patient-name" value="<%= patientName %>" readonly>
                        </div>

                        <div class="form-group">
                            <label for="appointment-date">Date</label>
                            <input type="date" id="appointment-date" value="<%= appointmentDate %>">
                        </div>

                        <div class="form-group">
                            <label for="appointment-time">Time</label>
                            <input type="time" id="appointment-time" value="10:30">
                        </div>

                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status">
                                <option value="active" <%= "Active".equals(status) ? "selected" : "" %>>Active</option>
                                <option value="completed" <%= "Completed".equals(status) ? "selected" : "" %>>Completed</option>
                                <option value="cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                                <option value="pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="doctor">Doctor</label>
                            <input type="text" id="doctor" value="Dr. <%= user.getFirstName() + " " + user.getLastName() %>" readonly>
                        </div>

                        <div class="form-group full-width">
                            <label for="symptoms">Symptoms</label>
                            <textarea id="symptoms"><%= symptoms %></textarea>
                        </div>

                        <div class="form-group full-width">
                            <label for="notes">Notes</label>
                            <textarea id="notes"><%= notes %></textarea>
                        </div>
                    </div>

                    <div class="appointment-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <button type="button" class="btn btn-outline" id="cancel-btn">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form submission
            const form = document.getElementById('edit-appointment-form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();

                    // Get form values
                    const appointmentId = document.getElementById('appointment-id').value;
                    const appointmentDate = document.getElementById('appointment-date').value;
                    const appointmentTime = document.getElementById('appointment-time').value;
                    const status = document.getElementById('status').value;
                    const symptoms = document.getElementById('symptoms').value;
                    const notes = document.getElementById('notes').value;

                    // Validate form
                    if (!appointmentDate || !appointmentTime) {
                        alert('Please fill in all required fields.');
                        return;
                    }

                    // In a real application, you would send the data to the server
                    alert('Appointment updated successfully!');
                    window.location.href = 'appointments.jsp';
                });
            }

            // Cancel button
            const cancelBtn = document.getElementById('cancel-btn');
            if (cancelBtn) {
                cancelBtn.addEventListener('click', function() {
                    if (confirm('Are you sure you want to cancel? Any unsaved changes will be lost.')) {
                        window.location.href = 'appointments.jsp';
                    }
                });
            }
        });
    </script>
</body>
</html>
