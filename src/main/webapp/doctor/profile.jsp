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
        /* Main Profile Styles */
        .profile-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 20px;
            max-width: 1200px;
        }

        /* Profile Header */
        .profile-header {
            background-color: #4361ee;
            color: white;
            padding: 20px;
            display: flex;
            align-items: center;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 3px solid white;
            overflow: hidden;
            margin-right: 20px;
            background-color: #fff;
            flex-shrink: 0;
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-info {
            flex: 1;
        }

        .profile-info h2 {
            margin: 0 0 5px 0;
            font-size: 22px;
            font-weight: 600;
        }

        .profile-info p {
            margin: 0 0 8px 0;
            font-size: 14px;
            display: flex;
            align-items: center;
        }

        .profile-info i {
            margin-right: 8px;
            width: 16px;
        }

        /* Profile Body */
        .profile-body {
            padding: 20px;
        }

        .profile-section {
            margin-bottom: 25px;
            background-color: #f8f9fa;
            border-radius: 6px;
            padding: 15px;
        }

        .profile-section h3 {
            color: #4361ee;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 8px;
            margin-bottom: 15px;
            font-size: 16px;
            font-weight: 600;
        }

        /* Profile Details */
        .profile-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .detail-item {
            margin-bottom: 12px;
        }

        .detail-item label {
            display: block;
            color: #666;
            margin-bottom: 4px;
            font-size: 13px;
            font-weight: 500;
        }

        .detail-item p {
            color: #333;
            font-weight: 500;
            margin: 0;
            font-size: 14px;
        }

        /* Profile Actions */
        .profile-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 15px;
        }

        .btn-edit {
            background-color: #4361ee;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .btn-edit:hover {
            background-color: #3a56d4;
        }

        /* Availability Section */
        .availability-section {
            margin-top: 0;
        }

        .availability-days {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }

        .day-badge {
            background-color: #e1e8ff;
            color: #4361ee;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 500;
        }

        /* Biography Section */
        .bio-section {
            line-height: 1.5;
            color: #444;
        }

        .bio-section p {
            font-size: 14px;
        }

        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
            background-color: #f5f7fa;
        }

        .dashboard-main {
            flex: 1;
            padding: 15px;
        }

        .dashboard-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 15px;
            background-color: #fff;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }

        /* Sidebar Improvements */
        .sidebar {
            width: 220px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            height: 100vh;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .user-profile {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        .profile-image {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 10px;
            overflow: hidden;
            border: 3px solid #f0f0f0;
        }

        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-initials {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #4361ee;
            color: white;
            font-size: 24px;
            font-weight: 600;
        }

        .user-name {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #333;
        }

        .user-email, .user-phone {
            font-size: 12px;
            color: #666;
            margin-bottom: 3px;
            word-break: break-word;
        }

        .sidebar-menu ul {
            padding: 0;
            list-style: none;
        }

        .sidebar-menu li {
            margin: 5px 0;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            color: #555;
            text-decoration: none;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }

        .sidebar-menu a:hover {
            background-color: #f5f5f5;
            color: #4361ee;
        }

        .sidebar-menu li.active a {
            background-color: #e1e8ff;
            color: #4361ee;
            border-left-color: #4361ee;
        }

        .sidebar-menu i {
            margin-right: 10px;
            font-size: 16px;
            width: 20px;
            text-align: center;
        }

        .sidebar-menu .logout {
            margin-top: 20px;
            border-top: 1px solid #eee;
            padding-top: 10px;
        }

        .sidebar-menu .logout a {
            color: #f44336;
        }

        .sidebar-menu .logout a:hover {
            background-color: #ffebee;
        }

        .page-header {
            margin-bottom: 15px;
        }

        .page-header h1 {
            font-size: 20px;
            color: #333;
            margin-bottom: 5px;
        }

        .page-header p {
            color: #666;
            font-size: 14px;
        }

        /* Responsive Styles */
        @media (max-width: 992px) {
            .sidebar {
                width: 200px;
            }

            .dashboard-main {
                padding: 12px;
            }
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .user-profile {
                display: flex;
                align-items: center;
                text-align: left;
                padding: 10px;
            }

            .profile-image {
                width: 50px;
                height: 50px;
                margin: 0 10px 0 0;
            }

            .sidebar-menu {
                display: flex;
                overflow-x: auto;
                padding: 5px 0;
            }

            .sidebar-menu ul {
                display: flex;
                width: 100%;
            }

            .sidebar-menu li {
                margin: 0 2px;
                flex-shrink: 0;
            }

            .sidebar-menu a {
                padding: 8px 12px;
                border-left: none;
                border-bottom: 3px solid transparent;
            }

            .sidebar-menu li.active a {
                border-left-color: transparent;
                border-bottom-color: #4361ee;
            }

            .sidebar-menu .logout {
                margin-top: 0;
                border-top: none;
                padding-top: 0;
                margin-left: auto;
            }

            .profile-header {
                flex-direction: column;
                text-align: center;
                padding: 15px;
            }

            .profile-avatar {
                margin-right: 0;
                margin-bottom: 15px;
                width: 80px;
                height: 80px;
            }

            .profile-details {
                grid-template-columns: 1fr;
            }

            .profile-section {
                padding: 12px;
            }

            .profile-body {
                padding: 15px;
            }

            .dashboard-main {
                padding: 10px;
            }

            .dashboard-nav {
                padding: 8px 10px;
            }

            .page-header h1 {
                font-size: 18px;
            }

            .page-header p {
                font-size: 13px;
            }
        }

        @media (max-width: 480px) {
            .profile-info p {
                font-size: 13px;
            }

            .profile-info h2 {
                font-size: 18px;
            }

            .profile-section h3 {
                font-size: 15px;
            }

            .detail-item label {
                font-size: 12px;
            }

            .detail-item p {
                font-size: 13px;
            }

            .day-badge {
                font-size: 12px;
                padding: 3px 10px;
            }

            .btn-edit {
                font-size: 13px;
                padding: 6px 12px;
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
