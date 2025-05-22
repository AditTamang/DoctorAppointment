<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

    // Get appointment from request attribute
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    if (appointment == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/appointments-list");
        return;
    }

    // Format date
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    String formattedDate = appointment.getAppointmentDate() != null ?
                          dateFormat.format(appointment.getAppointmentDate()) : "";

    // Determine status class
    String statusClass = "pending";
    if ("CONFIRMED".equals(appointment.getStatus())) {
        statusClass = "confirmed";
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
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

        .medical-notes {
            margin-top: 20px;
        }

        .medical-notes h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .medical-notes textarea {
            width: 100%;
            height: 150px;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            resize: vertical;
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
        <jsp:include page="doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-right">
                    <div class="search-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="user-profile-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                    </div>
                </div>
            </div>

            <!-- Appointment Details -->
            <div class="appointment-details-container">
                <div class="appointment-details-header">
                    <h2>Appointment Details</h2>
                    <a href="${pageContext.request.contextPath}/doctor/appointments-list" class="btn btn-outline">
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

                    <div class="detail-item">
                        <label>Doctor</label>
                        <p><%= appointment.getDoctorName() %></p>
                    </div>

                    <div class="detail-item full-width">
                        <label>Symptoms</label>
                        <p><%= appointment.getSymptoms() != null ? appointment.getSymptoms() : "None provided" %></p>
                    </div>

                    <div class="detail-item full-width">
                        <label>Notes</label>
                        <p><%= appointment.getNotes() != null ? appointment.getNotes() : "No notes available" %></p>
                    </div>

                    <% if (!"CANCELLED".equals(appointment.getStatus()) && !"COMPLETED".equals(appointment.getStatus())) { %>
                    <div class="appointment-actions">
                        <a href="${pageContext.request.contextPath}/doctor/appointment/update-status?id=<%= appointment.getId() %>&status=COMPLETED" class="btn btn-success">
                            <i class="fas fa-check-circle"></i> Mark as Completed
                        </a>
                        <a href="${pageContext.request.contextPath}/doctor/appointment/cancel?id=<%= appointment.getId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this appointment?')">
                            <i class="fas fa-times-circle"></i> Cancel Appointment
                        </a>
                    </div>
                    <% } %>
                </div>

                <div class="medical-notes">
                    <h3>Medical Notes</h3>
                    <textarea placeholder="Add medical notes here..."></textarea>
                </div>

                <div class="appointment-actions">
                    <button class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Notes
                    </button>
                    <button class="btn btn-outline">
                        <i class="fas fa-print"></i> Print Details
                    </button>
                    <button class="btn btn-danger">
                        <i class="fas fa-times-circle"></i> Cancel Appointment
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Save notes button functionality
            const saveNotesBtn = document.querySelector('.btn-primary');
            if (saveNotesBtn) {
                saveNotesBtn.addEventListener('click', function() {
                    const notes = document.querySelector('textarea').value;
                    if (notes.trim() === '') {
                        alert('Please add some notes before saving.');
                        return;
                    }

                    // In a real application, you would send the notes to the server
                    alert('Notes saved successfully!');
                });
            }

            // Print details button functionality
            const printBtn = document.querySelector('.btn-outline');
            if (printBtn) {
                printBtn.addEventListener('click', function() {
                    window.print();
                });
            }

            // Cancel appointment button functionality
            const cancelBtn = document.querySelector('.btn-danger');
            if (cancelBtn) {
                cancelBtn.addEventListener('click', function() {
                    if (confirm('Are you sure you want to cancel this appointment?')) {
                        // In a real application, you would send a request to the server
                        alert('Appointment cancelled successfully!');
                        window.location.href = 'appointments.jsp';
                    }
                });
            }
        });
    </script>
</body>
</html>
