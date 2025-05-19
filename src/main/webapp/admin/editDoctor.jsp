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
    <title>Edit Doctor | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-doctor.css">
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
            font-size: 15px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #4e54c8;
            outline: none;
            box-shadow: 0 0 5px rgba(78, 84, 200, 0.2);
        }

        .form-group-full {
            grid-column: span 2;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .form-error {
            color: #dc3545;
            font-size: 13px;
            margin-top: 5px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 20px;
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
            background-color: #4e54c8;
            color: white;
        }

        .btn-primary:hover {
            background-color: #3a3f9a;
        }

        .btn-secondary {
            background-color: #f8f9fa;
            color: #333;
            border: 1px solid #ddd;
        }

        .btn-secondary:hover {
            background-color: #e9ecef;
        }

        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .checkbox-item input[type="checkbox"] {
            width: 16px;
            height: 16px;
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

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group-full {
                grid-column: span 1;
            }

            .form-actions {
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
                        <img src="${pageContext.request.contextPath}/assets/images/admin/default.jpg" alt="Admin">
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
                                <img src="${pageContext.request.contextPath}/assets/images/admin/default.jpg" alt="Admin">
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
                    <h1>Edit Doctor Profile</h1>
                    <p>Update doctor information</p>
                </div>

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
                    </div>

                    <div class="profile-body">
                        <form action="${pageContext.request.contextPath}/admin/doctors/update" method="post">
                            <input type="hidden" name="id" value="<%= doctor.getId() %>">

                            <div class="profile-section">
                                <h3>Professional Information</h3>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="specialization">Specialization</label>
                                        <select id="specialization" name="specialization" class="form-control" required>
                                            <option value="" <%= doctor.getSpecialization() == null ? "selected" : "" %>>Select Specialization</option>
                                            <option value="Cardiology" <%= "Cardiology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Cardiology</option>
                                            <option value="Neurology" <%= "Neurology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Neurology</option>
                                            <option value="Dermatology" <%= "Dermatology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Dermatology</option>
                                            <option value="Orthopedics" <%= "Orthopedics".equals(doctor.getSpecialization()) ? "selected" : "" %>>Orthopedics</option>
                                            <option value="Gynecology" <%= "Gynecology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Gynecology</option>
                                            <option value="Pediatrics" <%= "Pediatrics".equals(doctor.getSpecialization()) ? "selected" : "" %>>Pediatrics</option>
                                            <option value="Psychiatry" <%= "Psychiatry".equals(doctor.getSpecialization()) ? "selected" : "" %>>Psychiatry</option>
                                            <option value="Ophthalmology" <%= "Ophthalmology".equals(doctor.getSpecialization()) ? "selected" : "" %>>Ophthalmology</option>
                                            <option value="Dentistry" <%= "Dentistry".equals(doctor.getSpecialization()) ? "selected" : "" %>>Dentistry</option>
                                            <option value="General Medicine" <%= "General Medicine".equals(doctor.getSpecialization()) ? "selected" : "" %>>General Medicine</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="qualification">Qualification</label>
                                        <input type="text" id="qualification" name="qualification" class="form-control" value="<%= doctor.getQualification() != null ? doctor.getQualification() : "" %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="experience">Experience (years)</label>
                                        <input type="text" id="experience" name="experience" class="form-control" value="<%= doctor.getExperience() != null ? doctor.getExperience() : "" %>">
                                    </div>
                                    <div class="form-group">
                                        <label for="consultationFee">Consultation Fee ($)</label>
                                        <input type="text" id="consultationFee" name="consultationFee" class="form-control" value="<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "" %>">
                                    </div>
                                </div>
                            </div>

                            <div class="profile-section">
                                <h3>Availability</h3>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label>Available Days</label>
                                        <div class="checkbox-group">
                                            <%
                                            String[] availableDays = doctor.getAvailableDays() != null ? doctor.getAvailableDays().split(",") : new String[0];
                                            String[] allDays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};

                                            for (String day : allDays) {
                                                boolean isChecked = false;
                                                for (String availableDay : availableDays) {
                                                    if (day.equals(availableDay.trim())) {
                                                        isChecked = true;
                                                        break;
                                                    }
                                                }
                                            %>
                                            <div class="checkbox-item">
                                                <input type="checkbox" id="day_<%= day %>" name="day_<%= day %>" value="<%= day %>" <%= isChecked ? "checked" : "" %>>
                                                <label for="day_<%= day %>"><%= day %></label>
                                            </div>
                                            <% } %>
                                            <!-- Hidden input to store the comma-separated list of days -->
                                            <input type="hidden" id="availableDays" name="availableDays" value="<%= doctor.getAvailableDays() != null ? doctor.getAvailableDays() : "" %>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="availableTime">Available Hours</label>
                                        <input type="text" id="availableTime" name="availableTime" class="form-control" value="<%= doctor.getAvailableTime() != null ? doctor.getAvailableTime() : "" %>" placeholder="e.g., 09:00 AM - 05:00 PM">
                                    </div>
                                </div>
                            </div>

                            <div class="profile-section">
                                <h3>Biography</h3>
                                <div class="form-group">
                                    <textarea id="bio" name="bio" class="form-control"><%= doctor.getBio() != null ? doctor.getBio() : "" %></textarea>
                                </div>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/admin/doctors/view?id=<%= doctor.getId() %>" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Changes
                                </button>
                            </div>
                        </form>
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

        // Handle checkbox group for available days
        function updateAvailableDays() {
            const dayCheckboxes = document.querySelectorAll('input[id^="day_"]');
            const checkedDays = [];

            dayCheckboxes.forEach(function(checkbox) {
                if (checkbox.checked) {
                    checkedDays.push(checkbox.value);
                }
            });

            // Update the hidden input with the comma-separated list of days
            const hiddenInput = document.getElementById('availableDays');
            hiddenInput.value = checkedDays.join(',');
            console.log('Updated available days:', hiddenInput.value);
        }

        // Add event listeners to all day checkboxes
        document.querySelectorAll('input[id^="day_"]').forEach(function(checkbox) {
            checkbox.addEventListener('change', updateAvailableDays);
        });

        // Initialize the hidden input on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateAvailableDays();
        });
    </script>
</body>
</html>
