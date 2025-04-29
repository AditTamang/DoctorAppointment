<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.doctorapp.model.Department" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Department Form | Admin Dashboard</title>
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
            margin-bottom: 20px;
        }
        
        .page-header h1 {
            font-size: 24px;
        }
        
        .form-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-group input[type="text"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        
        .form-actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            border: none;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: #fff;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: #fff;
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
                <li><a href="${pageContext.request.contextPath}/admin/doctors"><i class="fas fa-user-md"></i> Doctors</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/patients"><i class="fas fa-users"></i> Patients</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/departments" class="active"><i class="fas fa-hospital"></i> Departments</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/specializations"><i class="fas fa-stethoscope"></i> Specializations</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="fas fa-cog"></i> Settings</a></li>
                <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <a href="${pageContext.request.contextPath}/admin/departments" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Departments
        </a>
        
        <div class="date-display">
            Today's Date: <%= LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) %>
        </div>
        
        <%
        Department department = (Department) request.getAttribute("department");
        boolean isEdit = department != null;
        String formTitle = isEdit ? "Edit Department" : "Add New Department";
        String formAction = isEdit ? request.getContextPath() + "/admin/department/edit" : request.getContextPath() + "/admin/department/add";
        %>
        
        <div class="page-header">
            <h1><%= formTitle %></h1>
        </div>
        
        <div class="form-container">
            <form action="<%= formAction %>" method="post">
                <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= department.getId() %>">
                <% } %>
                
                <div class="form-group">
                    <label for="name">Department Name</label>
                    <input type="text" id="name" name="name" value="<%= isEdit ? department.getName() : "" %>" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description"><%= isEdit ? department.getDescription() : "" %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="ACTIVE" <%= isEdit && "ACTIVE".equals(department.getStatus()) ? "selected" : "" %>>Active</option>
                        <option value="INACTIVE" <%= isEdit && "INACTIVE".equals(department.getStatus()) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> <%= isEdit ? "Update" : "Save" %>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/departments" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
        
        <div class="footer">
            <p>&copy; 2023 MedDoc. All Rights Reserved.</p>
            <p>Version 1.0.0</p>
        </div>
    </div>
</body>
</html>
