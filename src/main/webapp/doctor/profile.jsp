<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get doctor data from request attribute
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    if (doctor == null) {
        // Redirect to profile servlet to load the data
        response.sendRedirect(request.getContextPath() + "/doctor/profile");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Profile | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctorDashboard.css">
    <style>
        .profile-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .profile-header {
            background-color: #4e54c8;
            color: white;
            padding: 30px;
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 5px solid white;
            overflow: hidden;
            margin-right: 30px;
            background-color: #fff;
        }
        
        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .profile-info h2 {
            margin: 0 0 5px 0;
            font-size: 24px;
        }
        
        .profile-info p {
            margin: 0 0 10px 0;
            opacity: 0.9;
            font-size: 16px;
        }
        
        .profile-body {
            padding: 30px;
        }
        
        .profile-section {
            margin-bottom: 30px;
        }
        
        .profile-section h3 {
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 20px;
            font-size: 18px;
        }
        
        .profile-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .detail-item {
            margin-bottom: 15px;
        }
        
        .detail-item label {
            display: block;
            color: #666;
            margin-bottom: 5px;
            font-size: 14px;
        }
        
        .detail-item p {
            color: #333;
            font-weight: 500;
            margin: 0;
        }
        
        .profile-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        .btn-edit {
            background-color: #4e54c8;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-edit:hover {
            background-color: #3a3f9a;
        }
        
        .availability-section {
            margin-top: 20px;
        }
        
        .availability-days {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }
        
        .day-badge {
            background-color: #e6f7ff;
            color: #0099ff;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
        }
        
        .bio-section {
            line-height: 1.6;
            color: #555;
        }
        
        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
            }
            
            .profile-avatar {
                margin-right: 0;
                margin-bottom: 20px;
            }
            
            .profile-details {
                grid-template-columns: 1fr;
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
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                    <% } %>
                </div>
                <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
                <p class="user-email"><%= user.getEmail() %></p>
                <p class="user-phone"><%= user.getPhone() %></p>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="index.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="appointments.jsp">
                            <i class="fas fa-calendar-check"></i>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li>
                        <a href="patients.jsp">
                            <i class="fas fa-users"></i>
                            <span>My Patients</span>
                        </a>
                    </li>
                    <li>
                        <a href="schedule.jsp">
                            <i class="fas fa-clock"></i>
                            <span>Schedule</span>
                        </a>
                    </li>
                    <li>
                        <a href="prescriptions.jsp">
                            <i class="fas fa-prescription"></i>
                            <span>Prescriptions</span>
                        </a>
                    </li>
                    <li>
                        <a href="messages.jsp">
                            <i class="fas fa-comment-medical"></i>
                            <span>Messages</span>
                            <span class="badge">5</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="profile.jsp">
                            <i class="fas fa-user-md"></i>
                            <span>My Profile</span>
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
        <div class="dashboard-main">
            <!-- Top Navigation -->
            <div class="dashboard-nav">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </div>

                <div class="nav-right">
                    <div class="logout-nav">
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>My Profile</h1>
                    <p>View and manage your profile information</p>
                </div>

                <div class="profile-container">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <img src="${pageContext.request.contextPath}${doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? doctor.getImageUrl() : '/assets/images/doctors/default.jpg'}" alt="Doctor Profile">
                        </div>
                        <div class="profile-info">
                            <h2>Dr. <%= doctor.getName() %></h2>
                            <p><i class="fas fa-stethoscope"></i> <%= doctor.getSpecialization() %></p>
                            <p><i class="fas fa-envelope"></i> <%= doctor.getEmail() %></p>
                            <p><i class="fas fa-phone"></i> <%= doctor.getPhone() %></p>
                        </div>
                    </div>

                    <div class="profile-body">
                        <div class="profile-section">
                            <h3>Personal Information</h3>
                            <div class="profile-details">
                                <div class="detail-item">
                                    <label>Full Name</label>
                                    <p><%= doctor.getName() %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Email Address</label>
                                    <p><%= doctor.getEmail() %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Phone Number</label>
                                    <p><%= doctor.getPhone() %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Address</label>
                                    <p><%= doctor.getAddress() != null ? doctor.getAddress() : "Not provided" %></p>
                                </div>
                            </div>
                        </div>

                        <div class="profile-section">
                            <h3>Professional Information</h3>
                            <div class="profile-details">
                                <div class="detail-item">
                                    <label>Specialization</label>
                                    <p><%= doctor.getSpecialization() %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Qualification</label>
                                    <p><%= doctor.getQualification() != null ? doctor.getQualification() : "Not provided" %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Experience</label>
                                    <p><%= doctor.getExperience() != null ? doctor.getExperience() + " years" : "Not provided" %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Consultation Fee</label>
                                    <p>$<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "Not set" %></p>
                                </div>
                            </div>
                        </div>

                        <div class="profile-section availability-section">
                            <h3>Availability</h3>
                            <div class="detail-item">
                                <label>Available Days</label>
                                <div class="availability-days">
                                    <% 
                                    if (doctor.getAvailableDays() != null && !doctor.getAvailableDays().isEmpty()) {
                                        String[] days = doctor.getAvailableDays().split(",");
                                        for (String day : days) {
                                    %>
                                        <span class="day-badge"><%= day.trim() %></span>
                                    <% 
                                        }
                                    } else {
                                    %>
                                        <p>No availability information provided</p>
                                    <% } %>
                                </div>
                            </div>
                            <div class="detail-item">
                                <label>Available Hours</label>
                                <p><%= doctor.getAvailableTime() != null ? doctor.getAvailableTime() : "Not provided" %></p>
                            </div>
                        </div>

                        <div class="profile-section bio-section">
                            <h3>Biography</h3>
                            <p>
                                <%= doctor.getBio() != null && !doctor.getBio().isEmpty() ? doctor.getBio() : 
                                   "Dr. " + doctor.getName() + " is a highly skilled " + doctor.getSpecialization() + 
                                   " with " + (doctor.getExperience() != null ? doctor.getExperience() : "many") + 
                                   " years of experience. " + (doctor.getQualification() != null ? doctor.getQualification() : "") + 
                                   ". Specializing in comprehensive care, Dr. " + doctor.getName() + 
                                   " is dedicated to providing personalized treatment plans for each patient." %>
                            </p>
                        </div>

                        <div class="profile-actions">
                            <a href="edit-profile.jsp" class="btn-edit">
                                <i class="fas fa-edit"></i> Edit Profile
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="dashboard-footer">
                <p>&copy; 2023 HealthCare. All Rights Reserved.</p>
                <p>Version 1.0.0</p>
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
