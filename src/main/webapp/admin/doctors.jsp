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
    <link rel="stylesheet" href="../css/admin-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #f8f9fc;
        }

        .dashboard-header {
            background-color: #4a2c46;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dashboard-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }

        .add-new-btn {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .search-container {
            display: flex;
            margin: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
        }

        .search-container input {
            flex: 1;
            padding: 10px 15px;
            border: none;
            font-size: 14px;
        }

        .search-container button {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
        }

        .doctors-count {
            margin: 20px;
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .doctors-table {
            width: calc(100% - 40px);
            margin: 0 20px 20px;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .doctors-table th, .doctors-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e3e6f0;
        }

        .doctors-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            transition: all 0.3s ease;
        }

        .view-btn {
            background-color: #3498db;
        }

        .edit-btn {
            background-color: #2ecc71;
        }

        .delete-btn {
            background-color: #e74c3c;
        }

        .dashboard-footer {
            background-color: white;
            padding: 10px 20px;
            text-align: left;
            border-top: 1px solid #e3e6f0;
            font-size: 12px;
            color: #6c757d;
            position: fixed;
            bottom: 0;
            width: 100%;
        }

        .dashboard-main {
            padding-bottom: 50px; /* To account for fixed footer */
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="dashboard-header">
        <h1 class="dashboard-title">Add New Doctor</h1>
        <a href="add-doctor.jsp" class="add-new-btn">
            <i class="fas fa-plus"></i> Add New
        </a>
    </div>

    <!-- Main Content -->
    <div class="dashboard-main">
        <!-- Search Bar -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/admin/doctors" method="get">
                <input type="text" name="search" placeholder="Search doctor name or ID">
                <button type="submit">Search</button>
            </form>
        </div>

        <!-- Doctors List -->
        <div class="doctors-count">
            All Doctors (${doctors.size()})
        </div>

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
                List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                if (doctors != null && !doctors.isEmpty()) {
                    for (Doctor doctor : doctors) {
                %>
                <tr>
                    <td>Dr. <%= doctor.getName() %></td>
                    <td><%= doctor.getEmail() %></td>
                    <td><%= doctor.getSpecialization() %></td>
                    <td>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/admin/doctor/view?id=<%= doctor.getId() %>" class="action-btn view-btn">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/doctor/edit?id=<%= doctor.getId() %>" class="action-btn edit-btn">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="#" onclick="confirmDelete(<%= doctor.getId() %>)" class="action-btn delete-btn">
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

    <!-- Footer -->
    <div class="dashboard-footer">
        <p>&copy; 2023 MedDoc. All Rights Reserved.</p>
        <p>Version 1.0.0</p>
    </div>

    <script>
        // Confirm delete function
        function confirmDelete(doctorId) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/doctor/delete?id=' + doctorId;
            }
        }
    </script>
</body>
</html>
