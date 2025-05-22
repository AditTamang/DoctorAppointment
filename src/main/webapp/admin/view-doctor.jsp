<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Details | Admin Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .doctor-profile {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 20px;
            max-width: 1000px;
            margin-left: auto;
            margin-right: auto;
        }

        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .profile-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 30px;
            border: 4px solid #4e73df;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        /* Error handling for images */
        .profile-image img[src=""],
        .profile-image img:not([src]) {
            display: none;
        }

        .profile-info {
            flex: 1;
            min-width: 250px;
        }

        .profile-info h2 {
            margin: 0 0 5px 0;
            color: #333;
            font-size: 28px;
            font-weight: 600;
        }

        .profile-info p {
            margin: 0 0 12px 0;
            color: #666;
            font-size: 16px;
        }

        .profile-info .specialization {
            color: #4e73df;
            font-weight: 600;
            font-size: 18px;
            display: inline-block;
            padding: 5px 12px;
            background-color: rgba(78, 115, 223, 0.1);
            border-radius: 20px;
            margin-bottom: 15px;
        }

        .profile-details {
            margin-top: 30px;
        }

        .detail-section {
            margin-bottom: 30px;
            background-color: #f8f9fc;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #4e73df;
        }

        .detail-section h3 {
            margin: 0 0 20px 0;
            color: #333;
            font-size: 20px;
            font-weight: 600;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .detail-row {
            display: flex;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .detail-label {
            width: 180px;
            font-weight: 600;
            color: #555;
            font-size: 14px;
        }

        .detail-value {
            flex: 1;
            color: #333;
            font-size: 15px;
            min-width: 250px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .btn-primary {
            background-color: #4e73df;
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background-color: #3756a4;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-danger {
            background-color: #e74a3b;
            color: white;
            border: none;
        }

        .btn-danger:hover {
            background-color: #c23321;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #4e73df;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .back-btn:hover {
            color: #3756a4;
            transform: translateX(-3px);
        }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
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

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .profile-image {
                margin-right: 0;
                margin-bottom: 20px;
            }

            .detail-row {
                flex-direction: column;
            }

            .detail-label {
                width: 100%;
                margin-bottom: 5px;
            }

            .action-buttons {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="logo">
                    <h2>MedDoc</h2>
                </div>
                <button id="sidebarClose" class="sidebar-close">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="sidebar-user">
                <img src="../images/admin-avatar.png" alt="Admin">
                <div>
                    <h3>Administrator</h3>
                    <p>admin@medoc.com</p>
                </div>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/redirect-dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Doctors</span>
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
                        <a href="${pageContext.request.contextPath}/admin/specializations">
                            <i class="fas fa-stethoscope"></i>
                            <span>Specializations</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fas fa-chart-bar"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                    <li class="logout">
                        <a href="${pageContext.request.contextPath}/logout">
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
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search...">
                    </div>

                    <div class="nav-notifications">
                        <div class="icon-badge">
                            <i class="fas fa-bell"></i>
                            <span class="badge">3</span>
                        </div>
                    </div>

                    <div class="nav-messages">
                        <div class="icon-badge">
                            <i class="fas fa-envelope"></i>
                            <span class="badge">5</span>
                        </div>
                    </div>

                    <div class="nav-user">
                        <img src="../images/admin-avatar.png" alt="Admin">
                        <div class="user-info">
                            <h4>${sessionScope.user.username}</h4>
                            <p>Admin</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <a href="${pageContext.request.contextPath}/admin/doctors" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Doctors
                </a>

                <div class="page-header">
                    <h1>Doctor Details</h1>
                </div>

                <%
                Doctor doctor = (Doctor) request.getAttribute("doctor");
                if (doctor != null) {
                %>
                <div class="doctor-profile">
                    <div class="profile-header">
                        <div class="profile-image">
                            <img src="${pageContext.request.contextPath}${doctor.getProfileImage() != null && !doctor.getProfileImage().isEmpty() ? doctor.getProfileImage() : (doctor.getImageUrl() != null && !doctor.getImageUrl().isEmpty() ? (doctor.getImageUrl().startsWith('/') ? doctor.getImageUrl() : '/assets/images/doctors/'.concat(doctor.getImageUrl())) : '/assets/images/doctors/d1.png')}" alt="${doctor.getName()}">
                        </div>
                        <div class="profile-info">
                            <h2><%= doctor.getName() %></h2>
                            <p class="specialization"><%= doctor.getSpecialization() %></p>
                            <p><i class="fas fa-envelope"></i> <%= doctor.getEmail() %></p>
                            <p><i class="fas fa-phone"></i> <%= doctor.getPhone() %></p>
                        </div>
                    </div>

                    <div class="profile-details">
                        <div class="detail-section">
                            <h3>Professional Information</h3>
                            <div class="detail-row">
                                <div class="detail-label">Qualification</div>
                                <div class="detail-value"><%= doctor.getQualification() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Experience</div>
                                <div class="detail-value"><%= doctor.getExperience() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Consultation Fee</div>
                                <div class="detail-value"><%= doctor.getConsultationFee() %></div>
                            </div>
                        </div>

                        <div class="detail-section">
                            <h3>Contact Information</h3>
                            <div class="detail-row">
                                <div class="detail-label">Email</div>
                                <div class="detail-value"><%= doctor.getEmail() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Phone</div>
                                <div class="detail-value"><%= doctor.getPhone() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Address</div>
                                <div class="detail-value"><%= doctor.getAddress() %></div>
                            </div>
                        </div>

                        <div class="detail-section">
                            <h3>Availability</h3>
                            <div class="detail-row">
                                <div class="detail-label">Available Days</div>
                                <div class="detail-value"><%= doctor.getAvailableDays() %></div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Available Time</div>
                                <div class="detail-value"><%= doctor.getAvailableTime() %></div>
                            </div>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/admin/doctors/edit?id=<%= doctor.getId() %>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="#" onclick="confirmDelete(<%= doctor.getId() %>)" class="btn btn-danger">
                            <i class="fas fa-trash"></i> Delete
                        </a>
                    </div>
                </div>
                <% } else { %>
                <div class="alert alert-danger">
                    Doctor not found.
                </div>
                <% } %>
            </div>

            <!-- Footer -->
            <div class="dashboard-footer">
                <p>&copy; 2023 MedDoc. All Rights Reserved.</p>
                <p>Version 1.0.0</p>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar on mobile
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.querySelector('.dashboard-sidebar').classList.toggle('active');
        });

        document.getElementById('sidebarClose').addEventListener('click', function() {
            document.querySelector('.dashboard-sidebar').classList.remove('active');
        });

        // Confirm delete function
        function confirmDelete(doctorId) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/doctors/delete?id=' + doctorId;
            }
        }
    </script>
</body>
</html>
