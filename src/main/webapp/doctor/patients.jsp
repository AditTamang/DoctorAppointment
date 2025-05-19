<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="com.doctorapp.model.Patient" %>
<%@ page import="com.doctorapp.model.Appointment" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in and is a doctor
    User user = (User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get doctor information
    String doctorName = "Dr. " + user.getFirstName() + " " + user.getLastName();

    // Get patients list from request
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    String searchTerm = (String) request.getAttribute("searchTerm");

    // Date formatter for last visit
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Details | HealthPro Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-profile-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-buttons.css">
    <style>
        /* Main Content Styling */
        .main-content {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .patients-container {
            background-color: #fff;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            width: 100%;
            max-width: 900px;
        }

        .patients-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .patients-header h2 {
            font-size: 22px;
            font-weight: 600;
            color: #333;
        }

        .patients-filter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }

        .search-form {
            display: flex;
            width: 100%;
            gap: 10px;
        }

        .search-box {
            position: relative;
            flex: 1;
        }

        .search-box input {
            width: 100%;
            padding: 12px 15px 12px 40px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .search-box input:focus {
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
            outline: none;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }

        .filter-btn {
            padding: 12px 20px;
            background-color: #4361ee;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-btn:hover {
            background-color: #3a56d4;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .patients-table {
            width: 100%;
            border-collapse: collapse;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border-radius: 8px;
            overflow: hidden;
        }

        .patients-table th,
        .patients-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        .patients-table th {
            font-weight: 600;
            color: #333;
            background-color: #f8f9fa;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .patients-table tr:hover {
            background-color: #f8f9fa;
            transition: all 0.3s ease;
        }

        .patients-table tr:last-child td {
            border-bottom: none;
        }

        .patient-info {
            display: flex;
            align-items: center;
        }

        .patient-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 12px;
            border: 2px solid #f0f2f5;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .patient-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .patient-details {
            display: flex;
            flex-direction: column;
        }

        .patient-name {
            font-weight: 600;
            color: #333;
            font-size: 15px;
            margin-bottom: 3px;
        }

        .patient-email {
            font-size: 13px;
            color: #6c757d;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .status-badge.active {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-badge.inactive {
            background-color: #ffebee;
            color: #c62828;
        }

        .status-badge:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .action-btn {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            margin-right: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 6px rgba(0,0,0,0.15);
        }

        .action-btn.view {
            background-color: #2196f3;
        }

        .action-btn.view:hover {
            background-color: #1e88e5;
        }

        .action-btn.edit {
            background-color: #ff9800;
        }

        .action-btn.edit:hover {
            background-color: #f57c00;
        }

        .action-btn.delete {
            background-color: #f44336;
        }

        .action-btn.delete:hover {
            background-color: #e53935;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .pagination-item {
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            margin: 0 5px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            background-color: #f5f7fa;
            color: #555;
        }

        .pagination-item.active {
            background-color: #4361ee;
            color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .pagination-item:hover:not(.active) {
            background-color: #e0e6f5;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        /* Patient Stats */
        .patients-stats {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 10px 20px;
        }

        .stat-label {
            font-size: 14px;
            color: #555;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 22px;
            font-weight: 600;
            padding: 5px 15px;
            border-radius: 20px;
        }

        .stat-value.total {
            background-color: #e3f2fd;
            color: #1565c0;
        }

        .stat-value.active {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .stat-value.inactive {
            background-color: #ffebee;
            color: #c62828;
        }

        /* No Patients Message */
        .no-patients {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            text-align: center;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin: 20px 0;
        }

        .no-data-icon {
            font-size: 50px;
            color: #aaa;
            margin-bottom: 15px;
        }

        .no-patients h3 {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .no-patients p {
            font-size: 15px;
            color: #666;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .patients-container {
                padding: 15px;
                margin-bottom: 20px;
            }

            .patients-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }

            .patients-stats {
                flex-direction: row;
                flex-wrap: wrap;
                gap: 10px;
                padding: 10px;
            }

            .stat-item {
                padding: 8px 15px;
            }

            .stat-value {
                font-size: 18px;
                padding: 4px 12px;
            }

            .patients-filter {
                flex-direction: column;
                gap: 10px;
            }

            .search-form {
                flex-direction: column;
                gap: 10px;
            }

            .patients-table th,
            .patients-table td {
                padding: 10px;
                font-size: 14px;
            }

            .action-btn {
                width: 28px;
                height: 28px;
                margin-right: 5px;
            }

            .pagination-item {
                width: 32px;
                height: 32px;
                margin: 0 3px;
            }

            .no-patients {
                padding: 30px 15px;
            }

            .no-data-icon {
                font-size: 40px;
            }

            .no-patients h3 {
                font-size: 18px;
            }

            .no-patients p {
                font-size: 14px;
            }
        }

        @media (max-width: 480px) {
            .patients-container {
                padding: 12px;
            }

            .patients-stats {
                flex-direction: column;
                padding: 8px;
            }

            .stat-item {
                width: 100%;
                padding: 6px 10px;
                flex-direction: row;
                justify-content: space-between;
                border-bottom: 1px solid #e0e0e0;
            }

            .stat-item:last-child {
                border-bottom: none;
            }

            .stat-label {
                margin-bottom: 0;
            }

            .stat-value {
                font-size: 16px;
                padding: 3px 10px;
            }

            .patients-table {
                font-size: 13px;
            }

            .patients-table th,
            .patients-table td {
                padding: 8px;
            }

            .patient-avatar {
                width: 35px;
                height: 35px;
            }

            .patient-name {
                font-size: 14px;
            }

            .patient-email {
                font-size: 12px;
            }

            .status-badge {
                padding: 4px 8px;
                font-size: 12px;
            }

            .action-btn {
                width: 26px;
                height: 26px;
                margin-right: 3px;
                font-size: 12px;
            }

            .no-patients {
                padding: 20px 10px;
            }

            .no-data-icon {
                font-size: 35px;
            }

            .no-patients h3 {
                font-size: 16px;
            }

            .no-patients p {
                font-size: 13px;
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
            <!-- Top Header -->
            <div class="top-header">
                <div class="top-header-left">
                    <a href="index.jsp">Profile</a>
                    <a href="appointments.jsp">Appointment Management</a>
                    <a href="patients.jsp" class="active">Patient Details</a>
                </div>

                <div class="top-header-right">
                    <div class="search-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="user-profile-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                    </div>
                </div>
            </div>

            <!-- Patients List -->
            <div class="patients-container">
                <div class="patients-header">
                    <h2>Patient Details</h2>
                    <button class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Patient
                    </button>
                </div>

                <div class="patients-stats">
                    <div class="stat-item">
                        <span class="stat-label">Total Patients</span>
                        <span class="stat-value total">25</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Active</span>
                        <span class="stat-value active">20</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Inactive</span>
                        <span class="stat-value inactive">5</span>
                    </div>
                </div>

                <div class="patients-filter">
                    <form action="${pageContext.request.contextPath}/doctor/patients" method="get" class="search-form">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" name="search" placeholder="Search patients" value="${searchTerm}">
                        </div>
                        <button type="submit" class="filter-btn">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </form>
                </div>

                <!-- No patients message - hidden by default -->
                <div class="no-patients" style="display: none;">
                    <div class="no-data-icon">
                        <i class="fas fa-user-slash"></i>
                    </div>
                    <h3>No patients found</h3>
                    <p>There are no patients matching your search criteria.</p>
                </div>

                <!-- Table will be shown when there are patients -->
                <table class="patients-table">
                    <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Phone</th>
                            <th>Last Visit</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <div class="patient-info">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
                                    </div>
                                    <div class="patient-details">
                                        <span class="patient-name">John Doe</span>
                                        <span class="patient-email">john.doe@example.com</span>
                                    </div>
                                </div>
                            </td>
                            <td>42</td>
                            <td>Male</td>
                            <td>+1 234 567 890</td>
                            <td>2023-10-10</td>
                            <td><span class="status-badge active">Active</span></td>
                            <td>
                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                <a href="#" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                <a href="#" class="action-btn delete"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="patient-info">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
                                    </div>
                                    <div class="patient-details">
                                        <span class="patient-name">Jane Smith</span>
                                        <span class="patient-email">jane.smith@example.com</span>
                                    </div>
                                </div>
                            </td>
                            <td>35</td>
                            <td>Female</td>
                            <td>+1 987 654 321</td>
                            <td>2023-10-11</td>
                            <td><span class="status-badge active">Active</span></td>
                            <td>
                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                <a href="#" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                <a href="#" class="action-btn delete"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="patient-info">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
                                    </div>
                                    <div class="patient-details">
                                        <span class="patient-name">David Wilson</span>
                                        <span class="patient-email">david.wilson@example.com</span>
                                    </div>
                                </div>
                            </td>
                            <td>45</td>
                            <td>Male</td>
                            <td>+1 789 012 345</td>
                            <td>2023-10-13</td>
                            <td><span class="status-badge inactive">Inactive</span></td>
                            <td>
                                <a href="#" class="action-btn view"><i class="fas fa-eye"></i></a>
                                <a href="#" class="action-btn edit"><i class="fas fa-edit"></i></a>
                                <a href="#" class="action-btn delete"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination">
                    <div class="pagination-item"><i class="fas fa-chevron-left"></i></div>
                    <div class="pagination-item active">1</div>
                    <div class="pagination-item">2</div>
                    <div class="pagination-item">3</div>
                    <div class="pagination-item"><i class="fas fa-chevron-right"></i></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Search functionality
            const searchInput = document.querySelector('.search-box input');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase();
                    const rows = document.querySelectorAll('.patients-table tbody tr');

                    rows.forEach(row => {
                        const patientName = row.querySelector('.patient-name').textContent.toLowerCase();
                        const patientEmail = row.querySelector('.patient-email').textContent.toLowerCase();

                        if (patientName.includes(searchTerm) || patientEmail.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }

            // Action buttons functionality
            const viewButtons = document.querySelectorAll('.action-btn.view');
            viewButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const patientName = this.closest('tr').querySelector('.patient-name').textContent;
                    alert('View patient details for ' + patientName);
                    // In a real application, you would redirect to the patient details page
                });
            });

            const editButtons = document.querySelectorAll('.action-btn.edit');
            editButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const patientName = this.closest('tr').querySelector('.patient-name').textContent;
                    alert('Edit patient details for ' + patientName);
                    // In a real application, you would redirect to the edit patient page
                });
            });

            const deleteButtons = document.querySelectorAll('.action-btn.delete');
            deleteButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const patientName = this.closest('tr').querySelector('.patient-name').textContent;
                    if (confirm('Are you sure you want to delete patient ' + patientName + '?')) {
                        alert('Patient ' + patientName + ' deleted successfully!');
                        // In a real application, you would send a request to the server
                        this.closest('tr').remove();
                    }
                });
            });

            // Pagination functionality
            const paginationItems = document.querySelectorAll('.pagination-item');
            paginationItems.forEach(item => {
                item.addEventListener('click', function() {
                    // Remove active class from all pagination items
                    paginationItems.forEach(i => i.classList.remove('active'));

                    // Add active class to clicked pagination item
                    if (!this.querySelector('i')) {
                        this.classList.add('active');
                    }

                    // In a real application, you would fetch data for the selected page
                });
            });
        });
    </script>
</body>
</html>
