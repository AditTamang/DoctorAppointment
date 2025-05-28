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

    // Get doctor data from request attribute or session
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    if (doctor == null) {
        // Try to get from session instead of redirecting
        doctor = (Doctor) session.getAttribute("doctor");
        if (doctor == null) {
            // If still null, redirect to dashboard instead of creating a loop
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Doctor Appointment System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctorDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-sidebar-clean.css">
    <style>
        /* Base Styles */
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f5f5;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 20px;
            margin-left: 220px;
        }

        /* Profile Header */
        .profile-header {
            margin-bottom: 20px;
        }

        .profile-header h2 {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin: 0 0 5px 0;
        }

        .profile-header p {
            color: #666;
            font-size: 14px;
            margin: 0;
        }

        /* Profile Card */
        .profile-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        /* Success Message */
        .success-message {
            background-color: #e8f5e9;
            border-radius: 4px;
            padding: 12px 15px;
            margin-bottom: 20px;
            color: #2e7d32;
            display: flex;
            align-items: center;
        }

        .success-message i {
            margin-right: 10px;
        }

        /* Doctor Info Section */
        .doctor-info {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            margin-bottom: 20px;
        }

        .doctor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 20px;
        }

        .doctor-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .doctor-details {
            flex: 1;
        }

        .doctor-details h3 {
            font-size: 20px;
            font-weight: 600;
            margin: 0 0 5px 0;
            color: #333;
        }

        .doctor-contact {
            display: flex;
            flex-direction: column;
        }

        .doctor-contact p {
            margin: 3px 0;
            color: #666;
            font-size: 14px;
            display: flex;
            align-items: center;
        }

        .doctor-contact i {
            width: 20px;
            margin-right: 8px;
            color: #4CAF50;
        }

        /* Profile Picture Update */
        .profile-picture-section {
            text-align: center;
            margin-bottom: 20px;
        }

        .profile-picture-section h3 {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-picture-section h3 i {
            margin-right: 8px;
            color: #4CAF50;
        }

        .profile-picture-actions {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .btn-upload {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .btn-remove {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .btn-upload i, .btn-remove i {
            margin-right: 5px;
        }

        .btn-upload:hover, .btn-remove:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }

        /* Form Actions */
        .form-actions {
            text-align: center;
            margin-top: 20px;
            padding: 15px;
            border-top: 1px solid #eee;
        }

        /* Information Sections */
        .info-section {
            margin-bottom: 20px;
        }

        .info-section h3 {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .info-section h3 i {
            margin-right: 8px;
            color: #4CAF50;
        }

        .form-row {
            display: flex;
            margin-bottom: 15px;
        }

        .form-group {
            flex: 1;
            margin-right: 15px;
        }

        .form-group:last-child {
            margin-right: 0;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            color: #666;
            margin-bottom: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .form-row {
                flex-direction: column;
            }

            .form-group {
                margin-right: 0;
                margin-bottom: 15px;
            }

            .doctor-info {
                flex-direction: column;
                text-align: center;
            }

            .doctor-avatar {
                margin-right: 0;
                margin-bottom: 15px;
            }

            .profile-picture-actions {
                flex-direction: column;
            }

            .btn-upload, .btn-remove {
                width: 100%;
                justify-content: center;
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
            <!-- Profile Header -->
            <div class="profile-header">
                <h2>My Profile</h2>
                <p>View your registration details</p>
            </div>

            <!-- Profile Card -->
            <div class="profile-card">
                <% if (session.getAttribute("successMessage") != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <span>Profile updated successfully</span>
                </div>
                <% session.removeAttribute("successMessage"); %>
                <% } %>

                <!-- Doctor Info -->
                <div class="doctor-info">
                    <div class="doctor-avatar">
                        <%
                        String imagePath = "";
                        if (doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty()) {
                            imagePath = request.getContextPath() + doctor.getProfileImage();
                        } else if (doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty()) {
                            imagePath = request.getContextPath() + doctor.getImageUrl();
                        } else {
                            imagePath = request.getContextPath() + "/assets/images/doctors/default-doctor.png";
                        }
                        %>
                        <img src="<%= imagePath %>" alt="Doctor Profile">
                    </div>
                    <div class="doctor-details">
                        <h3><%= doctor.getName() %></h3>
                        <div class="doctor-contact">
                            <p><i class="fas fa-envelope"></i> <%= doctor.getEmail() %></p>
                            <p><i class="fas fa-phone"></i> <%= doctor.getPhone() %></p>
                        </div>
                    </div>
                </div>

                <!-- No profile picture update section here - consolidated in edit profile page -->

                <!-- Personal Information Section -->
                <div class="info-section">
                    <h3><i class="fas fa-user"></i> Personal Information</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label>First Name</label>
                            <input type="text" value="<%= user.getFirstName() %>" readonly>
                        </div>
                        <div class="form-group">
                            <label>Last Name</label>
                            <input type="text" value="<%= user.getLastName() %>" readonly>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" value="<%= doctor.getEmail() %>" readonly>
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="tel" value="<%= doctor.getPhone() %>" readonly>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Address</label>
                            <input type="text" value="<%= doctor.getAddress() != null ? doctor.getAddress() : "" %>" readonly>
                        </div>
                    </div>
                </div>

                <!-- Medical Information Section -->
                <div class="info-section">
                    <h3><i class="fas fa-heartbeat"></i> Medical Information</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Specialization</label>
                            <input type="text" value="<%= doctor.getSpecialization() %>" readonly>
                        </div>
                        <div class="form-group">
                            <label>Qualification</label>
                            <input type="text" value="<%= doctor.getQualification() != null ? doctor.getQualification() : "" %>" readonly>
                        </div>
                    </div>
                </div>

                <!-- Edit Profile Button -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/doctor/edit-profile" class="btn-upload">
                        <i class="fas fa-edit"></i> Edit Profile
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Set context path for JavaScript
        const contextPath = '${pageContext.request.contextPath}';

        // Add event listener to the edit profile form
        document.addEventListener('DOMContentLoaded', function() {
            // Get the edit profile link
            const editProfileLink = document.querySelector('.form-actions .btn-upload');

            if (editProfileLink) {
                editProfileLink.addEventListener('click', function(e) {
                    // Store the current scroll position in sessionStorage
                    sessionStorage.setItem('scrollPosition', window.scrollY);
                });
            }

            // Restore scroll position if coming back from edit page
            const scrollPosition = sessionStorage.getItem('scrollPosition');
            if (scrollPosition) {
                window.scrollTo(0, parseInt(scrollPosition));
                sessionStorage.removeItem('scrollPosition');
            }

            // Function to refresh profile data without page reload
            window.refreshProfileData = function() {
                fetch(contextPath + '/doctor/profile', {
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update profile information
                        const doctorName = document.querySelector('.doctor-details h3');
                        const doctorEmail = document.querySelector('.doctor-contact p:nth-child(1)');
                        const doctorPhone = document.querySelector('.doctor-contact p:nth-child(2)');

                        if (doctorName) doctorName.textContent = data.name;
                        if (doctorEmail) doctorEmail.innerHTML = '<i class="fas fa-envelope"></i> ' + data.email;
                        if (doctorPhone) doctorPhone.innerHTML = '<i class="fas fa-phone"></i> ' + data.phone;

                        // Show success message
                        const profileCard = document.querySelector('.profile-card');
                        if (profileCard) {
                            const successMessage = document.createElement('div');
                            successMessage.className = 'success-message';
                            successMessage.innerHTML = '<i class="fas fa-check-circle"></i><span>Profile updated successfully</span>';

                            // Insert at the beginning of the profile card
                            profileCard.insertBefore(successMessage, profileCard.firstChild);

                            // Remove after 3 seconds
                            setTimeout(() => {
                                successMessage.remove();
                            }, 3000);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error refreshing profile data:', error);
                });
            };
        });
    </script>
</body>
</html>
