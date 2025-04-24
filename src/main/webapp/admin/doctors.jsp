<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Doctors | Admin Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .doctor-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .doctor-table th, .doctor-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        .doctor-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        .doctor-table tr:hover {
            background-color: #f9f9f9;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-icon {
            width: 32px;
            height: 32px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            transition: all 0.3s ease;
        }

        .view {
            background-color: #3498db;
        }

        .edit {
            background-color: #2ecc71;
        }

        .remove {
            background-color: #e74c3c;
        }

        .btn-icon:hover {
            opacity: 0.8;
            transform: translateY(-2px);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .add-new-btn {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .add-new-btn:hover {
            background-color: #3756a4;
            transform: translateY(-2px);
        }

        .search-container {
            display: flex;
            margin-bottom: 20px;
        }

        .search-container input {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px 0 0 4px;
            font-size: 14px;
        }

        .search-container button {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 0 4px 4px 0;
            cursor: pointer;
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

        .today-date {
            text-align: right;
            margin-bottom: 20px;
            font-size: 14px;
            color: #666;
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
                <a href="${pageContext.request.contextPath}/dashboard" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>

                <div class="today-date">
                    Today's Date: <span id="currentDate">2023-10-18</span>
                </div>

                <div class="page-header">
                    <h1>Add New Doctor</h1>
                    <a href="add-doctor.jsp" class="add-new-btn">
                        <i class="fas fa-plus"></i> Add New
                    </a>
                </div>

                <div class="search-container">
                    <form action="${pageContext.request.contextPath}/admin/doctors" method="get">
                        <input type="text" name="search" placeholder="Search Doctor name or Email">
                        <button type="submit">Search</button>
                    </form>
                </div>

                <h2>All Doctors (${doctors.size()})</h2>

                <div class="table-responsive">
                    <table class="doctor-table">
                        <thead>
                            <tr>
                                <th>Doctor Name</th>
                                <th>Email</th>
                                <th>Specialties</th>
                                <th>Events</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                            if (doctors != null && !doctors.isEmpty()) {
                                for (Doctor doctor : doctors) {
                            %>
                            <tr>
                                <td><%= doctor.getName() %></td>
                                <td><%= doctor.getEmail() %></td>
                                <td><%= doctor.getSpecialization() %></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/admin/doctor/view?id=<%= doctor.getId() %>" class="btn-icon view">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/doctor/edit?id=<%= doctor.getId() %>" class="btn-icon edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="#" onclick="confirmDelete(<%= doctor.getId() %>)" class="btn-icon remove">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center;">No doctors found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
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

        // Set current date
        const today = new Date();
        const formattedDate = today.getFullYear() + '-' +
                             String(today.getMonth() + 1).padStart(2, '0') + '-' +
                             String(today.getDate()).padStart(2, '0');
        document.getElementById('currentDate').textContent = formattedDate;

        // Confirm delete function
        function confirmDelete(doctorId) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/doctor/delete?id=' + doctorId;
            }
        }
    </script>
</body>
</html>
