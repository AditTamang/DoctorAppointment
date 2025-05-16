<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
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
    <style>
        .patients-container {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .patients-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }

        .patients-header h2 {
            font-size: 20px;
            font-weight: 600;
        }

        .patients-filter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .patients-table {
            width: 100%;
            border-collapse: collapse;
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
        }

        .patients-table tr:hover {
            background-color: #f8f9fa;
        }

        .patient-info {
            display: flex;
            align-items: center;
        }

        .patient-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            overflow: hidden;
            margin-right: 10px;
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
            font-weight: 500;
            color: #333;
        }

        .patient-email {
            font-size: 12px;
            color: #6c757d;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-badge.active {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-badge.inactive {
            background-color: #ffebee;
            color: #c62828;
        }

        .action-btn {
            width: 30px;
            height: 30px;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            margin-right: 5px;
            cursor: pointer;
        }

        .action-btn.view {
            background-color: #2196f3;
        }

        .action-btn.edit {
            background-color: #ff9800;
        }

        .action-btn.delete {
            background-color: #f44336;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination-item {
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 5px;
            margin: 0 5px;
            cursor: pointer;
            font-weight: 500;
        }

        .pagination-item.active {
            background-color: #2196f3;
            color: #fff;
        }

        .pagination-item:hover:not(.active) {
            background-color: #e0e0e0;
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

                <div class="patients-filter">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search patients">
                    </div>
                    <button class="filter-btn">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                </div>

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
                                        <span class="patient-name">Emily Brown</span>
                                        <span class="patient-email">emily.brown@example.com</span>
                                    </div>
                                </div>
                            </td>
                            <td>28</td>
                            <td>Female</td>
                            <td>+1 456 789 012</td>
                            <td>2023-10-12</td>
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
                        <tr>
                            <td>
                                <div class="patient-info">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="Patient">
                                    </div>
                                    <div class="patient-details">
                                        <span class="patient-name">Sarah White</span>
                                        <span class="patient-email">sarah.white@example.com</span>
                                    </div>
                                </div>
                            </td>
                            <td>32</td>
                            <td>Female</td>
                            <td>+1 012 345 678</td>
                            <td>2023-10-14</td>
                            <td><span class="status-badge active">Active</span></td>
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
