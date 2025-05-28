<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is an admin
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get appointment from request attribute
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    if (appointment == null) {
        response.sendRedirect(request.getContextPath() + "/appointments");
        return;
    }

    // Format date
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    String formattedDate = appointment.getAppointmentDate() != null ?
                          dateFormat.format(appointment.getAppointmentDate()) : "";

    // Determine status class
    String statusClass = "pending";
    if ("CONFIRMED".equals(appointment.getStatus()) || "APPROVED".equals(appointment.getStatus())) {
        statusClass = "approved";
    } else if ("CANCELLED".equals(appointment.getStatus())) {
        statusClass = "cancelled";
    } else if ("COMPLETED".equals(appointment.getStatus())) {
        statusClass = "completed";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details | MedDoc</title>
    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/logo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
    <style>
        .appointment-details-container {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .appointment-details-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }

        .appointment-details-header h2 {
            font-size: 20px;
            font-weight: 600;
        }

        .appointment-details-content {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .detail-item {
            margin-bottom: 15px;
        }

        .detail-item label {
            display: block;
            font-weight: 500;
            margin-bottom: 5px;
            color: #6c757d;
        }

        .detail-item p {
            font-size: 16px;
            color: #333;
        }

        .detail-item.full-width {
            grid-column: span 2;
        }

        .appointment-actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
        }

        .status-badge.pending {
            background-color: #ffeeba;
            color: #856404;
        }

        .status-badge.approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-badge.cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-badge.completed {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        @media (max-width: 768px) {
            .appointment-details-content {
                grid-template-columns: 1fr;
            }

            .detail-item.full-width {
                grid-column: span 1;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the standardized sidebar -->
        <jsp:include page="admin-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="page-title">
                    <h2>Appointment Details</h2>
                </div>
                <div class="top-header-right">
                    <div class="user-profile-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="Admin">
                    </div>
                </div>
            </div>

            <!-- Appointment Details -->
            <div class="appointment-details-container">
                <div class="appointment-details-header">
                    <h2>Appointment #<%= appointment.getId() %></h2>
                    <a href="${pageContext.request.contextPath}/appointments" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Back to Appointments
                    </a>
                </div>

                <div class="appointment-details-content">
                    <div class="detail-item">
                        <label>Appointment ID</label>
                        <p><%= appointment.getId() %></p>
                    </div>

                    <div class="detail-item">
                        <label>Patient Name</label>
                        <p><%= appointment.getPatientName() %></p>
                    </div>

                    <div class="detail-item">
                        <label>Patient ID</label>
                        <p><%= appointment.getPatientId() %></p>
                    </div>

                    <div class="detail-item">
                        <label>Doctor Name</label>
                        <p><%= appointment.getDoctorName() %></p>
                    </div>

                    <div class="detail-item">
                        <label>Doctor ID</label>
                        <p><%= appointment.getDoctorId() %></p>
                    </div>

                    <div class="detail-item">
                        <label>Date</label>
                        <p><%= formattedDate %></p>
                    </div>

                    <div class="detail-item">
                        <label>Time</label>
                        <p><%= appointment.getAppointmentTime() %></p>
                    </div>

                    <div class="detail-item">
                        <label>Status</label>
                        <p><span class="status-badge <%= statusClass %>"><%= appointment.getStatus() %></span></p>
                    </div>

                    <div class="detail-item full-width">
                        <label>Symptoms</label>
                        <p><%= appointment.getSymptoms() != null ? appointment.getSymptoms() : "None provided" %></p>
                    </div>

                    <div class="detail-item full-width">
                        <label>Notes</label>
                        <p><%= appointment.getNotes() != null ? appointment.getNotes() : "No notes available" %></p>
                    </div>
                </div>

                <% if (!"CANCELLED".equals(appointment.getStatus()) && !"COMPLETED".equals(appointment.getStatus())) { %>
                <div class="appointment-actions">
                    <button id="cancelAppointmentBtn" class="btn btn-danger">
                        <i class="fas fa-times-circle"></i> Cancel Appointment
                    </button>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Cancel appointment button functionality
            const cancelBtn = document.getElementById('cancelAppointmentBtn');
            if (cancelBtn) {
                cancelBtn.addEventListener('click', function() {
                    if (confirm('Are you sure you want to cancel this appointment?')) {
                        // Create form for POST request
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '${pageContext.request.contextPath}/appointment/cancel';

                        // Create hidden input for appointment ID
                        const idInput = document.createElement('input');
                        idInput.type = 'hidden';
                        idInput.name = 'id';
                        idInput.value = <%= appointment.getId() %>;

                        // Append input to form
                        form.appendChild(idInput);

                        // Append form to body and submit
                        document.body.appendChild(form);
                        form.submit();
                    }
                });
            }
        });
    </script>
</body>
</html>
