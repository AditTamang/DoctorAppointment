<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.dao.PatientDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard.css">
    <link rel="stylesheet" href="../css/adminDashboard.css">
    <style>
        .patient-list {
            margin-top: 20px;
        }
        .patient-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .patient-avatar {
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
        .patient-info {
            flex: 1;
        }
        .patient-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }
        .patient-details {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 10px;
        }
        .patient-detail {
            display: flex;
            align-items: center;
            font-size: 14px;
            color: #666;
        }
        .patient-detail i {
            margin-right: 5px;
            width: 16px;
            text-align: center;
        }
        .patient-actions {
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
            .patient-card {
                flex-direction: column;
                text-align: center;
            }
            .patient-avatar {
                margin-right: 0;
                margin-bottom: 15px;
            }
            .patient-details {
                justify-content: center;
            }
            .patient-actions {
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
        
        // Get all patients
        PatientDAO patientDAO = new PatientDAO();
        List<Patient> patients = patientDAO.getAllPatients();
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
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/doctors">
                            <i class="fas fa-user-md"></i>
                            <span>Doctors</span>
                        </a>
                    </li>
                    <li class="active">
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
                <h1>Patient Management</h1>
                <a href="${pageContext.request.contextPath}/admin/add-patient" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Patient
                </a>
            </div>
            
            <!-- Search and Filter -->
            <div class="search-bar">
                <input type="text" class="search-input" placeholder="Search patients...">
                <button class="search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </div>
            
            <div class="filter-options">
                <select class="filter-select">
                    <option value="">All Genders</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
                
                <select class="filter-select">
                    <option value="">All Blood Groups</option>
                    <option value="A+">A+</option>
                    <option value="A-">A-</option>
                    <option value="B+">B+</option>
                    <option value="B-">B-</option>
                    <option value="AB+">AB+</option>
                    <option value="AB-">AB-</option>
                    <option value="O+">O+</option>
                    <option value="O-">O-</option>
                </select>
            </div>
            
            <!-- Patient List -->
            <div class="patient-list">
                <% if (patients != null && !patients.isEmpty()) {
                    for (Patient patient : patients) { %>
                <div class="patient-card">
                    <div class="patient-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="patient-info">
                        <h3 class="patient-name"><%= patient.getFirstName() + " " + patient.getLastName() %></h3>
                        <div class="patient-details">
                            <div class="patient-detail">
                                <i class="fas fa-envelope"></i>
                                <%= patient.getEmail() %>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-phone"></i>
                                <%= patient.getPhone() %>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-venus-mars"></i>
                                <%= patient.getGender() %>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-tint"></i>
                                <%= patient.getBloodGroup() != null ? patient.getBloodGroup() : "Not specified" %>
                            </div>
                        </div>
                        <div class="patient-actions">
                            <a href="${pageContext.request.contextPath}/admin/view-patient?id=<%= patient.getId() %>" class="btn-action btn-view">
                                <i class="fas fa-eye"></i> View
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/edit-patient?id=<%= patient.getId() %>" class="btn-action btn-edit">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="#" class="btn-action btn-delete" onclick="confirmDelete(<%= patient.getId() %>)">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="no-data">
                    <p>No patients found.</p>
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
        function confirmDelete(patientId) {
            if (confirm("Are you sure you want to delete this patient?")) {
                window.location.href = "${pageContext.request.contextPath}/admin/delete-patient?id=" + patientId;
            }
        }
    </script>
</body>
</html>
