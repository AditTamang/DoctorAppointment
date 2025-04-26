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
    <title>Edit Profile | Doctor Appointment System</title>
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
        }
        
        .profile-header h2 {
            margin: 0;
            font-size: 24px;
        }
        
        .profile-header p {
            margin: 5px 0 0 0;
            opacity: 0.9;
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
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: #4e54c8;
            outline: none;
        }
        
        .form-group-full {
            grid-column: span 2;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 20px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }
        
        .btn-primary {
            background-color: #4e54c8;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #3a3f9a;
        }
        
        .btn-secondary {
            background-color: #f5f5f5;
            color: #333;
        }
        
        .btn-secondary:hover {
            background-color: #e0e0e0;
        }
        
        .avatar-upload {
            position: relative;
            max-width: 150px;
            margin-bottom: 20px;
        }
        
        .avatar-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            border: 5px solid #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        .avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .avatar-edit {
            position: absolute;
            right: 5px;
            bottom: 5px;
            width: 40px;
            height: 40px;
            background: #4e54c8;
            border-radius: 50%;
            text-align: center;
            line-height: 40px;
            color: white;
            cursor: pointer;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .form-group-full {
                grid-column: span 1;
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
                        <a href="${pageContext.request.contextPath}/doctor/profile">
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
                    <h1>Edit Profile</h1>
                    <p>Update your profile information</p>
                </div>

                <div class="profile-container">
                    <div class="profile-header">
                        <h2>Edit Your Profile</h2>
                        <p>Update your personal and professional information</p>
                    </div>

                    <div class="profile-body">
                        <form action="${pageContext.request.contextPath}/doctor/update-profile" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="doctorId" value="<%= doctor.getId() %>">
                            
                            <div class="profile-section">
                                <h3>Profile Picture</h3>
                                <div class="avatar-upload">
                                    <div class="avatar-preview">
                                        <img src="${pageContext.request.contextPath}${doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? doctor.getImageUrl() : '/assets/images/doctors/default.jpg'}" alt="Doctor Profile" id="profileImagePreview">
                                    </div>
                                    <div class="avatar-edit">
                                        <label for="profileImage">
                                            <i class="fas fa-camera"></i>
                                            <input type="file" id="profileImage" name="profileImage" style="display: none;" accept="image/*" onchange="previewImage(this)">
                                        </label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="profile-section">
                                <h3>Personal Information</h3>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="name">Full Name</label>
                                        <input type="text" class="form-control" id="name" name="name" value="<%= doctor.getName() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="email">Email Address</label>
                                        <input type="email" class="form-control" id="email" name="email" value="<%= doctor.getEmail() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="phone">Phone Number</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" value="<%= doctor.getPhone() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="address">Address</label>
                                        <input type="text" class="form-control" id="address" name="address" value="<%= doctor.getAddress() != null ? doctor.getAddress() : "" %>">
                                    </div>
                                </div>
                            </div>

                            <div class="profile-section">
                                <h3>Professional Information</h3>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="specialization">Specialization</label>
                                        <input type="text" class="form-control" id="specialization" name="specialization" value="<%= doctor.getSpecialization() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="qualification">Qualification</label>
                                        <input type="text" class="form-control" id="qualification" name="qualification" value="<%= doctor.getQualification() != null ? doctor.getQualification() : "" %>">
                                    </div>
                                    <div class="form-group">
                                        <label for="experience">Experience (years)</label>
                                        <input type="number" class="form-control" id="experience" name="experience" value="<%= doctor.getExperience() != null ? doctor.getExperience() : "" %>">
                                    </div>
                                    <div class="form-group">
                                        <label for="consultationFee">Consultation Fee ($)</label>
                                        <input type="text" class="form-control" id="consultationFee" name="consultationFee" value="<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "" %>">
                                    </div>
                                </div>
                            </div>

                            <div class="profile-section">
                                <h3>Availability</h3>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="availableDays">Available Days (comma separated)</label>
                                        <input type="text" class="form-control" id="availableDays" name="availableDays" value="<%= doctor.getAvailableDays() != null ? doctor.getAvailableDays() : "Monday,Tuesday,Wednesday,Thursday,Friday" %>" placeholder="e.g. Monday,Tuesday,Wednesday">
                                    </div>
                                    <div class="form-group">
                                        <label for="availableTime">Available Hours</label>
                                        <input type="text" class="form-control" id="availableTime" name="availableTime" value="<%= doctor.getAvailableTime() != null ? doctor.getAvailableTime() : "09:00 AM - 05:00 PM" %>" placeholder="e.g. 09:00 AM - 05:00 PM">
                                    </div>
                                </div>
                            </div>

                            <div class="profile-section">
                                <h3>Biography</h3>
                                <div class="form-group form-group-full">
                                    <label for="bio">Professional Bio</label>
                                    <textarea class="form-control" id="bio" name="bio" rows="5"><%= doctor.getBio() != null ? doctor.getBio() : "" %></textarea>
                                </div>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
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
        
        // Preview uploaded image
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    document.getElementById('profileImagePreview').src = e.target.result;
                }
                
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>
