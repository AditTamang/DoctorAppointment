<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.DoctorDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Management | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard.css">
    <link rel="stylesheet" href="../css/adminDashboard.css">
    <style>
        .doctor-list {
            margin-top: 20px;
        }
        .doctor-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .doctor-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 30px;
            color: #777;
        }
        .doctor-info {
            flex: 1;
        }
        .doctor-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }
        .doctor-specialization {
            color: #4e73df;
            font-weight: 500;
            margin-bottom: 10px;
        }
        .doctor-details {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 10px;
        }
        .doctor-detail {
            display: flex;
            align-items: center;
            font-size: 14px;
            color: #666;
        }
        .doctor-detail i {
            margin-right: 5px;
            width: 16px;
            text-align: center;
        }
        .doctor-actions {
            display: flex;
            gap: 10px;
        }
        .btn-action {
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-action i {
            margin-right: 5px;
        }
        .btn-view {
            background-color: #4e73df;
            color: #fff;
        }
        .btn-edit {
            background-color: #1cc88a;
            color: #fff;
        }
        .btn-delete {
            background-color: #e74a3b;
            color: #fff;
        }
        .btn-action:hover {
            opacity: 0.9;
        }
        .search-bar {
            display: flex;
            margin-bottom: 20px;
        }
        .search-input {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #d1d3e2;
            border-radius: 4px 0 0 4px;
            font-size: 14px;
        }
        .search-btn {
            background-color: #4e73df;
            color: #fff;
            border: none;
            padding: 0 20px;
            border-radius: 0 4px 4px 0;
            cursor: pointer;
        }
        .filter-options {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        .filter-select {
            padding: 8px 15px;
            border: 1px solid #d1d3e2;
            border-radius: 4px;
            font-size: 14px;
            flex: 1;
        }
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .page-link {
            display: inline-block;
            padding: 8px 15px;
            margin: 0 5px;
            border-radius: 4px;
            background-color: #f8f9fc;
            color: #4e73df;
            text-decoration: none;
            transition: all 0.3s;
        }
        .page-link.active {
            background-color: #4e73df;
            color: #fff;
        }
        .page-link:hover:not(.active) {
            background-color: #eaecf4;
        }
        @media (max-width: 768px) {
            .doctor-card {
                flex-direction: column;
                text-align: center;
            }
            .doctor-avatar {
                margin-right: 0;
                margin-bottom: 15px;
            }
            .doctor-details {
                justify-content: center;
            }
            .doctor-actions {
                flex-direction: column;
                width: 100%;
            }
            .btn-action {
                width: 100%;
            }
            .filter-options {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in and is an admin
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get all doctors
        DoctorDAO doctorDAO = new DoctorDAO();
        List<Doctor> doctors = doctorDAO.getAllDoctors();
    %>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Dashboard</h3>
            </div>

            <div class="sidebar-menu">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
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
                            <i class="fas fa-user-injured"></i>
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
                        <a href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i>
                            <span>Settings</span>
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
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h1>Doctor Management</h1>
                <a href="${pageContext.request.contextPath}/admin/add-doctor" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Doctor
                </a>
            </div>

            <!-- Search and Filter -->
            <div class="search-bar">
                <input type="text" class="search-input" placeholder="Search doctors...">
                <button class="search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </div>

            <div class="filter-options">
                <select class="filter-select">
                    <option value="">All Specializations</option>
                    <option value="Cardiology">Cardiology</option>
                    <option value="Neurology">Neurology</option>
                    <option value="Orthopedics">Orthopedics</option>
                    <option value="Pediatrics">Pediatrics</option>
                    <option value="Dermatology">Dermatology</option>
                </select>

                <select class="filter-select">
                    <option value="">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>
            </div>

            <!-- Doctor List -->
            <div class="doctor-list">
                <% if (doctors != null && !doctors.isEmpty()) {
                    for (Doctor doctor : doctors) { %>
                <div class="doctor-card">
                    <div class="doctor-avatar">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="doctor-info">
                        <h3 class="doctor-name">Dr. <%= doctor.getName() %></h3>
                        <div class="doctor-specialization"><%= doctor.getSpecialization() %></div>
                        <div class="doctor-details">
                            <div class="doctor-detail">
                                <i class="fas fa-envelope"></i>
                                <%= doctor.getEmail() %>
                            </div>
                            <div class="doctor-detail">
                                <i class="fas fa-phone"></i>
                                <%= doctor.getPhone() %>
                            </div>
                            <div class="doctor-detail">
                                <i class="fas fa-calendar-check"></i>
                                <%
                                    int appointmentCount = 0;
                                    try {
                                        appointmentCount = doctor.getAppointmentCount();
                                    } catch (Exception e) {
                                        // Ignore any errors and use default value
                                    }
                                %>
                                <%= appointmentCount %> Appointments
                            </div>
                        </div>
                        <div class="doctor-actions">
                            <a href="${pageContext.request.contextPath}/admin/view-doctor?id=<%= doctor.getId() %>" class="btn-action btn-view">
                                <i class="fas fa-eye"></i> View
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/edit-doctor?id=<%= doctor.getId() %>" class="btn-action btn-edit">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="#" class="btn-action btn-delete" onclick="confirmDelete(<%= doctor.getId() %>)">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="no-data">
                    <p>No doctors found.</p>
                </div>
                <% } %>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <a href="#" class="page-link">&laquo;</a>
                <a href="#" class="page-link active">1</a>
                <a href="#" class="page-link">2</a>
                <a href="#" class="page-link">3</a>
                <a href="#" class="page-link">&raquo;</a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(doctorId) {
            if (confirm("Are you sure you want to delete this doctor?")) {
                window.location.href = "${pageContext.request.contextPath}/admin/delete-doctor?id=" + doctorId;
            }
        }
    </script>
</body>
</html>
