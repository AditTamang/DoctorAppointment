<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorapp.model.Doctor" %>
<%@ page import="com.doctorapp.model.User" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Doctors | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        
        body {
            background-color: #f8f9fa;
        }
        
        /* Admin sidebar */
        .admin-sidebar {
            width: 200px;
            background-color: #343a40;
            color: #fff;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            overflow-y: auto;
        }
        
        .admin-header {
            padding: 15px;
            border-bottom: 1px solid #495057;
        }
        
        .admin-header h2 {
            font-size: 18px;
            margin-bottom: 5px;
        }
        
        .admin-header p {
            font-size: 14px;
            color: #adb5bd;
        }
        
        .admin-menu {
            padding: 15px 0;
        }
        
        .admin-menu ul {
            list-style: none;
        }
        
        .admin-menu li {
            margin-bottom: 5px;
        }
        
        .admin-menu a {
            display: block;
            padding: 10px 15px;
            color: #fff;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        
        .admin-menu a:hover, .admin-menu a.active {
            background-color: #495057;
        }
        
        .admin-menu a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        /* Main content */
        .main-content {
            margin-left: 200px;
            padding: 20px;
        }
        
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #007bff;
            text-decoration: none;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .page-header h1 {
            font-size: 24px;
        }
        
        .add-new-btn {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
        }
        
        .add-new-btn i {
            margin-right: 5px;
        }
        
        .search-container {
            display: flex;
            margin-bottom: 20px;
        }
        
        .search-container input {
            flex: 1;
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px 0 0 4px;
        }
        
        .search-container button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 8px 15px;
            border-radius: 0 4px 4px 0;
            cursor: pointer;
        }
        
        .doctors-list h2 {
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        .doctors-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .doctors-table th, .doctors-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .doctors-table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        
        .btn-icon {
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            color: #fff;
            text-decoration: none;
        }
        
        .btn-view {
            background-color: #17a2b8;
        }
        
        .btn-edit {
            background-color: #28a745;
        }
        
        .btn-remove {
            background-color: #dc3545;
        }
        
        .date-display {
            text-align: right;
            margin-bottom: 20px;
            color: #6c757d;
        }
        
        /* Footer */
        .footer {
            margin-top: 30px;
            padding: 15px 0;
            border-top: 1px solid #e9ecef;
            color: #6c757d;
            font-size: 14px;
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <!-- Admin Sidebar -->
    <div class="admin-sidebar">
        <div class="admin-header">
            <h2>Administrator</h2>
            <p>admin@medoc.com</p>
        </div>
        <div class="admin-menu">
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/doctors" class="active"><i class="fas fa-user-md"></i> Doctors</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/patients"><i class="fas fa-users"></i> Patients</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/specializations"><i class="fas fa-stethoscope"></i> Specializations</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="fas fa-cog"></i> Settings</a></li>
                <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        
        <div class="date-display">
            Today's Date: <%= LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) %>
        </div>
        
        <div class="page-header">
            <h1>Add New Doctor</h1>
            <a href="${pageContext.request.contextPath}/admin/doctor/add" class="add-new-btn">
                <i class="fas fa-plus"></i> Add New
            </a>
        </div>
        
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/admin/doctors" method="get">
                <input type="text" name="search" placeholder="Search Doctor name or Email" value="${param.search}">
                <button type="submit">Search</button>
            </form>
        </div>
        
        <div class="doctors-list">
            <%
            List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
            int doctorCount = (doctors != null) ? doctors.size() : 0;
            %>
            <h2>All Doctors (<%= doctorCount %>)</h2>
            
            <table class="doctors-table">
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
                    if (doctors != null && !doctors.isEmpty()) {
                        for (Doctor doctor : doctors) {
                    %>
                    <tr>
                        <td><%= doctor.getName() %></td>
                        <td><%= doctor.getEmail() %></td>
                        <td><%= doctor.getSpecialization() %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/admin/doctor/view?id=<%= doctor.getId() %>" class="btn-icon btn-view"><i class="fas fa-eye"></i></a>
                                <a href="${pageContext.request.contextPath}/admin/doctor/edit?id=<%= doctor.getId() %>" class="btn-icon btn-edit"><i class="fas fa-edit"></i></a>
                                <a href="#" onclick="confirmDelete(<%= doctor.getId() %>)" class="btn-icon btn-remove"><i class="fas fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                        // If no doctors found, show a sample doctor
                    %>
                    <tr>
                        <td>Dr. Carly Armstrong</td>
                        <td>sezanp@mailinator.com</td>
                        <td>Urology</td>
                        <td>
                            <div class="action-buttons">
                                <a href="#" class="btn-icon btn-view"><i class="fas fa-eye"></i></a>
                                <a href="#" class="btn-icon btn-edit"><i class="fas fa-edit"></i></a>
                                <a href="#" class="btn-icon btn-remove"><i class="fas fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        </div>
        
        <div class="footer">
            <p>&copy; 2023 MedDoc. All Rights Reserved.</p>
            <p>Version 1.0.0</p>
        </div>
    </div>

    <script>
        function confirmDelete(doctorId) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/doctor/delete?id=' + doctorId;
            }
        }
    </script>
</body>
</html>
