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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Details - Doctor Dashboard</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            background-color: #f8f9fa;
        }

        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .top-header-left {
            display: flex;
            gap: 20px;
        }

        .top-header-left a {
            text-decoration: none;
            color: #6c757d;
            font-weight: 500;
            padding: 5px 0;
            position: relative;
        }

        .top-header-left a.active {
            color: #2196f3;
        }

        .top-header-left a.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background-color: #2196f3;
        }

        .top-header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .search-icon {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background-color: #f1f3f4;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .user-profile-icon {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            overflow: hidden;
            cursor: pointer;
        }

        .user-profile-icon img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .patients-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .patients-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .patients-header h2 {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
        }

        .btn-primary {
            background-color: #2196f3;
            border-color: #2196f3;
        }

        .patients-filter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-form {
            display: flex;
            width: 100%;
            gap: 10px;
        }

        .search-box {
            flex: 1;
            position: relative;
            max-width: 300px;
        }

        .search-box i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .search-box input {
            width: 100%;
            padding: 10px 10px 10px 35px;
            border: 1px solid #ced4da;
            border-radius: 5px;
        }

        .filter-btn {
            padding: 10px 15px;
            background-color: #f8f9fa;
            border: 1px solid #ced4da;
            border-radius: 5px;
            cursor: pointer;
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
            color: #6c757d;
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
                    <a href="${pageContext.request.contextPath}/doctor/profile">Profile</a>
                    <a href="${pageContext.request.contextPath}/doctor/appointments">Appointment Management</a>
                    <a href="${pageContext.request.contextPath}/doctor/patients" class="active">Patient Details</a>
                </div>

                <div class="top-header-right">
                    <div class="user-profile-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/doctors/default.jpg" alt="Doctor">
                    </div>
                </div>
            </div>

            <!-- Patients List -->
            <div class="patients-container">
                <div class="patients-header">
                    <h2>Patient Details</h2>
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
                        <% if (patients != null && !patients.isEmpty()) {
                            for (Patient patient : patients) {
                                // Calculate age from date of birth if available
                                int age = 0;
                                if (patient.getDateOfBirth() != null && !patient.getDateOfBirth().isEmpty()) {
                                    try {
                                        java.time.LocalDate birthDate = java.time.LocalDate.parse(patient.getDateOfBirth());
                                        java.time.LocalDate currentDate = java.time.LocalDate.now();
                                        age = java.time.Period.between(birthDate, currentDate).getYears();
                                    } catch (Exception e) {
                                        // If date parsing fails, leave age as 0
                                    }
                                }

                                // Get last visit date (already formatted as string)
                                String lastVisit = patient.getLastVisit() != null ? patient.getLastVisit() : "";
                        %>
                        <tr>
                            <td>
                                <div class="patient-info">
                                    <div class="patient-avatar">
                                        <img src="${pageContext.request.contextPath}/assets/images/patients/default.jpg" alt="<%= patient.getFirstName() %>">
                                    </div>
                                    <div class="patient-details">
                                        <span class="patient-name"><%= patient.getFirstName() + " " + patient.getLastName() %></span>
                                        <span class="patient-email"><%= patient.getEmail() != null ? patient.getEmail() : "No email" %></span>
                                    </div>
                                </div>
                            </td>
                            <td><%= age > 0 ? age : "N/A" %></td>
                            <td><%= patient.getGender() != null ? patient.getGender() : "N/A" %></td>
                            <td><%= patient.getPhone() != null ? patient.getPhone() : "N/A" %></td>
                            <td><%= lastVisit.isEmpty() ? "N/A" : lastVisit %></td>
                            <td><span class="status-badge active">Active</span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/doctor/view-patient?id=<%= patient.getId() %>" class="action-btn view" title="View Patient"><i class="fas fa-eye"></i></a>
                                <a href="${pageContext.request.contextPath}/doctor/edit-patient?id=<%= patient.getId() %>" class="action-btn edit" title="Edit Patient"><i class="fas fa-edit"></i></a>
                                <a href="${pageContext.request.contextPath}/doctor/add-medical-record?patientId=<%= patient.getId() %>" class="action-btn" style="background-color: #4CAF50;" title="Add Medical Record"><i class="fas fa-notes-medical"></i></a>
                            </td>
                        </tr>
                        <% }
                        } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 20px;">
                                <p>No patients found. Only patients with approved appointments will appear here.</p>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
