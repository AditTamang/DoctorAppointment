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
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
    <style>

        /* Page Header Styles */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
        }

        .page-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #333;
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
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .add-new-btn:hover {
            background-color: #375abd;
        }

        /* Search Container Styles */
        .search-container {
            margin-bottom: 20px;
            display: flex;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .search-container input {
            flex: 1;
            padding: 10px 15px;
            border: none;
            font-size: 14px;
            outline: none;
        }

        .search-container button {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .search-container button:hover {
            background-color: #375abd;
        }

        /* Doctors Count Styles */
        .doctors-count {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }

        /* Doctors Table Styles */
        .doctors-table {
            width: 100%;
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

        .doctors-table tr:hover {
            background-color: #f8f9fc;
        }

        /* Action Buttons Styles */
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
            text-decoration: none;
            transition: opacity 0.3s;
        }

        .action-btn:hover {
            opacity: 0.8;
        }

        .view-btn {
            background-color: #36b9cc;
        }

        .edit-btn {
            background-color: #1cc88a;
        }

        .delete-btn {
            background-color: #e74a3b;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .doctors-table {
                font-size: 14px;
            }

            .doctors-table th, .doctors-table td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Include the standardized sidebar -->
    <jsp:include page="admin-sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="header-left">
                <button id="menuToggle" class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 class="page-title">Manage Doctors</h1>
            </div>
            <a href="add-doctor.jsp" class="add-new-btn">
                <i class="fas fa-plus"></i> Add New Doctor
            </a>
        </div>

        <!-- Search Bar -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/admin/doctors" method="get" style="display: flex; width: 100%;">
                <input type="text" name="search" placeholder="Search doctor name, email or specialization">
                <button type="submit"><i class="fas fa-search"></i> Search</button>
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
                    <th>Specialization</th>
                    <th>Actions</th>
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
                            <a href="${pageContext.request.contextPath}/admin/doctors/view?id=<%= doctor.getId() %>" class="action-btn view-btn" title="View Doctor">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/doctors/edit?id=<%= doctor.getId() %>" class="action-btn edit-btn" title="Edit Doctor">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="#" onclick="confirmDelete(<%= doctor.getId() %>)" class="action-btn delete-btn" title="Delete Doctor">
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

    <script>
        // Confirm delete function
        function confirmDelete(doctorId) {
            if (confirm('Are you sure you want to delete this doctor?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/doctors/delete?id=' + doctorId;
            }
        }

        // Toggle sidebar on mobile
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menuToggle');
            const sidebar = document.querySelector('.sidebar');

            if (menuToggle && sidebar) {
                menuToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('active');
                });
            }
        });
    </script>
</body>
</html>
