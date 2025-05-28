<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is an admin
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor data from request attribute
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/admin/doctorDashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Doctor | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-doctor.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-layout-fix.css">
    <style>
        .doctor-profile {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .profile-header {
            background: linear-gradient(135deg, #4e54c8, #8f94fb);
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
            border: 5px solid rgba(255, 255, 255, 0.7);
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

        .profile-actions {
            position: absolute;
            top: 20px;
            right: 20px;
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 15px;
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
            background-color: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background-color: #388E3C;
        }

        .btn-danger {
            background-color: #f44336;
            color: white;
        }

        .btn-danger:hover {
            background-color: #d32f2f;
        }

        .btn-secondary {
            background-color: #f8f9fa;
            color: #333;
            border: 1px solid #ddd;
        }

        .btn-secondary:hover {
            background-color: #e9ecef;
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

        .availability-days {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }

        .day-badge {
            background-color: #e6f7ff;
            color: #0099ff;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
        }

        .stats-section {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 30px;
        }

        .stat-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
        }

        .stat-card h4 {
            color: #666;
            margin-bottom: 10px;
            font-size: 16px;
        }

        /* Availability Form Styles */
        .availability-form {
            margin-top: 20px;
            padding: 20px;
            background-color: #f8f9fc;
            border-radius: 8px;
            border-left: 4px solid #4e73df;
        }

        .availability-form h4 {
            margin-bottom: 15px;
            color: #333;
            font-size: 18px;
            font-weight: 600;
        }

        .update-availability-form .form-group {
            margin-bottom: 15px;
        }

        .update-availability-form label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }

        .update-availability-form .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .update-availability-form .form-text {
            color: #666;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .update-availability-btn {
            margin-top: 10px;
        }

        #availability-message {
            margin-top: 15px;
        }

        .stat-card p {
            color: #333;
            font-size: 24px;
            font-weight: 600;
            margin: 0;
        }

        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .alert i {
            margin-right: 10px;
            font-size: 18px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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

            .profile-actions {
                position: static;
                justify-content: center;
                margin-top: 20px;
            }

            .profile-details {
                grid-template-columns: 1fr;
            }

            .stats-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="admin-interface">
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="user-profile">
                <div class="profile-image">
                    <% if (user.getFirstName().equals("Adit") && user.getLastName().equals("Tamang")) { %>
                        <div class="profile-initials">AT</div>
                    <% } else { %>
                        <img src="${pageContext.request.contextPath}/assets/images/admin/adit.jpg" alt="Admin">
                    <% } %>
                </div>
                <h3 class="user-name"><%= user.getFirstName() + " " + user.getLastName() %></h3>
                <p class="user-role">Administrator</p>
            </div>

            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="active">
                    <a href="${pageContext.request.contextPath}/admin/doctorDashboard">
                        <i class="fas fa-user-md"></i>
                        <span>Doctors</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/doctor-requests">
                        <i class="fas fa-user-plus"></i>
                        <span>Doctor Requests</span>
                        <%
                        // Get the count of pending doctor requests
                        com.doctorapp.service.DoctorRegistrationService doctorRegistrationService = new com.doctorapp.service.DoctorRegistrationService();
                        int pendingRequestsCount = doctorRegistrationService.getPendingRequests().size();
                        if (pendingRequestsCount > 0) {
                        %>
                        <span class="badge badge-primary"><%= pendingRequestsCount %></span>
                        <% } %>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/patients">
                        <i class="fas fa-users"></i>
                        <span>Patients</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/appointments">
                        <i class="fas fa-calendar-check"></i>
                        <span>Appointments</span>
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
                                <img src="${pageContext.request.contextPath}/assets/images/admin/adit.jpg" alt="Admin">
                            <% } %>
                        </div>
                        <div class="user-info">
                            <h4><%= user.getFirstName() + " " + user.getLastName() %></h4>
                            <p>Administrator</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <div class="page-header">
                    <h1>Doctor Profile</h1>
                    <p>View and manage doctor information</p>
                </div>

                <!-- Success or Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${successMessage}
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <div class="doctor-profile">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <img src="${pageContext.request.contextPath}${doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty() ? doctor.getProfileImage() : (doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? doctor.getImageUrl() : '/assets/images/doctors/default.jpg')}" alt="Doctor Profile">
                        </div>
                        <div class="profile-info">
                            <h2>Dr. <%= doctor.getName() %></h2>
                            <p><i class="fas fa-stethoscope"></i> <%= doctor.getSpecialization() %></p>
                            <p><i class="fas fa-envelope"></i> <%= doctor.getEmail() %></p>
                            <p><i class="fas fa-phone"></i> <%= doctor.getPhone() %></p>
                        </div>
                        <div class="profile-actions">
                            <a href="${pageContext.request.contextPath}/admin/doctors/edit?id=<%= doctor.getId() %>" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="#" class="btn btn-danger" onclick="confirmDelete(<%= doctor.getId() %>)">
                                <i class="fas fa-trash-alt"></i> Delete
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/doctorDashboard" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back
                            </a>
                        </div>
                    </div>

                    <div class="profile-body">
                        <div class="stats-section">
                            <div class="stat-card">
                                <h4>Patients</h4>
                                <p><%= doctor.getPatientCount() %></p>
                            </div>
                            <div class="stat-card">
                                <h4>Rating</h4>
                                <p><%= doctor.getRating() %> <i class="fas fa-star" style="color: #FFD700;"></i></p>
                            </div>
                            <div class="stat-card">
                                <h4>Success Rate</h4>
                                <p><%= doctor.getSuccessRate() %>%</p>
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
                                    <p><%= doctor.getExperience() != null ? doctor.getExperience() : "Not provided" %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Consultation Fee</label>
                                    <p>$<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "Not set" %></p>
                                </div>
                            </div>
                        </div>

                        <div class="profile-section">
                            <h3>Contact Information</h3>
                            <div class="profile-details">
                                <div class="detail-item">
                                    <label>Email</label>
                                    <p><%= doctor.getEmail() %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Phone</label>
                                    <p><%= doctor.getPhone() %></p>
                                </div>
                                <div class="detail-item">
                                    <label>Address</label>
                                    <p><%= doctor.getAddress() != null ? doctor.getAddress() : "Not provided" %></p>
                                </div>
                            </div>
                        </div>

                        <div class="profile-section">
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

                            <!-- Update Availability section removed as per requirements -->
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
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Confirm Deletion</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this doctor? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                <a id="confirmDeleteBtn" href="#" class="btn btn-danger">Delete</a>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
        });

        // Delete confirmation modal
        function confirmDelete(doctorId) {
            document.getElementById('deleteModal').style.display = 'block';
            document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/admin/doctors/delete?id=' + doctorId;
        }

        function closeModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        // Availability form submission code removed as per requirements
    </script>

    <style>
        /* Modal Styles */
        .modal {
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background-color: #fff;
            border-radius: 8px;
            width: 400px;
            max-width: 90%;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 18px;
            color: #333;
        }

        .close {
            font-size: 24px;
            font-weight: bold;
            color: #777;
            cursor: pointer;
        }

        .close:hover {
            color: #333;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
    </style>
</body>
</html>
