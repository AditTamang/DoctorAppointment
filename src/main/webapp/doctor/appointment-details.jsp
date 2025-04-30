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
    <title>Appointment Details | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile-dashboard.css">
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
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="HealthPro Logo">
                <h2>HealthPro Portal</h2>
            </div>
            
            <div class="profile-overview">
                <h3><i class="fas fa-user-md"></i> <span>Profile Overview</span></h3>
            </div>
            
            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="index.jsp">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="appointments.jsp">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointment Management</span>
                        </a>
                    </li>
                    <li>
                        <a href="patients.jsp">
                            <i class="fas fa-user-injured"></i>
                            <span>Patient Details</span>
                        </a>
                    </li>
                    <li>
                        <a href="availability.jsp">
                            <i class="fas fa-clock"></i>
                            <span>Set Availability</span>
                        </a>
                    </li>
                    <li>
                        <a href="health-packages.jsp">
                            <i class="fas fa-box-open"></i>
                            <span>Health Packages</span>
                        </a>
                    </li>
                    <li>
                        <a href="preferences.jsp">
                            <i class="fas fa-cog"></i>
                            <span>UI Preferences</span>
                        </a>
                    </li>
                    <li class="logout">
                        <a href="../logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        
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
            
            <!-- Appointment Details -->
            <div class="appointment-details-container">
                <div class="appointment-details-header">
                    <h2>Appointment Details</h2>
                    <a href="appointments.jsp" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Back to Appointments
                    </a>
                </div>
                
                <div class="appointment-details-content">
                    <div class="detail-item">
                        <label>Appointment ID</label>
                        <p><%= appointmentId %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label>Patient Name</label>
                        <p><%= patientName %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label>Date</label>
                        <p><%= appointmentDate %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label>Time</label>
                        <p><%= appointmentTime %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label>Status</label>
                        <p><span class="status-badge active"><%= status %></span></p>
                    </div>
                    
                    <div class="detail-item">
                        <label>Doctor</label>
                        <p>Dr. <%= user.getFirstName() + " " + user.getLastName() %></p>
                    </div>
                    
                    <div class="detail-item full-width">
                        <label>Symptoms</label>
                        <p><%= symptoms %></p>
                    </div>
                    
                    <div class="detail-item full-width">
                        <label>Notes</label>
                        <p><%= notes %></p>
                    </div>
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
