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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/patientDashboard.css">
    <style>
        .confirmation-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .confirmation-header {
            background: linear-gradient(135deg, #1977cc, #3fbbc0);
            color: white;
            padding: 40px 30px;
            position: relative;
        }
        
        .confirmation-icon {
            width: 100px;
            height: 100px;
            background-color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: #1977cc;
            font-size: 50px;
        }
        
        .confirmation-header h2 {
            margin: 0 0 10px 0;
            font-size: 28px;
        }
        
        .confirmation-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 16px;
        }
        
        .confirmation-body {
            padding: 30px;
        }
        
        .appointment-details {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        
        .detail-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .detail-label {
            flex: 0 0 150px;
            font-weight: 600;
            color: #555;
        }
        
        .detail-value {
            flex: 1;
            color: #333;
        }
        
        .doctor-info {
            display: flex;
            align-items: center;
            background-color: #e6f7ff;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .doctor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 20px;
            background-color: #fff;
        }
        
        .doctor-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .doctor-details {
            flex: 1;
            text-align: left;
        }
        
        .doctor-details h3 {
            margin: 0 0 5px 0;
            color: #333;
        }
        
        .doctor-details p {
            margin: 0 0 5px 0;
            color: #666;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 25px;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: #1977cc;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #1565c0;
        }
        
        .btn-secondary {
            background-color: #f8f9fa;
            color: #333;
            border: 1px solid #ddd;
        }
        
        .btn-secondary:hover {
            background-color: #e9ecef;
        }
        
        .instructions {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px 20px;
            margin-top: 30px;
            text-align: left;
            border-radius: 5px;
        }
        
        .instructions h3 {
            margin-top: 0;
            color: #856404;
            font-size: 18px;
        }
        
        .instructions ul {
            margin: 10px 0 0 0;
            padding-left: 20px;
            color: #856404;
        }
        
        .instructions li {
            margin-bottom: 8px;
        }
        
        @media (max-width: 768px) {
            .detail-row {
                flex-direction: column;
            }
            
            .detail-label {
                margin-bottom: 5px;
            }
            
            .doctor-info {
                flex-direction: column;
                text-align: center;
            }
            
            .doctor-avatar {
                margin-right: 0;
                margin-bottom: 15px;
            }
            
            .doctor-details {
                text-align: center;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="user-profile">
                <div class="profile-image">
                    <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                        <div class="profile-initials">AT</div>
                    <% } else { %>
                        <div class="profile-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                    <% } %>
                </div>
                <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
                <p class="user-role">Patient</p>
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
                            <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                                <div class="user-initials">AT</div>
                            <% } else { %>
                                <div class="user-initials"><%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %></div>
                            <% } %>
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
                <div class="confirmation-container">
                    <div class="confirmation-header">
                        <div class="confirmation-icon">
                            <i class="fas fa-check"></i>
                        </div>
                        <h2>Appointment Confirmed!</h2>
                        <p>Your appointment has been successfully booked</p>
                    </div>

                    <div class="confirmation-body">
                        <div class="doctor-info">
                            <div class="doctor-avatar">
                                <img src="${pageContext.request.contextPath}${doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? doctor.getImageUrl() : '/assets/images/doctors/default.jpg'}" alt="Doctor Profile">
                            </div>
                            <div class="doctor-details">
                                <h3>Dr. <%= doctor.getName() %></h3>
                                <p><i class="fas fa-stethoscope"></i> <%= doctor.getSpecialization() %></p>
                                <p><i class="fas fa-graduation-cap"></i> <%= doctor.getQualification() != null ? doctor.getQualification() : "Qualified Professional" %></p>
                                <p><i class="fas fa-phone"></i> <%= doctor.getPhone() != null ? doctor.getPhone() : "Contact details will be shared" %></p>
                            </div>
                        </div>

                        <div class="appointment-details">
                            <div class="detail-row">
                                <div class="detail-label">Appointment ID</div>
                                <div class="detail-value">#<%= appointment.getId() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Date</div>
                                <div class="detail-value"><%= appointment.getAppointmentDate() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Time</div>
                                <div class="detail-value"><%= appointment.getAppointmentTime() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Status</div>
                                <div class="detail-value">
                                    <span style="background-color: #ffc107; color: #856404; padding: 5px 10px; border-radius: 20px; font-size: 14px;">
                                        <%= appointment.getStatus() %>
                                    </span>
                                </div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Reason</div>
                                <div class="detail-value"><%= appointment.getReason() %></div>
                            </div>
                            <% if (appointment.getSymptoms() != null && !appointment.getSymptoms().isEmpty()) { %>
                            <div class="detail-row">
                                <div class="detail-label">Symptoms</div>
                                <div class="detail-value"><%= appointment.getSymptoms() %></div>
                            </div>
                            <% } %>
                        </div>

                        <div class="instructions">
                            <h3><i class="fas fa-info-circle"></i> Important Information</h3>
                            <ul>
                                <li>Please arrive 15 minutes before your scheduled appointment time.</li>
                                <li>Bring your ID and any relevant medical records or test results.</li>
                                <li>If you need to cancel or reschedule, please do so at least 24 hours in advance.</li>
                                <li>The doctor will confirm your appointment. You'll receive a notification once confirmed.</li>
                                <li>For any queries, please contact our support team.</li>
                            </ul>
                        </div>

                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/appointments" class="btn btn-primary">
                                <i class="fas fa-calendar-check"></i> View My Appointments
                            </a>
                            <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary">
                                <i class="fas fa-home"></i> Go to Dashboard
                            </a>
                        </div>
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
    </script>
</body>
</html>
