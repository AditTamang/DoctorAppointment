<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Doctor | Admin Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-top: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            border-color: #4e73df;
            outline: none;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-col {
            flex: 1;
        }

        .btn-primary {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #3756a4;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
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

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #4e73df;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            color: #3756a4;
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
                        <a href="${pageContext.request.contextPath}/dashboard">
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
                    <h1>Edit Doctor</h1>
                </div>

                <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("message") %>
                </div>
                <% } %>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                <%
                Doctor doctor = (Doctor) request.getAttribute("doctor");
                if (doctor != null) {
                %>
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/admin/doctor/edit" method="post">
                        <input type="hidden" name="id" value="<%= doctor.getId() %>">

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="name">Doctor Name</label>
                                    <input type="text" id="name" name="name" class="form-control" value="<%= doctor.getName() %>" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" class="form-control" value="<%= doctor.getEmail() %>" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="specialization">Specialization</label>
                                    <input type="text" id="specialization" name="specialization" class="form-control" value="<%= doctor.getSpecialization() %>" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="qualification">Qualification</label>
                                    <input type="text" id="qualification" name="qualification" class="form-control" value="<%= doctor.getQualification() %>" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="experience">Experience</label>
                                    <input type="text" id="experience" name="experience" class="form-control" value="<%= doctor.getExperience() %>" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="phone">Phone</label>
                                    <input type="text" id="phone" name="phone" class="form-control" value="<%= doctor.getPhone() %>" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea id="address" name="address" class="form-control" rows="3" required><%= doctor.getAddress() %></textarea>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="consultationFee">Consultation Fee</label>
                                    <input type="text" id="consultationFee" name="consultationFee" class="form-control" value="<%= doctor.getConsultationFee() %>" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="imageUrl">Profile Image URL</label>
                                    <input type="text" id="imageUrl" name="imageUrl" class="form-control" value="<%= doctor.getImageUrl() != null ? doctor.getImageUrl() : "" %>">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="availableDays">Available Days</label>
                                    <input type="text" id="availableDays" name="availableDays" class="form-control" value="<%= doctor.getAvailableDays() %>" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="availableTime">Available Time</label>
                                    <input type="text" id="availableTime" name="availableTime" class="form-control" value="<%= doctor.getAvailableTime() %>" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/admin/doctors" class="btn-secondary">Cancel</a>
                            <button type="submit" class="btn-primary">Update Doctor</button>
                        </div>
                    </form>
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
    </script>
</body>
</html>
